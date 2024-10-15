clc
clear

%% Q3
pd = im2double(imread('S3_Q2_utils/pd.jpg'));
t1 = im2double(imread('S3_Q2_utils/t1.jpg'));
t2 = im2double(imread('S3_Q2_utils/t2.jpg'));

data = cat(3, pd(:, :, 1), t1(:, :, 1), t2(:, :, 1));
data = reshape(data, size(pd, 1)*size(pd, 2),3);
n = size(data, 1); %data points

N_cluster = 6;
start = randperm(n, N_cluster); %N random data indices
cent = data(start,:); %Initial centers
idx = zeros(n,1); %data cluster ids

for i = 1:5 %iterations
    %Assigning new cluster ids to data
    for j = 1:n
        id = 1;
        dist = sum((data(j,:)-cent(id,:)).^2);
        for k = 2:N_cluster
            if(sum((data(j,:)-cent(k,:)).^2)<dist)
                dist = sum((data(j,:)-cent(k,:)).^2);
                id = k;
            end
        end
        idx(j) = id;
    end
    %Updating the centers
    clust_sum = zeros(N_cluster,3);
    clust_count = zeros(N_cluster,1);
    for j = 1:n
        clust_sum(idx(j),:) = clust_sum(idx(j),:) + data(j,:);
        clust_count(idx(j)) = clust_count(idx(j)) + 1;
    end
    cent = clust_sum./(repmat(clust_count,1,3));
end

img = reshape(idx, size(pd, 1), size(pd, 2));

figure('WindowState', 'maximized');
for i=1:N_cluster
    subplot(2, 3, i)
    ith_cluster = img;
    ith_cluster(img~=i) = 0;
    imshow(ith_cluster/i);
end
%saveas(gcf, 'Manual kmeans.png');