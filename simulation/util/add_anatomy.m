function [corrupted_image] = add_anatomy(image, im_size, opacity)%128, 64
if nargin == 2   % if the number of inputs equals 2
    opacity = 1; % then make the third value, z, equal to my default value, 5.
end

mask = zeros(im_size);
imshow(mask,[])
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
new = imgaussfilt(corrupted_image, 1,'FilterSize',7);  
corrupted_image = new+image;
            

% blur side patches
% leftthird = corrupted_image(40:105,1:ceil(im_size(2)/3));
% rightthird = corrupted_image(22:105,35: im_size(2));
% %     hl = fspecial('motion', 10,10);
% %     hr = fspecial('motion', 20,20);
% hr = fspecial('gaussian',10, 25);
% hl = fspecial('gaussian',10, 20);
% blurryLeft = imfilter(leftthird, hl);
% blurryRight = imfilter(rightthird, hr);
% corrupted_image(40:105,1:ceil(im_size(2)/3)) = blurryLeft;
% corrupted_image(22:105,35: im_size(2)) = blurryRight;

end