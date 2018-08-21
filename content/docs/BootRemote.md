+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Build your own bitstream and images"
parent = "/docs/fpga-v0.6/"
showdisqus = true

+++


### Boot Linux remotely on FPGA

You should have examples of remote booting in the Makefile known as etherlocal and etherremote.

Modify or duplicate these examples to reflect your local network topology, then

    make etherlocal or make etherremote
    
