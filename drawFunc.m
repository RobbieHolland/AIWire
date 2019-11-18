function [im] = drawFunc(im, xx, yy, vals)
    xx = round(xx);
    yy = round(yy);
    for i = 1:size(xx, 2)
        if xx(i) < 1 || yy(i) < 1 || xx(i) > size(im, 1) ||  yy(i) > size(im, 2)
            continue
        end
        im(xx(i), yy(i)) = max(im(xx(i), yy(i)), vals(i));
    end
end