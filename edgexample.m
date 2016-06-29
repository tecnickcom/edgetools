function [] = edgexample()
    % =====================================================================
    % File name   : edgexample.m
    % File Type   : m-file (script file for Matlab)
    % Requirements: Matlab Image Processing Toolbox
    % Begin       : 2006-07-07
    % Last Update : 2007-03-22
    % Author      : Nicola Asuni
    % Description : example script for edgemap.m and edgedir.m functions.
    % Copyright   : 2006-2016 Nicola Asuni - Tecnick.com LTD
    % License     : GNU GENERAL PUBLIC LICENSE v.3
    %               http://www.gnu.org/copyleft/gpl.html
    % =====================================================================

    % DESCRIPTION
    % --------------------
    % This is an example script that shows you how to use the edgemap.m and
    % edgedir.m functions.
    % 
    % The edgemap.m function detects edges, which are those places in an
    % image that correspond to object boundaries. To find edges, this
    % function looks for places in the image where the intensity changes
    % rapidly, using an improved SUSAN technique.
    %
    % The edgedir.m function detects the angles of the tangents to image
    % edges (requires edgemap.m). Angles are counted counter-clockwise
    % starting from horizontal. This function uses a modified SUSAN
    % technique. To use this function you have to uncomment the last line
    % of this script.

    % USAGE
    % --------------------
    % edgexample

    % Example
    % --------------------
    % >> edgexample

    % ---------------------------------------------------------------------

    % Help
    disp('This is an example script that shows you how to use the edgemap.m and edgedir.m functions.');
    disp('Please check the documentation inside this file for further information.');

    % --- set parameters ---

    % Brightness Threshold
    TR = 10;

    % USAN Kernel Radius (nucleus excluded)
    KR = 3;

    % NR : EDG matrix will be normalized to this range of integers
    NR = 255;

    % OP : if true (default) removes from USAN the pixels that are not 
    %      directly connected with the nucleus.
    %      IMPORTANT: This optimization is very slow, so use it carefully
    %      only for small images and when it's really needed. 
    OP = false;

    % --- end set parameters ---

    % load test image
    IMG = imread('testimage.png'); 

    % display image
    figure, imshow(IMG);

    % get the current CPU time
    t1 = cputime;

    % get edge map
    EDG = edgemap(IMG, TR, KR, NR, OP);

    % print the elapsed time
    fprintf('\nProcessing time: %8.3f sec\n', cputime-t1);

    % display edge map
    figure, imshow(EDG);

    % display edges in 3D space
    % (uncomment the following lines to get a 3D map)
    figure, surface(EDG,'FaceColor','texturemap','EdgeColor','none','CDataMapping','scaled');
    view(135,80); % rotate image

    % get edges directions
    % (uncomment the following line to print a direction map)
    % EDGDIR = edgedir(EDG, KR, OP)

% === EOF =================================================================
