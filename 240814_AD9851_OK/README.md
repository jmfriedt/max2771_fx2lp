
cat control | cut -d= -f2,3,7,8 | sed 's/dt=//g' | sed 's/x=//g' | sed 's/f=//g'> dt

load dt
plot((dt(:,1)-dt(1,1)/1000),dt(:,4)-24e6)

