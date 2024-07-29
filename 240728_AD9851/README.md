## Replacing a static TCXO with a DDS

The objective is to dynamically control the driving oscillator frequency with
the time (frequency) offset information provided by ``gnss-sdr`` and hence
steer the local oscillator with GPS time.

As a first demonstration of the feasibility, the AD9851 frequency is defined
by a new Vendor Request broadcast on the USB bus and triggering the SPI communication
of the Frequency Tuning Word and the associated chip-select (FQ_UD) connected to pin
PA7 of the FX2LP.

<img src="all_d9851.png">

For this demonstration, the PlutoSDR local oscillator is set to 174.2 MHz, the 0.2 MHz
offset being introduced to avoid mistakenly identifying the LO leakage with the
wanted signal at fCK+fo with fCK the AD9851 clock frequency (6x25=150 MHz) and fo=24 MHz 
the output frequency. When the AD9851 is unconfigured (red curve), only the 175 MHz overtone
as 7x25 MHz of the square wave oscillator is detected. Programming the AD9851 frequency
is demonstrated by also generating 24.3 and 24.4 MHz, observed at 174.3 and 174.4 MHz 
respectively.
