# sudo app/pocket_conf/pocket_conf conf/pocket_L1L2_4MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -r -t 5 ch1.bin ch2.bin
# /!\ -r for raw output
pkg load signal
% graphics_toolkit('gnuplot')
fs=12e6;
fi=3e6;

dirlist=dir('G*12M*bin');
for l=1:length(dirlist)
  figure
  f=fopen(dirlist(l).name)
  d=fread(f,2e6,'int8');    
  d=d-mean(d);                            % with IF => I only
  fd=linspace(-fs/2,fs/2,length(d))/1e6;
  hold on
  subplot(211)
  plot(fd,abs(fftshift(fft(d))),'linewidth',2)
  xlabel('freqency offset (MHz)')
  ylabel('power (a.u.)')
  legend('signal with 3 MHz IF')
  t=[0:length(d)-1]'/fs;
  lo=exp(j*2*pi*fi*t);
  d=d.*lo;
  b=firls(256,[0 fi fi+fi/10 fs/2]*2/fs,[1 1 0 0]);
  d=filter(b,1,d);
  subplot(212)
  plot(fd,abs(fftshift(fft(d.^2))),'linewidth',2)
  xlabel('freqency offset (MHz)')
  ylabel('power (a.u.)')
  legend('squared signal')
  axis([-.02 .02 0 50000])
end


