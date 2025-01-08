x2=csvread('diff_galileoC1.csv');
dat=real(x2(:,2)*3600+x2(:,3)*60+x2(:,4));dat=dat-dat(1);
subplot(312);plot(dat,x2(:,9)/3e8*1e9,'x');ylabel('MAX2771_1-MAX2771_2');axis tight;
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

