% 21103080: Akash Rout
% Question 3

clc; clear; close all; % clear previous memory

% read grayscale image and convert to double format
img = double(imread('cameraman.tif'));

% Template definition
template_size = [30, 30]; % Template size 30x30 pixels
% Find 30x30 template from original image
template = img(50:50+template_size(1)-1, 50:50+template_size(2)-1);

% Define sizes
[rows, cols] = size(img); % size of image
[trows, tcols] = size(template); % size of template

% Initialize Result Matrices for all methods
% 1) Correlation
corr_result = zeros(rows - trows, cols - tcols);
% 2) Zero Mean Correlation
zm_corr_result = zeros(rows - trows, cols - tcols);
% 3) Sum of Squared Differences
ssd_result = ones(rows - trows, cols - tcols) * Inf; % lower values better
% 4) Normalized Cross Correlation
ncc_result = zeros(rows - trows, cols - tcols);

% Mean and standard deviation of template
template_mean = mean(template(:));
template_std = std(template(:));

% Slide template over image to find similarity
for i = 1:rows - trows
    for j = 1:cols - tcols
        % Extract local region
        region = img(i:i+trows-1, j:j+tcols-1);
        
        % 1) Correlation
        corr_result(i, j) = sum(sum(region .* template));
        
        % 2) Zero Mean Correlation
        region_mean = mean(region(:)); % mean of current region
        zm_corr_result(i, j) = sum(sum((region - region_mean) .* (template - template_mean)));
        
        % 3) Sum of Squared Differences
        ssd_result(i, j) = sum(sum((region - template).^2));
        
        % 4) Normalized Cross Correlation
        region_std = std(region(:)); % standard deviation of current region
        if region_std > 0  % Don't divide by zero
            ncc_result(i, j) = sum(sum((region - region_mean) .* (template - template_mean))) / (template_std * region_std);
        end
    end
end

% Find best template matches for each method
[~, corr_idx] = max(corr_result(:)); % Max for Correlation
[~, zm_corr_idx] = max(zm_corr_result(:)); % Max for Zero Mean Correlation
[~, ssd_idx] = min(ssd_result(:)); % Min for SSD
[~, ncc_idx] = max(ncc_result(:)); % Max for NCC

% Convert best match point to 2D row column format
[corr_y, corr_x] = ind2sub(size(corr_result), corr_idx);
[zm_corr_y, zm_corr_x] = ind2sub(size(zm_corr_result), zm_corr_idx);
[ssd_y, ssd_x] = ind2sub(size(ssd_result), ssd_idx);
[ncc_y, ncc_x] = ind2sub(size(ncc_result), ncc_idx);

% Show image and template
figure;
subplot(2,3,1), imshow(uint8(img)), title('Original Image');
subplot(2,3,2), imshow(uint8(template)), title('Template');

% Show resulting matches for each method
subplot(2,3,3), imshow(uint8(img)), hold on, rectangle('Position',[corr_x, corr_y, tcols, trows],'EdgeColor','r'), title('Correlation');
subplot(2,3,4), imshow(uint8(img)), hold on, rectangle('Position',[zm_corr_x, zm_corr_y, tcols, trows],'EdgeColor','g'), title('Zero-Mean Correlation');
subplot(2,3,5), imshow(uint8(img)), hold on, rectangle('Position',[ssd_x, ssd_y, tcols, trows],'EdgeColor','b'), title('SSD');
subplot(2,3,6), imshow(uint8(img)), hold on, rectangle('Position',[ncc_x, ncc_y, tcols, trows],'EdgeColor','m'), title('NCC');
