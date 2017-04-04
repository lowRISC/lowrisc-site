+++
Description = ""
date = "2017-04-04T16:00:00+00:00"
title = "Hierarchical tag cache"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/xxx/"
next = "/docs/minion-v0.4/xxx/"
showdisqus = true

+++

### Hierarchical tag cache

The tagged memory mechanism augments each data word in memory with a small tag.
To store these tags in generic memories such as DDR3/4,
a small section in the memory space (normally near the upper boundary)
is reserved for tags and hidden from applications.
As a result, each memory access to the memory is converted into two separate accesses,
one for the actual data word and another one for the tag.
For a naive design, the speed/throughput overhead of supporting tagged memory is 100%!

A small tag cache was used in our previous [tagged-memory release]{{< ref "docs/tagged-memory-v0.1/tags.md" >}}).
That tag cache is a plain write-back set-associated cache.
When the tags associated with the application memory exceed the available space of the small tag cache,
the tag cache would frequently replace previously cached tags and fetch new tags.
The extra overhead of replacing tags may surpass the benefit of using a cache in the worst cases.
