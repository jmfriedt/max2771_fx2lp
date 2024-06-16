# sudo app/pocket_conf/pocket_conf conf/pocket_L1L2_4MHz.conf
# sudo app/pocket_conf/pocket_conf 
# sudo app/pocket_dump/pocket_dump -r -t 5 ch1.bin ch2.bin
# /!\ -r for raw output
graphics_toolkit('gnuplot')
fs=4e6;

dirlist=dir('1*4M*bin');
for l=1:length(dirlist)
  f=fopen(dirlist(l).name)
  d=fread(f,1e6,'int8'); 
  d=d(1:2:end)+j*d(2:2:end);             % no IF => IQ
  d=d-mean(d);
  fd=linspace(-fs/2,fs/2,length(d))/1e6;
  hold on
  plot(fd,abs(fftshift(fft(d))))
end
legend('1574.92 MHz','1575.22 MHz','1575.32 MHz','1575.82 MHz','off','location','northwest')
xlabel('freqency offset (MHz)')
ylabel('power (a.u.)')

figure

fs=12e6;

dirlist=dir('1*12M*bin');
for l=1:length(dirlist)
  f=fopen(dirlist(l).name)
  d=fread(f,1e6,'int8');    
  d=d-mean(d);                            % with IF => I only
  fd=linspace(-fs/2,fs/2,length(d))/1e6;
  hold on
  plot(fd,abs(fftshift(fft(d))))
end
legend('1574.92 MHz','1575.42 MHz','1575.92 MHz','1575.92 MHz','off','location','north')
xlabel('freqency offset (MHz)')
ylabel('power (a.u.)')


