% 21103080: Akash Rout
% Question 1

clc; clear; close all; % clear previous memory

% Import ear images
img_folder = 'ear_images/';
num_images = 10;
img_size = [100 100]; % resize to 100x100 for consistency

% First Step: Loading images and converting to vector form
data_matrix = zeros(prod(img_size), num_images);

for i = 1:num_images
    % Take image as input
    img_path = fullfile(img_folder, sprintf('ear%d.png', i));
    img = imread(img_path);

    % Converting to grayscale
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Resize to uniform dimensions
    img = imresize(img, img_size);

    % Flatten image into column vector
    data_matrix(:, i) = double(img(:));
end

% Second Step: Centre the data around its mean
mean_image = mean(data_matrix, 2);
centered_data = data_matrix - mean_image;

% Third Step: Covariance Matirx
cov_matrix = cov(centered_data');

% Fourth Step: Eigen Value Decomposition
[eig_vectors, eig_values] = eig(cov_matrix);

% Fifth Step: Sort eigen values and eigen vectors
eig_values_diag = diag(eig_values);
[~, idx] = sort(eig_values_diag, 'descend');
eig_vectors = eig_vectors(:, idx);
eig_values = eig_values_diag(idx);

% Sixth Step: Image projection into the principal components
num_components = 5;
projected_data = eig_vectors(:, 1:num_components)' * centered_data;

% Seventh Step: Display results
figure;
subplot(2, 3, 1);
imshow(reshape(uint8(mean_image), img_size));
title('Mean Ear Image');

for i = 1:num_components
    subplot(2, 3, i+1);
    eig_face = reshape(eig_vectors(:, i), img_size);
    imagesc(eig_face); colormap gray;
    title(['Eigenface ', num2str(i)]);
end

% Image Reconstruction using top principal components
sample_img_index = 1;
reconstructed = mean_image + eig_vectors(:, 1:num_components) * projected_data(:, sample_img_index);

figure;
subplot(1,2,1);
imshow(reshape(uint8(data_matrix(:, sample_img_index)), img_size));
title('Original Image');

subplot(1,2,2);
imshow(reshape(uint8(reconstructed), img_size));
title(['Reconstructed with ', num2str(num_components), ' PCs']);