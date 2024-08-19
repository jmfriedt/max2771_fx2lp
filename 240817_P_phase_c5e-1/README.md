grep TOW control | cut -d= -f2,3,7,8 | sed 's/dt=//g' | sed 's/x=//g' | sed 's/f=//g'| sed 's/gdop//g' > dt
grep TOW control | cut -d= -f2,9,10 | sed 's/pdop=//g' | sed 's/dt=//g' > dop
