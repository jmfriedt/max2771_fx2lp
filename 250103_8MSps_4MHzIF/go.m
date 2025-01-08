x2=csvread('4MHzIF/E1moinsE2.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);

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
% subplot(312);
hold on
plot(dats-dats(1),sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
mean(sol/3e8*1e9)
line([0 250],[mean(sol/3e8*1e9) mean(sol/3e8*1e9)])
std(sol/3e8*1e9)
%%%%%%%%%%%
x2=csvread('4MHzIF_2m/differenceC.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);

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
hold on
plot(dats-dats(1),sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
mean(sol/3e8*1e9)
line([0 250],[mean(sol/3e8*1e9) mean(sol/3e8*1e9)])
std(sol/3e8*1e9)

%%%%%%%%%%%
x2=csvread('4MHzIF_4m/diff_galileoC1.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);

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
hold on
plot(dats-dats(1),sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
mean(sol/3e8*1e9)
line([0 250],[mean(sol/3e8*1e9) mean(sol/3e8*1e9)])
std(sol/3e8*1e9)

%%%%%%%%%%%
x2=csvread('4MHzIF_5m80/diff_galileoC1.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);

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
hold on
plot(dats-dats(1),sol/3e8*1e9,'x')
xlabel('time (s)')
ylim([-40 20])
legend('0 m: 6.0+/-4.2 ns','2 m: -5.9+/-4.4','4 m: -16.3+/-2.9','5m80: -24.1+/-4.5')
mean(sol/3e8*1e9)
line([0 250],[mean(sol/3e8*1e9) mean(sol/3e8*1e9)])
std(sol/3e8*1e9)
ylabel('delay diff. (ns)')

xlim([0 250])
