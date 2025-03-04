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

load GNSS-matlab/prn_codes/codes_L1CA.mat

f=fopen('1h.bin'); 
fs=32e6 
freq0=[-1.0e4:200:1.0e4];
d=fread(f,fs/200,'int8'); d=d(1:2:end)+j*d(2:2:end);
d=d-mean(d);
%  b=firls(32,[0 2e6 3.5e6 fs/2]*2/fs,[1 1 0 0]);
%  d=filter(b,1,d);
temps=[0:length(d)-1]'/fs;
for m=1:size(codes_L1CA)(2)
  code=interpolated(codes_L1CA(:,m),fs/1.023e6);
  u=1;            % sweep
  for freq=freq0  % sweep
    nco=exp(-j*2*pi*temps*freq);
    [valeur(m,u),position(m,u)]=max(abs(xcorr(code,d.*nco)));
    u=u+1; % sweep 
  end
end
figure  % see https://www.gsc-europa.eu/system-service-status/constellation-information
imagesc(freq0,[1:size(codes_L1CA)(2)],(valeur));colorbar
title([num2str(fs/1e6),' MS/s']);xlabel('frequency (Hz)');ylabel('SV')
