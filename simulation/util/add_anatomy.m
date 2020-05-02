function [corrupted_image] = add_anatomy(image, opacity)%128, 64
if nargin == 1   % if the number of inputs equals 2
    opacity = 1; % then make the third value, z, equal to my default value, 5.
end

im_size = size(image);
mask = zeros(im_size);
corrupted_image = add_ellipses(mask);

% Assign random values to patches
for i = 1:im_size(1)
    for j = 1:im_size(2)
        % binarise image first
        if corrupted_image(i,j) < 0.99 
           corrupted_image(i,j) = 0;
        else
           corrupted_image(i,j) = 1;
        end
        % assign value where true
        if corrupted_image(i,j) == 1
           corrupted_image(i,j) = rand()*opacity;
        else
            continue
        end
    end
end
deformed = deform_ellipses(corrupted_image);
%new = imgaussfilt(deformed, 1,'FilterSize',7);  
corrupted_image = deformed+image;            
end