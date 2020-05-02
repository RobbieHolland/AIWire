function [filter_r] = gen_blur_filter(filter_dim, blur)
    center = [filter_dim/2, filter_dim/2];
    [col_index, row_index] = ndgrid(1:filter_dim, 1:filter_dim);
    filter_r = sqrt((1 ./ ((row_index - center(1)).^2 + (col_index - center(2)).^2)).^blur);
    filter_r(center(1), center(2)) = 1;
    filter_r = filter_r / sum(filter_r, 'all');
end