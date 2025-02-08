% 21103080: Akash Rout
% Question 4

clc; clear; close all; % clear previous memory

% read a grayscale image
img = imread('cameraman.tif');

if size(img,3) == 3
    img = rgb2gray(img); % convert to grayscale
end

img = double(img); % convert to double format for transformations

% Fourier Transformation function
F = fft2(img); % 2D Fourier transform
F_shifted = fftshift(F); % zero frequency to center

% magnitude spectrum for display
magnitude_spectrum = log(1 + abs(F_shifted));

% image reconstruction using inverse Fourier transformation
reconstructed_img = ifft2(F); % inverse Fourier transform
reconstructed_img = real(reconstructed_img); % take only real components

figure; % display results

% Original Image
subplot(1,3,1);
imshow(uint8(img));
title('Original');

% Fourier Transformation Magnitude Spectrum
subplot(1,3,2);
imshow(mat2gray(magnitude_spectrum));
title('Fourier Transform');

% Reconstructed Image
subplot(1,3,3);
imshow(uint8(reconstructed_img));
title('Reconstructed');

% Observation
% Fourier Transform displays frequency components of the image with low
% frequency components in the crowded center and edges in the high
% frequency corners
% Reconstructed image is almost identical to original image with some
% approximation losses