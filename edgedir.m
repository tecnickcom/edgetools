function [ANG] = edgedir(EDG, KR, OP)
    % =====================================================================
    % File name   : edgedir.m
    % File Type   : m-file (script file for Matlab)
    % Requirements: Matlab Image Processing Toolbox
    % Begin       : 2006-07-07
    % Last Update : 2007-05-31
    % Author      : Nicola Asuni
    % Description : This function returns the orientation of image edges
    %               using a modified SUSAN technique.
    % Copyright   : 2006-2016 Nicola Asuni - Tecnick.com LTD
    % License     : GNU GENERAL PUBLIC LICENSE v.3
    %               http://www.gnu.org/copyleft/gpl.html
    % Version     : 1.1.000
    % =====================================================================
    
    % DESCRIPTION
    % --------------------
    % This function detects the angles of the tangents to image edges. 
    % Angles are counted counter-clockwise starting from horizontal.
    % The edges are those places in an image that correspond to object
    % boundaries.
    % To find the angles of edges, this function uses a modified SUSAN
    % technique.
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
    % [ANG] = edgedir(EDG)
    % [ANG] = edgedir(EDG, KR)
    % [ANG] = edgedir(EDG, KR, OP)
    
    % INPUT
    % --------------------
    % EDG : edge strength image
    % KR  : USAN Kernel Radius (nucleus excluded) (default = 3)
    % OP  : if true removes from USAN the pixels that are not 
    %       directly connected with the nucleus (default = false).
    %       IMPORTANT: This optimization is very slow, so use it carefully
    %       only for small images and when it's really needed.
    
    % OUTPUT
    % --------------------
    % ANG : angles of the tangents to image edges (edge orientation) in
    %       radiants ]0,pi]. Angles are counted counter-clockwise starting
    %       from horizontal.
    
    % Examples
    % --------------------
    % Please check the edgexample.m and edgexample2.m files on how to use
    % this function (uncomment the last line of these files to calculate
    % and print the edge orientation matrix).
    
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
        disp('edgedir function by Nicola Asuni.');
        disp('This function detects edges orientation using the SUSAN criteria.');
        disp('Usage:');
        disp('[ANG] = edgedir(EDG)');
        disp('[ANG] = edgedir(EDG, KR)');
        disp('[ANG] = edgedir(EDG, KR, OP)');
        disp('Where:');
        disp('EDG : edge strength image');
        disp('KR  : USAN Kernel Radius (nucleus excluded) (default = 3)');
        disp('OP  : if true removes from USAN the pixels that are not directly connected with the nucleus (default = false)');
        disp('ANG : edge directions in radiants normalized in the interval ]0,pi]');
        ANG = [];
        return;
    end
    
    % assign default values
    if (nargin > 3)
        error('Too many arguments');
    end
    if (nargin < 3)
        OP = false;
    end
    if (nargin < 2)
        KR = 3;
    end

    % ---------------------------------------------------------------------
    
    % convert coloured images to grayscale (if needed)
    NCOLORS = length(size(EDG));
    if (NCOLORS == 3)
        % RGB image
        EDG = rgb2gray(EDG);
    end
    % check edge map values
    MAXVAL = double(max(max(EDG)));
    if (MAXVAL > 1)
        % normalize map in the interval [0,1]
        EDG = double(EDG) / MAXVAL;
    end
    
    % the image leves are traslated to reduce computational errors around
    % zero
    EDG = EDG + 255;
    
    % get edge map size
    [m,n] = size(EDG);

    % create a circular kernel mask (KM)
    KW = (2*KR)+1; % kernel width
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
    
    % padding: add borders to edge map to simplify calculations
    EDG = [zeros(KR,n+(2*KR));zeros(m,KR),EDG,zeros(m,KR);zeros(KR,n+(2*KR))];
    
    % array used to store edge direction in radiants
    % angles are counted counter-clockwise starting from horizontal
    ANG = zeros(m,n);

    % create some matrices to simplify next calculations
    D = -KR:KR;
    RX = repmat(D,(2*KR)+1,1);
    RY = RX';
    DSQX = RX .^ 2;
    DSQY = DSQX';

    % for each image pixel
    for i = KR+1:m+KR
        for j = KR+1:n+KR
            if (EDG(i,j) > 0)
                
                % Select USAN region
                USAN = KM .* double(EDG(i-KR:i+KR,j-KR:j+KR));
                
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
                
                % --- find edge direction by case ---
                % this is an improved version of the original SUSAN
                % technique because the original seems to be faulty in some
                % conditions.
                
                % distances to the center of gravity of USAN region
                CDY = -(double(sum(sum(RY .* USAN))) / USAN_AREA);
                CDX = (double(sum(sum(RX .* USAN))) / USAN_AREA);
                
                if (sqrt((abs(CDX).^2) + (abs(CDY).^2)) < 1)
                    % --- intra-pixel edge case ---
                    % (center of gravity coinciding with the nucleus)
                    % calculates the angle to the longest axis of symmetry
                    DX = sum(sum(DSQX .* USAN));
                    if (DX > 0)
                        DY = - sum(sum(DSQY .* USAN));
                        DXY = sum(sum(RX .* RY .* USAN));
                        EANG = sign(DXY) * atan(DY/DX);
                    else
                        EANG = pi/2;
                    end
                else
                    % --- inter-pixel edge case ---
                    if (abs(CDX) > 0)
                        EANG = (pi/2) + atan(CDY/CDX);
                    else
                        EANG = pi;
                    end
                end
                % normalize angle in the ]0,pi] interval
                EANG = normalizeangle(EANG);
                % add angle to array        
                ANG(i-KR,j-KR) = EANG;  
            end
        end
    end

% === EOF =================================================================
