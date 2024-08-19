cat control | cut -d= -f2,3,7,8 | sed 's/dt=//g' | sed 's/x=//g' | sed 's/f=//g'> dt
