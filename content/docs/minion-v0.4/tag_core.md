+++
Description = ""
date = "2017-04-11T17:00:00+00:00"
title = "Tag support in the Rocket core"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/tag_cache/"
showdisqus = true

+++

### Motivation

In our previous [tagged-memory release]({{< ref "docs/tagged-memory-v0.1/tags.md" >}}),
special instructions are added to read and write tags for words in memory.
However, there is no easy way to use tags in checking anomalies,
such as protecting the return address from being altered on stack (important for protection against control-flow hijacking)
or triggering an exception when accessing a specific address (unlimited
hardware watch-points).
In this release, we incorporate these essential tag manipulation and check functions into the normal
RISC-V instructions and the Rocket core, which enables support for a range of
tag-related use cases.
This is our first attempt to incorporate tag functionality into the core pipeline, which is far from a hardened SOC from a security perspective.
More investigation and improvement will be made in following releases.


### Extension to the Rocket core

To support built-in tag manipulation and check in the Rocket core,
all general purpose registers (GPRs) and some exception related CSRs are extended with tags (excepted for `x0` whose tag is hardwired to `0`).
The L1 instruction cache feeds the instruction decoder (ID) stage with instructions along with their tags.
The L1 data cache is revised to store tags alongside data.
Several tag processing units (*tagProc*) and tag check units (*tagChck*) are added to the various stages of the Rocket core pipeline
and the L1 data cache pipeline, as shown in the diagram below.
To allow tag propagation between register data and register tags, some multiplexers are added in the MEM stage.

<p style="text-align:center;"><img src="../figures/tagpipe.png" alt="Drawing" style="width: 700px; padding: 20px 0px;"/></p>

Each tag unit added in the core pipeline executes a tag function, which can be enabled at run-time.
Here is a summary of the various tag functions supported in the expanded Rocket core.
Every function is controlled by a dedicated mask. The collection of all masks are placed in a 64-bit register called `tagctrl`.
It is assumed that a 4-bit tag is attached to every 64-bit data word and every instruction (regardless to the size of the instruction)
has a 2-bit tag which is correspondingly aligned to the 32-bit data boundary.


| Function                   |          Mask    |                        | Pipeline Stage   | &nbsp;&nbsp;&nbsp;&nbsp; Description              |
| :---                       |  ---:            |   :---                 | :---             | :---                                              |
| ALU tag propagation        |       `ALU_PROP:`|` 4-bit tagctrl[7:4]`   | EX *tagProc*     | \[ALU\] propagate tags from source to destination registers. |
| Load tag propagation       |      `LOAD_PROP:`|` 4-bit tagctrl[15:12]` | D$ *tagProc*     | \[load/AMO\] propagate tags from memory to the destination register. |
| Store tag propagation      |     `STORE_PROP:`|` 4-bit tagctrl[23:20]` | D$ *tagProc*     | \[store/AMO\] propagate tags from `rs2` to memory. |
| Store tag preservation     |     `STORE_KEEP:`|` 4-bit tagctrl[27:24]` | D$ *tagProc*     | \[store/AMO\] preserve some tag bits form being cleared. |
| Jump tag propagation       |       `JMP_PROP:`|` 4-bit tagctrl[39:36]` | MEM *tagProc*    | \[JAL/JALR\] set the tag of the link register. |
| ALU tag check              |      `ALU_CHECK:`|` 4-bit tagctrl[3:0]`   | EX *tagChck*     | \[ALU\] check if certain bits are set in the tags of source registers. |
| Load tag check             |     `LOAD_CHECK:`|` 4-bit tagctrl[11:8]`  | D$ *tagChck*     | \[load/AMO\] check if certain bits are set in the memory tag. |
| Store tag check            |    `STORE_CHECK:`|` 4-bit tagctrl[19:16]` | D$ *tagChck*     | \[store/AMO\] check if certain bits are set in the memory tag. |
| Instruction tag check      |    `FETCH_CHECK:`|` 2-bit tagctrl[41:40]` | ID *tagChck*     | \[all\] check if certain bits are set in the instruction tag. |
| Jump tag check             |      `JMP_CHECK:`|` 4-bit tagctrl[35:32]` | EX *tagChck*     | \[JALR\] check if certain bits are not set in the tag of `rs1`. |
| Directional target check   |  `CFLOW_DIR_TGT:`|` 2-bit tagctrl[29:28]` | MEM *tagChck*    | \[branch/JAL\] if jump, check the instruction tag of the jump target. |
| Indirectional target check |`CFLOW_INDIR_TGT:`|` 2-bit tagctrl[31:30]` | MEM *tagChck*    | \[JALR\] if jump, check the instruction tag of the jump target. |


