% 21103080: Akash Rout
% Question 1

clc; clear; close all; % clear previous memory

% read grayscale image and convert to double format
img = double(imread('cameraman.tif'));

% Steps in Canny Edge Detector:

% FIRST STEP: Apply smoothening using Gaussian filter
sigma = 1.4; % sigma value
kernel_size = 5; % filter size
% function to create grid
[x, y] = meshgrid(-floor(kernel_size/2):floor(kernel_size/2), -floor(kernel_size/2):floor(kernel_size/2));
% create Gaussian filter
G = exp(-(x.^2 + y.^2) / (2*sigma^2)) / (2*pi*sigma^2); % formula for Gaussian distribution
G = G / sum(G(:)); % normalization of values
% convolution over image
smoothed_img = conv2(img, G, 'same');

% SECOND STEP: Finding gradients using Sobel operator
Sx = [-1 0 1; -2 0 2; -1 0 1]; % In X direction
Sy = [-1 -2 -1; 0 0 0; 1 2 1]; % In Y direction
Gx = conv2(smoothed_img, Sx, 'same'); % Find gradient in X direction Gx
Gy = conv2(smoothed_img, Sy, 'same'); % Find gradient in Y direction Gy
Gm = sqrt(Gx.^2 + Gy.^2); % Magnitude of gradient
Gd = atan2(Gy, Gx) * (180 / pi); % Direction of gradient
Gd(Gd < 0) = Gd(Gd < 0) + 180; % Converting all angles to +v3

% THIRD STEP: Non Maximum Suppression of Points
[row, col] = size(Gm);
suppressed_img = zeros(row, col); % Result after non maximum suppression, initially all zeroes
for i = 2:row-1 % skip border pixels
    for j = 2:col-1
        angle = Gd(i, j); % find gradient angle of pixel
        % find dominant direction from angle and find two neighbours in
        % that direction
        if ((angle >= 0 && angle < 22.5) || (angle >= 157.5 && angle <= 180)) % gradient in horizontal direction
            neighbors = [Gm(i, j-1), Gm(i, j+1)];
        elseif (angle >= 22.5 && angle < 67.5) % gradient in right diagonal
            neighbors = [Gm(i-1, j+1), Gm(i+1, j-1)];
        elseif (angle >= 67.5 && angle < 112.5) % gradient in vertical direction
            neighbors = [Gm(i-1, j), Gm(i+1, j)];
        elseif (angle >= 112.5 && angle < 157.5) % gradient in left diagonal
            neighbors = [Gm(i-1, j-1), Gm(i+1, j+1)];
        end
        
        % See if pixel is maximum in neighbourhood
        if (Gm(i, j) >= max(neighbors))
            suppressed_img(i, j) = Gm(i, j); % if yes, then keep
        else
            suppressed_img(i, j) = 0; % else, discard
        end
    end
end

% FOURTH STEP: Thresholding and Edge Linking
tx = 0.1 * max(suppressed_img(:));  % lower threshold tx to find weak edges
Tx = 0.3 * max(suppressed_img(:)); % higher threshold Tx to find strong edges
strong_edges = (suppressed_img >= Tx); % find all strong edge pixels
weak_edges = (suppressed_img >= tx) & (suppressed_img < Tx); % find all weak edge pixels
% After marking strong and weak edge pixels, link them
final_edges = strong_edges; % automatically select all strong edge points
for i = 2:row-1
    for j = 2:col-1
        if weak_edges(i, j) % if pixel is a weak edge point
            if any(any(strong_edges(i-1:i+1, j-1:j+1))) % and connected to a strong edge point
                final_edges(i, j) = 1; % then add it to final edge points
            end
        end
    end
end

% Show results
subplot(2, 2, 1), imshow(uint8(img)), title('Original Image');
subplot(2, 2, 2), imshow(uint8(Gm)), title('Gradient Magnitude');
subplot(2, 2, 3), imshow(suppressed_img, []), title('Non-Maximum Suppression');
subplot(2, 2, 4), imshow(final_edges, []), title('Final Edges');
