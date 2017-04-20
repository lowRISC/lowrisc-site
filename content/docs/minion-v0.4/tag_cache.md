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
When the amount of tags accessed by programs exceeds the available space of the small tag cache,
the tag cache would be forced to frequently replace previously cached tags with new tags.
The extra overhead of writing back dirty tags may surpass the benefit of using a cache in the worst cases.

## General concept of a hierarchical tag cache

In this release, we implemented an optimised hierarchical tag cache to compress the empty tags cached in the tag cache.
This compression is based on the observation that most of the memory is not tagged for most use cases.
It is likely that most of the tags cached are zero or empty in normal operation condition.
To utilise this pattern, a hierarchical cache uses a bit-map to record the emptiness of each cached tag cache line.
When a whole line is empty (0), the emptiness state stored in the bit-map is enough to fully represent the cache line;
therefore, the actual empty line is no long need to be cached (no need to access it from memory as well).
As a result, a small tag cache is able to cover a much larger amount of tags than its own cache space.

The logic view of the hierarchical tag cache is depicted as below.
It adopts a multi-tree structure where leaf nodes in the *tag table* level hold the actual tags
while the nodes in higher levels (*tag map 0* and *tag map 1*) holds the bit maps identifying the
non-empty lower level nodes.
Every node is a full cache line in the tag cache.

<p style="text-align:center;"><img src="../figures/tag_map.png" alt="Drawing" style="width: 700px; padding: 20px 0px;"/></p>

All levels of the hierarchical tag cache are backed by the memory;
therefore, all nodes in the tree can be safely written back to memory when necessary.
Fortunately, tag maps do not increases the actual memory requirement compared with using a plain tag cache.
The spare space available in the reserved tag partition in memory is large enough to store the maps.

>For a tagged memory that attaches \\(N\\) bits for each 64-bit word, \\(\frac{N}{64}\\) memory space is reserved for the tags.
>As a result, this reserved \\(\frac{N}{64}\\) memory space is not tagged and its associated tag space is never accessed,
>which is the higher \\(\(\frac{N}{64}\)^2\\) of the memory space.
>Each lower level node is mapped to 1-bit in a higher level node.
>Assuming a node is 64 bytes, the required memory for *tag map 0* is \\(\frac{N}{64 \cdot 64 \cdot 8}\\).
>Since \\(\(\frac{N}{64}\)^2 \ge \frac{N}{64 \cdot 64 \cdot 8}\\), *tag map 0* does not need extra memory space.
>Similarly it can be proved that *tag map 1* is smaller than the spare space made available by *tag map 0*.\\(\Box\\)

The following graph shows the physical arrangement of data, tags and tag maps in a 1 GB memory.
The tags of the 1 GB memory (nodes of the *tag table*) is located to the higher 64 MB of the address space.
This area is then hidden and prohibited accessing from software.
The higher 128 KB of the *tag table* area is reserved for the *tag map 0*,
and the higher 256 bytes of the *tag map 0* space is reserved for *tag map 1*.
For normal SoC systems, two levels of tag maps are enough to reduce the top map to around kilo bytes.
Recall that only the nodes of the top map needs to be reset after powering up,
this significantly reduce the system initialisation delay.
Also for an SoC that does not utilise tags,
a tag cache as small as kilo bytes is enough to eliminate all throughput overhead related to tagged memory.

<p style="text-align:center;"><img src="../figures/memory_map.png" alt="Drawing" style="width: 700px; padding: 20px 0px;"/></p>

As a summary, the benefits of using a hierarchical tag cache compared with a plain tag cache include:

+ Increased cache capacity when a big portion of memory words are not tagged.
+ Reduced memory overhead by avoiding fetch empty tags (empty *tag table* or even *tag map 0* nodes) from memory.
+ Fast tag initialisation as only the top map nodes (*tag map 1* nodes) need to be reset after powering up.

On the cost side:

+ Complicated control logic to maintaining the consistency between *tag table* nodes and *tag map* nodes.
+ Extra cache space to store *tag map* nodes in the tag cache.

## Hardware implementation

Instead of using three separate caches to store the *tag table* and the two *tag maps*, a unified cache is used.
Nodes from all tree levels use the same size so they can be stored and searched in the same manner.
This also allows dynamic space allocation to the table nodes and the map nodes.
When most memory words are tagged, map nodes can be replaced to store table nodes;
while when most memory words are not tagged, space is most used by map nodes.

The internal structure of the hierarchical tag cache is depicted below.

<p style="text-align:center;"><img src="../figures/tag_cache_structure.png" alt="Drawing" style="width: 400px; padding: 20px 0px;"/></p>

The tag cache has five major components:

+ *Data Array*<br>
  The cache memory block to store the cached nodes of all levels of the tree.

+ *Metadata Array*<br>
  The cache metadata memory block to store the line status (state flag *state* and non-empty flag *tagFlag*)
  and the address tag (*addrTag*) associated with each cache line.

+ *MemXact Trackers*<br>
  Parallel transaction trackers for memory accesses from the last level cache.

+ *TagXact Trackers*<br>
  Parallel transaction trackers (shared by all MemXact trackers) for accessing the uniformed tag cache.

+ *Writeback Unit*<br>
  A single writeback unit shared by all TagXact trackers for writing back a tag cache line.

The tag cache is capable of serving multiple memory accesses in parallel depending on the number of MemXact trackers.
Each MemXact tracker is responsible to serve a single memory access in a consistent way.
This implies two requirements:

+ A memory transaction must starts with a consistent view of the tree.
  If a simultaneous transaction is updating the part of the tree visible to this transaction,
  the transaction must wait until the outstanding update is finished.

+ A memory transaction may temporarily update the tag tree into an inconsistent state,
  because it is difficult to make the whole transaction an atomic operation.
  A MemXact tracker must recover the tag tree back into a consistent state before accepting a new transaction.

Each TagXact tracker is a tag cache handler that handles a single node operation atomically at any time.

### Extra hardware optimisation

Some extra hardware optimisation techniques are used for better cache capacity and smaller transaction latency.

#### Bottom-up search order

The tag tree is searched in a bottom-up order.
If a tag is found in a *tag table* node, there is no need to search higher *tag map* nodes.
When most memory words are tagged, this search order reduces transaction latency and,
more importantly, reduces the missing penalty when higher *tag map* nodes are replaced by *tag table* nodes.
In a way, this also slightly increases the capacity of the hierarchical tag cache.

#### Creation rather than fetch

When writing a node that is missing but indicated empty by the associated *tag map* bit,
an empty node is created directly rather than fetching it from memory.

#### Avoiding writing back empty nodes

When a dirty but empty node is going to be replaced by another node, the writeback can be avoided because the
associated *tag map* bit should have indicated the emptiness. This technique can only be used when the
'creation rather than fetch' technique is utilised at the same time.
