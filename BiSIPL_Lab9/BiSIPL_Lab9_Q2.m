% BiSPL Lab 9

% Part 2
close all
pd = im2double(imread('S3_Q2_utils/pd.jpg'));
t1 = im2double(imread('S3_Q2_utils/t1.jpg'));
t2 = im2double(imread('S3_Q2_utils/t2.jpg'));

data = cat(3, pd(:, :, 1), t1(:, :, 1));
data = cat(3, data(:, :, :), t2(:, :, 1));

data = reshape(permute(data,[3 1 2]), 3, []);
number_of_clusters = 6;
IDX = kmeans(data', number_of_clusters);

img = reshape(IDX, size(pd, 1), size(pd, 2));

figure
for i=1:number_of_clusters
    subplot(2, 3, i)
    ith_cluster = img;
    ith_cluster(img~=i)=0;
    imshow(ith_cluster/number_of_clusters)
end



