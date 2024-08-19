close all
clear all
% graphics_toolkit('gnuplot')
dt=dlmread('dt');

% GPS week jump
k=find(diff(dt(:,1))<0);
for l=1:length(k)
  k(l)
  dt(k(l)+1:end,1)=dt(k(l)+1:end,1)+7*24*3600*1000;
  dt=dt([1:k(l) k(l)+2:end],:); 
end

k=find(abs(dt(:,2))>2E-10); dt=dt(k,:);

% detect 20 ms jumps
k=find(abs(diff(dt(:,2)))>10e-3);
for l=1:length(k)
  dt(k(l)+1:end,2)=dt(k(l)+1:end,2)-20e-3;
end

% interpolate missing measurements
k=1;
do           % dt changes size dynamically => cannot be a for loop since k increases with interoplated samples
  tint=[];
  if (dt(k+1,1)-dt(k,1))>1100  % ms
     tint=interp1([dt(k,1) dt(k+1,1)],[dt(k,2) dt(k+1,2)],[dt(k,1)+1000:1000:dt(k+1,1)-1000]);
     dt=[dt(1:k,:) ; zeros(length(tint),4) ; dt(k+1:end,:)];
     for m=1:length(tint)
	     dt(k+m,1)=dt(k,1)+1000*m; % measurement time
	     dt(k+m,2)=tint(m);        % linear interpolation
     end
  end
  k=k+length(tint)+1;
until (k>=length(dt)-1);

% plot with drift
subplot(311);plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,2),'.')
tmpy=[(dt(:,1)-dt(1,1))/1000 dt(:,2)];
save -ascii dt_line19 tmpy
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
ylabel('frequency/time offset (ppm)')
