%% Load image (to determine dimensions)
rng(1234)
%im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
%im = im.imageDicom.image;
im = zeros(256, 192, 203);

%% Simulated image
im_size = size(im(:,:,1));

% ----------- Define spline points (3D Version) -----------
pts = gen_spline();

grads = gradient(pts);
% Normalise gradient vectors
for i = 1:size(grads, 2)
    grads(:,i) = grads(:,i) / sqrt(sum(grads(:,i).^2));
end
z_grads = (1 + abs(grads(2,:))) / 2;

figure
subplot(1,2,1)
simulated = drawFunc(zeros(im_size), pts(2,:), pts(3,:), ones(size(pts(1,:))));
imshow(simulated,[])
title('Wire spline')

gradient_map = drawFunc(zeros(im_size), pts(2,:), pts(3,:), z_grads);
subplot(1,2,2)
imshow(gradient_map,[])
title('(1 + Gradient)/2 in vertical (z) direction')

% ----------- Define spline points (2D Version) -----------
% yy = ppval(spline_fn,xx); 
% g_yy = ppval(spline_dev,xx); 

% yy = yy + size_f(2) / 2;
% angle = atan(g_yy);
% [hor, vert] = pol2cart(angle, 1);

% g_yy = abs(atan(gradient(yy)));
% g_yy = max(g_yy) - g_yy;

% gradient_map = drawFunc(zeros(size(im(:,:,1))), xx, yy, g_yy);
% gradient_map = drawFunc(zeros(size(im(:,:,1))), xx, yy, (hor+1)/2);

%% Apply 1/r filter
filter_dim = 500;
scale = 0.5;
center = [filter_dim/2, filter_dim/2];
[col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
filter_r = sqrt(scale ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2));
filter_r(center(1), center(2)) = 1;

gradient_map_conved = conv2(gradient_map, filter_r, 'same');

% Add complex noise
sigma = 0.3;
complex_guassian = normrnd(0, sigma, im_size) + 1i * normrnd(0, sigma, im_size);
noised_gradient_map = gradient_map_conved + complex_guassian;

% Show result of filtering + noise
figure
subplot(1,4,1)
imshow(simulated, [])
title('Wire spline')
subplot(1,4,2)
imshow(gradient_map, [])
title('Gradient (z component)')
subplot(1,4,3)
imshow(gradient_map_conved,[])
title('Convolved with 1/r')
subplot(1,4,4)
imshow(noised_gradient_map,[])
title('Complex gaussian noise')