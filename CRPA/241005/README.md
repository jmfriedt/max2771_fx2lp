Various experiments with the dual-MAX2771 board for detecting spoofing by codeless decoding
of the GNSS signals. The assumption is that a genuine constellation with satellites distributed
over the celestial sphere with different direction of arrivals will exhibit different phase differences
of the signals recorded by two antennas separated by half wavelength, while a spoofing source will
exhibit signals with similar phases for all satellites assuming the signal is being broadcast by
a single spoofing source.

Experimental demonstration:
```
pluto-gps-sim$ sudo ./pluto-gps-sim  -e hour1790.23n  -A -65 -t 2023/06/28,12:00:00 -l 48.3621221,-4.8223307,100 -U usb:3.28.5
Using static location mode.
Gain: -65.0dB
RINEX date = 28-JUN-23 12:42     
Start time = 2023/06/28,12:00:00 (2268:302400)
PRN   Az    El     Range     Iono
01  272.0  49.4  21052322.7   4.6
02  287.1  67.6  20923913.4   3.8
03  208.3  13.7  24263590.3  11.1
08  144.5  68.4  20648270.7   4.1
10   49.1  31.1  22849975.1   6.1
14  308.8  26.3  23121575.2   5.8
21  307.9  77.6  20636456.6   3.7
22  115.5  17.3  24099494.4  10.2
27  131.6  32.3  22771574.0   7.2
32   94.1  25.6  23356935.7   7.8

max2771/PocketSDR$ sudo ./app/pocket_conf/pocket_conf conf/pocket_L1L1_8MHz.conf
#  [CH1] F_LO = 1573.420 MHz, F_ADC =  8.000 MHz (I ), F_FILT =  2.0 MHz, BW_FILT =  2.5 MHz
#  [CH2] F_LO = 1573.420 MHz, F_ADC =  0.000 MHz (I ), F_FILT =  2.0 MHz, BW_FILT =  2.5 MHz
max2771/PocketSDR$ sudo ./app/pocket_dump/pocket_dump -t 2 /tmp/1.bin /tmp/2.bin
  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
      2.0    I     15990784   I     15990784       7971.5

python3 PocketSDR/python/pocket_acq.py 1.bin -f 8 -fi 2 -sig L1CA -prn 1-32 -d 20000

SIG= L1CA, PRN=   1, COFF=  0.00950 ms, DOP=  2700 Hz, C/N0= 50.0 dB-Hz
SIG= L1CA, PRN=   2, COFF=  0.44237 ms, DOP=  1516 Hz, C/N0= 52.5 dB-Hz
SIG= L1CA, PRN=   3, COFF=  0.99475 ms, DOP=  4566 Hz, C/N0= 45.0 dB-Hz
SIG= L1CA, PRN=   4, COFF=  0.59588 ms, DOP=  5001 Hz, C/N0= 35.4 dB-Hz
SIG= L1CA, PRN=   5, COFF=  0.43000 ms, DOP= 10546 Hz, C/N0= 35.8 dB-Hz
SIG= L1CA, PRN=   6, COFF=  0.20437 ms, DOP=  3914 Hz, C/N0= 36.2 dB-Hz
SIG= L1CA, PRN=   7, COFF=  0.51537 ms, DOP= 17505 Hz, C/N0= 35.9 dB-Hz
SIG= L1CA, PRN=   8, COFF=  0.27700 ms, DOP=  -922 Hz, C/N0= 52.3 dB-Hz
SIG= L1CA, PRN=   9, COFF=  0.36700 ms, DOP= 14029 Hz, C/N0= 35.7 dB-Hz
SIG= L1CA, PRN=  10, COFF=  0.63812 ms, DOP= -2083 Hz, C/N0= 47.7 dB-Hz
SIG= L1CA, PRN=  11, COFF=  0.29925 ms, DOP=  5881 Hz, C/N0= 35.8 dB-Hz
SIG= L1CA, PRN=  12, COFF=  0.75613 ms, DOP= -8554 Hz, C/N0= 36.3 dB-Hz
SIG= L1CA, PRN=  13, COFF=  0.15475 ms, DOP=  7451 Hz, C/N0= 36.2 dB-Hz
SIG= L1CA, PRN=  14, COFF=  0.00962 ms, DOP=  2415 Hz, C/N0= 46.7 dB-Hz
SIG= L1CA, PRN=  15, COFF=  0.42913 ms, DOP= -10010 Hz, C/N0= 35.5 dB-Hz
SIG= L1CA, PRN=  16, COFF=  0.96587 ms, DOP=  -788 Hz, C/N0= 36.1 dB-Hz
SIG= L1CA, PRN=  17, COFF=  0.56413 ms, DOP=  2560 Hz, C/N0= 35.9 dB-Hz
SIG= L1CA, PRN=  18, COFF=  0.08937 ms, DOP= -5515 Hz, C/N0= 36.0 dB-Hz
SIG= L1CA, PRN=  19, COFF=  0.29050 ms, DOP= 16193 Hz, C/N0= 36.9 dB-Hz
SIG= L1CA, PRN=  20, COFF=  0.24412 ms, DOP= -18035 Hz, C/N0= 35.8 dB-Hz
SIG= L1CA, PRN=  21, COFF=  0.82325 ms, DOP=   621 Hz, C/N0= 52.5 dB-Hz
SIG= L1CA, PRN=  22, COFF=  0.80950 ms, DOP=  3128 Hz, C/N0= 44.8 dB-Hz
SIG= L1CA, PRN=  23, COFF=  0.57225 ms, DOP= 16913 Hz, C/N0= 36.0 dB-Hz
SIG= L1CA, PRN=  24, COFF=  0.99862 ms, DOP= -8598 Hz, C/N0= 35.5 dB-Hz
SIG= L1CA, PRN=  25, COFF=  0.19163 ms, DOP=  -492 Hz, C/N0= 35.8 dB-Hz
SIG= L1CA, PRN=  26, COFF=  0.21525 ms, DOP= -1977 Hz, C/N0= 35.5 dB-Hz
SIG= L1CA, PRN=  27, COFF=  0.36813 ms, DOP= -2572 Hz, C/N0= 48.0 dB-Hz
SIG= L1CA, PRN=  28, COFF=  0.50963 ms, DOP=  4886 Hz, C/N0= 35.7 dB-Hz
SIG= L1CA, PRN=  29, COFF=  0.58887 ms, DOP= 15499 Hz, C/N0= 36.4 dB-Hz
SIG= L1CA, PRN=  30, COFF=  0.57888 ms, DOP= 17065 Hz, C/N0= 35.3 dB-Hz
SIG= L1CA, PRN=  31, COFF=  0.27000 ms, DOP= -3489 Hz, C/N0= 36.1 dB-Hz
SIG= L1CA, PRN=  32, COFF=  0.42037 ms, DOP=  2314 Hz, C/N0= 46.3 dB-Hz

pluto-gps-sim$ sudo ./pluto-gps-sim  -e hour3270.19n  -A -65 -t  2019/11/23,09:00:00  -l 48.3621221,-4.8223307,100 -U usb:3.28.5
```


