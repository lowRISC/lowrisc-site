+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Prepare to launch X-windows"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### X-windows introduction

X-windows operates a bit differently from imitators such as Microsoft Windows, the core protocol
is designed to run over a network connection or serial line to a separate display device, this connection
can also be a unix local socket, and although the display (known as the server) is frequently on the same computer as the
client(s), it need not be so and the configuration options (in particular the DISPLAY environment variable) reflect
the extra complexity. For remote usage authentication is typically managed using the -X or -Y options of the ssh client
on the remote client machine. This obviates the need for the server to have a display at all (known as headless operation).
The best performance is associated with local rendering (client==server) usually.

* [Booting the kernel from QSPI memory] ({{< ref "docs/boot-qspi.md">}})
* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})

### Configuring X-windows

An initial configuration for X-windows will be created automatically in the sdcard-install step and its dependencies.
There should be no special reason to modify this file in the hardware configurations offered by LowRISC, but pointing out the
obvious there needs to be a mouse device, and a core keyboard which generates X-events as opposed to ASCII that a remote
serial connection would generate. The LowRISC team recommends that a Bluetooth mouse and keyboard should be used though other
obsolescent options are possible (for example the PS/2 over USB keyboard that the previous release supported, and/or a PS/2 mouse
which unfortunately requires 5V power and the PMOD PS/2 adaptor only supplies 3.3V)

    Section "ServerFlags"
            Option "AutoAddDevices" "false"
    EndSection

    Section "ServerLayout"
            Identifier     "X.org"
            Screen      0  "Screen0" 0 0
    EndSection

    Section "Files"
            ModulePath   "/usr/lib/xorg/modules"
            FontPath     "/usr/share/fonts/X11/misc"
            FontPath     "/usr/share/fonts/X11/100dpi/:unscaled"
            FontPath     "/usr/share/fonts/X11/75dpi/:unscaled"
            FontPath     "/usr/share/fonts/X11/Type1"
            FontPath     "/usr/share/fonts/X11/100dpi"
            FontPath     "/usr/share/fonts/X11/75dpi"
            FontPath     "built-ins"
    EndSection

    Section "Device"
            Identifier "LowRISC"
            Driver     "fbdev"
            BusID      "AXI"
    EndSection

    Section "Screen"
            Identifier "Screen0"
            Device     "Card0"
            Monitor    "Monitor0"
            DefaultDepth 8
            DefaultFbBpp 8
    EndSection

    Section "InputDevice"
            Identifier "Generic Keyboard"
            Driver "kbd"
            Option "CoreKeyboard"
    EndSection

    Section "InputDevice"
            Identifier "Generic Mouse"
            Driver "mouse"
            Option "CorePointer"
    EndSection

## X startup clients

These are customised based on the file /etc/X11/xinit/xinitrc. These may readily be changed by the user, by copying this file into ~/.xinitrc

    oclock -geometry 75x75-0-0 &
    xload -geometry -80-0 &
    xterm -geometry +0-100 &
    twm &
    /usr/games/xfishtank

The order of clients is significant on an 8-bit server. Only 256 colours are available, so the most greedy client in terms of colours usage should be last. This will have the side effect that the X-server will shutdown if xfishtank crashes.

## Preparing the Bluetooth keyboard and mouse.

The only Bluetooth device available as a PMOD from Digilent is the PmodBT2 which uses Roving Networks [RN42 module] (http://ww1.microchip.com/downloads/en/devicedoc/rn-42-ds-v2.32r.pdf) which uses a CSR BC04-EXT internally. Out of the box it only supports a serial port profile (SPP), it needs to be switched to host command interface (HCI) mode.




