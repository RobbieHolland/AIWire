function [im] = drawFuncRadius(im, xx, yy, vals, radius)
    for i = 1:size(im, 1)
       for j = 1:size(im, 2)
           closest_val = im(i, j);
           for ix = size(xx, 2):-1:1
               dist_sq = sum(([i, j] - [xx(ix), yy(ix)]).^2);
               if dist_sq < radius^2
                   closest_val = vals(ix);
                   break % Works for this data since vals is increasing
               end
           end
           im(i, j) = closest_val;
       end
    end
end