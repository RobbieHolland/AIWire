% Load image (to determine dimensions)
im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
im = im.imageDicom.image;

% Simulated image
simulated = zeros(size(im(:,:,1)));
size_f = size(simulated);

% Define spline points
point_spacing = 40;
x = 1:point_spacing:size_f(1);
y = randi([-30, 30], size(x)); 

% Interpolate and draw onto simulated image
xx = 1:0.2:size_f(1);
yy = spline(x,y,xx);

a = 'Mari&ambra'

yy = yy + size_f(2) / 2;
xx = round(xx);
yy = round(yy);
for i = 1:size(xx, 2)
    simulated(xx(i), yy(i)) = 1;
end

% Apply 1/r filter
filter_dim = 30;
center = [filter_dim/2, filter_dim/2];
[col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
filter = sqrt(1 ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2));
filter(center(1), center(2)) = 1;

simulated_conved = conv2(simulated, filter, 'same');

% TODO: Add noise

% Show result of filtering + noise
figure
subplot(1,2,1)
imshow(simulated, [])
title('Wire spline')
subplot(1,2,2)
imshow(simulated_conved,[])
title('Convolved with 1/r')
