function [corrupted_image] = add_anatomy(image, im_size, opacity)%128, 64
if nargin == 2   % if the number of inputs equals 2
    opacity = 1; % then make the third value, z, equal to my default value, 5.
end
% Add anatomy to image here
imshow(image)
%Create coils on top of figure
right = annotation('ellipse',...
    [0.526490196078432 0.532455315145813 0.0623986928104575 0.230479774223893],...
    'Color',[0.90,0.90,0.90],'FaceColor',[0.90*opacity,0.90*opacity,0.90*opacity]);
left = annotation('ellipse',...
    [0.413906910336949 0.547156227501801 0.0452592804111935 0.158387329013679],...
    'Color',[0.65,0.65,0.65],'LineWidth',2,'FaceColor',[0.65*opacity,0.65*opacity,0.65*opacity]);

%save figure as stuct movie frame
F = getframe;
RGB = frame2im(F); %convert to image data(uint8)
corrupted_image = im2double(RGB(:,:,1));%convert to double

% blur side patches
leftthird = corrupted_image(40:105,1:ceil(im_size(2)/3));
rightthird = corrupted_image(22:105,35: im_size(2));
%     hl = fspecial('motion', 10,10);
%     hr = fspecial('motion', 20,20);
hr = fspecial('gaussian',10, 25);
hl = fspecial('gaussian',10, 20);
blurryLeft = imfilter(leftthird, hl);
blurryRight = imfilter(rightthird, hr);
corrupted_image(40:105,1:ceil(im_size(2)/3)) = blurryLeft;
corrupted_image(22:105,35: im_size(2)) = blurryRight;
%imshow(corrupted_image)

close %close imshow



end