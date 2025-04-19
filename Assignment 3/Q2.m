% 21103080: Akash Rout
% Question 2

clc; clear; close all; % clear previous memory

% First step 1: Generate 100 random data points from two Gaussians
rng(1); % For reproducibility

% Parameters for Gaussian 1
mu1 = [2, 3];
sigma1 = [0.5 0; 0 0.5];
data1 = mvnrnd(mu1, sigma1, 50);

% Parameters for Gaussian 2
mu2 = [7, 8];
sigma2 = [0.8 0; 0 0.8];
data2 = mvnrnd(mu2, sigma2, 50);

% Combine data
data = [data1; data2];

%% Second Step: K-means clustering
k = 2;
[idx_kmeans, C_kmeans] = kmeans(data, k);

% Plotting K-means result
figure;
gscatter(data(:,1), data(:,2), idx_kmeans);
hold on;
plot(C_kmeans(:,1), C_kmeans(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 2);
title('K-means Clustering');
xlabel('X');
ylabel('Y');
legend('Cluster 1','Cluster 2','Centroids');
grid on;

%% Third Step: Gaussian Mixture Model (GMM)
gmm_model = fitgmdist(data, k);       % Fit GMM
idx_gmm = cluster(gmm_model, data);   % Predict clusters

% Plotting GMM result
figure;
gscatter(data(:,1), data(:,2), idx_gmm);
hold on;

% Plotting GMM means
plot(gmm_model.mu(:,1), gmm_model.mu(:,2), 'r+', 'MarkerSize', 15, 'LineWidth', 2);
title('GMM Clustering');
xlabel('X');
ylabel('Y');
legend('Cluster 1','Cluster 2','GMM Means');
grid on;