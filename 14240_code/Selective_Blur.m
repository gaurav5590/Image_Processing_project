function I_ret=Selective_Blur(I_gray)

% Take a seed point as input from GUI
[m,n]=ginput(1);
m=ceil(m);
n=ceil(n);

% Convert grayscale image to double 
I_gray=im2double(I_gray);

% Apply Motion Blur 
H = fspecial('motion',40,65);
blurryImage = imfilter(I_gray,H,'replicate');


% Find gradient of the image
gradientImage = imgradient(I_gray);

% Binarize the gradient image
binaryImage = gradientImage > 0.6;
 % Fill the holes in the image
binarymask = imfill(binaryImage, 'holes');

% Connect all the connected Components to the seed point
oneBlob = bwselect(binarymask, round(m), round(n), 8);
oneBlobc=imcomplement(oneBlob);
maskedImage = I_gray; 

% Superimpose the mask
maskedImage(oneBlobc) = blurryImage(oneBlobc); 
% Sharpen the image
maskedImage=imsharpen(maskedImage);

I_ret=maskedImage;

end


