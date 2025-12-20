fs=4e6;
f=fopen('/tmp/1.bin');x=fread(f,inf,'int8'); fclose(f)
x1=x(1:2:end)+j*x(2:2:end);
xsig1=x1(1:fs);        xsig1=xsig1-mean(xsig1);
xref1=x1(end-fs+1:end);xref1=xref1-mean(xref1);
fr=linspace(-fs/1e6/2,fs/1e6/2,length(xsig1));
s=abs(fftshift(fft(xsig1))); 
subplot(221); plot(fr,s);legend('sig1');line([-0.5 -0.5],[0 0.8*max(s)]);ylabel('|FFT| (a.u.)');
s=abs(fftshift(fft(xref1))); 
subplot(222); plot(fr,s);legend('ref1');line([-0.1 -0.1],[0 0.8*max(s)]);

f=fopen('/tmp/2.bin');x=fread(f,inf,'int8'); fclose(f)
x2=x(1:2:end)+j*x(2:2:end);
xsig2=x2(1:fs);        xsig2=xsig2-mean(xsig2);
xref2=x2(end-fs+1:end);xref2=xref2-mean(xref2);
s=abs(fftshift(fft(xsig2)));
subplot(223); plot(fr,s);legend('sig2');line([-0.5 -0.5],[0 0.8*max(s)]);
xlabel('f (MHz)');ylabel('|FFT| (a.u.)')
s=abs(fftshift(fft(xref2)));
subplot(224); plot(fr,s);legend('ref2');line([-0.1 -0.1],[0 0.8*max(s)]);hold on;xlabel('f (MHz)')
pause
