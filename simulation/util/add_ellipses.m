function [corrupted_image] = add_ellipses(mask,ratio, sizeanatomy)%128, 64

[columnsInImage rowsInImage] = meshgrid(1:size(mask,2), 1:size(mask,1));

%for left ellipse
centerX = 0.01*size(mask,2)+rand(1,1)*(0.25-0.01)*size(mask,2);
centerY = 0.25*size(mask,1)+rand(1,1)*(0.75-0.25)*size(mask,1);
radiusX = ratio*(sizeanatomy*size(mask,2)/4); 
radiusY = 1/ratio*(sizeanatomy*size(mask,1)/4);
ellipseLeft = (rowsInImage - centerY).^2 ./ radiusY^2 ...
+ (columnsInImage - centerX).^2 ./ radiusX^2 <= 1;

%for right ellipse
centerX = 0.75*size(mask,2)+rand(1,1)*(0.99-0.75)*size(mask,2);
centerY = 0.25*size(mask,1)+rand(1,1)*(0.75-0.25)*size(mask,1);
ellipseRight = (rowsInImage - centerY).^2 ./ radiusY^2 ...
+ (columnsInImage - centerX).^2 ./ radiusX^2 <= 1;

%add both ellipses together
corrupted_image = ellipseLeft+ellipseRight;
end