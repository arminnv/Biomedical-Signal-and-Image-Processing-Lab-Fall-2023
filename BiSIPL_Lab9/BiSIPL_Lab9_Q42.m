% BiSPL Lab 9

% Part 4
close all
pd = im2double(imread('S3_Q2_utils/pd.jpg'));
t1 = im2double(imread('S3_Q2_utils/t1.jpg'));
t2 = im2double(imread('S3_Q2_utils/t2.jpg'));

data = cat(3, pd(:, :, 1), t1(:, :, 1), t2(:, :, 1));
data = reshape(data, size(pd, 1)*size(pd, 2),3);

number_of_clusters = 6;
[center, U] = fcm(data, number_of_clusters);

%Assigning an id to the cluster with the highest u
u_max = max(U);
for i=1:size(data,1)
    idx(i) = find(U(:,i) == u_max(i));
end
img = reshape(idx, size(pd, 1), size(pd, 2));

figure('WindowState', 'maximized');
for i=1:number_of_clusters
    subplot(2, 3, i)
    ith_cluster = img;
    ith_cluster(img~=i) = 0;
    imshow(ith_cluster/i);
end
saveas(gcf, 'fcm.png');


