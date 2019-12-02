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
which unfortunately requires 5V power and the PMOD PS/2 adaptor only supplies 3.3V). To use this support, check out revision 601c4db411b44eb8c3f3ac1ffa0e32b8f60c4448 of the lowrisc-chip repository hot-wire the 5V supply as shown below:

<a name="PS/2 mouse hot wiring"></a>
<img src="/img/ps2mouse.png" alt="Drawing" style="width: 600px; padding: 20px 0px;"/>

## Configuration section

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

The only Bluetooth device available as a PMOD from Digilent is the PmodBT2 which uses Roving Networks [RN42 module] (http://ww1.microchip.com/downloads/en/devicedoc/rn-42-ds-v2.32r.pdf) which uses a CSR BC04-EXT internally. Out of the box it only supports a serial port profile (SPP), it needs to be switched to host command interface (HCI) mode. This is a once only procedure per module and is explained [here]({{< ref "docs/pmod-bt.md">}})

## Pairing the Bluetooth HID devices

After booting, log in as root. First of all attach the serial port to the kernel bluez stack:

    hciattach ttyS1 bcsp

expect to see output like this:

    Device setup complete
    Bluetooth: Out-of-order packet arrived, got 3 expected 0
    Bluetooth: hci0: hardware error 0x37

In spite of this, the attachment succeeds.

Next launch bluetoothctl (first-time situation with a new Bluetooth module):

    bluetoothctl 
    Agent registered
    [bluetooth]# paired-devices 
    [bluetooth]# scan on
    ...other devices...
    [CHG] Device 00:14:51:CB:E7:1A Name: anon’s mouse
    ...other devices...
    [CHG] Device E8:06:88:42:AA:4E Name: Apple Wireless Keyboard
    ...other devices...
    [bluetooth]# scan off
    [bluetooth]# pair 00:14:51:CB:E7:1A
    [CHG] Device 00:14:51:CB:E7:1A Connected: yes
    [CHG] Device 00:14:51:CB:E7:1A Modalias: usb:v05ACp030Cd0200
    [CHG] Device 00:14:51:CB:E7:1A UUIDs: 00001124-0000-1000-8000-00805f9b34fb
    [CHG] Device 00:14:51:CB:E7:1A UUIDs: 00001200-0000-1000-8000-00805f9b34fb
    [CHG] Device 00:14:51:CB:E7:1A ServicesResolved: yes
    [CHG] Device 00:14:51:CB:E7:1A Paired: yes
    Pairing successful
    [CHG] Device 00:14:51:CB:E7:1A ServicesResolved: no
    [CHG] Device 00:14:51:CB:E7:1A Connected: no
    [bluetooth]# pair E8:06:88:42:AA:4E
    Attempting to pair with E8:06:88:42:AA:4E
    [CHG] Device E8:06:88:42:AA:4E Connected: yes
    [agent] PIN code: 874135
    [DEL] Device F8:34:41:D4:A5:D9 Mint-Lenovo
    [CHG] Device E8:06:88:42:AA:4E Modalias: usb:v05ACp023Ad0050
    [CHG] Device E8:06:88:42:AA:4E UUIDs: 00001124-0000-1000-8000-00805f9b34fb
    [CHG] Device E8:06:88:42:AA:4E UUIDs: 00001200-0000-1000-8000-00805f9b34fb
    [CHG] Device E8:06:88:42:AA:4E ServicesResolved: yes
    [CHG] Device E8:06:88:42:AA:4E Paired: yes
    Pairing successful
    [CHG] Device E8:06:88:42:AA:4E ServicesResolved: no
    [CHG] Device E8:06:88:42:AA:4E Connected: no
    [bluetooth]# paired-devices 
    Device 00:14:51:CB:E7:1A anon’s mouse
    Device E8:06:88:42:AA:4E Apple Wireless Keyboard
    [bluetooth]# 
   
Here we have a typical situation where the mouse pairs without a PIN, since it has no numeric interface, whereas the keyboard is required to have it's PIN typed to prove it is the correct keyboard.

If the devices were previously paired then it suffices to just run the connection procedure:

    bluetoothctl 
    Agent registered
    [bluetooth]# connect 00:14:51:CB:E7:1A
    Attempting to connect to 00:14:51:CB:E7:1A
    [CHG] Device 00:14:51:CB:E7:1A Connected: yes
    Connection successful
    [anon’s mouse]# [ 2462.864980] hid-generic 0005:05AC:030C.0002: unknown main item tag 0x0
    [ 2462.873858] input: anon’s mouse as /devices/platform/soc/46000000.lowrisc-bt/tty/ttyS1/hci0/hci0:47/..
    [ 2463.007982] Bluetooth: Out-of-order packet arrived, got 1 expected 3
    [ 2463.010446] Bluetooth: Out-of-order packet arrived, got 2 expected 3
    [ 2463.077770] hid-generic 0005:05AC:030C.0002: input,hidraw1: BLUETOOTH HID v2.00 Mouse [anon’s mouse] on..
    [CHG] Device 00:14:51:CB:E7:1A ServicesResolved: yes
    [anon’s mouse]# connect E8:06:88:42:AA:4E
    Attempting to connect to E8:06:88:42:AA:4E
    Connection successful
    [ 1987.105182] hid-generic 0005:05AC:023A.0001: unknown main item tag 0x0
    [ 1987.115782] input: Apple Wireless Keyboard as /devices/platform/soc/46000000.lowrisc-bt/tty/ttyS1/hci0/hci0:44/..
    [ 1987.126684] input: Apple Wireless Keyboard Consumer Control as /devices/platform/soc/46000000.lowrisc-bt/..
    [ 1987.705532] hid-generic 0005:05AC:023A.0001: input,hidraw0: BLUETOOTH HID v0.50 Keyboard [Apple Wireless Keyboard]..
    [Apple Wireless Keyboard]# exit

Most devices only have a limited window (for example, one minute) after powering up when they are discoverable and possibly pairable. If pairing fails switch off and/or remove the batteries for 30sec before trying again. If the failure occurs after pairing, use the remove command before trying again.

If the wired PS/2 over USB keyboard is used as well the keyboard events will both be available in X-windows and the text boot screen. Mouse events will not be available on the text screen unless the appropriate mouse event daemon is launched (not tested).

## Launching X windows

X-windows cannot be launched from the serial port, unless run by the super-user. In any case it will appear on the VGA console, which will only respond to the wired keyboard/previously paired keyboard and mouse. A restricted form of X-windows is also available remotely using the ssh -Y lowrisc@ipaddr command. Any windows created in this mode will appear on the remote computer.


