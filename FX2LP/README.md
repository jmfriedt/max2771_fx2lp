## FX2LP example codes

The original https://github.com/tomojitakasu/PocketSDR software relies
on the proprietary Keil compiler to generate the firmware running in the
FX2LP handling the bulk endpoint communication.

The objective is to replace the use of the proprietary compiler with ``sdcc``,
and in the mean time learn the interals on the 8051 core controlling the
FX2LP.

* ``LED_blink``: basic LED blinking example demonstrating the usage of the
``fx2lib`` library
