%% Load image (to determine dimensions)
rng(1234)
%im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
%im = im.imageDicom.image;
im = zeros(256, 192, 203);

%% Simulate data
im_size = size(im(:,:,1));
[ground_truth, simulated] = simulate(1);
