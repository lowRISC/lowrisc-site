+++
Description = ""
date = "2019-07-08T10:00:00+01:00"
title = "Introducing Sam"

+++

On June 1st, Sam Elliott followed [Laura and
Pirmin](/blog/2019/06/introducing-pirmin-laura/) in becoming lowRISC’s newest
employee. A few weeks into his new role, he shares why he joined lowRISC and
what he's been doing since he started.

![Sam Elliott photo](/img/sam_elliott.jpg "Sam Elliott")

"I joined lowRISC CIC as a Compiler Developer, working on the RISC-V LLVM
backend, and so far I’m enjoying working on the team! Prior to lowRISC, I worked
as a compilers and programming languages researcher at the University of
Washington, where I completed my Masters degree.

"I worked for about four years on the academic side of compiler research, trying
out new ideas with new technologies. As well as working with academics, during
that time I worked at Microsoft Research, on [Checked
C](https://www.microsoft.com/en-us/research/project/checked-c/), and at NVIDIA
on an experimental compiler team. This was both challenging and fun, but I found
that I was more satisfied with the work when it was closer to problems that
normal software developers face. I’m really happy to have moved over to a more
focused compiler development role on the team here at lowRISC, where I get to
improve LLVM and participate in the wider open source community.

"My first month at lowRISC has been lots of fun. Alex and Luís have been great
mentors to get me up to speed with the project. As we’re hoping to stabilise the
RISC-V backend soon, some of my time has been spent ensuring we can build and
run the LLVM [test suite](https://llvm.org/docs/TestingGuide.html#test-suite) on
RISC-V. Gratifyingly, it seems 98% of the tests are passing – with some pending
patches – and the rest are not far from also doing so. A few of the other
patches I have committed this month have related to tuning the optimiser and
instruction selector to make better decisions for RISC-V. Of course, we’ll never
truly finish tuning the optimiser, especially as more and more instruction set
extensions and open cores are implemented and released.

"On top of all of this, it was good to get out of the office and meet other
RISC-V and open-source hardware supporters at the RISC-V Workshop and WOSH in
Zurich. It was an almost overwhelming amount of information for someone so new
to the ecosystem, but the community has been very friendly and welcoming.

"I’m not just interested in how programs can be compiled to be as efficient as
possible; I’m also interested in how the design of programming languages allow
developers to write programs that contain fewer errors. This is why I joined the
Checked C project, and am interested in Rust. Along these lines I am beginning
to look at improving the support for compiling Rust programs to RISC-V. Rust
uses LLVM as a backend, so a lot of the work is already done, but we want to
make sure the experience of using Rust on RISC-V is as good as it is for any
other platform. Rust support is a key requirement for the RISC-V ports of
distros such as Debian and Fedora, and I look forward to helping stabilise
further support for the platform in these distributions.

"Having stable RISC-V support in both the Clang and Rust compilers, in addition
to the existing support in GCC, should allow more people and projects to adopt
RISC-V and quickly get started on the platform."

----

We're excited to have Sam join our team and help further accelerate our
toolchain and LLVM-related efforts. If you're interested in joining us on our
mission, check out our [jobs page]({{< ref "jobs.md" >}}) for details on
positions we are looking to fill.

_Alex Bradbury, CTO and Co-Founder_
