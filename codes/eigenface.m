clc;clear;close all;
load('../faces.mat')
%% show some faces
rand_ind = randi([1, 5000], [1,100]);
data_sample = X(rand_ind,:);
for i=1:10
    for j=1:10
        images((i-1)*32+1:i*32,(j-1)*32+1:j*32 )= reshape(data_sample((i-1)*10+j,:),32,32);
    end
end
figure;imshow(images,[]);title('sample images')
%% normalize X
X = (X-min(X(:)))/(max(X(:))-min(X(:)));
%% subtract mean
mean_x = mean(X);
centered_x = X-mean_x;
%% calculate covariance
cov_matrix = 0;
for i = 1:length(centered_x)
    cov_matrix = cov_matrix + centered_x(i,:)'*centered_x(i,:);
end
cov_matrix = cov_matrix/length(centered_x);

%% eigenvalues and eigenvectors
[V,D] = eig(cov_matrix);
%% descending matrices
v_d = fliplr(V);
d_d = flipud(fliplr(D));
%% show eigen faces
eigf_sample = v_d(:,1:100);
for i=1:10
    for j=1:10
        eigf((i-1)*32+1:i*32,(j-1)*32+1:j*32 )= reshape(eigf_sample(:,(i-1)*10+j),32,32);
    end
end
figure;imshow(eigf,[]);title('Eigen faces')
%% histogram for eigenvalues
eig_vals = max(d_d);
eig_vals_hist = eig_vals/sum(eig_vals(:));
figure;bar(eig_vals_hist,'linewidth',2);xlim([0,100])
xlabel('Number of component'); ylabel('percent')
%% decompose an image to eigenfaces
numofcomp = 20;
img = centered_x(500,:);
weights = img*v_d;
recons_img = v_d*weights';
weights2 = img*v_d(:,1:numofcomp);
recons_img2 = v_d(:,1:numofcomp)*weights2';
figure;subplot(131);imshow(reshape(img,32,32),[]);title('main image')
subplot(132);imshow(reshape(recons_img,32,32),[]);title('reconstructed image with all comps')
subplot(133);imshow(reshape(recons_img2,32,32),[]);title('reconstructed image with 20 comps')


