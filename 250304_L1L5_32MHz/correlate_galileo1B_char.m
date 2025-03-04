% https://www.gsc-europa.eu/sites/default/files/sites/all/files/Galileo_OS_SIS_ICD_v2.1.pdf

close all
clear all
pkg load signal

function res=interpolated(input,interp)
  if (interp<1)
     error("interp < 1")
  end
  lenout=floor(length(input)*interp);
  res=NaN(lenout,1);
  m=1;
  cnt=0;
  for k=1:length(input)
    do
      res(m)=input(k);
      m=m+1;
      cnt+=1;
    until (cnt>=interp);
    cnt-=interp;
  end
end

load GNSS-matlab/prn_codes/codes_E1B.mat
load GNSS-matlab/prn_codes/codes_E1C.mat
Rsa=1.023e6;
Rsb=6.138e6;

f=fopen('1h.bin'); 
fs=32e6 
freq0=[-1.0e4:200:1.0e4];
d=fread(f,fs/200,'int8'); d=d(1:2:end)+j*d(2:2:end);
d=d-mean(d);
code=interpolated(codes_E1B(:,1),fs/1.023e6);
temps=[0:length(code)-1]'/fs;
sce1a=sqrt(10/11)*((sin(2*pi*temps*Rsa)>0)*2-1);
sce1b=sqrt(1/11)*((sin(2*pi*temps*Rsb)>0)*2-1);

temps=[0:length(d)-1]'/fs;
for m=1:36 % size(codes_E1B)(2)
  code=interpolated(codes_E1B(:,m),fs/1.023e6).*(sce1a+sce1b);
  u=1;            % sweep
  for freq=freq0  % sweep
    nco=exp(-j*2*pi*temps*freq);
    [valeur(m,u),position(m,u)]=max(abs(xcorr(code,d.*nco)));
    u=u+1; % sweep 
  end
end
figure  % see https://www.gsc-europa.eu/system-service-status/constellation-information
imagesc(freq0,[1:36],(valeur));colorbar
title([num2str(fs/1e6),' MS/s']);xlabel('frequency (Hz)');ylabel('SV')
SNR=max(max(valeur))/mean(mean(valeur(1:4,1:4)))
