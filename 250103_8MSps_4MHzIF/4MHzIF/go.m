x1=csvread('galileo_E1-sortie.csv');
dat=real(x1(:,2)*3600+x1(:,3)*60+x1(:,4));dat=dat-dat(1);
[a,b]=polyfit([229:length(x1)]',x1(229:end,9),1);
subplot(321);plot(dat(229:end),x1(229:end,9)/3e8*1e9,'x');
ylabel('MAX2771_1-ZedF9P');axis tight
subplot(322);plot(dat(229:end),(x1(229:end,9)-b.yf)/3e8*1e9,'x');
ylabel('MAX2771_1-ZedF9P-lin');axis tight
x2=csvread('galileo_E2-galileo_E1.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);
subplot(312);plot(dat,x2(:,9)/3e8*1e9,'x');ylabel('MAX2771_1-MAX2771_2');;axis tight;
x3=csvread('galileo_E2-sortie.csv')
dat=real(x3(:,2)*3600+x3(:,3)*60+x3(:,4));dat=dat-dat(1);
[a,b]=polyfit([22:length(x3)]',x3(22:end,9),1);
subplot(325);plot(dat(22:end),x3(22:end,9)/3e8*1e9,'x');ylabel('MAX2771_1-ZedF9P');axis tight
xlabel('time (s)')
subplot(326);plot(dat(22:end),(x3(22:end,9)-b.yf)/3e8*1e9,'x');ylabel('MAX2771_1-ZedF9P-lin');axis tight
xlabel('time (s)')

p=1
dat=real(x2(1,2)*3600+x2(1,3)*60+x2(1,4));dat=dat-dat(1);
v=[x2(1,9)];
for m=2:length(x2)
   olddat=dat;
   dat=real(x2(m,2)*3600+x2(m,3)*60+x2(m,4));
   if (dat==olddat) 
      v=[v x2(m,9)];
   else
      sol(p)=median(v);
      dats(p)=dat;
      p=p+1;
      v=[];
   end
end
subplot(312);
hold on
plot(dats-dats(1),sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
legend('Galileo E1','median')
mean(sol/3e8*1e9)
std(sol/3e8*1e9)

figure
x=csvread('gps1-gps2.csv');
dat=real(x(:,2)*3600+x(:,3)*60+x(:,4));dat=dat-dat(1);
subplot(312);
plot(dat,-x(:,9)/3e8*1e9,'x');;axis tight

p=1
dat=real(x(1,2)*3600+x(1,3)*60+x(1,4));dat=dat-dat(1);
v=[x(1,9)];
for m=2:length(x)
   olddat=dat;
   dat=real(x(m,2)*3600+x(m,3)*60+x(m,4));
   if (dat==olddat) 
      v=[v x(m,9)];
   else
      sol(p)=median(v);
      dats(p)=dat;
      p=p+1;
      v=[];
   end
end
subplot(312);
hold on
plot(dats-dats(1),-sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
legend('GPS L1','median')
mean(sol/3e8*1e9)
std(sol/3e8*1e9)
