function [ground_truth, noised_gradient_map] = simulate(verbose)
    im = zeros(256, 192, 203);
    im_size = size(im(:,:,1));

    % Define spline
    [pts, spline_f] = gen_spline_realistic(im_size, 100);
    if verbose
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
    filter_dim = 500;
    scale = 0.5;
    center = [filter_dim/2, filter_dim/2];
    [col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
    filter_r = sqrt(scale ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2));
    filter_r(center(1), center(2)) = 1;

    gradient_map_conved = conv2(gradient_map, filter_r, 'same');
    
    % Add complex noise
    sigma = 1;
    complex_guassian = normrnd(0, sigma, im_size) + 1i * normrnd(0, sigma, im_size);
    noised_gradient_map = abs(gradient_map_conved + complex_guassian);
    
    if verbose
       % Show result of filtering + noise
        figure
        subplot(1,4,1)
        imshow(ground_truth, [])
        title({'Wire spline', '(ground truth)'})
        subplot(1,4,2)
        imshow(gradient_map, [])
        title('Gradient (z component)')
        subplot(1,4,3)
        imshow(gradient_map_conved,[])
        title('Convolved with 1/r')
        subplot(1,4,4)
        imshow(noised_gradient_map,[])
        title({'Complex gaussian noise', '(training data)'}) 
    end
end