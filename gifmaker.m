% Load 2D+t matrix
im = load('../HASTE_GW_SAG_TR1200_S80_0012/HASTE_GW_SAG_TR1200_S80_0012.mat');
im = im.imageDicom.image;

% Crop image to wire (also crudely enhances visibility by removing high intensity anatomy)
im = im(:,60:130,:);

% Generate GIF from all 2D images over time
filename = 'cropped_gif.gif';
for idx = 1:203
    map=colormap(gray);
    A = uint8(im(:,:,idx));
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.04);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.04);
    end
end
