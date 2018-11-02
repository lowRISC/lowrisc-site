+++
date = "2018-10-11T14:00:00Z"
title = "RISC-V LLVM Coding Lab at the LLVM Developers' Meeting 2018"

+++

Alex Bradbury is running a [Coding 
Lab](https://llvmdev18.sched.com/event/HGJT/coding-lab-for-risc-v-tutorial) at 
the [2018 LLVM Developers' Meeting](https://llvm.org/devmtg/2018-10/) to 
complement his [LLVM backend 
tutorial](https://llvmdev18.sched.com/event/H2UV/llvm-backend-development-by-example-risc-v).

This coding lab will build on the material presented in the backend and guide 
you through some sample modifications to the RISC-V backend, including both 
codegen and MC layer (assembler/disassembler) modifications. Anyone familiar 
with C++ and a passing familiarity with LLVM IR should be able to get 
something out of this session, and you're able to go at your own pace.

This page will be updated with full instructions prior to the coding lab.

You will need:

* A laptop
* A debug build of a recent HEAD LLVM with the RISC-V backend enabled 
(see below). Incremental builds should be relatively fast, but if your 
laptop is underpowered you may want to plan to ssh out to a faster machine you 
own.

## Tutorial slides

You will likely find it useful to refer to the 
[slides](https://speakerdeck.com/asb/llvm-backend-development-by-example-risc-v) 
from my tutorial presentation.

## Building LLVM

The canonical source for LLVM build instructions are the [getting started 
guide](https://llvm.org/docs/GettingStarted.html) or [instructions on building 
LLVM with CMake](https://llvm.org/docs/CMake.html). I outline my recommended 
options below.

When developing LLVM you really want a build with
debug info and assertions. This leads to huge binaries and a lot of
work for your linker. GNU ld tends to struggle in this case and it's likely 
you'll encounter long build times and/or run out of memory if GNU ld is your 
system linker (`ld --version` reports "GNU ld"). Linkers such as GNU gold or 
LLVM's lld do not have this problem. The following instructions will check out 
and build LLVM using a system `clang` and `lld`, installed from your package 
manager. If you're on Debian or Ubuntu, you may want to look at the packages 
available at [apt.llvm.org](http://apt.llvm.org/).

    git clone http://llvm.org/git/llvm.git
    cd llvm
    mkdir build
    cd build
    cmake -G Ninja -DCMAKE_BUILD_TYPE="Debug" \
      -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
      -DLLVM_BUILD_TESTS=True \
      -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
      -DLLVM_ENABLE_LLD=True \
      -DLLVM_TARGETS_TO_BUILD="all" \
      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV" ../
    cmake --build .

The cmake options are chosen in order to allow a relatively fast
incremental rebuild time.

## First steps
All commands in this document assume you are in the `build/` directory you 
created and ran cmake from. All file name references are relative to the 
project root.  I recommend having one terminal in the project root and another 
in the build directory, used just for building and running tests.

Firstly, check your just-built LLVM:

    ./bin/llc --version

Now let's run the RISC-V tests:

    ./bin/llvm-lit -s -i -v test/CodeGen/RISCV test/MC/RISCV

Next, inspect the isel debug output for a simple test (you may want to extract 
a single function to a separate file)

    ./bin/llc -mtriple=riscv32 -verify-machineinstrs \
      < ../test/CodeGen/RISCV/alu32.ll -debug-only=isel

And inspect the records produced by tablegen (search for RISCV in the output):

    ./bin/llvm-tblgen -I ../lib/Target/RISCV/ -I ../include/ -I ../lib/Target/ \
       ../lib/Target/RISCV/RISCV.td | less


## Incremental development how-to

The basic approach is to first build any changes:

    cmake --build .

Then re-run the tests:

    ./bin/llvm-lit -s -i test/CodeGen/RISCV test/MC/RISCV

If you used the build options I recommended, have a reasonable linker (GNU 
gold or lld) and a machine that's not completely underpowered most changes 
should have a fairly fast iteration time. e.g. 30s or less, depending on the 
file modified.

I strongly encourage you to make full use of git, committing changes when they 
make sense and reminding yourself what you changed with git diff.

## Code study (optional)

The RISC-V backend implementation lives in `lib/Target/RISCV`. You might want 
to look at some of the files we mentioned in the tutorial. e.g.
RISCVInstrInfo.td, RISCVRegisterInfo.td.

You may also want to look in build/lib/Target/RISCV to see some of the 
tablegenerated files (all named `*.inc`).

## Task 1: Improving immediate materialisation

Problem: For RV32, any 32-bit constant can be materialised in at most two 
instructions: lui+addi. However, when compiling with the RVC (compressed) 
instruction set, we want to select instructions that may have a 16-bit 
compressed form. One improvement would be to select `addi $reg, zero, -1` and 
`srli $reg, $reg, N` for any constant that is comprised of `N` 0s in the upper 
bits and 32-N 1s in the lower bits.

What is materialisation? This just refers to the process of loading a constant 
into a register.

First of all, write a test for this in `test/CodeGen/RISCV/newimm.ll`:

    ; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
    ; RUN:   | FileCheck %s -check-prefix=RV32I

    define i32 @shiftedmask() nounwind {
      ret i32 16777215
    }

Unfortunately hex literals are reserved for floating point constants, so we 
have to use the decimal representation of 0xffffff.

You can directly check out output of this test by running:

    ./bin/llc -mtriple=riscv32 -verify-machineinstrs < \
    ../test/CodeGen/RISCV/newimm.ll

Now, lets generate check lines to capture the current lowering:

    ../utils/update_llc_test_checks.py --llc-binary=./bin/llc \
      ../test/CodeGen/RISCV/newimm.ll

If you reload newimm.ll you'll see that the test now tracks the generated 
instructions.

Next we want to try to improve lowering in this case. Although we want a 
general solution for immediates of this type, let's start with the simplest 
possible change and introduce a pattern in RISCVInstrInfo.td just for that 
immediate:

    def mask24 : ImmLeaf<XLenVT, [{return Imm == 0xffffff;}]>;
    def : Pat<(mask24), (SRLI (ADDI X0, -1), 8)>, Requires<[IsRV32]>;


Put this pattern just before the existing immediate patterns (search for `/// 
Immediates` in the file). Note that we mark the pattern as valid only for the 
32-bit RISC-V target, because a 40-bit shift would be need to produce the same 
bit pattern on RV64.

Now run the test and see if it matched. If it didn't, remember you can pass 
`-debug-only=isel` to llc to look in more detail.

We've just defined the `mask24` `Immleaf`, which will match any immediate with 
the value 0xffffff. The pattern defined on the next line expands that 
immediate to the desired addi+srli pair. But now we want to extend this to 
match any immediate with a bit pattern that means it can be materialised by 
shifting -1, with the proviso that it should be profitable to do so. This 
could be done solely within RISCVInstrInfo.td with the addition of:

1. A new ImmLeaf to match immediates with that property. You'll need to change 
the predicate. Check include/llvm/Support/MathExtras.h for useful helper 
functions
2. A new SDNodeXForm that produces a constant representing the number of bits 
to shift by (see current SDNodeXForm examples)

Or alternatively, a C++ selection code could be introduced in 
RISCVDAGToDAGISel::Select in RISCVISelDAGToDAG.cpp. This patch shows a good 
example of how to create `MachineSDNode`s. <https://reviews.llvm.org/D52962>

Lets modify the existing ImmLeaf. As the instruction selector will prefer 
shorter output patterns, we don't need to explicitly guard against the case 
where it would be cheaper to just generate `ADDI` (e.g. for immediates like 
2047 or 1). As it happens, `isMask_64` checks the exact property we want. You 
might want to add some new tests for mask-like constants to newimm.ll (e.g.  
268435455), then change the predicate and re-run the test file to see if it 
matches. The generated code will be incorrect (as a shift of 8 is always 
selected), but we'll address that now.

We need to define a new `SDNodeXForm` which will take the immediate and 
produce the appropriate shift width for use in our output pattern.
`countLeadingZeros` from `MathExtras.h` will be useful for this. You should now
have:

		def LeadingZeros32 : SDNodeXForm<imm, [{
			return CurDAG->getTargetConstant(countLeadingZeros<uint32_t>(N->getZExtValue()),
																			 SDLoc(N), N->getValueType(0));
		}]>;
		def mask : ImmLeaf<XLenVT, [{return isMask_64(Imm);}]>;

Finally, lets replace the previous pattern. I've marked the output pattern as
TODO for you to fill out. See the nearby immediate patterns for examples of
using an `SDNodeXForm`.

    def : Pat<(mask:$imm), (TODO)>, Requires<[IsRV32]>;

Extension task: match an `and` with a mask of this type directly to `slli` and 
`srli`, thus avoiding the need for a register. Although saving a register, the 
downside of this codegen choice is that it may result in more instructions in 
the case that the same mask is used multiple times.

## Task 2: Adding bit manipulation instruction(s)

Aim: add a new instruction to the RISC-V LLVM backend. First introduce it to 
the MC layer (i.e. add assembler support). Then add codegen support.

To simplify things, we will have this instruction enabled by default rather 
than requiring a specific extension to be enabled.

First, we'll add a test. Create test/MC/RISCV/bitrev.s:

		# RUN: llvm-mc %s -triple=riscv32 -riscv-no-aliases -show-encoding \
		# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
		# RUN: llvm-mc -filetype=obj -triple=riscv32 < %s \
		# RUN:     | llvm-objdump -riscv-no-aliases -d -r - \
		# RUN:     | FileCheck -check-prefixes=CHECK-OBJ,CHECK-ASM-AND-OBJ %s

		# CHECK-ASM-AND-OBJ: bitrev a0, a1
		bitrev a0, a1

You can directly execute this test with:

	./bin/llvm-mc /local/scratch/asb58/llvm-repos/llvm/test/MC/RISCV/bitrev.s -triple=riscv32 -show-encoding

Open up lib/Target/RISCV/RISCVInstrInfo.td and study the instruction 
definitions. You want to define a new unary instruction for bitreverse.

Lets create a new instruction:

		let hasSideEffects = 0, mayLoad = 0, mayStore = 0, rs2 = 0 in
		def BITREV
				: RVInstR<0b1111111, 0b111, OPC_OP, (outs GPR:$rd), (ins GPR:$rs1),
									"bitrev", "$rd, $rs1">;

Now check that the bitrev.s passes, e.g. `./bin/llvm-lit -v test/MC/RISCV/bitrev.s`.

Next, we want to support codegen. Start by defining a test in 
test/CodeGen/RISCV/bitrev.ll

    ; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
    ; RUN:   | FileCheck %s -check-prefix=RV32I
    declare i32 @llvm.bitreverse.i32(i32)

		define i32 @bitrev(i32 %a) {
			%1 = call i32 @llvm.bitreverse.i32(i32 %a)
			ret i32 %1
    }

If you run this through llc, you'll see it generates a huge amount of code 
right now.

The first step to enabling codegen is to mark the `ISD::BITREVERSE` 
SelectionDAG opcode as legal. Do this in the RISCVTargetLowering constructor 
in RISCVISelLowering.cpp:

    setOperationAction(ISD::BITREVERSE, XLenVT, Legal);

You can check the definitions of SelectionDAG pattern fragments such as 
`bitreverse` in `include/llvm/Target/TargetSelectionDAG.td` and of 
SelectionDAG opcodes in `include/llvm/CodeGen/ISDOpcodes.h`.

Now define a pattern mapping the `bitreverse` SelectionDAG node to the 
`BITREV` instruction and re-run the test.

Extension: dream up further instructions and add support for them, perhaps
adding new reg-immediate instructions.

## Task 3: Undoing an detrimental dagcombine

Consider the following somewhat contrived example which aligns an input value:

		; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
		; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
		; RUN:   | FileCheck %s -check-prefix=RV32I

		define i32 @aligner(i16 zeroext %a) nounwind {
		; RV32I-LABEL: aligner:
		; RV32I:       # %bb.0:
		; RV32I-NEXT:    lui a1, 32
		; RV32I-NEXT:    addi a1, a1, -16
		; RV32I-NEXT:    addi a0, a0, 15
		; RV32I-NEXT:    and a0, a0, a1
		; RV32I-NEXT:    ret
			%1 = zext i16 %a to i32
			%2 = add i32 %1, 15
			%3 = and i32 %2, -16
			ret i32 %3
		}

This example is contrived, but similar code sequences can occur for the 64-bit 
RISC-V target.

Note that the generated code is suboptimal. Why isn't a simple `andi a0, a0,
-16` selected?

Let's inspect the ISel debug output to investigate:

    ./bin/llc -mtriple=riscv32 < ../test/CodeGen/RISCV/aligner.ll -debug-only=isel

Look at the DAG just prior to the start of instruction selection:

		Optimized legalized selection DAG: %bb.0 'aligner:'
		SelectionDAG has 12 nodes:
			t0: ch = EntryToken
							t2: i32,ch = CopyFromReg t0, Register:i32 %0
						t4: i32 = AssertZext t2, ValueType:ch:i16
					t8: i32 = add t4, Constant:i32<15>
				t15: i32 = and t8, Constant:i32<131056>
			t12: ch,glue = CopyToReg t0, Register:i32 $x10, t15
			t13: ch = RISCVISD::RET_FLAG t12, Register:i32 $x10, t12:1

We can see that during SelectionDAG lowering, the constant operand to `and` 
was mutated from `-16` (which can be used in `ANDI`) to 131056 (0x1FFF0 in 
hex), which does not look correct. Looking at the SelectionDAG dumped after each stage, we 
can see that the constant is mutated during the first DAG combine.

Running `llc` with `-debug-only=dagcombine` we can see when this happens:

    Combining: t10: i32 = and t8, Constant:i32<-16>

    Replacing.2 t10: i32 = and t8, Constant:i32<-16>

    With: t15: i32 = and t8, Constant:i32<131056>

You can open up `lib/CodeGen/SelectionDAG/DAGCombiner.cpp` and inspect 
`DAGCombiner::visitAND` to see all the combines. In order to narrow down 
exactly which one is causing the problem, it may be easiest to get a stack 
trace from the point the mutated constant is created. Either use your 
favourite debugger to add a breakpoint in `SelectionDAG::getConstant` in 
`lib/CodeGen/SelectionDAG/SelectionDAG.cpp` or insert 
`sys::PrintStackTrace(llvm::errs())` (being sure to include 
`include/llvm/Support/Signals.h`). This shows that the culprit is 
`SimplifyDemandedBits` called from `visitAND` at line 4671 (in my checkout).

The problem is that `SimplifyDemandedBits` is recognising that not all bits of 
the mask are actually needed (the upper 16 bits are known-zero before the 
addition and the addition can only affect a small number of bits), so it's creating 
a constant without those upper bits set. This isn't a beneficial 
transformation for this input because the new mask no longer fits into an 
immediate.

Now we've identified the source of the problem, what can we do to fix it? We 
could either try to modify the target-independent DAG combiner to recognise 
this case in somehow, or undo the combine in the backend. We'll elect to 
handle this in our backend. We're going to do this by writing some C++ 
instruction selection logic. As well as demonstrating the process of 
investigating when the input to instruction selection isn't what's expected, 
this task also demonstrates another common backend development approach: 
learning from other backends. X86 actually handles this case in
`X86DAGToDAGISel::shrinkAndImmediate`.

Open up `lib/Target/RISCV/RISCVISelDAGToDAG.cpp`. We're going to edit the 
switch statement in `RISCVDagToDAGISel::Select`. We need to recognise an 
`ISD::ADD` SelectionDAG node where:

* It has a constant operand
* The constant operand doesn't fit in the 12-bit immediate field of `ANDI`
* That constant operand has N leading zero bits
* Setting those N leading bits to 1 would result in a signed 12-bit immediate
* The most significant N bits of the first input operand are known to be zero

This is quite fiddly, so I've provided the majority of the logic for you:

    case ISD::AND: {
      SDValue Op0 = Node->getOperand(0);
      auto *Op1C = dyn_cast<ConstantSDNode>(Node->getOperand(1));
      // Check we have a constant operand.
      if (!Op1C)
        break;
      APInt MaskVal = Op1C->getAPIntValue();
      // Check the mask currently doesn't fit in ANDI immediate.
      if (MaskVal.getMinSignedBits() <= 12)
        break;
      unsigned MaskLZ = MaskVal.countLeadingZeros();
      APInt HighOnes = APInt::getHighBitsSet(MaskVal.getBitWidth(), MaskLZ);
      APInt NewMaskVal = MaskVal | HighOnes;
      // If we were able to set the N upper zero bits to ones, would the new
      // mask fit in the ANDI immediate?
      if (NewMaskVal.getMinSignedBits() > 12)
        break;
      // Are the upper N bits of the first operand known to be zero?
      if (!CurDAG->MaskedValueIsZero(Op0, HighOnes))
        break;
      llvm_unreachable("Replace me with code to select the new ANDI!");
      return;
    }

Note that we use LLVM's arbitrary precision integer representation. The 
"magic" happens in the call to `MaskedValueIsZero`. This in turn calls the 
`computeKnownBits` helper, which is very important for a number of 
optimisations. 

I encourage you to step through the above logic carefully, then re-run `llc` 
with `aligner.ll` as its input to verify that the `llvm_unreachable` is hit 
(i.e. the preceding logic identified a candidate for this transformation).

You'll now need to create a TargetConstant for the new mask, and call 
`CurDAG->ReplaceNode` with the selected `MachineSDNode`. See my tutorial 
slides for an example of this, or look for examples elsewhere in 
`RISCVISelDAGToDAG.cpp`.

With your change in place, you should see the `andi a0, a0, -16` generated 
from `aligner.ll`.

Warning: this transformation was not heavily tested. It's quite possible you 
can spot a bug. Please let me know if so.
