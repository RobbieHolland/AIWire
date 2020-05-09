function [new]= deform_ellipses(img)
dx = -1+2*rand(size(img)); 
dy = -1+2*rand(size(img)); 

sig=50; %smoothness
alpha=100; %how much it can move
H=fspecial('gauss',[7 7], sig); %smooth deformation field
fdx=imfilter(dx,H);
fdy=imfilter(dy,H);
fdx=alpha*fdx; %final def fields
fdy=alpha*fdy;

[y x]=ndgrid(1:size(img,1),1:size(img,2)); %get pixel indexes out
new = griddata(x-fdx,y-fdy,double(img),x,y);
new(isnan(new))=0;
imshow(new)
end

