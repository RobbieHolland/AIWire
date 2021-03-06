%% Load image (to determine dimensions)
addpath('./exportfig/')
pwd
rng(1234)
%im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
%im = im.imageDicom.image;
im = zeros(128, 16, 203);

%% Simulate data
addpath('util/')
rng(1234)

im_size = [256 192];
[pts, spline_f] = gen_spline_realistic(im_size, 100, 0.75);
blur_filter = gen_blur_filter(250, 1.3);
% [ground_truth, simulated] = simulate(pts, im_size, blur_filter, 1, 1.3, 10, 0.2, 0, 0);

% [ground_truth, simulated] = simulate(pts, im_size, blur_filter,1,0,1,...
%     [0.0 1.0],[0.001 0.005], [1.3, 1.3], [0,10]);
[ground_truth, simulated] = simulate(pts, im_size, blur_filter,1,0,1,...
    [0.1 0.1], [0.2 0.2], [0.6 0.6], [0.8 0.8], [0.4 0.4], [1 1]);
%simulate(pts, im_size, blur_filter, thickness, length_regression,verbose, 
% sigma, tip_current, undersampling, undersampling_spread, anatomy)
figure;
imshow(ground_truth,[])
figure;
imshow(simulated,[])

save_figure('example')

%% Plot many examples
figure
n = 10;
im_size = [512 256];

test = [];
train = [];

tic
blur_filter = gen_blur_filter(250, 1.3);
for i = 1:n
    [pts, spline_f] = gen_spline_realistic(im_size, 100, 0.75, 500);
    [ground_truth, simulated] = simulate(pts, im_size, blur_filter,1,0,0,...
    [0.0 0.3]);
%     [ground_truth, noised_gradient_map] = simulate(pts, im_size, blur_filter, 1, 1.3, 10, 0, 0, 0);
    
    test = horzcat(test, ground_truth);
    train = horzcat(train, simulated);
end
toc

subplot(2,1,1)
imshow(test, [])
title({'Wire spline', '(ground truth)'})

subplot(2,1,2)
imshow(train, [])
title({'Complex gaussian noise', '(training data)'})

% save_figure('dataset')
