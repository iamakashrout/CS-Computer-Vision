% 21103080: Akash Rout
% Question 3

clc; clear; close all; % clear previous memory

% read a grayscale image
img = imread('cameraman.tif');

if size(img,3) == 3
    img = rgb2gray(img); % convert to grayscale
end

img = double(img); % convert to double format for transformations

% a) Image Negative
img_neg = 255 - img;

figure;
% original Image
subplot(1,2,1);
imshow(uint8(img));
title('Original Image');
% negative image
subplot(1,2,2);
imshow(uint8(img_neg));
title('Negative');

% b) Power law with gamma = 0.2, 0.5, 1.5, 2.0
gamma_values = [0.2, 0.5, 1.5, 2.0];
power_images = cell(1, length(gamma_values));

for i = 1:length(gamma_values)
    gamma = gamma_values(i);
    power_images{i} = 255 * (img / 255).^gamma;
end

figure;
for i = 1:length(gamma_values)
    subplot(2,2,i);
    imshow(uint8(power_images{i}));
    title(['Gamma = ', num2str(gamma_values(i))]);
end
sgtitle('Power Law Transformations');

% c) Histogram Equalization
img_hist = histeq(uint8(img));


figure;
subplot(1,3,1);
imshow(img_hist);
title('HE Image');

subplot(1,3,2);
imhist(uint8(img));
title('Histogram Original'); % show histogram
subplot(1,3,3);
imhist(img_hist);
title('Histogram Equalized');