Similar to the previous release, two special instructions are provided to read and write the tag of a GPR (rather than a memory word in the previous release).
These two instructions can be used to read/write tags in all privilege levels
and are not affected by the
*ALU tag propagation* and the *ALU tag check* masks.

~~~
TAGR  [   imm[11:0]  ][  rs1  ][ funct3 ][  rd   ][  opcode  ]
            12'd0        src     3'b000    dest    7'b1010111

TAGR rd, rs1;  // (rd, rd_t) <= (rs1_t, 0)


TAGW  [   imm[11:0]  ][  rs1  ][ funct3 ][  rd   ][  opcode  ]
            12'd0        src     3'b001    dest    7'b1010111

TAGW rd, rs1;  // (rd, rd_t) <= (rd, rs1)
~~~

#### ALU tag propagation and check

For any ALU instructions, such as `add`, `addi`, `or`, `andi`, etc., the tag of the destination register (`rd_t`) is updated according to the equation below.
When `rs2` is replaced with an immediate number, `rs2_t` is 0.
At the same time, a tag check can be applied. An exception (`xcpt!`) is raised
when the check fails.

    rd_t <= (rs1_t | rs2_t) & ALU_PROP
    ((rs1_t | rs2_t) & ALU_CHECK) != 0 -> xcpt!


#### Load tag propagation and check

For any load or atomic memory operation, the tag from memory (`mem_t`) is
copied to `rd_t` under the control of mask `LOAD_PROP`.
This tag propagation ignores the width of the load and always overwrites all bits of `rd_t`.
A check is performed on `mem_t` if the mask `LOAD_CHECK` is non-zero.
This feature can be used for compartment isolation, memory safety or data watch-points.

    rd_t <= mem_t & LOAD_PROP
    (mem_t & LOAD_CHECK) != 0 -> xcpt!

#### Store tag propagation, preservation and check

For any store or atomic memory operation, the tag from `rs2` (`rs2_t`) is copied to `mem_t` under the control of the mask `STORE_PROP`.
At the same time, the `STORE_KEEP` mask prevents certain tag bits from being cleared by `rs2_t`.
Like load, store tag propagation also ignores the data width and always overwrites all bits of `mem_t`.
A check is performed on `mem_t` if the `STORE_CHECK` mask is non-zero.
This feature can be used for type tags, fine-grained memory protection, or data watch-points.

    mem_t <= (mem_t & STORE_KEEP) | (rs2_t & STORE_PROP)
    (mem_t & STORE_CHECK) != 0 -> xcpt!

#### Instruction tag check

The tag of an instruction (`inst_t`) can be checked against the `FETCH_CHECK` mask.
This feature can be used for breakpoints.

    (inst_t & FETCH_CHECK) != 0 -> xcpt!

#### Jump related tag operations

For a jump instruction, assuming jump is either unconditional or conditional but taken,
a mask (`CFLOW_INDIR_TGT` for `JALR` otherwise `CFLOW_DIR_TGT`) is stored as the tag for the program counter (noted as `pc_t`) of the next instruction (the jump target).
When the jump target is executed, its `inst_t` is checked against `pc_t`.
This feature can be used to protect control flow integrity.

    for directional jump:   pc_t <= CFLOW_DIR_TGT
    for JALR:               pc_t <= CFLOW_INDIR_TGT
    non-jump instructions:  pc_t <= 0
    all instructions:       (inst_t & pc_t) != pc_t -> xcpt!

For indirect jumps, `rs1_t` can be checked against mask `JMP_CHECK`.
Also for all unconditional jumps (`JAL/JALR`), mask `JMP_PROP` is used to set the tag of the link register (`rd_t` in this case).

    for JALR:      JMP_CHECK != 0 && (rs1_t & JMP_CHECK) == 0 -> xcpt!
    for JAL/JALR:  rd_t <= JMP_PROP

### Program guidance

