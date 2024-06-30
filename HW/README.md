From Tomoji Takasu's Pocket SDR design, v2.3 found at https://github.com/tomojitakasu/PocketSDR, 
to be fitted on https://fr.aliexpress.com/item/1005006134347046.html FX2LP development board:

<img src="max2771_fx2lp.png">

Schematic:

<img src="max2771_fx2lp.svg">

Board layers:

<img src="max2771_fx2lp_gerber/max2771_fx2lp-B_Cu.svg">
<img src="max2771_fx2lp_gerber/max2771_fx2lp-F_Cu.svg">
<img src="max2771_fx2lp_gerber/max2771_fx2lp-In1_Cu.svg">
<img src="max2771_fx2lp_gerber/max2771_fx2lp-In2_Cu.svg">

Result of the assembled board: configuring both MAX2771 to collect the 
upper (L1) band with 8 MHz sampling rate and 2 MHz IF bandwith
```
sudo ./app/pocket_conf/pocket_conf conf/pocket_L1L1_8MHz.conf
```
and recording using
```
sudo ./app/pocket_dump/pocket_dump -t 5 ch1.bin ch2.bin
```
The two binary files are processed for acquisition of GPS L1 C/A signal with
```
python3 ./python/pocket_acq.py ch2.bin -d 30000 -f 8 -fi 2 -sig L1CA -prn 1-32
```
with the ``-d`` option to reach Doppler shifts up to 30 kHz to account for
the poor quality TCXO whereas the default is to search for 5 kHz (theoretical
Doppler shift maximum assuming a perfect reference clock, e.g. Rb, Cs or HM 
source or good quality OCXO).

First demonstration, Doppler limited to 30 kHz offset from carrier:

<img src="2024-06-30-135856_2944x1080_scrot.png">

Second demonstration, Doppler extended to 40 kHz offset from carrier matching the mobile phone
measurements:

<img src="2024-06-30-144230_2944x1080_scrot.png">

Experimental setup:

<img src="IMG_20240630_143603_058.jpg" width=700>
