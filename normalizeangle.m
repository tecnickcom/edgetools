function [NANG] = normalizeangle(ANG)
    % =====================================================================
    % File name   : normalizeangle.m
    % File Type   : m-file (script file for Matlab)
    % Begin       : 2006-07-07
    % Last Update : 2006-09-15
    % Author      : Nicola Asuni
    % Description : This function returns the normalized angle in the 
    %               ]0,pi] interval. 
    % Copyright   : 2006-2016 Nicola Asuni - Tecnick.com LTD
    % License     : GNU GENERAL PUBLIC LICENSE v.3
    %               http://www.gnu.org/copyleft/gpl.html
    % =====================================================================
    
    % DESCRIPTION
    % --------------------
    % This function returns the normalized angle in the ]0,pi] interval. 

    % USAGE
    % --------------------
    % [NANG] = normalizeangle(ANG)
    
    % INPUT
    % --------------------
    % ANG  : the angle to be normalized
    
    % OUTPUT
    % --------------------
    % NANG : normalized angle in the ]0,pi] interval
    
    % Example
    % --------------------
    % >> [NANG] = normalizeangle(3*pi/2)
    % Please check also the edgedir.m script for usage example.
    
    % ---------------------------------------------------------------------
    
    % Some initial tests on the input arguments
    
    if (nargin < 1)
        disp('This function returns the normalized angle in the ]0,pi] interval.');
        disp('Usage:');
        disp('[NANG] = normalizeangle(ANG)');
        disp('Where:');
        disp('ANG  : the angle to be normalized');
        disp('NANG : normalized angle in the ]0,pi] interval');
        return
    end
    
    if (nargin > 1)
        error('Too many arguments');
    end;

    % ---------------------------------------------------------------------
    
    NANG = ANG;
    
    if (NANG <= 0)
        NANG = pi + NANG;
    end
    if (NANG > pi)
        NANG = NANG - pi;
    end

% === EOF =================================================================
