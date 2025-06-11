fs=4;
graphics_toolkit('gnuplot')
d=dir('m*_1*.bin');
leg=[];
premier=0;
N=inf;  % 2e5 for plotting
for l=1:length(d)
  f=fopen(d(l).name);
  val=str2num(strrep(d(l).name(2:4),'_',''));
  val=-val-13;
  x=fread(f,N,'int8');
  x1=x(1:2:end)+j*x(2:2:end);
  fr=linspace(-fs/2,fs/2-fs/length(x1),length(x1));
  xf1=(fftshift(fft(x1)));
  if (val!=-103)
%    plot(fr,abs(xf1));hold on
    leg=[leg,'''',num2str(val),''','];
  end
  if (val==-103) && (premier!=1)
%    plot(fr,abs(xf1));hold on
    premier=1;
    leg=[leg,'''',num2str(val),''','];
  end
  [a,b1]=max(abs(xf1));
  fclose(f);
  f=fopen(strrep(d(l).name,'_1','_2'));
  x=fread(f,N,'int8');
  x2=x(1:2:end)+j*x(2:2:end);
  xf2=(fftshift(fft(x2)));
  % plot(fr,abs(xf));hold on
  [a,b2]=max(abs(xf2));
  fclose(f);
  if (b1!=b2) printf("frequencies differ\n");end
  printf("%s: %f %f -> %f\n",d(l).name,fr(b1),fr(b2),angle(xf1(b1)-angle(xf2(b2))))
end
eval(['legend(',leg(1:end-1),');'])
