function [im] = drawFunc(im, xx, yy, vals)
    xx = round(xx);
    yy = round(yy);
    for i = 1:size(xx, 2)
        im(xx(i), yy(i)) = vals(i);
    end
end