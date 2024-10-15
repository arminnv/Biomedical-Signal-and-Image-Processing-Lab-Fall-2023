clc
clear

%% Q1

img = imread('S1_Q1_utils/t1.jpg');
img = img(:,:,1);

figure('WindowState', 'maximized');
imshow(img);
saveas(gcf, 'imshow.png');

%FFT of 128th row
dft = fft(img(128,:));

figure('WindowState', 'maximized');
subplot(2,1,1);
plot(abs(dft));
xlim([0 257]);
title('1D Fourier: Row 128');
xlabel('Frequency');
ylabel('Amplitude');

subplot(2,1,2);
plot(angle(dft));
xlim([0 257]);
title('1D Fourier: Row 128');
xlabel('Frequency');
ylabel('Phase');
saveas(gcf, '128.png');


%2D Fourier
img = im2double(img);
dft = log(abs(fft2(img)));
shft = fftshift(dft); %Shifts Fourier to center(0);

%Transform to Greyscale
dft = dft/max(dft(:));
shft = shft/max(shft(:));

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('t1');
subplot(1,3,2);
imshow(dft);
title('fft2');
subplot(1,3,3);
imshow(shft);
title('Shifted fft2');
saveas(gcf, 'fft2.png');

%% Q2

range = -127.5:127.5;
[x, y] = ndgrid(range , range);

%Circle
r = 15;
G = zeros(256);
G(x.^2 + y.^2 <= r^2) = 1;
G_dft = fft2(G);
%Two Element
F = zeros(256);
F(100,50) = 1;
F(120,48) = 2;
F_dft = fft2(F);
F = F/max(F(:));

%Convolution
Conv = fftshift(abs(ifft2(F_dft.*G_dft)));
%Scaling the Colors for Proper Plotting
Conv = Conv/max(Conv(:)); 

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(G);
title('G');
subplot(1,3,2);
imshow(F);
title('F');
subplot(1,3,3);
imshow(Conv);
title('Conv');
saveas(gcf, 'G.F.png');

%pd.jpg
img = im2double(imread('S1_Q2_utils/pd.jpg'));
img = img(:,:,1);
dft = fft2(img);
Conv = fftshift(abs(ifft2(G_dft.*dft)));
Conv = Conv/max(Conv(:)); 

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(img);
title('pd');
subplot(1,3,2);
imshow(G);
title('G');
subplot(1,3,3);
imshow(Conv);
title('Conv');
saveas(gcf, 'G.pd.png');

%% Q3

img = im2double(imread('S1_Q3_utils/ct.jpg'));
img = img(:,:,1);
y = size(img,1);
x = size(img,2);

zoom_scale = 0.75; %Percentage
pad_y = y*(1-zoom_scale)/zoom_scale;
pad_x = x*(1-zoom_scale)/zoom_scale;

%Zero Padding in Frequency Domain = 
% = Sinc Interpolation in Spatial Domain
dft = fftshift(fft2(img));
dft_zoom = padarray(dft, [floor(pad_y/2) floor(pad_x/2)], 'both');
zoom = abs(ifft2(ifftshift(dft_zoom)));
zoom = zoom/max(zoom(:));
zoom = zoom(floor(pad_y/2)+(1:y),floor(pad_x/2)+(1:x),:);

figure('WindowState', 'maximized');
subplot(1,2,1);
imshow(img);
title('ct');
subplot(1,2,2);
imshow(zoom);
title('Zoomed');
saveas(gcf, 'Zoom.png');

%% Q4-1

img = im2double(imread('S1_Q4_utils/ct.jpg'));
img = img(:,:,1);
y = size(img,1);
x = size(img,2);

%Shifting Kernels
shift_y(1:y) = exp((1:y)*2*pi*1i*(-40)/y);
shift_x(1:x) = exp((1:x)*2*pi*1i*(-20)/x);
[Ker_y, Ker_x] = ndgrid(shift_y, shift_x);

dft = fft2(img);
Ker = Ker_y.*Ker_x;
dft_shift = dft.*Ker;
Shift = abs(ifft2(dft_shift));

figure('WindowState', 'maximized');
subplot(1,2,1);
imshow(img);
title('ct');
subplot(1,2,2);
imshow(Shift);
title('Shifted');
saveas(gcf, 'Shift.png');

figure('WindowState', 'maximized');
subplot(1,2,1);
imshow(abs(Ker));
title('Shift Kernel: Amplitude');
subplot(1,2,2);
imshow(angle(Ker));
title('Shift Kernel: Phase');
saveas(gcf, 'Shift_Ker.png');

%% Q4-2
%Rotation
img = im2double(imread('S1_Q4_utils/ct.jpg'));
img = img(:,:,1);
Rot = imrotate(img,30,'bilinear');
dft_Rot = fft2(Rot);
dft = fft2(ifftshift(img));

figure('WindowState', 'maximized');
subplot(2,2,1);
imshow(img);
title('ct');
subplot(2,2,2);
imshow(Rot);
title('Rotated');
subplot(2,2,3);
imshow(abs(dft));
title('ct: Fourier');
subplot(2,2,4);
imshow(abs(dft_Rot));
title('Rotated: Fourier');
saveas(gcf, 'Rotation.png');


dft_Manual = imrotate(fftshift(dft),30,'bilinear');
Manual = fftshift(abs(ifft2((dft_Manual))));

figure('WindowState', 'maximized');
subplot(1,2,1);
imshow(img);
title('ct');
subplot(1,2,2);
imshow(Manual/max(Manual(:)));
title('Rotated in Fourier');
saveas(gcf, 'Manual Rotation.png');

%% Q5

img = im2double(imread('S1_Q5_utils/t1.jpg'));
img = img(:,:,1);

%Alongside y
fwd_y = diff([img; img(end,:)], 1, 1);
bck_y = diff([img(end,:); img], 1, 1);
cent_y = (fwd_y + bck_y)/2;

%Alongside x
fwd_x = diff([img, img(:,end)], 1, 2);
bck_x = diff([img(:,end), img], 1, 2);
cent_x = (fwd_x + bck_x)/2;

%Gradiant
grad = sqrt(cent_y.^2 + cent_x.^2);

figure('WindowState', 'maximized');
subplot(1,4,1);
imshow(img);
title('t1');
subplot(1,4,2);
imshow(cent_x/max(cent_x(:)));
title('Horizontal diff');
subplot(1,4,3);
imshow(cent_y/max(cent_y(:)));
title('Vertical diff');
subplot(1,4,4);
imshow(grad/max(grad(:)));
title('Gradiant');
saveas(gcf, 'Diff.png');

%% Q6

img = im2double(imread('S1_Q5_utils/t1.jpg'));
img = img(:,:,1);
figure('WindowState', 'maximized');

%Sobel
subplot(1,2,1);
imshow(edge(img,'Sobel'))
title('Sobel Edges')

%Canny
subplot(1,2,2);
imshow(edge(img,'Sobel'))
title('Canny Edges')
saveas(gcf, 'Edges.png');