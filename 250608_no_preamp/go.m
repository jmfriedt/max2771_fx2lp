pkg load signal
fs=12;
% fs=32;
% fs=40;
Ncor=80;
Ndsi=0 % 5; % range of Direct Signal Interferences (in sample index)

% b=firls(256,[0 4.5 5.6 fs/2]*2/fs,[1 1 0 0]);
d=dir('/tmp/*_1.bin');
for l=1:length(d)
  f1=fopen(['/tmp/',d(l).name]);
  f2=fopen(['/tmp/',strrep(d(l).name,'_1','_2')]);
  navg=0;
  do
    x1=fread(f1,2e6,'int8');x1=x1(1:2:end)-j*x1(2:2:end);
    x2=fread(f2,2e6,'int8');x2=x2(1:2:end)-j*x2(2:2:end);
  % x1=filter(b,1,x1);
  % x2=filter(b,1,x2);
    if (length(x1)==1e6)
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
      w=pinv(mat)*x1      % least square optimal weights of the reference in the surveillance
      x1c=x1-mat*w; % remove reference from surveillance in the +/-Ndsi range
    end 
    if (exist('xm')==0)
       xm=abs(xcorr(x1,x2,Ncor));
       figure
       subplot(221)
       plot([-Ncor:Ncor]*300/fs,abs(xm))
       fr=str2num(strrep(d(l).name,'_1.bin',''));
       title([strrep(d(l).name,'_',' '),'=',num2str(1575.42-fr)])
       xlabel('bistatic range (m)')
       ylabel('correlation (a.u.)')
       xc=xcorr(x1,x2,Ncor);
       if (Ndsi>0)
         xdsi=xcorr(x1c,x2,Ncor);
       end
    else
       xm=xm+abs(xcorr(x1,x2,Ncor));
       xc=xc+xcorr(x1,x2,Ncor);
       if (Ndsi>0)
         xdsi=xdsi+xcorr(x1c,x2,Ncor);
       end
    end
    navg=navg+1
    else
      x=[]
      printf('x1 too short')
    end
  until((length(x1)<1e6) || (navg==10))
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
  plot([-Ncor:Ncor]*300/fs,abs(xm)/navg)
  plot([-Ncor:Ncor]*300/fs,abs(xc)/navg)
  if (Ndsi>0)
  plot([-Ncor:Ncor]*300/fs,abs(xdsi)/navg)
  legend('no average','magnitude averaging','complex averaging','mag. averaging with DSI suppression')
  else
  legend('no average','magnitude averaging','complex averaging')
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
  clear('xm')
end
