% BiSPL Lab 9

% Part 2
pd = im2double(imread('S3_Q2_utils/pd.jpg'));
t1 = im2double(imread('S3_Q2_utils/t1.jpg'));
t2 = im2double(imread('S3_Q2_utils/t2.jpg'));

data = cat(3, pd(:, :, 1), t1(:, :, 1), t2(:, :, 1));
data = reshape(data, size(pd, 1)*size(pd, 2),3);

number_of_clusters = 6;
IDX = kmeans(data, number_of_clusters);

img = reshape(IDX, size(pd, 1), size(pd, 2));

figure('WindowState', 'maximized');
for i=1:number_of_clusters
    subplot(2, 3, i)
    ith_cluster = img;
    ith_cluster(img~=i) = 0;
    imshow(ith_cluster/i);
end
%saveas(gcf, 'Matlab kmeans.png');

figure('WindowState', 'maximized');
subplot(1,3,1);
imshow(pd);
title('pd');
subplot(1,3,2);
imshow(t1);
title('t1');
subplot(1,3,3);
imshow(t2);
title('t2');
saveas(gcf, 'Brain.png');


