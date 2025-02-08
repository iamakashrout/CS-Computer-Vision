% 21103080: Akash Rout
% Question 5

clc; clear; close all; % clear previous memory

% read a grayscale image
img = imread('cameraman.tif');

if size(img,3) == 3
    img = rgb2gray(img); % convert to grayscale
end

% a) Box filter
box_filter = fspecial('average', [5 5]); % average in 5x5 neighbourhood
img_box = imfilter(img, box_filter, 'replicate');

% b) Weighted box filter
weighted_filter = [1 2 1; 2 4 2; 1 2 1]; % 3x3 weighted filter
weighted_filter = weighted_filter / sum(weighted_filter(:));
img_weighted = imfilter(img, weighted_filter, 'replicate');

% c) Gaussian low pass filter
gaussian_filter = fspecial('gaussian', [5 5], 1.0); % variance=1
img_gaussian = imfilter(img, gaussian_filter, 'replicate');

figure; % display results

% Original Image
subplot(2,2,1);
imshow(img);
title('Original Image');

% Box Filtered Image
subplot(2,2,2);
imshow(img_box);
title('Box Filter');

% Weighted Box Filtered Image
subplot(2,2,3);
imshow(img_weighted);
title('Weighted Box');

% Gaussian Low Pass Filtered Image
subplot(2,2,4);
imshow(img_gaussian);
title('Gaussian Low Pass');

% Observation
% Box filter blurs the image removing noise as well as edges
% Weighted box shows less blurring and preserves edges
% Better smoothening in Gaussian and removes noise more naturally