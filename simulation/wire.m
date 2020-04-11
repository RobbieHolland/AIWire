%% Load image (to determine dimensions)
addpath('./exportfig/')
pwd
rng(1234)
%im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
%im = im.imageDicom.image;
im = zeros(128, 16, 203);

%% Simulate data
addpath('util/')

im_size = size(im(:,:,1));
[pts, spline_f] = gen_spline_realistic([128 64], 100, 0.75);

[ground_truth, simulated] = simulate(pts, [128 64], 1.3, 1, 1.3, 10, 0.2, 0, 0);
imshow(ground_truth,[])
figure;
imshow(simulated,[])

%% Plot many examples
figure
n = 10;

test = [];
train = [];

tic
for i = 1:n
    [pts, spline_f] = gen_spline_realistic([128 64], 100, 0.75);
    [ground_truth, noised_gradient_map] = simulate(pts, [128 64], 1.3, 1, 1.3, 10, 0, 0, 0);
    
    test = horzcat(test, ground_truth);
    train = horzcat(train, noised_gradient_map);
end
toc

subplot(2,1,1)
imshow(test, [])
title({'Wire spline', '(ground truth)'})

subplot(2,1,2)
imshow(train, [])
title({'Complex gaussian noise', '(training data)'})

% save_figure('dataset')
