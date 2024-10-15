% BiSPL Lab 9

% Part 4
close all
pd = im2double(imread('S3_Q2_utils/pd.jpg'));
t1 = im2double(imread('S3_Q2_utils/t1.jpg'));
t2 = im2double(imread('S3_Q2_utils/t2.jpg'));

data = cat(3, pd(:, :, 1), t1(:, :, 1));
data = cat(3, data(:, :, :), t2(:, :, 1));

data = reshape(permute(data,[3 1 2]), 3, []);
number_of_clusters = 6;
[center, U] = fcm(data', number_of_clusters);

img = reshape(U, 6, size(pd, 1), size(pd, 2));

figure
for i=1:number_of_clusters
    subplot(2, 3, i)
    imshow(squeeze(img(i, :, :)))
end



