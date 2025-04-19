% 21103080: Akash Rout
% Question 4

clc; clear; close all; % clear previous memory

% Load image
img = imread('cameraman.tif');
if size(img, 3) == 3
    img = rgb2gray(img);  % Convert image to grayscale
end
img = double(img);
[orig_h, orig_w] = size(img); % Store original image dimensions

% Downsample image for speed
img = imresize(img, 0.25);  % Reduce size to 50%


% Applying Gaussian blur to reduce noise
sigma = 2;
img_smooth = imgaussfilt(img, sigma);

% Preparing feature space
[h, w] = size(img_smooth);
pixels = reshape(img_smooth, [h*w, 1]);

% Parameters for Mean Shift
bandwidth = 40; % Large bandwidth for faster convergence
max_iter = 30; % Fewer iterations
threshold = 1;

% Mean Shift Iterations
num_pixels = length(pixels);
centers = pixels;
for iter = 1:max_iter
    old_centers = centers;
    for i = 1:num_pixels
        dist = abs(pixels - centers(i));
        weights = exp(-0.5 * (dist / bandwidth).^2);
        weights = weights / sum(weights);
        centers(i) = sum(pixels .* weights);
    end
    max_shift = max(abs(centers - old_centers));
    fprintf('Iteration %d, Max Shift: %f\n', iter, max_shift);
    if max_shift < threshold
        fprintf('Converged after %d iterations\n', iter);
        break;
    end
end

% Assigning cluster labels
unique_centers = unique(round(centers));
num_clusters = length(unique_centers);
labels = zeros(num_pixels, 1);
for i = 1:num_pixels
    [~, idx] = min(abs(centers(i) - unique_centers));
    labels(i) = idx;
end
segmented_img = reshape(labels, [h, w]);

% Upsample to original size for display
segmented_img = imresize(segmented_img, [orig_h, orig_w], 'nearest');
% Normalize
segmented_img = uint8(255 * (segmented_img - min(segmented_img(:))) / (max(segmented_img(:)) - min(segmented_img(:))));

% Display results
figure;
subplot(1, 2, 1);
imshow(uint8(img));
title('Original Image');
subplot(1, 2, 2);
imshow(segmented_img);
title('Segmented Image');