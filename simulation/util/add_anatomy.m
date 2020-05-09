function [corrupted_image] = add_anatomy(image,ratio, sizeanatomy)%128, 64
%Inputs:
%image containing wire
%ratio [0.5,2] between width and height
%sizeanatomy [0,1]: at 1 the anatomy might occupy whole image, at 0 anatomy
%is absent

%Add ellipses on black mask
mask = zeros(size(image));
corrupted_image = add_ellipses(mask,ratio, sizeanatomy);

%Fill in with random noise
for i = 1:size(mask,1)
    for j= 1:size(mask,2)
        if corrupted_image(i,j) == 1
            corrupted_image(i,j) = rand;
        end
    end
end

%Add elastic transformation to ellipses
deformed = deform_ellipses(corrupted_image);
corrupted_image = deformed+image;            
end