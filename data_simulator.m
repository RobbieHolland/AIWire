x = [0 1 2.5 3.6 5 7 8.1 10];
y = 5*sin(x);
xx = 0:.05:10;
yy = spline(x,y,xx);

figure
plot(xx(150:180),yy(150:180),'LineWidth',5);
set(gca,'visible','off')
set(gca,'xtick',[])

%saveas(gcf,'spline_img.png')

F = getframe(gcf);
[ImageX, Map] = frame2im(F);
thesize = size(ImageX);

figure 
colormap ('gray'); imagesc(mat2gray(ImageX(:,:,1))); 

ImageX_BW = mat2gray(ImageX(:,:,1)); 

for i = 1:size(ImageX_BW,1) 
    for j = 1:size(ImageX_BW,2) 
        if ImageX_BW(i,j) == 1 
           ImageX_BW(i,j) = 0;
        elseif ImageX_BW(i,j) == 0 
           ImageX_BW(i,j) = 1;
        else 
            ImageX_BW(i,j) = ImageX_BW(i,j); 
        end
    end
end

ImageX_BW_pad = padarray(ImageX_BW,500);

ImageX_BW_pad = imrotate(ImageX_BW_pad,-50); 

figure 
colormap ('gray'); imagesc(ImageX_BW_pad); 

roi = roipoly(); 
ImageX_BW_pad(roi) = 1; 

roi2 = roipoly(); 
ImageX_BW_pad(roi2) = 1; 

filt_image = imgaussfilt(ImageX_BW_pad,4);
noise_image = imnoise(filt_image,'gaussian');

figure 
colormap ('gray'); imagesc(noise_image); 

