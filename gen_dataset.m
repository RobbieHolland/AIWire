tic
N = 5000;
im_size = [192 128];
dataset_X = zeros([N, im_size]);
dataset_y = zeros([N, im_size]);

sprintf('Generating the dataset...')
parfor i = 1:N
    [gt, im] = simulate(1.3, 1, 0);

    dataset_X(i, :, :) = im;
    dataset_y(i, :, :) = gt;
end
toc

sprintf('Saving the dataset...')
tic
dataset = [reshape(dataset_X, [1, size(dataset_X)]); reshape(dataset_y, [1, size(dataset_y)])];
size(dataset)
save('dataset.mat','dataset');
toc
