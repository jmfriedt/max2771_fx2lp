# sudo app/pocket_conf/pocket_conf conf/pocket_L1L2_4MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -r -t 5 ch1.bin ch2.bin
# /!\ -r for raw output
fs=16e6;

f=fopen("ch1.bin")
d=fread(f,1e6,'int8'); 
# d=d(1:2:end)+j*d(2:2:end);
d=d-mean(d);
fd=linspace(-fs/2,fs/2,length(d))/1e6;
hold on
plot(fd,abs(fftshift(fft(d))))
xlabel('freqency offset (MHz)')
ylabel('power (a.u.)')
