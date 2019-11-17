%% Load image (to determine dimensions)
rng(1234)
im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
im = im.imageDicom.image;

%% Simulated image
simulated = zeros(size(im(:,:,1)));
size_f = size(simulated);

% Define spline points
point_spacing = 40;
x = 1:point_spacing:size_f(1);
y = randi([-40, 40], size(x)); 

% Interpolate and draw onto simulated image
xx = 1:0.2:size_f(1);
spline_fn = spline(x,y);
spline_dev= fnder(spline_fn,1);

yy = ppval(spline_fn,xx); 
g_yy = ppval(spline_dev,xx); 

yy = yy + size_f(2) / 2;

% g_yy = abs(atan(gradient(yy)));
% g_yy = max(g_yy) - g_yy;
s = size(g_yy);

simulated = drawFunc(simulated, xx, yy, ones(size(yy)));
gradient_map = drawFunc(zeros(size(im(:,:,1))), xx, yy, g_yy);
figure
imshow(gradient_map, [])


%% Apply 1/r filter
filter_dim = 50;
center = [filter_dim/2, filter_dim/2];
[col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
filter = sqrt(1 ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2));
filter(center(1), center(2)) = 1;

gradient_map_conved = conv2(gradient_map, fspecial('gaussian'), 'same');

% TODO: Add noise

% Show result of filtering + noise
figure
subplot(1,2,1)
imshow(gradient_map, [])
title('Wire spline')
subplot(1,2,2)
imshow(gradient_map_conved,[])
title('Convolved with 1/r')

% Left->Right gradient
filter = fspecial('prewitt');
grads = conv2(simulated, filter, 'same');
figure
imshow(grads,[])