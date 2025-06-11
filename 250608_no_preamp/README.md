## Link budget

25 kW ERP = 74 dBm

TX to RXref distance = 4840 m

$FSPL=20log_{10}(490\cdot 10^6)+20log_{10}(4840)-147.55=100 dB$

74-100=-26 dBm excluding Yagi-Uda receiving antenna gain

P1dB(MAX2771)=-85 dBm !

## Experimental setup

<img src="DSC02881small.jpg">
<img src="DSC02884small.jpg">
<img src="DSC02887small.jpg">

## Acquisition results

<img src="1_514MHz.png"><img src="2_490MHz.png"><img src="3_682MHz.png">
<img src="4_658MHz.png"><img src="5_650MHz.png">

<img src="6_stacking.png">

## Displying the bistatic range ellipse in QGis:

<img src="2025-06-11-073154_2704x1050_scrot.png">

```
Layer -> Create Layer -> New Shapefile Layer (Geometry Type: Polygon)

Pen Icon to Toggle Editing (also in the Layer Menu)

View -> Toolbars -> Advanced Digitizing Toolbar (enable)

Add Polygon Feature

Ellipse from Foci
```

<img src="wide.png">

<img src="zoom.png">
