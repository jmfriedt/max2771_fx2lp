close all
clear all
dt=dlmread('dt');

% GPS week jump
k=find(diff(dt(:,1))<0);
for l=1:length(k)
  k(l)
  dt(k(l)+1:end,1)=dt(k(l)+1:end,1)+7*24*3600*1000;
  dt=dt([1:k(l) k(l)+2:end],:); 
end
k=find(abs(dt(:,2))>2E-10);dt=dt(k,:);
% detect 20 ms jumps
k=find(diff(dt(:,2))>10e-3);
for l=1:length(k)
  dt(k(l)+1:end,2)=dt(k(l)+1:end,2)-20e-3;
end
% plot with drift
subplot(311);plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,2),'.')
% remove drift
[a,b]=polyfit((dt(:,1)-dt(1,1))/1000,dt(:,2),1);
a(1)
ylabel('local time-GPS time (s)');legend(num2str(a(1)))
res=dt(:,2)-b.yf;
subplot(312);plot((dt(:,1)-dt(1,1))/1000/3600,res,'.');
xlabel('time (h)');ylabel('local time-GPS time (s)')
y=[(dt(:,1)-dt(1,1))/1000 res];
save -ascii y y
% estimated frequency offset by gnss-sdr v.s 1-PPS time offset
subplot(313);plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,end),'.');
xlabel('time (h)');ylabel('frequency offset (ppm)')
figure;subplot(211)
ddt=diff(dt(:,2))./(diff(dt(:,1))/1E3);  % d/dt with dt(:,1) in ms
plot((dt(1:end-1,1)-dt(1,1))/3600/1000,ddt*1e6,'.');hold on;plot((dt(:,1)-dt(1,1))/3600/1000,dt(:,3),'.')
ylim([-0.6 -0.2]);xlabel('time (h)');
ylabel('local time-GPS time (ppm)')

% interpolate (physical system keeps on running with last estimated frequency)
printf("before: %d ",length(dt))
k=1;
do           % dt changes size dynamically => cannot be a for loop since k increases with interoplated samples
  tint=[];
  if (dt(k+1,1)-dt(k,1))>1100  % ms
     tint=interp1([dt(k,1) dt(k+1,1)],[dt(k,2) dt(k+1,2)],[dt(k,1)+1000:1000:dt(k+1,1)-1000]);
     dt=[dt(1:k,:) ; zeros(length(tint),3) ; dt(k+1:end,:)];
     for m=1:length(tint)
	     dt(k+m,1)=dt(k,1)+1000*m; % measurement time
	     dt(k+m,2)=tint(m);        % linear interpolation
	     dt(k+m,3)=dt(k,3);        % propagate freq offset
     end
  end
  k=k+length(tint)+1;
until (k>=length(dt)-1);
printf("after: %d\n",length(dt))
ddt=diff(dt(:,2));  % d/dt but now dt=1 s

% filtered output
b=5E-3;
ddtf=zeros(length(ddt),1);ddtf(1)=ddt(1);
dtf=zeros(length(dt),1);ddtf(1)=dt(1,3);
tf=zeros(length(dt),1);tf(1)=dt(1,2);
for p=2:length(ddt)
  tf(p)=tf(p-1)+b*(dt(p-1,2)-tf(p-1));      % dt
  ddtf(p)=ddtf(p-1)+b*(ddt(p-1)-ddtf(p-1)); % diff dt
  dtf(p)=dtf(p-1)+b*(dt(p-1,3)-dtf(p-1));   % ecart en ppm
end

% feedforward
cdtf=cumsum(ddtf.*diff(dt(:,1)*1e-3));
plot((dt(1:end-1,1)-dt(1,1))/3600/1000,ddtf*1e6,'.');hold on;plot((dt(:,1)-dt(1,1))/3600/1000,dtf,'.')
legend('diff(dt)','df','<diff(dt)>_{200s}','<df>_{200s}')
subplot(212)
plot((dt(2:end,1)-dt(1,1))/3600/1000,(dt(2:end,2)-cdtf)-mean((dt(2:end,2)-cdtf)),'.')
ylabel('local time-GPS time (s)');xlabel('time (h)');ylim([-0.00001 0.00001])
% feedback
figure
fo=0;
Kp=.6
Ki=.3
N=length(dt)
subplot(411)
plot((dt(2:N,1)-dt(1,1))/3600/1000,dt(2:N,2)-dt(400,2),'.')
hold on
plot((dt(2:N,1)-dt(1,1))/3600/1000,tf(2:N)-tf(400),'.')
for k=2:N % length(dtf) % filtered dt
	tstep=(dt(k,1)-dt(k-1,1))/1000;
	fo(k)=fo(k-1)+Kp*(tf(k)-tf(k-1))+Ki*tf(k)*tstep;
	dt(k+1:end,2)=dt(k+1:end,2)-fo(k);
	tf(k+1:end)=tf(k+1:end)-fo(k);
end
plot((dt(2:N,1)-dt(1,1))/3600/1000,dt(2:N,2)-dt(400,2),'.')
plot((dt(2:N,1)-dt(1,1))/3600/1000,tf(2:N)-tf(400),'.')
legend('dt before','tf before','dt after','tf after','location','southwest')
ylim([-.15 .01]);ylabel('local time-GPS time (s)')
subplot(412)
plot((dt(2:N,1)-dt(1,1))/3600/1000,dt(2:N,2)-dt(400,2),'.')
ylim([-.000017 .000001])
ylabel('dt (s)');
subplot(413)
plot((dt(2:N,1)-dt(1,1))/3600/1000,(tf(2:N)-tf(400))*1e9,'.')
ylim([0 2]);ylabel('tf (ns)')
subplot(414)
plot((dt(1:N,1)-dt(1,1))/3600/1000,fo*1e6,'.')
ylim([-.47 -.35]);ylabel('df (ppm)');xlabel('time (h)')
subplot(413)
ylim([0 2e-9]);
