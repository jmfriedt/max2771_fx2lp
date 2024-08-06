## MAX2771 multiband GNSS receiver for FX2LP

### Objective: multi-MAX2771 GNSS receiver with up to 44 MS/s bulk USB communication

... for
* multiband GNSS (or other L-band signal) acquisition and processing if a power combiner 
(e.g. MiniCircuits ZAPD-2DC+) is used to feed both chips with the signal coming from a 
single multiband antenna
* CRPA (Controlled Radiation Pattern Antenna) if each chip is fed from a different
antenna for spatial diversity
* applicable to any L-band communication systems sampled with 2-3 bit ADC (verified with
Iridium)

<img src="HW/IMG_20240629_113625_461small.jpg">

Assembled daughter board: the missing 24 MHz oscillator is replaced with the 
24 MHz output from one of the resonator pins fitted on the FX2LP board. However,
the frequency pulling by the capacitor leads to a 3 kHz offset (2 ppm) which must
be compensated for when processing (acquisition phase of GNSS signal analysis) the
recorded signals. This feature is however illustrated to emphasize that the GNSS
receiver can be clocked by an external (24 MHz) source, a capability missing from most
commercial GNSS receivers.

Processing relies on the PocketSDR software provided by Tomoji Takasu at
https://github.com/tomojitakasu/PocketSDR.

The firmware for the FX2LP is compiled using opensource tools including the
``sdcc`` compiler, ``fx2lib`` library, ``cycfx2prog`` for prototyping the 8051 embedded
software and  ``fxload`` for flashing the onboard EEPROM.

### Getting started (assuming development on a GNU/Linux system)

1. Compile the FX2LP 8051 firmware (assumes ``sdcc`` is installed):
```
cd FX2LP/fx2lib
make
cd ../complete_fw
make
```
must complete with ``build/complete_fw.ihx`` in ``FX2LP/complete_fw``

2. Compile ``fxload`` for flashing the FX2LP
```
cd fxload
git submodule update --init
cmake .
make -j12
```

3. Flash the firmware in the FX2LP development board: switch on the board with the jumper to the bottom left (with the USB port facing
upward) closed in order to start the bootloader (``lsusb`` must return ``ID 04b4:8613 Cypress Semiconductor Corp. CY7C68013 EZ-USB FX2 
USB 2.0 Development Kit``):
```
sudo ./fxload/src/fxload load_eeprom --device 04b4:8613 --ihex-path ./FX2LP/complete_fw/build/complete_fw.ihx -t FX2LP --control-byte 0xC2 -s ./fxload/resources/Vend_Ax.hex
```
which must reply with
```
FX2:  config = 0x42, disconnected, I2C = 100 KHz
Done.

```

In case a message stating ``WARNING: don't see a large enough EEPROM`` is displayed, then the first byte of the EEPROM must be erased. To do so,
follow the sequences in ``FX2LP/bulk_read_example`` and most significantly the section about *Erase EEPROM and flash program to EEPROM*

4. Check the firmware has been flashed: switch off, remove the bottom-left jumper (to execute the firmware flashed in the EEPROM) and
restart the FX2LP: ``lsusb`` must now indicate ``ID 04b4:1004 Cypress Semiconductor Corp. There``

If so, the FX2LP is ready to communicate with PocketSDR ``app/pocket_conf/pocket_conf`` for configuring the MAX2771 (SPI communication)
or with ``app/pocket_dump/pocket_dump`` for streaming data from the FX2LP to the host computer through a USB Bulk interface.
