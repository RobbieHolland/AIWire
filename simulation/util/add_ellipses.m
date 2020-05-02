function [corrupted_image] = add_ellipses(mask)%128, 64
imshow(mask)
set(gca,'position',[0 0 1 1],'units','normalized')

%Generate random position, shape and size of ellipses
leftcenter = 0.35+rand(1,1)*(0.5-0.35);
leftx = 0.1+rand(1,1)*(0.4-0.1);%lower left
lefty = 0.1+rand(1,1)*(0.4-0.1);
leftw = 0+rand(1,1)*(leftcenter-leftx); %towards the middle
lefth = lefty+rand(1,1)*(1-lefty);

rightx = 0.65+rand(1,1)*(0.75-0.65); 
righty = 0+rand(1,1)*(0.4-0);
rightw = 0+rand(1,1)*(1-rightx);
righth = righty+rand(1,1)*(1-righty);

% set range for rand,avoid annotation, check deform ellipses call,
right = annotation('ellipse',...
    [rightx righty rightw righth],...
    'Color',[1,1,1],'FaceColor',[1,1,1]);

left = annotation('ellipse',...
    [leftx lefty leftw lefth],...
    'Color',[1,1,1],'LineWidth',2,'FaceColor',[1,1,1]);

%save figure as stuct movie frame
F = getframe; %getframe changed the image size
RGB = frame2im(F); %convert to image data(uint8)
slice = im2double(RGB(:,:,1));%convert to double
corrupted_image = imresize(slice, size(mask)); %resize to original dimentions
end