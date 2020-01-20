+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Compiling and running a game"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Introduction

X-windows comes with its own toolkit for X-windows client development. We will use this to compile and run a game on the FPGA.

First of all, check out the source code:

    lowrisc@lowrisc:~$ git clone https://github.com/jrrk/cbzone.git
    Cloning into 'cbzone'...
    remote: Enumerating objects: 71, done.
    remote: Counting objects: 100% (71/71), done.
    remote: Compressing objects: 100% (51/51), done.
    remote: Total 71 (delta 24), reused 63 (delta 18), pack-reused 0
    Unpacking objects: 100% (71/71), done.

Then, make using maximum optimisation:

    lowrisc@lowrisc:~$ cd cbzone/
    lowrisc@lowrisc:~/cbzone$ time make
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_draw.o c_draw.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_explode.o c_explode.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_gpr.o c_gpr.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_graphics.o c_graphics.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_main.o c_main.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_move.o c_move.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_parseopts.o c_parseopts.c
    cc -DTANKDIR=\"/var/tmp/\" -O3   -c -o c_scores.o c_scores.c
    gcc -o cbzone c_draw.o c_explode.o c_gpr.o c_graphics.o c_main.o c_move.o c_parseopts.o c_scores.o -lXt -lXext -lX11 -lm

    real	9m3.809s
    user	6m42.279s
    sys	0m28.397s

It is entirely possible that paging and/or swapping will occur on the Nexys4-DDR which has only 128MB of RAM. Needless to say, it would not be advisable to try any of the parallel options of make.

    lowrisc@lowrisc:~/cbzone$ size cbzone
       text	   data	    bss	    dec	    hex	filename
      61053	  10554	    872	  72479	  11b1f	cbzone
    
We observe at this point that the size of the program is a fairly good fit to L1 caches (32K code, 32K data)

    lowrisc@lowrisc:~/cbzone$ ./cbzone

The game is launched, with a private colourmap and mouse at the ready.

