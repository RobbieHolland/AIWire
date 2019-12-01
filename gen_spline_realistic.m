function [pts, spline_f] = gen_spline_realistic(im_size, depth)
    % Generate unlooped spline points 
    ln = 0.25:0.125:1;
    deviation = floor(im_size(2) * 0.05);
    y = im_size(2)/2 + cumsum(randi([-deviation, deviation], size(ln)));
    xyz = [ln * depth; ln * im_size(1); y];
    
    % Add the loop
    a = randi(size(xyz, 2));
    b = a + floor(size(xyz, 2) / 5);
    ab = [a b] - max(0, b - size(xyz, 2));
    f1 = xyz(:,1:ab(1));
    f2 = xyz(:,ab(1):ab(2));
    f3 = xyz(:,ab(2):end);
    xyz_looped = [f1, f2, fliplr(f2) + [0 0 20]', f3];
    
    % Generate 'continuous' spline
    spline_f = cscvn(xyz_looped);
    pts = fnplt_(spline_f,'r',2);
end