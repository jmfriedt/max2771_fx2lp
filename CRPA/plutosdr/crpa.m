# sudo app/pocket_conf/pocket_conf conf/pocket_L1L1_8MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -t 5 ch1.bin ch2.bin
pkg load signal
ifreq=2e6;
fs=8e6;
filename='ch1_20240706_193119genuine.bin';seuil=2.6
% filename="ch1_20240706_061654_spoof.bin";seuil=7

f=fopen(filename);
d=fread(f,1e6,'int8'); d=fread(f,1e6,'int8');
d=fread(f,1e6,'int8'); d=fread(f,1e6,'int8');
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
b=firls(256,[0 100e5 120e4 fs/2]*2/fs,[1 1 0 0]);
d2=filter(b,1,d.^2);

fd=linspace(-4,4,length(d));
% kindex=find((fd>-0.07) & (fd < -0.053));
kindex=find((fd>-0.1) & (fd < 0.1));
kfreq=fd(kindex);
subplot(311)
res1=fftshift(fft(d2))(kindex);
plot(kfreq,abs(res1))
fclose(f)
ylabel('|FFT(sig1^2)| (a.u.)')

hold on
f=fopen(strrep(filename,"ch1","ch2")); % second channel
d=fread(f,1e6,'int8'); d=fread(f,1e6,'int8');
d=fread(f,1e6,'int8'); d=d-mean(d);
t=[0:length(d)-1]'/fs;
lo=exp(j*2*pi*t*ifreq);
d=d.*lo;
d2=filter(b,1,d.^2);
fd=linspace(-4,4,length(d));
subplot(312)
res2=fftshift(fft(d2))(kindex);
plot(kfreq,abs(res2))
fclose(f)

k=find(abs(res2)>mean(abs(res2(1:10)))*seuil)
hold on
plot(kfreq(k),20000,'rx')
ylabel('|FFT(sig2^2)| (a.u.)')

subplot(313)
res=angle(res2(k))-angle(res1(k));
kres=find(res>2);res(kres)=res(kres)-pi*2;
kres=find(res<-4);res(kres)=res(kres)+pi*2;
plot(kfreq(k),res,'x');
xlim([-.1 .1])
ylim([-4 2])
xlabel('2xFourier frequency (Hz)')
ylabel('phase difference (rad)')
