+++
Description = ""
date = "2019-07-19T20:00:00+01:00"
title = "Six more weeks of Ibex development - what's new?"

+++

In the past months, we have invested considerable effort in improving our
RISC-V core [Ibex](https://github.com/lowRISC/ibex/). This 2-stage, in-order,
32-bit microcontroller-class CPU core was [contributed to us]({{<
ref "an-update-on-ibex-our-microcontroller-class-cpu-core.md" >}}) by ETH Zürich in
December 2018, with activity really ramping up since May. Having been taped out
multiple times (as zero-riscy) in a mix of academic and industry projects, it
came to us as a relatively mature code base. Despite this, we have continued to
invest in improving its design and maintainability.

![Ibex cleaning up](/img/ibex-cleaning-up.jpg "Carl the Ibex")

Changes have included enhancements to functionality and improved compliance
with the latest RISC-V specification. More recently we’ve been looking beyond
that - the bare user-level ISA requirements are fairly minimal (e.g. there is
no requirement that exceptions are precise). We’ve worked on a series of
cleanups and improvements in order to provide an environment that is friendly
to programmers and usable outside of deeply embedded use cases. An additional
goal is to improve the code style and readability of the core. This is
important for long-term maintenance as well as to reduce the barrier for
engineers in industry, academics, students, and hobbyists to use and understand
the core.

We’ve performed a lot of refactoring on the RTL design of Ibex. This has
included a major cleanup and reorganization of critical Ibex components such as
the [main processor controller](https://github.com/lowRISC/ibex/pull/132), the
entire [instruction-decode stage](https://github.com/lowRISC/ibex/pull/120),
and streamlining the interaction between those blocks. As well as improving the
understandability of the core this allowed us to get rid of a painful control
loop and to correct the handling of interrupts and exceptions.

Here are some numbers to give you an idea on the extent of our efforts over the
past few months. Since we started to intensify our work on Ibex in early May,
we pushed 132 Git commits to the Ibex repository which modified its RTL,
inserting 3495 lines and deleting 3026 of them (not including initial mostly
cosmetic commits and coding style changes). The whole RTL consists of 7,001
lines of code. In other words, during the last 2.5 months, roughly 50 percent
of the RTL was refactored.

![Ibex diffstat](/img/2019-07-ibex-diffstat.png)

Ultimately, having a clean codebase helps maintainability and eases a lot the
implementation of new features and bug fixes. To this end, our refactoring
efforts definitely start to pay off. Including all bug reports since May, our
average time between receiving an issue report and and merging the
corresponding bug fix into the master branch at roughly two working days.

## From bug report to fix in two days: the power of open source

Looking at those bug reports we note a gradual shift on where they are coming
from and how the bugs are found, with an increasing proportion of bug reports
seeming to come from industry users. We have been desligned with the feedback
we get and the interaction we are having from companies, individuals, and
researchers, in private communications and especially via the public bug
tracker on GitHub. This definitely helps us to improve Ibex, but also our
processes. And it is an enriching experience!

Furthermore, there is definitely a growing interest in formal verification in
industry. On our side, we have been working together with our collaborators to
include support for the [RISC-V Formal Interface
(RVFI)](https://github.com/SymbioticEDA/riscv-formal/) and to incorporate the
[RISCV-DV instruction generator](https://github.com/google/riscv-dv).
Meanwhile, many bugs reported to us are found by means of formal verification,
often covering corner cases or cases where the requirements of the
specification are very minimal. The code was already mature and the design
silicon proven when we first started work, but thanks to the combination of
open source, our own engineering efforts, and the powerful community growing
around this work we can go much beyond that. At a rapid pace we’re able to make
Ibex fully compliant with the recently ratified RISC-V Specification, we’re
making it more friendly to get started with, and we’re also making it more
straightforward to hack on.

Do you have something you want Ibex to do? Let us know by opening an issue on
GitHub! Our next priorities support for [Physical Memory Protection
(PMPs)](https://github.com/lowRISC/ibex/issues/8) and
[U-mode](https://github.com/lowRISC/ibex/issues/88), with more to follow.

But why stop there? You can make hacking on Ibex and other exciting projects
your day job! lowRISC is hiring, and you can find details on all of our current
roles on our [jobs page]({{< ref "jobs.md" >}}).

_Philipp Wagner and Pirmin Vogel_
