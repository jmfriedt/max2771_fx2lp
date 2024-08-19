% graphics_toolkit('gnuplot')
load dt

dtvar=dt(4000:end,2);

subplot(411)
k=find(dt(:,2)<1e-10);
dt(k,2)=NaN;
plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,2),'.')
%axis([0 1500 .00935 .00965])
axis tight
ylim([min(dt(:,2))*0.9 max(dt(:,2))*1.1])
ylabel('dt (s)')
subplot(412)
plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,3),'.')
%axis([0 1500 -.35 .15])
axis tight
ylabel('df (ppm)')
subplot(413)
x=load('240817frequence');
hold on
plot([0:length(x)-1]/3600,(x-24)*1e6)
ylabel('f(HP53131)-24.10^6 (Hz)')
axis tight
subplot(414)
plot((dt(:,1)-dt(1,1))/1000/3600,dt(:,4)-24e6,'.')
ylabel('f(DDS)-24.10^6 (Hz)')
axis tight
xlabel('time (h)')

k=find(dtvar<1e-10);
do
  dtvar(k)=dtvar(k-1);
  printf("*")
until min(dtvar>2e-10)
a=[[0:length(dtvar)-1]' dtvar];
save -ascii closed a
