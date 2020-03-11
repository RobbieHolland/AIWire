function [corrupted_image] = add_anatomy(image, im_size)%128, 64
    % Add anatomy to image here
    imshow(image)
    %Create coils on top of figure
    left = annotation('rectangle',...
    [0.413906910336949 0.547156227501801 0.0452592804111935 0.158387329013679],...
    'Color',[0.65,0.65,0.65]); % smaller, darker, thinner 
    right = annotation('rectangle',...
    [0.52751528627015 0.525827814569536 0.0494719288493608 0.232450331125828],...
    'Color',[0.90,0.90,0.90],'LineWidth',2);
    %save figure as stuct movie frame
    F = getframe;
    RGB = frame2im(F); %convert to image data(uint8)
    corrupted_image = im2double(RGB(:,:,1));%convert to double
    
    
    % blur side patches
    leftthird = corrupted_image(:,1:ceil(im_size(2)/3)); 
    rightthird = corrupted_image(:,42: im_size(2));
    hl = fspecial('motion', 10,10);
    hr = fspecial('motion', 20,20);
    blurryLeft = imfilter(leftthird, hl);
    blurryRight = imfilter(rightthird, hr);
    corrupted_image(:, 1:17) = blurryLeft(:, 1:17);
    corrupted_image(:, 42:im_size(2)) = blurryRight;
    %imshow(corrupted_image)

    close %close imshow
    
    
    
end