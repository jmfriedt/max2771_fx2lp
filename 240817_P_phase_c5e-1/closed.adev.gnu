
set terminal dumb 
set logscale xy
set format xy "10^{%+T}"
set grid
set key right
set xrange[6.800e-01:3.296e+03]
set yrange[7.428e-12:3.798e-08]
set mxtics 10
set mytics 10
set title "closed.adev" noenhanced
set xlabel "Integration time τ [s]"
set ylabel "ADEV σ_A(τ)"
set style line 1 pt 2 ps 1 lc 7 lw 3
set style line 2 pt 2 ps 1 lc 7 lw 2
set style line 3 pt 6 ps 2 lc rgb "#30D015" lw 4
set style line 4 lc rgb "#D01000" lw 5
set style line 5 lc rgb "#00A0A0" lw 3
set style line 6 lc rgb "#FFE000" lw 3
set style line 7 lc rgb "#109010" lw 3
set style line 8 lc rgb "#A000A0" lw 3
set style line 9 lc rgb "#0010D0" lw 3
set style line 10 lc rgb "#FF8000" lw 3
set style line 11 pt 0 ps 1 lc 7 lw 3
set style line 12 pt 0 ps 1 lc rgb "#A0A0A0" lw 2
set label "SigmaTheta 0.0.1" at 3.111e+03,8.874e-12 right font "Verdana,6"
plot "closed.adev" using 1:2 notitle with points ls 2, "closed.adev" using 1:3:4:7 title "95 % confidence interval" with yerrorbars ls 12 , "closed.adev" using 1:3:5:6 title "68 % confidence interval" with yerrorbars ls 11 
set terminal wxt size 1024,768 enhanced font "Verdana" fontscale 1.5 persist
replot
set term postscript color "Helvetica" 18
set output "closed.eps"
replot

exit
