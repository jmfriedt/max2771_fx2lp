## FX2LP example codes

The original https://github.com/tomojitakasu/PocketSDR software relies
on the proprietary Keil compiler to generate the firmware running in the
FX2LP handling the USB bulk endpoint communication and SPI configuration
of the MAX2771 through USB Vendor Requests.

The objective is to replace the use of the proprietary compiler with ``sdcc``,
and in the mean time learn the interals on the 8051 core controlling the
FX2LP.

* ``pocket_fw_FE_2CH_v2.1.hex`` the original firmware from PocketSDR for initial
tests
* ``LED_blink``: basic LED blinking example demonstrating the usage of the
``fx2lib`` library and ``sdcc`` for generating 8051 firmware.
* ``python_access_USB`` for becoming familiar with Python3 interaction with the
USB bus and reading/writing MAX2771 registers through bitbanged SPI
* ``complete_fw`` includes bitbanged SPI and USB Bulk endpoint communication, final
firmware with all core functionalities.

When git cloning the repository, ``fx2lib`` is an external submodule dependency,
so the easiest is to ``git clone --recursive``. Before compiling the examples, go to
``fx2lib`` and ``make`` to compile ``lib/fx2.lib`` to be linked with the programs
we develop for the FX2LP 8051 microcontroller.

Useful resources for understanding the FX2LP internals: [Cypress CY7C68013A microcontroller](https://www.infineon.com/dgdl/Infineon-CY7C68013A_CY7C68014A_CY7C68015A_CY7C68016A_EZ-USB_FX2LP_USB_Microcontroller_High-Speed_USB_Peripheral_Controller-DataSheet-v31_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0ec9f7974252) and [EZ-USB FX2 Technical Reference Manual](https://www.keil.com/dd/docs/datashts/cypress/fx2_trm.pdf)

<img src="pinout.png">
