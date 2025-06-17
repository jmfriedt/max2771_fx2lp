pkg load signal
dis=0

fs=4;  % MS/s
D=50;
b1=firls(512,[0 0.01 0.02 fs/2]*2/fs,[1 1 0 0]);
b2=firls(512,[0 0.0001 0.0002 fs/D/2]*2/(fs/D),[1 1 0 0]);
p=1;
for mesnum=1:41 
  for acqnum=1:3
    f=fopen(['/tmp/',num2str(mesnum),'_',num2str(acqnum),'_1.bin']);
    nam=[num2str(mesnum),'_',num2str(acqnum),'_1']
    x=fread(f,1e6,'int8');
    fclose(f);
    x1=x(1:2:end)+j*x(2:2:end);
    fr=linspace(-fs/2,fs/2-fs/length(x1),length(x1));
    if dis==1
      subplot(311)
      plot(fr,abs(fftshift(fft(x1))));
      hold on
      xlabel('freq (MHz)'); ylabel('|FFT ch1|')
    end
    f=fopen(['/tmp/',num2str(mesnum),'_',num2str(acqnum),'_2.bin']);
    x=fread(f,1e6,'int8');
    fclose(f);
    x2=x(1:2:end)+j*x(2:2:end);
    if dis==1
      subplot(312)
      plot(fr,abs(fftshift(fft(x2))));
      xlabel('freq (MHz)'); ylabel('|FFT ch2|')
      hold on
    end
    s=filter(b1,1,(x1./x2));
    s=s(1:D:end);
    s=filter(b2,1,s);
    if (dis==1)
      subplot(313)
      plot([0:length(s(1000:end-1000))-1]/fs*D/1e6,angle(s(1000:end-1000)));
      hold on
      xlabel('time (s)');ylabel('phase')
    end
    sol(p)=mean(angle(s(1000:end-1000)));
    p=p+1;
  end
end
plot(sol)
