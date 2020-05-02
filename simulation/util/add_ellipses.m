function [corrupted_image] = add_ellipses(mask)%128, 64

right = annotation('ellipse',...
    [0.526490196078432 0.532455315145813 0.0623986928104575 0.230479774223893],...
    'Color',[1,1,1],'FaceColor',[1,1,1]);

left = annotation('ellipse',...
    [0.413906910336949 0.547156227501801 0.0452592804111935 0.158387329013679],...
    'Color',[1,1,1],'LineWidth',2,'FaceColor',[1,1,1]);
%save figure as stuct movie frame
F = getframe; %getframe changed the image size
RGB = frame2im(F); %convert to image data(uint8)
slice = im2double(RGB(:,:,1));%convert to double
corrupted_image = imresize(slice, size(mask)); %resize to original dimentions
end