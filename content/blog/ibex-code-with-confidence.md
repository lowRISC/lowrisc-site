+++
Description = ""
date = "2019-08-23T16:00:00+01:00"
title = "Ibex: Code with Confidence"

+++

Ibex, our small RISC-V core, is constantly changing. [Roughly 50 percent of the
RTL was
refactored](https://www.lowrisc.org/blog/2019/07/six-more-weeks-of-ibex-development-whats-new/)
recently! We added features, tests, and cleaned the code up.  We and our
collaborators were able to make these changes (mostly) without breaking Ibex
because we invested in testing: earlier this year we added [UVM-based
verification to the tree](https://github.com/lowRISC/ibex/tree/master/dv/uvm),
and we run these tests after every change.  We run static code analysis to catch
common programming bugs. We run software on Ibex to see if it actually behaves
as we expect it to behave. For licensing reasons it hasn’t been possible to
share all of these tests - this post will
explain how we’ve been working to address that issue..

We want every contributor to have a similar degree of confidence that their
changes won’t break something, which is why we’ve been building out the test and
continuous integration infrastructure using open source or freely available
tooling. (I talked about the idea behind that at
[WOSH](https://fossi-foundation.org/wosh/), you’re invited to [watch the
recorded talk](https://youtu.be/bYidDwYuVr0) to hear more about it!)

Today, we’re happy to announce a significant step in this direction: we have
enabled publicly visible continuous integration (CI) for Ibex. On every pull
request we now run three tests:

- We run Verilator lint on all SystemVerilog code files. Verilator lint catches
common programming errors such as undefined variables or wrong signal width
definitions.
- We build a cycle-accurate compiled simulation of Ibex with
Verilator.
- Finally, we run the [RISC-V compliance test
suite](https://github.com/riscv/riscv-compliance/) with our cycle-accurate
simulation model of Ibex. This test suite executes a set of small assembly
programs and checks its output against a golden reference.

All of these tests run in a couple of minutes, and all test outputs are [publicly
visible at Azure Pipelines](https://dev.azure.com/lowrisc/ibex/_build).

![Azure pipeline](/img/ICwC_Azure_Pipelines.png "Azure pipeline")

The last test is worth explaining in more depth. The RISC-V Compliance test
suite is a collaborative effort by the RISC-V Foundation Compliance Task Group
to test RISC-V implementations for specification compliance. Lee Moore from
Imperas has been doing a lot of [work to get the test suite extended to work
with
Ibex](https://github.com/riscv/riscv-compliance/commit/25d14e798eb4b3a54bdf22083940e78ef731b817),
and we have done our part by [adjusting the simulation model of
Ibex](https://github.com/lowRISC/ibex/pull/209) to work with it. Once these
building blocks were in place it was only a matter of a [couple of lines of
configuration](https://github.com/lowRISC/ibex/blob/e97931c8c75aad34137db99121249fa675bc9aa3/azure-pipelines.yml#L102-L125)
to enable these tests to run in CI.

With all this infrastructure in place, contributors can submit pull requests
with more confidence than ever: look out for the green check mark under a pull
request!

![All checks have passed](/img/ICwC_checks_passed.png "Screenshot show checks passed")

We are delighted that Ibex can now serve as a [reference end-to-end RTL and ISS
co-simulation flow for
riscv-dv](https://github.com/google/riscv-dv#end-to-end-rtl-and-iss-co-simulation-flow)
and for running the RISC-V compliance suite on an RTL simulation. The
DARPA-funded [OpenROAD](https://github.com/The-OpenROAD-Project/alpha-release)
open source EDA toolchain initiative have also [included
Ibex](https://github.com/The-OpenROAD-Project/alpha-release/tree/master/flow/designs/src/ibex)
as a standard test case.

For us at lowRISC, this is just the start of the automation journey. Continuous
integration in open source hardware projects is uncharted territory for many
reasons, with licensing of proprietary tools adding further complicationWe will
continue to expand the coverage of our publicly available continuous
integration, and we’ll keep you updated here!

_Philipp Wagner_
