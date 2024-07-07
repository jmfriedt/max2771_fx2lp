# sudo app/pocket_conf/pocket_conf conf/pocket_L1L1_8MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -t 5 ch1.bin ch2.bin
pkg load signal
ifreq=2e6;
fs=8e6;

f=fopen("ch1.bin")
% f=fopen("ch1_20240705_184436.bin");
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
b=firls(256,[0 50e5 70e4 fs/2]*2/fs,[1 1 0 0]);
d=filter(b,1,d);
fd=linspace(-4,4,length(d));
subplot(311)
res1=fftshift(fft(d.^2));
plot(fd,abs(res1))
axis([-.07 -.055 0 40000])
fclose(f)
ylabel('|FFT(sig1^2)| (a.u.)')

hold on
f=fopen("ch2.bin")
% f=fopen("ch2_20240705_184436.bin");
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
d=filter(b,1,d);
fd=linspace(-4,4,length(d));
kindex=find((fd>-0.07) & (fd < -0.055));
kfreq=fd(kindex);
subplot(312)
res2=fftshift(fft(d.^2));
plot(fd,abs(res2))
axis([-.07 -.055 0 40000])
fclose(f)

res1=res1(kindex);
res2=res2(kindex);
k=find(abs(res2)>mean(abs(res2(1:100)))*3)
hold on
plot(kfreq(k),20000,'rx')
ylabel('|FFT(sig2^2)| (a.u.)')

subplot(313)
res=angle(res2(k))-angle(res1(k));
kres=find(res>2);res(kres)=res(kres)-pi*2;
plot(kfreq(k),res,'x');
xlim([-.07 -.055])
xlabel('2xFourier frequency (Hz)')
ylabel('phase difference (rad)')
