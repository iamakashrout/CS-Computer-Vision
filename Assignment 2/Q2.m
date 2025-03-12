% 21103080: Akash Rout
% Question 2

clc; clear; close all; % clear previous memory

% read grayscale image and convert to double format
img = double(imread('cameraman.tif'));

% 1) HARRIS CORNER DETECTOR

% Steps in Harris Corner Detector

% FIRST STEP: Finding gradients using Sobel operator
Sx = [-1 0 1; -2 0 2; -1 0 1]; % In X direction
Sy = [-1 -2 -1; 0 0 0; 1 2 1]; % In Y direction
Ix = conv2(img, Sx, 'same'); % Find X direction gradient
Iy = conv2(img, Sy, 'same'); % Find Y direction gradient
% Find Ix^2, Iy^2 and Ixy for Harris Matrix
Ixx = Ix.^2;
Iyy = Iy.^2;
Ixy = Ix .* Iy;

% SECOND STEP: Smoothening using Gaussian Filter
sigma = 1.5; % sigma value
kernel_size = 5; % filter size
% function to create grid
[x, y] = meshgrid(-floor(kernel_size/2):floor(kernel_size/2), -floor(kernel_size/2):floor(kernel_size/2));
% create Gaussian filter
G = exp(-(x.^2 + y.^2) / (2*sigma^2)) / (2*pi*sigma^2); % formula for Gaussian distribution
G = G / sum(G(:)); % normalization of values
% convolution over Ix^2, Iy^2 and Ixy
Sxx = conv2(Ixx, G, 'same');
Syy = conv2(Iyy, G, 'same');
Sxy = conv2(Ixy, G, 'same');

% THIRD STEP: Find Harris Matrix and Response R
% [Sx^2     Sxy]
% [Sxy     Sy^2]
k = 0.04; % Harris constant (0.04-0.06)
detM = (Sxx .* Syy) - (Sxy .^2); % determinant of Harris matrix
traceM = Sxx + Syy; % trace of Harris matrix
R = detM - k * (traceM.^2); % Response R=det-trace^2

% FOURTH STEP: Assign threshold and find corners
threshold = 0.01 * max(R(:));
harris_corners = (R > threshold);




% 2) HESSIAN CORNER DETECTOR

% Steps in Harris Corner Detector

% FIRST STEP: Finding second order derivatives using Sobel operator
Sxx = [1 -2 1; 1 -2 1; 1 -2 1]; % X direction second order derivative
Syy = Sxx'; % Y direction second order derivative
Sxy = [1 0 -1; 0 0 0; -1 0 1]; % Diagonl direction second order derivative
% Convolution over actual image
Ixx_hessian = conv2(img, Sxx, 'same'); 
Iyy_hessian = conv2(img, Syy, 'same'); 
Ixy_hessian = conv2(img, Sxy, 'same'); 

% SECOND STEP: Find determinant of Hessian Matrix
det_Hessian = (Ixx_hessian .* Iyy_hessian) - (Ixy_hessian .^ 2);

% THIRD STEP: Assign threshold and find corners
threshold_hessian = 0.005 * max(det_Hessian(:));
hessian_corners = (det_Hessian > threshold_hessian);


% Show results
subplot(2,2,1), imshow(uint8(img)), title('Original Image');
subplot(2,2,2), imshow(mat2gray(R)), title('Harris Response');
subplot(2,2,3), imshow(harris_corners), title('Harris Corners');
subplot(2,2,4), imshow(hessian_corners), title('Hessian Corners');
