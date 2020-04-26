% This function is a prototype to manually generate datasets. 
% In order to change parameters and name of file or size of the data in
% this file, the user needs to manually change the values.

% This function is now outdated. We can use the GUI to automatially create
% datasets. 

tic
N = 1000;
im_size = [128 64];
dataset_X = zeros([N, im_size]);
dataset_y = zeros([N, im_size]);

addpath('util/')
sprintf('Generating the dataset...')
parfor i = 1:N
    [pts, spline_f] = gen_spline_realistic(im_size, 100, 0.75);
    [gt, im] = simulate(pts, im_size, 1.3, 4, 1.3, 10, 0, 1, 0);

    dataset_X(i, :, :) = im;
    dataset_y(i, :, :) = gt;
end
toc

sprintf('Saving the dataset...')
tic
dataset = [reshape(dataset_X, [1, size(dataset_X)]); reshape(dataset_y, [1, size(dataset_y)])];
size(dataset)
save('length_regression_dataset.mat','dataset');
toc