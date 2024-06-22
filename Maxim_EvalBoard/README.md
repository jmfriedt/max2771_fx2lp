### MAX2771 evaluation board

Maxim IC (now ADi) sells a MAX2771 evaluation board with hardly any 
capability since the embedded microcontroller only handles USB (HID) to
SPI command conversion but is unable to collect and stream the IQ data.
The proprietary MS-Windows control software will not run with the Wine 
emulator and is also useless under GNU/Linux.

In these demonstrations, the tracks from SPI (MOSI, MISO, CLK, CS#) to 
MAX2771 were severed and connected to the control pins of an external
FX2LP evaluation board, as were the I and Q outputs.

The +/-5V power supply does not need to be connected since it is only used
for powering the operational amplifiers buffering the analog signals: only
the 3V power supply (20 mA) is used.

The huge wires connecting the IQ signals (see 
https://github.com/jmfriedt/max2771_fx2lp/blob/main/Maxim_EvalBoard/240611/IMG_20240611_180414_607.jpg) 
from the MAX2771 to the FX2LP probably radiate too much RF power at the 4 to 
24 MHz datarate and 0-IF measuremements are extremely noisy when streaming the 
IQ complex data. All useful measurements are performed with an IF, streaming 
only I componenents, and offsetting the IF during software processing.

TODO: check the assembled boards work at 0-IF
