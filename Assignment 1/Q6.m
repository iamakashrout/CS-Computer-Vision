% 21103080: Akash Rout
% Question 6

clc; clear; close all; % clear previous memory

% read a grayscale image
img = imread('cameraman.tif');

if size(img,3) == 3
    img = rgb2gray(img); % convert to grayscale
end

% generate histogram of image
[L, W] = size(img);
num_pixels = L * W; % total number of pixels in the image
histogram = zeros(1, 256);

% find no. of pixels for each intensity value
for i = 1:L
    for j = 1:W
        pixel_value = img(i, j);
        histogram(pixel_value + 1) = histogram(pixel_value + 1) + 1;
    end
end

% cumulative distribution function of histogram
cdf = cumsum(histogram) / num_pixels;

equalized_img = img; % histogram equalized image

% apply histogram equalization transformation
for i = 1:L
    for j = 1:W
        equalized_img(i, j) = round(cdf(img(i, j) + 1) * 255);
    end
end

figure; % display results

% Original Image
subplot(2,3,1);
imshow(img);
title('Original');

% Original Histogram
subplot(2,3,2);
bar(0:255, histogram, 'k');
title('Histogram');
xlim([0 255]);

% CDF Plot
subplot(2,3,3);
plot(0:255, cdf, 'r', 'LineWidth', 2);
title('CDF');
xlim([0 255]);

% Equalized Image
subplot(2,3,4);
imshow(uint8(equalized_img));
title('HE Image');

% Equalized Histogram
subplot(2,3,5);
histogram_equalized = imhist(uint8(equalized_img));
bar(0:255, histogram_equalized, 'b');
title('HE Histogram');
xlim([0 255]);

% Comparison of CDF Transformation
subplot(2,3,6);
plot(0:255, cdf * 255, 'g', 'LineWidth', 2);
title('Transformation');
xlim([0 255]);
xlabel('Input Intensity');
ylabel('Output Intensity');