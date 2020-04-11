function [points,t] = fnplt_(f, npoints, varargin) 
%FNPLT Plot a function. 
% 
%   FNPLT(F)  plots the function in F on its basic interval. 
% 
%   FNPLT(F,SYMBOL,INTERV,LINEWIDTH,JUMPS) plots the function F 
%   on the specified INTERV = [a,b] (default is the basic interval),  
%   using the specified plotting SYMBOL (default is '-'),  
%   and the specified LINEWIDTH (default is 1),  
%   and using NaNs in order to show any jumps as actual jumps only  
%   in case JUMPS is a string beginning with 'j'. 
% 
%   The four optional arguments may appear in any order, with INTERV 
%   the one of size [1 2], SYMBOL and JUMPS strings, and LINEWIDTH the 
%   scalar. Any empty optional argument is ignored. 
% 
%   If the function in F is 2-vector-valued, the planar curve is 
%   plotted.  If the function in F is d-vector-valued with d>2, the 
%   space curve given by the first three components of F is plotted. 
% 
%   If the function is multivariate, it is plotted as a bivariate function, 
%   at the midpoint of its basic intervals in additional variables, if any. 
% 
%   POINTS = FNPLT(F,...)   does not plot, but returns instead the sequence  
%   of 2D-points or 3D-points it would have plotted. 
% 
%   [POINTS,T] = FNPLT(F,...)  also returns, for a vector-valued F, the  
%   corresponding vector T of parameter values. 
% 
%   Example: 
%      x=linspace(0,2*pi,21); f = spapi(4,x,sin(x)); 
%      fnplt(f,'r',3,[1 3]) 
% 
%   plots the graph of the function in f, restricted to the interval [1 .. 3], 
%   in red, with linewidth 3 . 
 
%   Copyright 1987-2003 C. de Boor and The MathWorks, Inc. 
%   $Revision: 1.22 $ 
 
% interpret the input: 
symbol=''; interv=[]; linewidth=[]; jumps=0; 

for j=3:nargin 
   arg = varargin{j-2};
   if ~isempty(arg) 
      if ischar(arg) 
         if arg(1)=='j', jumps = 1; 
         else, symbol = arg; 
         end 
      else 
         [ignore,d] = size(arg); 
         if ignore~=1 
	    error('SPLINES:FNPLT:wrongarg',['arg',num2str(j),' is incorrect.']), end 
         if d==1 
            linewidth = arg; 
         else 
            interv = arg; 
         end 
      end 
   end 
end 

if ~strcmp(f.form([1 2]),'pp') 
  givenform = f.form; f = fn2fm(f,'pp'); basicint = ppbrk(f,'interval'); 
end 

if ~isempty(interv), f = ppbrk(f,interv); end 

[breaks,coefs,l,k,d] = ppbrk(f); 

% we are dealing with a univariate spline 
x = [breaks(2:l) linspace(breaks(1),breaks(l+1),npoints)]; 
v = ppual(f,x);  

if l>1 % make sure of proper treatment at jumps if so required 
 if jumps 
    tx = breaks(2:l); temp = repmat(NaN, d,l-1); 
 else 
    tx = []; temp = zeros(d,0); 
 end 
 x = [breaks(2:l) tx x];  
 v = [ppual(f,breaks(2:l),'left') temp v]; 
end 
[x,inx] = sort(x); v = v(:,inx); 
    
%  use the plotting info, to plot or else to output:

if d==1, points = [x;v]; 
  else, t = x; points = v([1:min([d,3])],:); 
end 
end 
