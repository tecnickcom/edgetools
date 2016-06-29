function [EDG] = edgemap(IM, TR, KR, NR, OP)
    % =====================================================================
    % File name   : edgemap.m
    % File Type   : m-file (script file for Matlab)
    % Requirements: Matlab Image Processing Toolbox
    % Begin       : 2006-07-07
    % Last Update : 2007-05-31
    % Author      : Nicola Asuni
    % Description : This function detects image edges using an improved 
    %               SUSAN technique.
    % Copyright   : 2006-2016 Nicola Asuni - Tecnick.com LTD
    % License     : GNU GENERAL PUBLIC LICENSE v.3
    %               http://www.gnu.org/copyleft/gpl.html
    % Version     : 1.1.000
    % =====================================================================
    
    % DESCRIPTION
    % --------------------
    % This function detects edges, which are those places in an image that
    % correspond to object boundaries. To find edges, this function looks
    % for places in the image where the intensity changes rapidly, using
    % an improved SUSAN technique.
    %
    % This algorithm is based on the technique described on:
    % S.M. Smith, J.M. Brady, "SUSAN - a new approach to low level image
    % processing", Int Journal of Computer Vision, 23(1):45-78, May 1997.
    % This technicque is subject to a patent:
    % S.M. Smith, "Method for digitally processing images to determine the
    % position of edges and/or corners therein for guidance of unmanned
    % vehicle. UK Patent 2272285. Proprietor: Secretary of State for
    % Defence, UK. 15 January 1997.
    
    % KEYWORDS
    % --------------------
    % SUSAN, image, edge, detection, detector, orientation, direction, matlab, octave.
    
    % WARNING
    % --------------------
    % This function is slow because of high computational complexity.
    
    % USAGE
    % --------------------
    % [EDG] = edgemap(IM)
    % [EDG] = edgemap(IM, TR)
    % [EDG] = edgemap(IM, TR, KR)
    % [EDG] = edgemap(IM, TR, KR, NR)
    % [EDG] = edgemap(IM, TR, KR, NR, OP)
    
    % INPUT
    % --------------------
    % IM : source image (RGB or grayscale)
    % TR : Brightness Threshold (default = 20)
    % KR : USAN Kernel Radius (nucleus excluded) (default = 3)
    % NR : EDG matrix will be normalized to this range of integers
    %      (default = 0 = not normalize)
    % OP : if true removes from USAN the pixels that are not 
    %      directly connected with the nucleus (default = false).
    %      IMPORTANT: This optimization is very slow, so use it carefully
    %      only for small images and when it's really needed. 
    
    % OUTPUT
    % --------------------
    % EDG : edge strength image
    
    % Examples
    % --------------------
    % Please check the edgexample.m and edgexample2.m files on how to use
    % this function.
    
    % NOTES
    % --------------------
    % This implementation is not intended to be used in a production
    % environment. The main purpose of this script is to clearly show how
    % this technique works. Better performaces could be obtained using a
    % compiled version or rewriting this technique using a low-level
    % programming language.
    
    % ---------------------------------------------------------------------
    
    % Some initial tests on the input arguments
    
    if (nargin < 1)
        disp('edgemap function by Nicola Asuni.');
        disp('This function returns an edge map.');
        disp('Usage:');
        disp('[EDG] = edgemap(IM)');
        disp('[EDG] = edgemap(IM, TR)');
        disp('[EDG] = edgemap(IM, TR, KR)');
        disp('[EDG] = edgemap(IM, TR, KR, NR)');
        disp('[EDG] = edgemap(IM, TR, KR, NR, OP)');
        disp('Where:');
        disp('IM  : source image (RGB or grayscale)');
        disp('TR  : Brightness Threshold (default = 20)');
        disp('KR  : USAN Kernel Radius (nucleus excluded) (default = 3)');
        disp('NR  : the EDG matrix will be normalized to this range of integers (default = 0 = not normalize)');
        disp('OP  : if true removes from USAN the pixels that are not directly connected with the nucleus (default = false)');
        disp('EDG : edge strength image');
        EDG = [];
        return;
    end
    
    % assign default values
    if (nargin > 5)
        error('Too many arguments');
    end
    if (nargin < 5)
        OP = false;
    end
    if (nargin < 4)
        NR = 255;
    end
    if (nargin < 3)
        KR = 3;
    end
    if (nargin < 2)
        TR = 27;
    end
    
    % ---------------------------------------------------------------------
    
    % convert coloured images to grayscale (if needed)
    NCOLORS = ndims(IM);
    if (NCOLORS == 3)
        % RGB image
        IMG = double(rgb2gray(IM));
    elseif (NCOLORS == 2)
        IMG = double(IM);
    else
        error('Unrecognized image type, please use RGB or greyscale images');
    end
    
    % the image leves are traslated to reduce computational errors around
    % zero
    IMG = IMG + 255;
    
    % get image size
    [m,n] = size(IMG);
    
    % kernel width
    KW = (2 * KR) + 1; 
    
    % create a circular kernel mask (KM)
    KM = ones(KW,KW);
    for i = -KR:KR
        for j = -KR:KR
            if (round(sqrt((i.^2) + (j.^2))) > KR)
                KM(i+KR+1,j+KR+1) = 0;
            end
        end
    end
    
    % number of nonzero kernel elements (max kernel area)
    KAREA = nnz(KM);
    
    % calculates geometric threshold
    GT = 3 * KAREA / 4;
    
    % padding: add borders to image to simplify calculations
    IMG = [repmat(IMG(1,:),KR,1);IMG;repmat(IMG(m,:),KR,1)];
    IMG = [repmat(IMG(:,1),1,KR),IMG,repmat(IMG(:,n),1,KR)];
    
    % initialize edge strength image
    EDG = zeros(m,n);
    
    % for each image pixel
    for i = KR+1:m+KR
        for j = KR+1:n+KR
            % USAN region:
            % calculate the number of pixels within the circular mask which
            % have a similar brightness to the nucleus
            USAN = KM .* exp(-((IMG(i-KR:i+KR, j-KR:j+KR) - IMG(i,j)) / TR).^6);
            
            if (OP)
                % remove pixels that are not directly connected with the
                % nucleus (this is an improvement of the original SUSAN
                % technique).
                % select nonzero pixels of USAN region
                USAN_BINARY = ceil(USAN);
                % check if we have minimum condition to have separate regions
                if (nnz(USAN_BINARY) < (KAREA - KR))
                    USAN = bwselect(USAN_BINARY,KR+1,KR+1,8) .* USAN;
                end
            end
            
            % USAN area
            USAN_AREA = sum(sum(USAN));
            
            % subtract the USAN size from the geometric threshold GT to produce
            % an edge strength image
            if (USAN_AREA < GT)
                % this pixel is an edge
                EDG(i-KR,j-KR) = GT - USAN_AREA;    
            end
        end
    end
    
    % normalize edge values to the specified range of integers
    % (this is not included on original SUSAN technique)
    if (NR > 0)
        NSCALE = NR / max(max(EDG));
        EDG = round(NSCALE .* EDG);
        % convert data to best integer type
        if (NR > (2^32))
            EDG = uint64(EDG);
        elseif (NR > (2^16))
            EDG = uint32(EDG);
        elseif (NR > (2^8))
            EDG = uint16(EDG);
        else
            EDG = uint8(EDG);
        end
    end

% === EOF =================================================================
