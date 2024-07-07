Recording with 2 MHz IF at 8 MS/s centered on GPS L1 C/A band-2 MHz (see ``pocket_L1L1_8MHz.conf``).

Processing using ``gnss-sdr`` (v.0.0.19) to reach a PVT solution:

```
$ gnss-sdr -c File_GPS_L1_char.conf
...
New GPS NAV message received in channel 4: subframe 2 from satellite GPS PRN 02 (Block IIR) with CN0=39 dB-Hz
New GPS NAV message received in channel 3: subframe 2 from satellite GPS PRN 32 (Block IIF) with CN0=48 dB-Hz
New GPS NAV message received in channel 1: subframe 2 from satellite GPS PRN 10 (Block IIF) with CN0=47 dB-Hz
New GPS NAV message received in channel 7: subframe 2 from satellite GPS PRN 27 (Block IIF) with CN0=42 dB-Hz
Current receiver time: 2 min 2 s
Current receiver time: 2 min 3 s
Current receiver time: 2 min 4 s
Current receiver time: 2 min 5 s
Current receiver time: 2 min 6 s
Loss of lock in channel 10!
Tracking of GPS L1 C/A signal started on channel 10 for satellite GPS PRN 19 (Block IIR)
Current receiver time: 2 min 7 s
New GPS NAV message received in channel 4: subframe 3 from satellite GPS PRN 02 (Block IIR) with CN0=38 dB-Hz
New GPS NAV message received in channel 3: subframe 3 from satellite GPS PRN 32 (Block IIF) with CN0=48 dB-Hz
New GPS NAV message received in channel 1: subframe 3 from satellite GPS PRN 10 (Block IIF) with CN0=46 dB-Hz
New GPS NAV message received in channel 7: subframe 3 from satellite GPS PRN 27 (Block IIF) with CN0=41 dB-Hz
Current receiver time: 2 min 8 s
First position fix at 2024-Jul-07 11:09:30.240000 UTC is Lat = 47.2486 [deg], Long = 6.02072 [deg], Height= 377.076 [m]
Current receiver time: 2 min 9 s
Loss of lock in channel 0!
```

Experimental setup: notice the 24 MHz oscillator:

<img src="IMG_20240707_132128_805.jpg">

Constellation observation using a mobile phone identifying GPS SV 2, 10, 27 and 32 as most powerful signals:

<img src="Screenshot_20240707-130422.png">
