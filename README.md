## MAX2771 multiband GNSS receiver for FX2LP

### Objective: multi-MAX2771 GNSS receiver with up to 48 MS/s bulk USB communication

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
