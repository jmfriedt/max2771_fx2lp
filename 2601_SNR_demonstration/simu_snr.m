clear all;close all
pkg load signal
load GNSS-matlab/prn_codes/codes_E1B.mat
load GNSS-matlab/prn_codes/codes_L1CA.mat
load GNSS-matlab/prn_codes/codes_L5I.mat
pos=20;
avg=100;
Nsequence=[.01 .1 1 5 10 20]
for iter=1:3
  if (iter==1) x=codes_L1CA(:,1)';end % x=cacode(1,1)*2-1;
  if (iter==2) x=codes_E1B(:,1)' ;end
  if (iter==3) x=codes_L5I(:,1)' ;end % x=cacode(1,1)*2-1;
  x=x-mean(x);
  nindex=0;
  for N=Nsequence
    nindex=nindex+1;
    for iter=1:avg   % must be randn() and not rand()
      s=randn(1,65536); s=s-mean(s); s=s*sqrt(N); % amp*sqrt(N) => power *N
      SNRbefore=var(x)/var(s);                  
      s(pos:pos+length(x)-1)=s(pos:pos+length(x)-1)+x;

      sol=(xcorr(s,x))(length(s):end);           % after pulse compression
      signal=sol(pos).^2;
      noise=var(sol(pos+length(x)+10:end)); 
      SNRafter=signal/noise;
      sm(iter,nindex)=(SNRafter/SNRbefore);
    end
  end
  subplot(211)
  errorbar(-10*log10(Nsequence),mean(sm),std(sm));hold on
end
xlabel('SNR (no unit)');ylabel('cros-correlation SNR gain (no unit)');
line([-15 22],[1023 1023]);line([-15 22],[10230 10230]);line([-15 22],[4092 4092])
legend('GPS L1 C/A (1023)','Galileo E1 (4092)','GPS L5I (10230)')
xlim([-15 22])
figure
subplot(211)
plot(s);ylabel('signal');xlabel('time (sample)')
subplot(212)
plot(sol);ylabel('xcorr');xlabel('delay (sample)')