Here is a short discussion of how to utilise the tag functions in assembly programs.

#### The tag control register

The tag control register (`tagctrl`) is initialised to 0 after reset, which disables all tag propagation and checks.
To enable a specific tag propagation or check function, a proper non-zero mask must be written to `tagctrl`.

In this release, the `tagctrl` register is mapped to a machine mode W/R CSR `mtagctrl` at address 0xbf0, which is then shadowed to
a supervisor mode R/W CSR `stagctrl` at address 0x9f0 and a user mode R/W CSR `utagctrl` at address 0x8f0.
Shadowed CSRs can be used to read the current value of `tagctrl`.
When writing to a shadowed CSR, the writable bits are controlled by the two machine mode R/W CSRs `mutagctrlen` (0x7f0) and `mstagctrlen` (0x7f1)
for user and supervisor modes respectively.
The write operations comply with the following equations:

~~~
tagctrl <= (wdata & mutagctrlen) | (tagctrl & ~mutagctrlen)  // user mode
tagctrl <= (wdata & mstagctrlen) | (tagctrl & ~mstagctrlen)  // supervisor mode
tagctrl <= wdata                                             // machine mode
~~~

The initial values of `mutagctrlen` and `mstagctrlen` are all-ones to give full access to `tagctrl` in all modes.
Note we are still investigating the proper mechanism for context switch.
The definition of the `tagctrl` register is prone for further refinement.

A set of macros (`TMASK_XXX` and `TSHIM_XXX`) are provided in the `encoding.h` header file for easy tag function configuration.

#### Handle tag check exceptions

When a tag check fails, an `TAG_CHECK_FAIL` exception is raised with the `cause` CSR set to 0x10 and `epc` pointing to the exceptional instruction.
It relies on the exception handler to check the specific failed function and clear the cause of the tag check failure.
If the cause is not rectified, the program would end up in an infinite loop of tag exceptions.

The following CSRs are extended with tags and can be safely read/written using GPRs without losing tags.

| CSR Name               | Usage                                             |
| :---                   | :---                                              |
| `mepc`, `sepc`         | preserve the pc tag for the exceptional instruction. |
| `mscratch`, `sscratch` | allow the scratch CSR used for preserve tags      |
| `mtvec`, `stvec`       | special pc tag check for exception handler vector |

When some tag checks are enabled, especially the jump related tag checks, you might want to disable them for exception handlers.
Currently there is no atomic support for this feature.
Example assembly sequences is provided to disable/enable tag checks for exception handlers.
Note that these sequences must be used as macros rather than sub-routines as any jump may cause embedded exceptions.

~~~
; disable tag check and enable propagation for machine exception
#define ENTER_TAG_MACHINE         \
    csrr t5, mtagctrl;            \
    csrw mscratch, t5;            \
    li   t6, TMASK_ALU_PROP;      \
    li   t5, TMASK_LOAD_PROP;     \
    or   t6, t6, t5;              \
    li   t5, TMASK_STORE_PROP;    \
    or   t6, t6, t5;              \
    csrw mtagctrl, t6;            \

; recover to the tag configuration before exception
#define EXIT_TAG_MACHINE          \
    csrr t5, mscratch;            \
    csrw mtagctrl, t5;            \

~~~

#### Asynchronous Load/Store tag exceptions

Currently the exceptions caused by Load/Store tag checks may be asynchronous.
If the load/store operation ends up missing in the L1 D$, the non-blocking D$ would fetch the missing cache line without blocking the core pipeline.
The missed load/store instructions are processed out-of-order with the ALU instructions.

When the missing cache line is fetched later, it may fail in the tag check. An exception is still raised with the right exceptional pc but out-of-sync with the core pipeline.
This behaviour leads to two issues: asynchronous tag exception and miscounting the retired instructions (`retire` CSR).

The error towards the number of retired instructions is small.
As for the asynchronous tag exception, a later release will fix this issue by rolling-back the core pipeline with a reorder buffer.
For this release, the `fence.i` instruction can be used to enforce synchronous load/store exceptions, but with a high overhead.

#### Tag regression tests

A relatively thorough regression test suite is provided for the tag functions in `vsim/riscv-tests/tag`.
It is possible to run this test suite by executing

    make run-tag-tests

in the `vsim` directory.
