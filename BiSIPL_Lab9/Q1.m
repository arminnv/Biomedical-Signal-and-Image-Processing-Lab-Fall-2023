clc
clear

%% Q1

img = im2double(imread('S3_Q1_utils/thorax_t1.jpg'));
img = img(:,:,1);
Sample_lung = img;
Sample_liv = img;

%Lung Sample pixel
lung_x = [100, 175];
lung_y = [80, 80];
pixel_lung(1) = mean(img(lung_y(1)-2:lung_y(1)+2, lung_x(1)-2:lung_x(1)+2),'all'); %Intensity Right Lung
pixel_lung(2) = mean(img(lung_y(2)-2:lung_y(2)+2, lung_x(2)-2:lung_x(2)+2),'all'); %Intensity Left Lung

%Liver Sample pixel
liv_x = 80;
liv_y = 140;
pixel_liv = mean(img(liv_y-2:liv_y+2, liv_x-2:liv_x+2),'all'); %Intensity

Sample_lung(lung_y(1)-2:lung_y(1)+2, lung_x(1)-2:lung_x(1)+2) = 255;
Sample_lung(lung_y(2)-2:lung_y(2)+2, lung_x(2)-2:lung_x(2)+2) = 255;
Sample_liv(liv_y-2:liv_y+2, liv_x-2:liv_x+2) = 255;

figure('WindowState', 'maximized');
subplot(1,2,1);
imshow(Sample_lung);
title('Lung Sample');
subplot(1,2,2);
imshow(Sample_liv);
title('Liver Sample');
saveas(gcf, 'Sample.png');



% Range that covers both lungs
mask_lung = zeros(size(img,1));
mask_lung(lung_y(1), lung_x(1)) = 1; %Starting pixel Right Lung
mask_lung(lung_y(2), lung_x(2)) = 1; %Starting pixel Left Lung
while(1)
    mask_tmp = mask_lung;
    %Sweeping all the pixels in a fixed window around the starting pixel
    for i = -70:140
        for j = -70:140
            %Exploring the neighbours of a verified pixel
            if(mask_lung(lung_y(1)+i,lung_x(1)+j)== 1)
                for m = -1:1
                    for n = -1:1
                        if(mask_lung(lung_y(1)+i+m,lung_x(1)+j+n) == 0)
                            pixel = img(lung_y(1)+i+m,lung_x(1)+j+n);
                            if(abs(pixel-pixel_lung(1))<2*pixel_lung(1))
                                mask_lung(lung_y(1)+i+m,lung_x(1)+j+n) = 1;
                            else
                                mask_lung(lung_y(1)+i+m,lung_x(1)+j+n) = -1;
                            end
                        end
                    end
                end
            end
        end
    end
    %Checking for mask updates
    if((mask_tmp == mask_lung))
        break
    end
end

mask_liv = zeros(size(img,1));
mask_liv(liv_y, liv_x) = 1; %Starting pixel
while(1)
    mask_tmp = mask_liv;
    %Sweeping all the pixels in a fixed window around the starting pixel
    for i = -100:100
        for j = -70:140
            %Exploring the neighbours of a verified pixel
            if(mask_liv(liv_y+i,liv_x+j)== 1)
                for m = -1:1
                    for n = -1:1
                        if(mask_liv(liv_y+i+m,liv_x+j+n) == 0)
                            pixel = img(liv_y+i+m,liv_x+j+n);
                            if(abs(pixel-pixel_liv)<0.228*pixel_liv)
                                mask_liv(liv_y+i+m,liv_x+j+n) = 1;
                            else
                                mask_liv(liv_y+i+m,liv_x+j+n) = -1;
                            end
                        end
                    end
                end
            end
        end
    end
    %Checking for mask updates
    if((mask_tmp == mask_liv))
        break
    end
end

mask_liv(mask_liv == -1) = 0;
mask_lung(mask_lung == -1) = 0;
    
figure('WindowState', 'maximized');
subplot(1,2,1);
Overlay(img,mask_lung);
title('Lung: Region Growing');
subplot(1,2,2);
Overlay(img,mask_liv);
title('Liver : Region Growing');
saveas(gcf, 'Region Growing.png');