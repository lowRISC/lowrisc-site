+++
Description = ""
date = "2017-09-19T14:45:00+00:00"
title = "lowRISC tagged memory OS enablement"

+++

This summer, we were fortunate enough to have Katherine Lim join the lowRISC 
team at the University of Cambridge Computer Laboratory as an intern.
Katherine's focus was on operating system and software enabled for lowRISC's 
tagged memory, building upon our
[most recent milestone release]({{< ref "docs/minion-v0.4/_index.md" >}}).
As Katherine's [detailed write-up]({{< ref 
"docs/tagged-memory-os-enablement-internship-2017/_index.md" >}}) demonstrates, 
it's been a very productive summer.

The goal of this internship was to take the lowRISC hardware release, and 
demonstrate kernel support and software support for the hardware tagged memory 
primitives. This includes support for context-switch of the `tagctrl` register 
used to configure tag rules, maintaining tags in pages upon copy-on-write, 
delivering tag exceptions to user space, loading tags from ELF binaries, and 
more. It culminated in a demonstration that pulls these various pieces of work 
together, showing how tagged memory can be used to mark valid branch targets.
Read the [report]({{< ref 
"docs/tagged-memory-os-enablement-internship-2017/_index.md" >}}) for full 
details.

We believe there is a rich design space in hardware support for tagged memory 
and tag-based software policies. This operating system enablement work is an 
important part of exploring that space, and in making it easier for other 
groups to do the same.

If working on problems like this sounds interesting to you, there's good news 
- [**we're hiring**]({{< ref "blog/we-re-hiring-2017.md" >}}).

_Alex Bradbury and Katherine Lim_
