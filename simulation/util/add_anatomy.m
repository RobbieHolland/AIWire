function [corrupted_image] = add_anatomy(image,ratio, sizeanatomy)%128, 64
%Inputs:
%image containing wire
%ratio [0.5,2] between width and height
%sizeanatomy [0,1]: at 1 the anatomy might occupy whole image, at 0 anatomy
%is absent

mask = zeros(size(image));
corrupted_image = add_ellipses(mask,ratio, sizeanatomy);

deformed = deform_ellipses(corrupted_image);
%new = imgaussfilt(deformed, 1,'FilterSize',7);  
corrupted_image = deformed+image;            
end