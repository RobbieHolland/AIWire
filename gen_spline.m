% Arbitrary spine generation function (can modify to be random + realistic)
function [pts] = gen_spline()
    npts = 13;
    t = linspace(0,8*pi,npts);
    z = linspace(-1,1,npts);
    xyz = 100*(1 + [cos(t); sin(t); z]);
    
    xyz = [xyz xyz(:,1) * 1];
    spline_f = cscvn(xyz);
    pts = fnplt_(spline_f,'r',2) + 10;
end