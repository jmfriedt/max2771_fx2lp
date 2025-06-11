pkg load signal
fs=12;    % sampling rate (MHz)
dist=800; % maximum range (m)
Ndsi=0    % 5; % range of Direct Signal Interferences (in sample index)
Nfft=1e5  % samples in FFT
fmin=490  % min DVB-T frequency band
fmax=682  % max DVB-T frequency band
rep='./'; % directory holding data files, must include trailing /

% 1e5 samples/12 MHz
% 490-6 -> 682+6 = 204 MHz = 17*12
spectre1=zeros((fmax+fs/2-(fmin-fs/2))/fs*Nfft,1); % Nfft points dans fs donc dans la bande ...
spectre2=zeros((fmax+fs/2-(fmin-fs/2))/fs*Nfft,1); % Nfft points dans fs donc dans la bande ...
fstep=(fs/Nfft);

% b=firls(256,[0 4.5 5.6 fs/2]*2/fs,[1 1 0 0]);
d=dir([rep,'*_1.bin']);
for l=1:length(d)
  f1=fopen([rep,d(l).name]);
  f2=fopen([rep,strrep(d(l).name,'_1','_2')]);
  navg=0;
  do
    x1=fread(f1,2*Nfft,'int8');x1=x1(1:2:end)-j*x1(2:2:end);
    x2=fread(f2,2*Nfft,'int8');x2=x2(1:2:end)-j*x2(2:2:end);
    if (length(x1)==Nfft)
      if (Ndsi>0)
        p=1;
        for m=-Ndsi:Ndsi
          if m<=0
            mat(:,p)=[x2(-m+1:end) ; zeros(-m,1)]; % time delayed copies of the reference
          else
            mat(:,p)=[zeros(m,1) ; x1(1:end-m)];
          end
          p=p+1;
        end
      w=pinv(mat)*x1  % least square optimal weights of the reference in the surveillance
      x1c=x1-mat*w;   % remove reference from surveillance in the +/-Ndsi range
    end 
    if (exist('x1f')==0)
       x1f=fftshift(fft(x1));
       x2f=fftshift(fft(x2));
       % abs(xcorr(x1,x2,Ncor));
       figure
       subplot(221)
       plot(([0:length(x1f)-1]-length(x1f)/2)*300/fs,abs(fftshift(ifft(fftshift(x1f.*conj(x2f))))));xlim([-dist dist])
       fr=str2num(strrep(d(l).name,'_1.bin',''));
       fr=1575.42-fr
       title([strrep(d(l).name,'_',' '),'=',num2str(fr)])
       xlabel('bistatic range (m)')
       ylabel('correlation (a.u.)')
       if (Ndsi>0)
         xdsi=xcorr(x1c,x2,Ncor);
       end
       n1=round((fr-(fmin-fs/2))/fstep-Nfft/2+1)
       n2=n1+Nfft-1
       spectre1(n1:n2)=x1f;  % on a centre' la frequence centrale
       spectre2(n1:n2)=x2f;
    else
       x1f=x1f+fftshift(fft(x1));
       x2f=x2f+fftshift(fft(x2));
       spectre1(n1:n2)=spectre1(n1:n2)+x1f;
       spectre2(n1:n2)=spectre2(n1:n2)+x2f;
       if (Ndsi>0)
         xdsi=xdsi+xcorr(x1c,x2,Ncor);
       end
    end
    navg=navg+1
    else
      x=[]
      printf('x1 too short')
    end
  until((length(x1)<Nfft) || (navg==100))
  fr=linspace(-fs/2,fs/2-fs/length(x1),length(x1));
  fclose(f1)
  fclose(f2)
  
  %t=[0:length(x1)-1]'/(fs*1e6);
  %p=1;
  %N=50
  %for df=-200:200
  %  df
  %  lo=exp(j*2*pi*t*df);
  %  u(:,p)=xcorr(x1.*lo,x2,Nco);
  %  p=p+1;
  %end
  subplot(223)
  hold on
  plot(([0:length(x1f)-1]-length(x1f)/2)*300/fs,abs(fftshift(ifft(fftshift(x1f.*conj(x2f)))))/navg);xlim([-dist dist])
  if (l==2) remember=abs(fftshift(ifft(fftshift(x1f.*conj(x2f)))))/navg;
  end
  if (Ndsi>0)
    plot([-Ncor:Ncor]*300/fs,abs(xdsi)/navg)
    legend('no average','magnitude averaging','complex averaging','mag. averaging with DSI suppression')
  else
  legend('no average','complex averaging')
  end
  xlabel('bistatic range (m)')
  ylabel('correlation (a.u.)')
  
  subplot(222)
  plot(fr,abs(fftshift(fft(x1))))
  legend('ch1 (surveillance)')
  hold on
  subplot(224)
  plot(fr,abs(fftshift(fft(x2))))
  xlabel('frequency (MHz)')
  ylabel('power (a.u.)')
  legend('ch2 (reference)')
  clear('x1f')
end

figure
spectrefreq=linspace(fmin-fs/2,fmax+fs/2,length(spectre1));
subplot(311)
plot(spectrefreq,abs(spectre1))
subplot(312)
plot(spectrefreq,abs(spectre2))
subplot(313)
plot(([0:length(spectre1)-1]-length(spectre1)/2)*300/(fstep*length(spectre1)),abs(fftshift(ifft(spectre1.*conj(spectre2)))));
xlim([-dist dist])

hold on
artefacts=flipud(abs(fftshift(ifft(spectre1.*conj(spectre2)))));
artefacts=artefacts(length(artefacts)/2:end);
plot(([0:length(artefacts)-1])*300/(fstep*length(spectre1)),artefacts)

figure
p1=abs(fftshift(ifft(spectre1.*conj(spectre2))));
plot(([0:length(spectre1)-1]-length(spectre1)/2)*300/(fstep*length(spectre1)),p1/max(p1));
hold on
p2=remember;
plot(([0:length(remember)-1]-length(remember)/2)*300/fs,p2/max(p2))
300/(fstep*length(spectre1))
300/fs
