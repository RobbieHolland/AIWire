function [ground_truth, undersampled_noised_gradient_map] = simulate(pts, im_size, blur, thickness, ...
    undersampling, undersampling_spread, tip_current, length_regression, verbose)
% simulate Simulate MRI acquisition of randomised catheter
%   im_size:                Size of output image
%   blur:                   Spread of signal around wire i.e. (1/r)^blur
%   thickness:              Thickness of ground truth catheter
%   undersampling:          Degree of k-space undersampling
%   undersampling_spread:   Spread of acquired lines in k-space about
%                           center (k_x, k_y = 0)
%   tip_current:            Fraction of current in tip compared to middle of wire
%   verbose:                Debug mode

grads = gradient(pts);

% Normalise gradient vectors
for i = 1:size(grads, 2)
    grads(:,i) = grads(:,i) / sqrt(sum(grads(:,i).^2));
end
z_grads = (1 + abs(grads(2,:))) / 2;

% Current standing wave (i.e. catheter tip looks dimmer)
x = linspace(0, pi, size(pts, 2));
standing_wave = (tip_current + sin(x)) / (1 + tip_current);
z_grads = z_grads .* standing_wave;

% Length regression
if length_regression
    gt_vals = 0.3 + 0.7 * (x / max(x));
else
    gt_vals = ones(size(pts(1,:)));
end

% Plot onto 2D image
if thickness == 1
    ground_truth = drawFunc(zeros(im_size), pts(2,:), pts(3,:), gt_vals);
else
    ground_truth = drawFuncRadius(zeros(im_size), pts(2,:), pts(3,:), gt_vals, thickness / 2);
end
gradient_map = drawFunc(zeros(im_size), pts(2,:), pts(3,:), z_grads);

% Add anatomy / obscuring uncorrelated irrelevant objects that give signal
%gradient_map_anatomy = add_anatomy(gradient_map);
gradient_map_anatomy = gradient_map;
% Apply 1/r filter
filter_dim = 250;
center = [filter_dim/2, filter_dim/2];
[col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
filter_r = sqrt((1 ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2)).^blur);
filter_r(center(1), center(2)) = 1;
filter_r = filter_r / sum(filter_r, 'all');

gradient_map_conved = conv2(gradient_map_anatomy, filter_r, 'same');

% Add complex noise
sigma = 0.001;
complex_guassian = normrnd(0, sigma, im_size) + 1i * normrnd(0, sigma, im_size);
noised_gradient_map = abs(gradient_map_conved + complex_guassian);

% K-space artefacts
k_space = itok(noised_gradient_map);
U_dim = flip(size(k_space));
U = sampling_VD(U_dim, undersampling, U_dim(2)/undersampling_spread)';
undersampled_noised_gradient_map = abs(ktoi(U .* k_space));

% Ground-truth line thickness
% thick_ground_truth = double(conv2(ground_truth, ones(thickness), "same"));

% Max activation should be 1
ground_truth = ground_truth / max(max(ground_truth));
undersampled_noised_gradient_map = undersampled_noised_gradient_map / max(max(undersampled_noised_gradient_map));

if verbose
   % Show result of filtering + noise
    figure
    subplot(1,6,1)
    imshow(ground_truth, [])
    title({'Wire spline', '(ground truth)'})
    subplot(1,6,2)
    imshow(gradient_map, [])
    title({'Gradient (z component)', '& standing wave'})
    subplot(1,6,3)
    imshow(gradient_map_anatomy, [])
    title({'Anatomy'})
    subplot(1,6,4)
    imshow(gradient_map_conved,[])
    title('Convolved with 1/r')
    subplot(1,6,5)
    imshow(noised_gradient_map,[])
    title('Complex gaussian noise') 
    subplot(1,6,6)
    imshow(undersampled_noised_gradient_map,[])
    title({'Undersampling', '(training data)'}) 
end
end