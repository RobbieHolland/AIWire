function [ground_truth, simulated] = simulate(pts, im_size, blur_filter, thickness, ...
    length_regression, verbose,sigma, tip_current, undersampling, undersampling_spread)%,  sizeanatomy,ratio)
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

if exist('tip_current','var')
    tip_current = (tip_current(2)-tip_current(1))*rand(1) + tip_current(1);
    fprintf('tip current is %f\n', tip_current)
    % Current standing wave (i.e. catheter tip looks dimmer)
    x = linspace(0, pi, size(pts, 2));
    standing_wave = (tip_current + sin(x)) / (1 + tip_current);
    z_grads = z_grads .* standing_wave;
    
end

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
simulated = gradient_map;

if exist("anatomy", "var")
    % Add anatomy / obscuring uncorrelated irrelevant objects that give signal
    ratio = 0.5; sizeanatomy = 1;
    gradient_map_anatomy = add_anatomy(gradient_map,ratio, sizeanatomy);
    %gradient_map_anatomy = gradient_map;   
end

% Apply 1/r filter
%gradient_map_conved = conv2(gradient_map_anatomy, blur_filter, 'same');
gradient_map_conved = conv2(gradient_map, blur_filter, 'same');
simulated = gradient_map_conved;
simulated = simulated / max(max(simulated));
% 

% Add complex noise
if exist('sigma','var')
    sigma = (sigma(2)-sigma(1))*rand(1) + sigma(1);
%     fprintf('sigma is %f\n', sigma)
    complex_guassian = normrnd(0, sigma, im_size) + 1i * normrnd(0, sigma, im_size);
    noised_gradient_map = simulated + abs(complex_guassian);
    simulated = noised_gradient_map;
end



% K-space artefacts
if exist('undersampling','var') && exist('undersampling_spread', 'var')
    undersampling = (undersampling(2)-undersampling(1))*rand(1) + undersampling(1);
%     fprintf('undersampling is %f\n', undersampling)
    undersampling_spread = (undersampling_spread(2)-undersampling_spread(1))*rand(1) + undersampling_spread(1);
%     fprintf('undersampling_spread is %f\n', undersampling_spread)
    
    k_space = itok(noised_gradient_map);
    U_dim = flip(size(k_space));
    U = sampling_VD(U_dim, undersampling, U_dim(2)/undersampling_spread)';
    simulated = abs(ktoi(U .* k_space));
    
        
end

% Max activation should be 1
ground_truth = ground_truth / max(max(ground_truth));
% simulated = simulated / max(max(simulated));
% simulated  = (simulated  - mean(simulated))./std(simulated);



if verbose

    % Show result of filtering + noise
    figure
    subplot(1,6,1)
    imshow(ground_truth, [])
    title({'Wire spline', '(ground truth)'})
    subplot(1,6,2)
    imshow(gradient_map, [])
    title({'Gradient (z component)', '& standing wave'})
    
    if exist("anatomy", "var")
    subplot(1,6,3)
    imshow(gradient_map_anatomy, [])
    title({'Anatomy'})
    end
    subplot(1,6,4)
    imshow(gradient_map_conved,[])
    title('Convolved with 1/r')
    
    if exist('sigma','var')
        subplot(1,6,5)
        imshow(noised_gradient_map,[])
        title('Complex gaussian noise')
    end
    
    if exist('undersampling','var') && exist('undersampling_spread', 'var')
        subplot(1,6,6)
        imshow(simulated,[])
        title({'Undersampling', '(training data)'})
    end
end
end