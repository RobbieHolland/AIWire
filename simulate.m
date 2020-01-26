function [thick_ground_truth, undersampled_noised_gradient_map] = simulate(blur, thickness, verbose)
    addpath('util/')

%     im = zeros(256, 192, 203);
%     im_size = size(im(:,:,1));
    im_size = [192 128];

    % Define spline
    [pts, spline_f] = gen_spline_realistic(im_size, 100);
    if verbose
       figure
       fnplt(spline_f) 
    end
    grads = gradient(pts);

    % Normalise gradient vectors
    for i = 1:size(grads, 2)
        grads(:,i) = grads(:,i) / sqrt(sum(grads(:,i).^2));
    end
    z_grads = (1 + abs(grads(2,:))) / 2;

    ground_truth = drawFunc(zeros(im_size), pts(2,:), pts(3,:), ones(size(pts(1,:))));
    gradient_map = drawFunc(zeros(im_size), pts(2,:), pts(3,:), z_grads);
    
    % Apply 1/r filter
    filter_dim = 250;
    center = [filter_dim/2, filter_dim/2];
    [col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
    filter_r = sqrt((1 ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2)).^blur);
    filter_r(center(1), center(2)) = 1;
    filter_r = filter_r / sum(filter_r, 'all');

    gradient_map_conved = conv2(gradient_map, filter_r, 'same');
    
    % Add complex noise
    sigma = 0.003;
    complex_guassian = normrnd(0, sigma, im_size) + 1i * normrnd(0, sigma, im_size);
    noised_gradient_map = abs(gradient_map_conved + complex_guassian);

    % K-space artefacts
    k_space = itok(noised_gradient_map);
    U = sampling_VD(flip(size(k_space)), 3)';
    undersampled_noised_gradient_map = abs(ktoi(U .* k_space));

    % Ground-truth line thickness
    thick_ground_truth = conv2(ground_truth, ones(thickness), "same")>0;

    if verbose
       % Show result of filtering + noise
        figure
        subplot(1,5,1)
        imshow(ground_truth, [])
        title({'Wire spline', '(ground truth)'})
        subplot(1,5,2)
        imshow(gradient_map, [])
        title('Gradient (z component)')
        subplot(1,5,3)
        imshow(gradient_map_conved,[])
        title('Convolved with 1/r')
        subplot(1,5,4)
        imshow(noised_gradient_map,[])
        title('Complex gaussian noise') 
        subplot(1,5,5)
        imshow(undersampled_noised_gradient_map,[])
        title({'Undersampling', '(training data)'}) 
    end
end