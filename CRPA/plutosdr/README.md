GPS L1 signal generated by a PlutoSDR thanks to ``pluto-gps-sim``, feeding both inputs
of the board fitted with two MAX2771

<img src="IMG_20240705_204506_398.jpg">

Notice the DC blockers between the PlutoSDR output and the DC-passing combiner, without which
the power supply of the FX2LP used to power the active antennas would be drawn to ground by
the protective diodes on the RF output, preventing the MAX2771 from being powered.

The screenshots of the ``pluto-gps-sim`` output indicating which SV signals are broadcast,
and the resulting data collection by the FX2LP

<img src="2024-07-05-204738_2704x1050_scrot.png">

Executing ``python3 PocketSDR/python/pocket_acq.py`` on the resulting datasets leads to

<img src="2024-07-05-213520_2704x1050_scrot.png">

<img src="2024-07-05-213639_2704x1050_scrot.png">

with the correct Space Vehicles (SVs) identified in both files.

Plotting the phase of the squared signals

<img src="plutosdr_m70dB.svg"> 

shows that all signals exhibit the same direction of arrival, a strong signature of 
a spoofing attack.
