tic
N = 2000;
im_size = [128 64];
dataset_X = zeros([N, im_size]);
dataset_y = zeros([N, im_size]);

sprintf('Generating the dataset...')
parfor i = 1:N
    [gt, im] = simulate([128 64], 1.3, 1, 1.5, 10, 0, 0);

    dataset_X(i, :, :) = im;
    dataset_y(i, :, :) = gt;
end
toc

sprintf('Saving the dataset...')
tic
dataset = [reshape(dataset_X, [1, size(dataset_X)]); reshape(dataset_y, [1, size(dataset_y)])];
size(dataset)
save('iteration_1_dataset.mat','dataset');
toc
