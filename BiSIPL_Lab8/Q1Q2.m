clc
clear

%% Q1

img = im2double(imread('S2_Q1_utils/t2.jpg'));
img = img(:,:,1);
y = size(img,1);
x = size(img,2);

%Adding a gaussian noise with specific mean and variance
noisy = imnoise(img,'gaussian',0 ,15/255);
noise_dft = fft2(noisy);

%Square Kernel
square = ones(4)/(4^2);
square = padarray(square, [(y-4)/2 (x-4)/2], 'both');
%Square filtering
sq_dft = fft2(square);
sq_filt = fftshift(abs(ifft2(noise_dft.*sq_dft)));

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('t2');
subplot(1,3,2);
imshow(noisy);
title('noisy');
subplot(1,3,3);
imshow(sq_filt);
title('Square Filter');
saveas(gcf, 'Square.png');

%Gaussian filter with specific std
gauss_filt = imgaussfilt(noisy,1);

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('t2');
subplot(1,3,2);
imshow(noisy);
title('noisy');
subplot(1,3,3);
imshow(gauss_filt);
title('Gaussian Filter');
saveas(gcf, 'Gaussian.png');

%% Q2

img = im2double(imread('S2_Q2_utils/t2.jpg'));
img = img(:,:,1);

%Gaussian filter with specific std
h = Gaussian(0.9, [size(img,1) size(img,1)]);
H = fft2(h);

%Blurred image
g = conv2(img,h,'same');
G = fft2(g);

f = fftshift(abs(ifft2(G./H)));

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('t2');
subplot(1,3,2);
imshow(g);
title('Blurred');
subplot(1,3,3);
imshow(f);
title('F = G/H std: 0.8');
saveas(gcf, 'G%H.png');

noisy = imnoise(g,'gaussian',0 ,0.001);
noise_dft = fft2(noisy);
f_noisy = fftshift(abs(ifft2(noise_dft./H)));

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('t2');
subplot(1,3,2);
imshow(noisy);
title('Blurred and Noisy');
subplot(1,3,3);
imshow(f_noisy/max(f_noisy(:)));
title('F = G/H std: 0.8');
saveas(gcf, 'G%H noise.png');