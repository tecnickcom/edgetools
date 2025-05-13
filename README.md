# edgetools
*edgetools (edgemap.m + edgedir.m) Matlab tools to find edges of a digital image*

[![Donate via PayPal](https://www.paypal.com/donate/?hosted_button_id=NZUEC5XS8MFBJ)
*Please consider supporting this project by making a donation via [PayPal](https://www.paypal.com/donate/?hosted_button_id=NZUEC5XS8MFBJ)*

* **category**    Application
* **package**     \Com\Tecnick\edgetools
* **author**      Nicola Asuni <info@tecnick.com>
* **copyright**   2006-2016 Nicola Asuni - Tecnick.com LTD
* **license**     http://www.gnu.org/copyleft/lesser.html GNU-LGPL v3 (see LICENSE.TXT)
* **link**        https://github.com/tecnickcom/edgetools
* **version**     1.1.1

## Description

This function detects edges, which are those places in an image that
correspond to object boundaries. To find edges, this function looks
for places in the image where the intensity changes rapidly, using
an improved SUSAN technique.

This algorithm is based on the technique described on:
S.M. Smith, J.M. Brady, "SUSAN - a new approach to low level image
processing", Int Journal of Computer Vision, 23(1):45-78, May 1997.
This technicque is subject to a patent:
S.M. Smith, "Method for digitally processing images to determine the
position of edges and/or corners therein for guidance of unmanned
vehicle. UK Patent 2272285. Proprietor: Secretary of State for
Defence, UK. 15 January 1997.

## KEYWORDS: SUSAN, image, edge, detection, detector, orientation, direction, matlab, octave.

---------------------------------------------------------------------

## edgemap.m

### USAGE

[EDG] = edgemap(IM)
[EDG] = edgemap(IM, TR)
[EDG] = edgemap(IM, TR, KR)
[EDG] = edgemap(IM, TR, KR, NR)
[EDG] = edgemap(IM, TR, KR, NR, OP)

### INPUT

IM : source image (RGB or grayscale)
TR : Brightness Threshold (default = 20)
KR : USAN Kernel Radius (nucleus excluded) (default = 3)
NR : EDG matrix will be normalized to this range of integers
     (default = 0 = not normalize)
OP : if true removes from USAN the pixels that are not 
     directly connected with the nucleus (default = false).
     IMPORTANT: This optimization is very slow, so use it carefully
     only for small images and when it's really needed. 

### OUTPUT
EDG : edge strength image

## Examples
Please check the edgexample.m and edgexample2.m files on how to use this function.

### NOTES

This implementation is not intended to be used in a production
environment. The main purpose of this script is to clearly show how
this technique works. Better performaces could be obtained using a
compiled version or rewriting this technique using a low-level
programming language.

---------------------------------------------------------------------


## edgedir.m

### DESCRIPTION

This function detects the angles of the tangents to image edges. 
Angles are counted counter-clockwise starting from horizontal.
The edges are those places in an image that correspond to object
boundaries.
To find the angles of edges, this function uses a modified SUSAN
technique.
%
This algorithm is based on the technique described on:
S.M. Smith, J.M. Brady, "SUSAN - a new approach to low level image
processing", Int Journal of Computer Vision, 23(1):45-78, May 1997.
This technicque is subject to a patent:
S.M. Smith, "Method for digitally processing images to determine the
position of edges and/or corners therein for guidance of unmanned
vehicle. UK Patent 2272285. Proprietor: Secretary of State for
Defence, UK. 15 January 1997.

### KEYWORDS
SUSAN, image, edge, detection, detector, orientation, direction, matlab, octave.

### WARNING

This function is slow because of high computational complexity.

### USAGE

[ANG] = edgedir(EDG)
[ANG] = edgedir(EDG, KR)
[ANG] = edgedir(EDG, KR, OP)

### INPUT
EDG : edge strength image
KR  : USAN Kernel Radius (nucleus excluded) (default = 3)
OP  : if true removes from USAN the pixels that are not 
      directly connected with the nucleus (default = false).
      IMPORTANT: This optimization is very slow, so use it carefully
      only for small images and when it's really needed.

### OUTPUT
ANG : angles of the tangents to image edges (edge orientation) in
      radiants ]0,pi]. Angles are counted counter-clockwise starting
      from horizontal.

### Examples
Please check the edgexample.m and edgexample2.m files on how to use
this function (uncomment the last line of these files to calculate
and print the edge orientation matrix).

### NOTES
This implementation is not intended to be used in a production
environment. The main purpose of this script is to clearly show how
this technique works. Better performaces could be obtained using a
compiled version or rewriting this technique using a low-level
programming language.

---------------------------------------------------------------------

### Example:
Check the edgexample.m and edgexample2.m scripts for usage example.
