+++
Description = ""
date = "2017-04-04T16:00:00+00:00"
title = "Hierarchical tag cache"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/tag_lowrisc/"
next = "/docs/minion-v0.4/tag_core/"
showdisqus = true

+++

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## Motivation

The tagged memory mechanism augments each data word in memory with a small tag.
To store these tags in generic memories such as DDR3/4,
a small section in the memory space (normally near the upper boundary)
is reserved for tags and hidden from applications.
As a result, each memory access to the memory is converted into two separate accesses,
one for the actual data word and another one for the tag.
For a naive design, the speed/throughput overhead of supporting tagged memory is 100%!

A small tag cache was used in our previous [tagged-memory release]({{< ref "docs/tagged-memory-v0.1/tags.md" >}}).
That tag cache is a plain write-back set-associated cache.
When the tags associated with the application memory exceed the available space of the small tag cache,
the tag cache would frequently replace previously cached tags with new tags.
The extra overhead of writing back dirty tags may surpass the benefit of using a cache in the worst cases.

## General concept of a hierarchical tag cache

In this release, we implemented a hierarchical tag cache to compress the tags cached in the tag cache.
A similarly small tag cache is now able to cover a much larger memory space compared with the previous implementation.
This compression bases on the observation that most of the memory is not tagged when tags are utilised.
As result, most of the tags cached are zero or empty.
When a whole cache line size of tags are empty,
a hierarchical tag cache uses a single bit in a higher level bit map to flag the empty state
rather than store the whole empty line as the plain cache does.
The logic view of the hierarchical tag cache is depicted as below.
It has a tree structure where the leaf nodes in the *tag table* hold the actual tags
and the nodes in higher levels (*tag map 0* and *tag map 1*) holds the bit maps identifying the
non-empty lower level nodes.

<img src="../figures/tag_map.png" alt="Drawing" style="width: 700px; padding: 20px 0px;"/>

The benefits of using a hierarchical tag cache compared with a plain tag cache:

+ Increased cache capacity when most memory words are not tagged.
+ Reduced memory overhead by avoiding fetch empty tags (empty *tag table* nodes) from memory.
+ Fast tag initialisation. Only the top nodes (*tag map 1* nodes) need to be reset after powering up.

On the cost side:

+ Complicated control logic to maintaining the consistency between *tag table* nodes and *tag map* nodes.
+ Extra space to store *tag map* nodes when most of the memory words are tagged.

All levels of the hierarchical tag cache are backed by the memory;
therefore, all nodes in the tree can be safely written back to memory when necessary.
However, the extra tag maps do not increases the memory requirement compared with using a plain tag cache.
The spare space left in the reserved tag partition in memory is large enough to store the maps.

>For a tagged memory that attaches \\(N\\) bits for each 64-bit word, \\(\frac{N}{64}\\) memory space is reserved for the tags.
>As a result, this \\(\frac{N}{64}\\) memory space is not tagged and therefore its associated tag space is never accessed,
>which is the higher \\(\(\frac{N}{64}\)^2\\) memory in the reserved tag space.
>Tag maps uses 1 bit to record the emptiness of each lower level nodes (a node is one cache line).
>Assuming the size of a cache line is 64 bytes, the required memory for *tag map 0* is \\(\frac{N}{64 \cdot 64 \cdot 8}\\).
>Since \\(\(\frac{N}{64}\)^2 \ge \frac{N}{64 \cdot 64 \cdot 8}\\), tag maps do not need extra memory space. \\(\Box\\)

## Physical memory partition

The following graph shows the physical arrangement of data, tags and tag maps in a 1 GB memory.
The tags of the 1 GB memory (nodes of the *tag table*) is located to the higher 64 MB of the address space.
This area is then hidden and prohibited from access from software.
The higher 128 KB of the *tag table* area is reserved for the *tag map 0*,
and the higher 256 bytes of the *tag map 0* space is reserved for *tag map 1*.
For normal SoC systems, two levels of tag maps are enough to reduce the top map to around kilo bytes.
Recall that only the nodes of the top map needs to be reset after powering up,
this significantly reduce the system initialisation delay.
Also for an SoC that does not utilise tags,
a tag cache as small as kilo bytes is enough to eliminate all throughput overhead related to tagged memory.

<img src="../figures/memory_map.png" alt="Drawing" style="width: 700px; padding: 20px 0px;"/>

## Hardware implementation

Instead of using three separate caches to store the *tag table* and the two *tag map*, a unified cache is used.
Nodes from all tree levels use the same cache line size so they can be stored and searched in the same cache.
This allow dynamic space allocation to the *tag table* and the two *tag map*.
When most memory words are tagged, more space is allocated to the *tag table*;
while when most memory words are not tagged, space is allocated to the higher *tag map* nodes.
However, this mechanism also allows lower level nodes to replace higher level nodes.
The tag cache control logic must cope with this hazard and maintain consistent constantly.

The internal structure of the hierarchical tag cache is depicted below.

<img src="../figures/tag_cache_structure.png" alt="Drawing" style="width: 400px; padding: 20px 0px;"/>

The tag cache has five major components:

+ *Data Array*<br>
  The cache memory block to store the cached nodes of all levels of the tree.

+ *Metadata Array*<br>
  The cache metadata memory block to store the status (cache state flag *state* and line non-empty flag *tagFlag*)
  and the address tag (*addrTag*) associated with each cache line.

+ *MemXact Trackers*<br>
  Parallel transaction trackers for memory accesses from the last level cache.

+ *TagXact Trackers*<br>
  Parallel transaction trackers (shared by all MemXact trackers) for accesses to the hierarchical tag cache.

+ *Writeback Unit*<br>
  A single writeback unit shared by all TagXact trackers for writing back a tag cache line.

In this structure, all nodes from the *tag table* and the two *tag maps* are stored in the unified data and metadata arrays.
The tag cache can serve multiple memory accesses simultaneously depending on the number of MemXact trackers.
Each MemXact tracker is responsible to serve a single memory access in a consistent way.
This implies two requirement:

+ A memory transaction must starts with a consistent view of the tree.
  If a simultaneous transaction is updating the part of the tree visible to this transaction,
  the transaction must be blocked until the outstanding update is finished.

+ A memory transaction may temporarily update the tag tree into an inconsistent state,
  because it is difficult to make the update to multiple nodes an atomic operation.
  However, a memory transaction can finish only after it recover the tag tree back to a consistent state.

Each TagXact tracker is a tag cache handler that handles a single node atomically at any time.

### Extra hardware optimisation

Some extra hardware optimisation techniques are used for better cache capacity and smaller transaction latency.

#### Bottom search order

The tag tree is searched in a bottom-up order.
If a tag is found in a *tag table* node, there is no need to search higher *tag map* nodes.
When most memory words are tagged, this search order reduces transaction latency and,
more importantly, reduces the missing penalty when higher *tag map* nodes are replaced by *tag table* nodes.
In a way, this also increases the capacity of the hierarchical tag cache.

#### Creation rather than fetch

When a node is found missing in the tag cache but it is indicated empty by the higher *tag map* bit,
an empty node is created directly inside the tag cache without fetching the node from memory.
This can significantly reduce the transaction latency at the tag setup stage.

#### Avoiding writing back empty nodes

When a dirty but empty node would be replaced by another node, the writeback can be avoided because the
higher *tag map* should be able to indicate the emptiness. This technique can only be used when the
'creation rather than fetch' technique is utilised at the same time.
