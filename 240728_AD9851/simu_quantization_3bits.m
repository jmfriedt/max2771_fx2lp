fs=4e6;
t=[0:4e5]/fs;
for f=[50e3 1e5 2e5 1e6]
  y=cos(2*pi*f*t);
  k=find(y>=0.5);yq(k)=1;
  k=find((y<=0.5)&(y>0));yq(k)=0;
  k=find((y>=-0.5)&(y<0));yq(k)=-1;
  k=find(y<-0.5);yq(k)=-2;
  fr=linspace(-fs/2,fs/2,length(yq));
  plot(fr,(abs(fftshift(fft(yq-mean(yq))))));
  hold on
end
xlim([0 fs/2])
