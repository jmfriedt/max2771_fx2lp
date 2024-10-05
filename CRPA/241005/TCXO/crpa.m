# sudo app/pocket_conf/pocket_conf conf/pocket_L1L1_8MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -t 5 ch1.bin ch2.bin
pkg load signal
ifreq=2e6;
fs=8e6;

l=0.05
threshold=20000;

f=fopen("1.bin");
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
b=firls(256,[0 50e5 70e4 fs/2]*2/fs,[1 1 0 0]);
d=filter(b,1,d);
fd=linspace(-4,4,length(d));
kindex=find((fd>-l) & (fd < l));
kfreq=fd(kindex);
subplot(311)
res1=fftshift(fft(d.^2))(kindex);
plot(kfreq,abs(res1))
fclose(f)
ylabel('|FFT(sig1^2)| (a.u.)')

hold on
f=fopen("2.bin");
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
d=filter(b,1,d);
fd=linspace(-4,4,length(d));
subplot(312)
res2=fftshift(fft(d.^2))(kindex);
plot(kfreq,abs(res2))
fclose(f)

k=find((abs(res2)>threshold) & (abs(res1)>threshold))
hold on
plot(kfreq(k),threshold,'rx')
ylabel('|FFT(sig2^2)| (a.u.)')

subplot(313)
res=angle(res2(k))-angle(res1(k));
kres=find(res>2);res(kres)=res(kres)-pi*2;
plot(kfreq(k),res,'x');
xlim([-l l])
xlabel('Fourier frequency (Hz)')
ylabel('phase difference (rad)')
