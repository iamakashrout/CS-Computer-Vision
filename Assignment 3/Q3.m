% 21103080: Akash Rout
% Question 3

clc; clear; close all; % clear previous memory

%% Generating data from two different Gaussians
rng(1); % For reproducibility

% Class 1 parameters
mu1 = [2 3];
sigma1 = [0.5 0; 0 0.5];
data1 = mvnrnd(mu1, sigma1, 50);
labels1 = ones(50,1);  % Class 1 label = 1

% Class 2 parameters
mu2 = [6 7];
sigma2 = [0.6 0; 0 0.6];
data2 = mvnrnd(mu2, sigma2, 50);
labels2 = ones(50,1)*2;  % Class 2 label = 2

% Combine data
X = [data1; data2];
y = [labels1; labels2];

%% Applying Linear Discriminant Analysis (LDA)
lda_model = fitcdiscr(X, y);

% Predicting on train data
y_pred_train = predict(lda_model, X);

%% Plotting original data and LDA decision boundary
figure;
gscatter(X(:,1), X(:,2), y, 'rb', 'xo');
title('Original Data and Classes');
xlabel('X1'); ylabel('X2'); grid on;

% Plotting decision boundary
d = 0.01;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)), ...
                           min(X(:,2)):d:max(X(:,2)));
XGrid = [x1Grid(:) x2Grid(:)];
predGrid = predict(lda_model, XGrid);
hold on;
contour(x1Grid, x2Grid, reshape(predGrid, size(x1Grid)), [1.5 1.5], 'k', 'LineWidth', 2);

%% Testing the model on new data
% Two test points from each class
test_points = [2.2 2.8; 1.8 3.3;   % Class 1-like
               6.5 7.1; 5.7 6.8];  % Class 2-like

test_labels = predict(lda_model, test_points);

% Display results
disp('Test Points and Predicted Classes:');
disp(table(test_points(:,1), test_points(:,2), test_labels, ...
     'VariableNames', {'X1','X2','PredictedClass'}));

% Plotting the test points
plot(test_points(1:2,1), test_points(1:2,2), 'ko', 'MarkerSize', 10, 'LineWidth', 2);
plot(test_points(3:4,1), test_points(3:4,2), 'ks', 'MarkerSize', 10, 'LineWidth', 2);
legend('Class 1','Class 2','Decision Boundary','Test Points Class 1','Test Points Class 2');