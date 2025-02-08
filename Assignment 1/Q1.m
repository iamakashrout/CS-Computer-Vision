% 21103080: Akash Rout
% Question 1

clc; clear; close all; % clear previous memory

z_dist = 30; % Minimum z distance from center of projection
d = 2; % Distance of the image plane from the center of projection

% Generate random cuboid dimensions
width = randi([5, 15]);
height = randi([5, 15]);
depth = randi([5, 15]);

% Ensure z distance is at least 30
x0 = randi([-10, 10]);
y0 = randi([-10, 10]);
z0 = randi([z_dist, z_dist + 20]);

% Define 8 vertices of the cuboid
vertices = [ 
    x0, y0, z0;
    x0+width, y0, z0;
    x0, y0+height, z0;
    x0, y0, z0+depth;
    x0+width, y0+height, z0;
    x0+width, y0, z0+depth;
    x0, y0+height, z0+depth;
    x0+width, y0+height, z0+depth]';

% Convert to homogeneous coordinates for easier transformations
vertices_h = [vertices; ones(1,8)];

% Perspective projection matrix
P = [d  0  0  0;
     0  d  0  0;
     0  0  1  0];

% Apply perspective transformation
projected = P * vertices_h;

% back to Cartesian coordinates
projected(1,:) = projected(1,:) ./ projected(3,:);
projected(2,:) = projected(2,:) ./ projected(3,:);
projected = projected(1:2, :); % Remove z-coordinates

figure; % plot results

% Plot original 3D cuboid
subplot(1,2,1);
hold on; grid on; axis equal;
plot3(vertices(1, [1 2 5 3 1]), vertices(2, [1 2 5 3 1]), vertices(3, [1 2 5 3 1]), 'b', 'LineWidth', 2);
plot3(vertices(1, [2 6 8 5 2]), vertices(2, [2 6 8 5 2]), vertices(3, [2 6 8 5 2]), 'b', 'LineWidth', 2);
plot3(vertices(1, [3 5 8 7 3]), vertices(2, [3 5 8 7 3]), vertices(3, [3 5 8 7 3]), 'b', 'LineWidth', 2);
plot3(vertices(1, [1 4 7 3 1]), vertices(2, [1 4 7 3 1]), vertices(3, [1 4 7 3 1]), 'b', 'LineWidth', 2);
plot3(vertices(1, [4 6 8 7 4]), vertices(2, [4 6 8 7 4]), vertices(3, [4 6 8 7 4]), 'b', 'LineWidth', 2);
plot3(vertices(1, [1 2 6 4 1]), vertices(2, [1 2 6 4 1]), vertices(3, [1 2 6 4 1]), 'b', 'LineWidth', 2);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Original 3D Cuboid');
view(3); % Set to 3D view

% Plot projected 2D image of cuboid
subplot(1,2,2);
hold on; grid on; axis equal;
plot(projected(1, [1 2 5 3 1]), projected(2, [1 2 5 3 1]), 'r', 'LineWidth', 2);
plot(projected(1, [2 6 8 5 2]), projected(2, [2 6 8 5 2]), 'r', 'LineWidth', 2);
plot(projected(1, [3 5 8 7 3]), projected(2, [3 5 8 7 3]), 'r', 'LineWidth', 2);
plot(projected(1, [1 4 7 3 1]), projected(2, [1 4 7 3 1]), 'r', 'LineWidth', 2);
plot(projected(1, [4 6 8 7 4]), projected(2, [4 6 8 7 4]), 'r', 'LineWidth', 2);
plot(projected(1, [1 2 6 4 1]), projected(2, [1 2 6 4 1]), 'r', 'LineWidth', 2);
xlabel('X'); ylabel('Y');
title('Projected 2D Image');
