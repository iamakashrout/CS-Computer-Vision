% 21103080: Akash Rout
% Question 5

clc; clear; close all; % clear previous memory

% Read video file
videoFile = 'sample_video.mp4';
v = VideoReader(videoFile);

% Parameters
alpha = 1;           % Regularization constant
num_iter = 100;      % Iterations for convergence
threshold = 2;       % Flow magnitude threshold for visualization

% Read first frame
frame1 = readFrame(v);
frame1_gray = im2double(rgb2gray(frame1));

while hasFrame(v)
    % Read next frame
    frame2 = readFrame(v);
    frame2_gray = im2double(rgb2gray(frame2));

    % Compute gradients
    [Ix, Iy] = gradient(frame1_gray);
    It = frame2_gray - frame1_gray;

    % Initialize flow
    u = zeros(size(frame1_gray));
    v_flow = zeros(size(frame1_gray));

    % Average kernel
    kernel = fspecial('average', [3 3]);

    % Horn-Schunck iterations
    for iter = 1:num_iter
        u_avg = imfilter(u, kernel, 'replicate');
        v_avg = imfilter(v_flow, kernel, 'replicate');

        num = (Ix .* u_avg + Iy .* v_avg + It);
        den = alpha^2 + Ix.^2 + Iy.^2;

        u = u_avg - Ix .* (num ./ den);
        v_flow = v_avg - Iy .* (num ./ den);
    end

    % Show motion vectors
    figure(1); imshow(frame1); hold on;
    [r, c] = size(frame1_gray);
    [X, Y] = meshgrid(1:10:c, 1:10:r);
    u_show = u(1:10:end, 1:10:end);
    v_show = v_flow(1:10:end, 1:10:end);
    quiver(X, Y, u_show, v_show, 'r');
    title('Estimated Optical Flow (Horn-Schunck)');
    hold off;
    drawnow;

    % Prepare for next frame
    frame1_gray = frame2_gray;
    frame1 = frame2;
end