+++
Description = ""
date = "2019-06-03T10:00:00+01:00"
title = "Introducing Pirmin & Laura"

+++

Pirmin Vogel and Laura James both joined lowRISC on May 1st this year. A few
weeks in to their new roles, they each share thoughts on what attracted them to
work at lowRISC. 

**Pirmin:**

![Pirmin Vogel photo](/img/pirmin_vogel.jpg "Pirmin Vogel")

"After having traveled around the world for 6 months, I finally started my new
position as hardware/software engineer at lowRISC C.I.C. in Cambridge at the
beginning of May. At lowRISC, we are working on open-source hardware/software
ecosystems with a fully open-sourced, Linux-capable, RISC-V-based SoC being the
ultimate goal.

"Having done my PhD in the Digital Circuits and Systems group of ETH Zurich,
i.e., a research group that very early started to promote and push for
open-source hardware, it was important for me to continue along the open-source
path. Open-source hardware and software are powerful catalysts for education,
research and industry. Studying the sources of the Linux kernel and its modules
was absolutely key to get to understand the kernel’s memory management system
and to get started with the design of kernel drivers required for my research.
Moreover, building on top of the open-source Parallel Ultra Low Power (PULP)
Platform allowed me to carry out my research in the first place. Not only could
I rely on a large pool of silicon-proven hardware designs and software tools
such as libraries, runtimes and compilers, but I was also able to freely modify,
tailor and extend them to fit my needs, and ultimately to release my own
research open-source as part of the [Open Heterogeneous Research Platform](
https://www.pulp-platform.org/hero) (HERO), thereby letting my research being more
useful to more people. As for the industry, it seems that the open-source PULP
ecosystem has gained quite some traction since its start in 2013 serving both as
a starting point for custom designs and also creating [new business opportunities]
(https://www.pulp-platform.org/pulp_users.html).

"At lowRISC, I am currently working on our RISC-V processor core [Ibex]
(https://github.com/lowRISC/ibex). This core has its origins in academia – it
has been designed by my former colleagues of the PULP team under the name
Zero-riscy – and leveraging its design in a professional context offers
challenges but also new opportunities. For example, it allows and requires to
put a stronger focus on design verification but ultimately, it can prove also to
the tough critics that open-source hardware is no longer just a toy but a
serious alternative."

**Laura:**

![Laura James photo](/img/laura_james.jpg "Laura James")

"I’m delighted to be joining lowRISC. This is a really exciting
opportunity for me on many levels - a chance to be part of a new wave of
fundamental computing innovation enabling specialised silicon chips, to learn
about the practicalities of shared engineering resource and IP at the hardware
layer, and to actually ship some useful products (hopefully at reasonable
scale). It builds on my varied career to date working to make emerging
technologies a reality in real products and services, and in growing innovative
organisations.

"lowRISC works on open source hardware at the silicon layer (and related open
source software tools), and so builds on my longstanding interest in open stuff,
and particularly the challenges of bringing open to new areas. Open source
silicon isn't a totally new idea, but producing products at scale with it is
rare. Nonetheless, it's important: openness means greater scope for audit and
security; for efficiency (code and hardware designs can be reused, rather than
reinventing the wheel), and for flexibility. With [Moore's law
slowing down](https://semiengineering.com/the-impact-of-moores-law-ending/), new
processors will be more specialised, rather than just smaller and faster.
Instead, we'll be designing silicon for more specific applications, and ensuring
the designs are efficient and verifiable. Open source hardware makes this much
easier - you can get more people working on a design to check it, and you can
bolt together open modules for different bits of functionality knowing you
understand what is in them (which you can't do with a proprietary processor core
which you've licensed - it's just a black box). So open hardware at the silicon
level is going to be important for the future of computing.

"lowRISC itself is still quite small (but growing), but the team size doesn't
reflect the range of people I’m working with day to day, because there's lots of
collaboration going on. Open source ecosystems have different kinds of
organisation and activity in them; lowRISC is focussing on providing quality
engineering resource and being a hub for collaborative engineering across other
partners. (A bit like [Linaro](https://www.linaro.org/) does for open source for
Arm, whose work I’ve always been fascinated by.)  It's a community interest
company, meaning a nonprofit dedicated to serving a broader mission not just
itself. I'm looking forward to being part of changing how hardware is developed,
making it fundamentally more collaborative and factoring in testing and
maintenance sensibly. 

"There are some really interesting challenges. For instance, you can't be 100%
open right now in silicon, because in an actual manufactured chip there's a lot
of analogue components as well as the open source digital bits, and those
analogue bits are generally closely linked to the big foundries which
manufacture silicon and are secret sauce today.  Collaborative engineering
should be cost effective and useful to companies, as a way of working on
non-differentiating technology components, but it's not always an easy sell or
easy to make happen in practice. The same goes for opening up hardware IP - not
always a straightforward case to make. How should the governance for this sort
of work operate, and how do you make it work in practice? And of course we have
the usual startup challenge, that we need to make reliable, high quality
products, in a reasonable time, which people actually want and are willing to
pay for.

"I’m really looking forward to seeing what we can accomplish, and being part of
the move towards open source silicon.

"(If you’d like to learn more about how I ended up here, I wrote on [my personal
blog](https://lbj20.blogspot.com/2019/04/new-challenges-ahead.html) about this
role and how it fits with things I’ve been working on.)"

----

We're thrilled to have Pirmin and Laura join the lowRISC team and if you'd like
to be part of the open source silicon revolution, we presently have a number
of openings and I'd encourage you to take a look at the [jobs page]({{< ref
"jobs.md" >}}).

_Alex Bradbury, CTO and Co-Founder_

