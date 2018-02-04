
function I_ret=Red_Eye(I)
Ih = rgb2hsv (I);   % Convert RGB to hsv for further processing
% Detect Eyes using inbuilt Matlab function
% Build a bounding box around the eye
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);

% Initialize a mask
mask = zeros ( length (I (:, 1 , :)), length (I ( 1 ,:, :)));

    % Code for detecting Red part in the Eye
    % The part of eye having hue greater than 0.9 or less than 0.02 
    % and Saturation greater than 0.6 is considered red
    for  i = BB(2) :1 :BB(2)+BB(4)-1
        for  j = BB(1) :1: BB(1)+BB(3)-1
            if (Ih ( i , j , 1 )> 0.9 || Ih ( i , j , 1 ) <0.02) & Ih ( i , j , 2 )> 0.6
                mask ( i , j ) = 1 ;
            end
        end
    end
    
    % Apply median filter to the mask to remove any impulse noise
    mask= medfilt2(mask);
    
    % Morphological transformations on Image
    % opening and dilation operation
    se = strel ( 'disk' , 2 );
    aux = imopen (mask, se);
    masknew = imdilate (aux, se);
    
    % Convert to RGB
    Irgb = I;
    
    % Replace red channel of the identified red part of eye to be average
    %  of blue and green channels.
    % Also replace blue and green channels to be average of green and blue
    for  i = 1 : size (I, 1 )
        for  j = 1 : size (I, 2 )
            if masknew ( i , j ) == 1
                Irgb ( i , j , 1 ) = (I ( i , j , 2 ) + I ( i , j , 3 )) / 2 ;
                Irgb( i, j, 2) = (I ( i , j , 2 ) + I ( i , j , 3 )) / 2;
                Irgb( i, j, 3) = (I ( i , j , 2 ) + I ( i , j , 3 )) / 2;
                
            end
        end
    end
    
    % return the final image to GUI for display on screen
I_ret=Irgb;

end
