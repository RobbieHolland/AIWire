% This function is a prototype to manually generate datasets. 
% In order to change parameters and name of file or size of the data in
% this file, the user needs to manually change the values.

% This function is now outdated. We can use the GUI to automatially create
% datasets. 

tic
N = 500;
n_spline_samples = 500;
im_size = [256 192];
dataset_X = zeros([N, im_size]);
dataset_y = zeros([N, im_size]);
spline_pts = zeros([N, n_spline_samples, 2]);
%sizeanatomy = 1; ratio = 0.5;

addpath('util/')
sprintf('Generating the dataset...')
blur_filter = gen_blur_filter(250, 1.3);

parfor i = 1:N
    [pts, spline_f] = gen_spline_realistic(im_size, 100, 0.75);
    [gt, im] = simulate(pts, im_size, blur_filter,1,0,1,...
    [0.0 0.3], [0.0 1.0], [0.7 2.0], [6 20], [0 1], [0.6 1.0]);
    
    dataset_X(i, :, :) = im;
    dataset_y(i, :, :) = gt;
    spline_pts(i, :, :) = [pts(2,:); pts(3,:)]'
end
toc

sprintf('Saving the dataset...')
tic
dataset = [reshape(dataset_X, [1, size(dataset_X)]); reshape(dataset_y, [1, size(dataset_y)])];
size(dataset)
save('dataset_all_1.mat', 'dataset', 'spline_pts');
toc
