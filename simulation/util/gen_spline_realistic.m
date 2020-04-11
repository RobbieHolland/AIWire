function [pts, spline_f] = gen_spline_realistic(im_size, depth, loop_prob)
    % Generate unlooped spline points 
    n_points = 8;
    loop_width = randi([10, 20]);
    wire_height = 0.125 + rand() * (0.375 - 0.125);
    ln = linspace(1, wire_height, n_points);
    deviation = floor(im_size(2) * 0.8 / n_points);
    y = im_size(2)/2 + wobbly_line(size(ln), deviation) - loop_width/2;
    xzy = [ln * depth; ln * im_size(1); y];
    
    % Add the loop with probability
    if rand() < loop_prob
        loop_height_proportion = 0.15 + rand() * (0.25 - 0.15);
        a = randi(floor(0.7 * size(xzy, 2)));
        b = a + floor(loop_height_proportion * size(xzy, 2));
        ab = [a b] - max(0, b - size(xzy, 2));
        f1 = xzy(:,1:ab(1));
        f2 = xzy(:,ab(1):ab(2));
        f3 = xzy(:,ab(2):end);
        loop = fliplr(f2);
        loop(3,:) = loop(3,1) + wobbly_line([size(loop, 2), 1], deviation / 2) + loop_width;

        xzy = [f1, f2, loop, f3];
    end
    
    % Generate 'continuous' spline
    spline_f = cscvn(xzy);
    pts = fnplt_(spline_f,500,'r',2);
end

function [line] = wobbly_line(sz, deviation)
    line = cumsum(randi([-deviation, deviation], sz));
end