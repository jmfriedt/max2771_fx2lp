Data collected using PocketSDR configuration
```
sudo app/pocket_conf/pocket_conf conf/pocket_L1L5_32MHz.conf
app/pocket_dump/pocket_dump -t 1 1h.bin 2l.bin
``` 
and processed using the GNU Octave scripts:

``correlate_gpsL1_char.m``

<img src="L1CA.png">

``correlate_galileo1B_char.m`` and ``correlate_galileo1C_char.m``

<img src="E1B.png">
<img src="E1C.png">

``correlate_galileoE5_char.m``

<img src="E5I+jE5Q.png">
<img src="E5I-jE5Q.png">

``correlate_gpsL5_char.m``

<img src="L5I+jL5Q.png">
<img src="L5I-jL5Q.png">

matching the observed constellation

<img src="Screenshot_20250304-093028.png">
