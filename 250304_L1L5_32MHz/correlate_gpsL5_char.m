% https://www.gsc-europa.eu/sites/default/files/sites/all/files/Galileo_OS_SIS_ICD_v2.1.pdf

close all
clear all

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

load GNSS-matlab/prn_codes/codes_L5I.mat
load GNSS-matlab/prn_codes/codes_L5Q.mat

tic
for essai=1:2
  f=fopen('2l.bin'); 
  fs=32e6 
  freq0=[-1.0e4:200:1.0e4];
  d=fread(f,fs/200,'int8'); d=d(1:2:end)+j*d(2:2:end);
  d=d-mean(d);
  temps=[0:length(d)-1]'/fs;
  doppler=exp(-j*2*pi*freq0'*temps');    % length(freq0)xlength(temps) matrix
  data=ones(length(freq0),1)*d.';
  all=doppler.*data;                    % Doppler-shifted data
  allf=fft(all.');
  for m=1:size(codes_L5Q)(2)
     if (essai==1) code=interpolated(codes_L5I(:,m),fs/10.23e6)+j*interpolated(codes_L5Q(:,m),fs/10.23e6);
     else          code=interpolated(codes_L5I(:,m),fs/10.23e6)-j*interpolated(codes_L5Q(:,m),fs/10.23e6);
     end
     code=[code ; zeros(length(all)-length(code),1)];      % zero padding
     pattern=ones(length(freq0),1)*code.';                             % 43x131072 matrix
     af=fft(pattern.');
     correlation=ifft(af.*conj(allf));
     [valeur(m,:),position(m,:)]=max(abs(correlation));
  end
  toc
  figure  % see https://www.gsc-europa.eu/system-service-status/constellation-information
  imagesc(freq0,[1:size(codes_L5Q)(2)],(valeur));colorbar
  title([num2str(fs/1e6),' MS/s, ',num2str(essai)]);xlabel('frequency (Hz)');ylabel('SV')
end
