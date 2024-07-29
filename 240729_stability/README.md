### TCXO stability v.s GNSS

<img src="setup.png">

1. create FIFO with
```
mkfifo /tmp/fifo1in
chmod 777 /tmp/fifo1in
```
2. configure MAX2771 for 8 MS/s and 2 MHz IF, and check PocketSDR configuration
```
sudo app/pocket_conf/pocket_conf pocket_L1L1_8MHz.conf
sudo app/pocket_conf/pocket_conf
```
3. launch PocketSDR acquisition
```
sudo app/pocket_dump/pocket_dump /tmp/fifo1in /dev/null
```
4. launch GNU Radio frequency transposition and FIFO to ZeroMQ Pub/Sub conversion
```
MAX2771_transpose.py
```
5. launch ``gnss-sdr`` for GNSS signal processing
```
gnss-sdr -c ZMQ_GPS_1_grcomplex.conf
```
6. collect result broadcast by ``gnss-sdr`` through UDP port 1234 and enjoy
```
python3 ./jmf.py > record
```
7. analyze the result
```
cut -d\  -f3 record | sed 's/dt=//g' > dt
```
and with GNU/Octave:
```
load dt
subplot(211);plot(dt)
[a,b]=polyfit([1:length(dt)],dt,1);
a(1)
subplot(212);plot(dt-b.yf);
y=[[1:length(dt)]' dt-b.yf];
save -ascii y y
```
and using SigmaTheta:
```
X2Y y
SigmaTheta y.ykt
```
results in

<img src="y.svg">

The script ``jmf.py`` is using ``monitor_pvt_pb2.py`` which was generated from ``gnss-sdr/docs/protobuf`` by running
```
protoc monitor_pvt.proto --cpp_out=. --python_out=.
```
and requires the Debian package ``python3-protobuf``. The ``from monitor_pvt_pb2 import MonitorPvt`` comes from reading
``gnss-sdr/docs/protobuf/monitor_pvt.proto`` starting with ``message MonitorPvt ...``

Make sure to *enable* ``PVT.enable_protobuf=true`` in the ``gnss-sdr`` configuration file 
