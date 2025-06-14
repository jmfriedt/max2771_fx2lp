# Phase stability between two MAX2771 clocked with the same source

Phase coherence is lost if programming from upper to lower or lower to
upper L-band.

Phase coherence is lost when starting from scratch a new acquisition.

Phase seems to be kept when streaming continuously IQ (ZMQ Publish) and
programming within the upper or lower L-band.

## Raw measurement outputs

```
sudo mkfifo /tmp/ch12
./go.sh

config 1  config2
1575.480  1575.420  Hi/Hi
1575.480  1227.600  Hi/Lo

Synthe 1575.500

1/ reprogramme entre deux frequences de L-band Hi (sans changer de bande)
$ ./tests.sh 
Pocket SDR device settings are changed.
config 2
4.15 MB/s 1.79 @ -55472.722636386825
4.15 MB/s 1.81 @ -55472.722636386825
4.15 MB/s 1.85 @ -55472.722636386825
4.15 MB/s 1.84 @ -55472.722636386825
4.15 MB/s 1.81 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.06 MB/s -0.41 @ 17860.91069544651
4.15 MB/s -0.42 @ 17860.91069544651
4.07 MB/s -0.39 @ 17860.91069544651
4.14 MB/s -0.39 @ 17860.91069544651
4.14 MB/s -0.38 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
4.14 MB/s 1.82 @ -55472.722636386825
4.15 MB/s 1.79 @ -55472.722636386825
4.13 MB/s 1.83 @ -55472.722636386825
4.15 MB/s 1.78 @ -55470.72264638677
4.14 MB/s 1.78 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.35 @ 17860.91069544651
4.14 MB/s -0.35 @ 17860.91069544651
4.14 MB/s -0.33 @ 17860.91069544651
4.14 MB/s -0.34 @ 17860.91069544651
4.15 MB/s -0.36 @ 17858.910705446455
Pocket SDR device settings are changed.
config 2
4.05 MB/s 1.87 @ -55472.722636386825
4.05 MB/s 1.85 @ -55472.722636386825
4.15 MB/s 1.85 @ -55472.722636386825
4.14 MB/s 1.79 @ -55472.722636386825
4.13 MB/s 1.80 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.40 @ 17860.91069544651
4.07 MB/s -0.40 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
4.13 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.42 @ 17858.910705446455
Pocket SDR device settings are changed.
config 2
4.13 MB/s 1.76 @ -55472.722636386825
4.06 MB/s 1.79 @ -55472.722636386825
4.06 MB/s 1.79 @ -55474.72262638687
4.14 MB/s 1.85 @ -55472.722636386825
4.14 MB/s 1.82 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.38 @ 17860.91069544651
4.15 MB/s -0.33 @ 17860.91069544651
4.14 MB/s -0.39 @ 17860.91069544651
4.07 MB/s -0.41 @ 17860.91069544651
4.15 MB/s -0.42 @ 17858.910705446455
Pocket SDR device settings are changed.
config 2
4.14 MB/s 1.74 @ -55472.722636386825
4.15 MB/s 1.81 @ -55472.722636386825
4.11 MB/s 1.78 @ -55472.722636386825
4.06 MB/s 1.86 @ -55472.722636386825
4.16 MB/s 1.82 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.41 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.36 @ 17860.91069544651
4.14 MB/s -0.36 @ 17860.91069544651
4.13 MB/s -0.37 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
4.06 MB/s 1.85 @ -55472.722636386825
4.06 MB/s 1.87 @ -55472.722636386825
4.13 MB/s 1.82 @ -55472.722636386825
4.17 MB/s 1.82 @ -55472.722636386825
4.16 MB/s 1.80 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.17 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.41 @ 17858.910705446455
4.15 MB/s -0.43 @ 17858.910705446455
4.08 MB/s -0.40 @ 17860.91069544651
4.17 MB/s -0.41 @ 17858.910705446455
Pocket SDR device settings are changed.
config 2
4.15 MB/s 1.74 @ -55472.722636386825
4.08 MB/s 1.81 @ -55472.722636386825
4.13 MB/s 1.80 @ -55472.722636386825
4.06 MB/s 1.81 @ -55472.722636386825
4.15 MB/s 1.78 @ -55474.72262638687
config 1
Pocket SDR device settings are changed.
4.06 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.39 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
4.07 MB/s -0.36 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
4.07 MB/s 1.86 @ -55472.722636386825
4.15 MB/s 1.91 @ -55472.722636386825
4.15 MB/s 1.85 @ -55472.722636386825
4.15 MB/s 1.82 @ -55474.72262638687
4.16 MB/s 1.81 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.39 @ 17860.91069544651
4.14 MB/s -0.40 @ 17860.91069544651
4.15 MB/s -0.40 @ 17860.91069544651
4.07 MB/s -0.43 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
4.15 MB/s 1.82 @ -55472.722636386825
4.15 MB/s 1.80 @ -55472.722636386825
4.13 MB/s 1.81 @ -55472.722636386825
4.15 MB/s 1.84 @ -55472.722636386825
4.15 MB/s 1.80 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.14 MB/s -0.41 @ 17860.91069544651
4.14 MB/s -0.38 @ 17860.91069544651
4.15 MB/s -0.41 @ 17862.91068544655
4.15 MB/s -0.40 @ 17862.91068544655
4.06 MB/s -0.38 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
4.14 MB/s 1.81 @ -55472.722636386825
4.15 MB/s 1.85 @ -55472.722636386825
4.08 MB/s 1.79 @ -55472.722636386825
4.15 MB/s 1.78 @ -55472.722636386825
4.15 MB/s 1.79 @ -55472.722636386825
config 1
Pocket SDR device settings are changed.
4.13 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.37 @ 17860.91069544651
4.15 MB/s -0.35 @ 17860.91069544651
4.15 MB/s -0.38 @ 17860.91069544651
4.15 MB/s -0.39 @ 17862.91068544655

2/ reprogramme entre deux frequences de L-band Hi et L-band Lo

$ ./tests.sh 
Pocket SDR device settings are changed.
config 2
4.06 MB/s -1.54 @ -0.9999950000346871  <- pas de signal en bande 2 donc phase arbitraire
4.07 MB/s -1.46 @ -0.9999950000346871
4.14 MB/s -1.53 @ -0.9999950000346871
4.15 MB/s -1.03 @ -0.9999950000346871
4.15 MB/s -2.07 @ -0.9999950000346871
config 1
Pocket SDR device settings are changed.
4.15 MB/s -0.83 @ 17862.91068544655
4.07 MB/s -0.80 @ 17862.91068544655
4.14 MB/s -0.82 @ 17862.91068544655
4.15 MB/s -0.82 @ 17862.91068544655
4.14 MB/s -0.81 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.07 MB/s -1.64 @ 17862.91068544655
4.15 MB/s -1.59 @ 17862.91068544655
4.15 MB/s -1.61 @ 17862.91068544655
4.15 MB/s -1.57 @ 17862.91068544655
4.09 MB/s -1.59 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.15 MB/s 2.43 @ 17862.91068544655
4.14 MB/s 2.40 @ 17862.91068544655
4.15 MB/s 2.42 @ 17862.91068544655
4.15 MB/s 2.39 @ 17860.91069544651
4.15 MB/s 2.39 @ 17864.910675446605
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.16 MB/s 2.33 @ 17862.91068544655
4.14 MB/s 2.31 @ 17862.91068544655
4.14 MB/s 2.32 @ 17862.91068544655
4.14 MB/s 2.32 @ 17862.91068544655
4.06 MB/s 2.32 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.15 MB/s 0.61 @ 17862.91068544655
4.15 MB/s 0.62 @ 17864.910675446605
4.15 MB/s 0.65 @ 17864.910675446605
4.06 MB/s 0.63 @ 17864.910675446605
4.15 MB/s 0.62 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.06 MB/s -0.03 @ 17862.91068544655
4.15 MB/s -0.04 @ 17862.91068544655
4.15 MB/s -0.02 @ 17862.91068544655
4.14 MB/s -0.03 @ 17862.91068544655
4.07 MB/s -0.03 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.07 MB/s 0.69 @ 17862.91068544655
4.15 MB/s 0.71 @ 17864.910675446605
4.14 MB/s 0.75 @ 17864.910675446605
4.06 MB/s 0.76 @ 17862.91068544655
4.06 MB/s 0.72 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.07 MB/s -3.06 @ 17862.91068544655
4.07 MB/s -3.08 @ 17862.91068544655
4.07 MB/s -3.02 @ 17862.91068544655
4.07 MB/s -3.03 @ 17862.91068544655
4.14 MB/s -3.01 @ 17862.91068544655
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.13 MB/s -0.49 @ 17862.91068544655
4.15 MB/s -0.50 @ 17862.91068544655
4.07 MB/s -0.51 @ 17862.91068544655
4.16 MB/s -0.50 @ 17862.91068544655
4.07 MB/s -0.54 @ 17860.91069544651
Pocket SDR device settings are changed.
config 2
...
config 1
Pocket SDR device settings are changed.
4.07 MB/s 1.81 @ 17862.91068544655
4.04 MB/s 1.84 @ 17862.91068544655
4.16 MB/s 1.82 @ 17862.91068544655
4.15 MB/s 1.85 @ 17862.91068544655
4.14 MB/s 1.80 @ 17862.91068544655
```
