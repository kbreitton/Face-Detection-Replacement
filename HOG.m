function [feature_vector] = HOG(window)

%extract HOG features for an input grayscale image detection window
%feature vector output is 1 x N
%where N = #Blocks-in-window * #Cells-per-block * 9 orientations

%detection window must be a factor of 6 in each dimension, because the
%cellSize is 6 x 6

% BlockSize = 4...(2 x 2)
% #Orientations = 9...(0 - 180 degrees)
% BlockOverlap = 1
% CellSize = 64...(8 x 8)

%fixel block size, cell size, & orientations
blockSize = [2 2]; %in i,j
orientations = [20 60 100 140 180 220 260 300 340]; %signed directions for face detection where it matters
cellSize = [6 6]; %in i,j

windowSize = size(window); %in i,j


%% normalize window gamma and color





%% get gradient direction and magnitude over whole window
gradX = conv2(double(window), [1 -1], 'same');
gradY = conv2(double(window), [1 -1]', 'same');

windowMag = sqrt(gradX.^2 + gradY.^2);
windowDir = atan2d(gradY, gradX);
windowDir(windowDir < 0) = windowDir(windowDir < 0) + 360; %convert negative angles to 0-360 degrees


%% get each cell's info (gradient direction and magnitude of each pixel) within window

%get cell matrix of window & cell sub-sub-info in each element
%mat2cell() can split up window image into cell-data-types
Cmag = mat2cell(windowMag, ones(windowSize(1) / cellSize(1), 1) * cellSize(1), ones(windowSize(2) / cellSize(2), 1) * cellSize(2));
Cdir = mat2cell(windowDir, ones(windowSize(1) / cellSize(1), 1) * cellSize(1), ones(windowSize(2) / cellSize(2), 1) * cellSize(2));

%apply gaussian spatial window to each pixel's gradient magnitude of each cell
gauss = fspecial('gaussian', cellSize(1), 5*blockSize(2));
GspatialWindow = @(x) x .* (gauss ./ norm(gauss));
Cmag = cellfun(GspatialWindow, Cmag, 'UniformOutput', 0); %Cmag re-saved as gaussian'd Cmag


%% functions for getting each cell's HOG

%functions -- spread magnitudes of each pixel of a cell over 9 orientation bins, then sum responses
%to obtain one HOG per cell
% spread = @(dir, mag) mag .* ((repmat(180, size(orientations)) - abs(dir - orientations)) ./ 180) ./ norm(((repmat(180, size(orientations)) - abs(dir - orientations)) ./ 180)); %to spread -- for a pixel x's gradDir, compute the normalized similarity between it and the 9 orientations then multiply by its gradMag
cellSpread = @(oneCdir, oneCmag) arrayfun(@spread, oneCdir, oneCmag, 'UniformOutput', false); %function to apply spread() on all pixels within one cell C
HOG_one_cell = @(oneCdir, oneCmag) sum(cell2mat(reshape(cellSpread(oneCdir,oneCmag), [cellSize(1) * cellSize(2) 1]))); %given one cell C's magnitudes and directions, function to obtain one HOG 1x9 feature vector per cell by summing each pixel's histogram

%% apply HOG_one_cell to all cells within window and obtain a 1 x 9 vector per cell in the window
HOGs_window = cellfun(HOG_one_cell, Cdir, Cmag, 'UniformOutput', false);

%% duplicate rows/columns of all HOGs per cell in the window to account for blocks' overlaps

%duplicate columns of HOGs_window to account for block overlap
HOGs_first_column = HOGs_window(:,1); %save first column before removing it (where one 'column' is the 9 orientations)
HOGs_last_column = HOGs_window(:,end); %save last column before removing it
HOGs_window = HOGs_window(:,2:end-1); %remove first and last column
sizeHOGs_window = size(HOGs_window);
HOGs_window = reshape(repmat(HOGs_window,2,1),sizeHOGs_window(1),2*sizeHOGs_window(2)); %duplicate columns
HOGs_window = [HOGs_first_column, HOGs_window, HOGs_last_column]; %add back the first and last column

%duplicate rows of HOGs_window to account for block overlap
HOGs_first_row = HOGs_window(1,:); %save first row
HOGs_last_row = HOGs_window(end,:); %save last row
HOGs_window = HOGs_window(2:end-1, :); %remove first and last row
HOGs_window=HOGs_window(ceil((1:blockSize(1)*size(HOGs_window,1))/blockSize(1)), :); %duplicate rows
HOGs_window = [HOGs_first_row; HOGs_window; HOGs_last_row]; %add back the first and last rows


%% get normalized HOG feature vector of each block

%reconfigure HOGs_window (a cell matrix) so that each cell element contains a single 2x2 block
%in matrix format (which ends up being 2 x 18)
HOGs_window = cell2mat(HOGs_window);
HOGs_window = mat2cell(HOGs_window, ones(size(HOGs_window,1) / blockSize(1),1) * blockSize(1), ones(size(HOGs_window,2) / (blockSize(2) * 9),1)*(blockSize(2) * 9));

%sum the HOGs of each cell within each block to obtain the single HOG per
%block -- and normalize it too
HOGblock = @(HOG) [HOG(1,1:9) HOG(1,10:18) HOG(2,1:9) HOG(2,10:18)] ./ norm([HOG(1,1:9) HOG(1,10:18) HOG(2,1:9) HOG(2,10:18)]);
% HOGblock = @(HOG) sum(reshape(sum(HOG), [9 blockSize(1)]),2)' ./ norm(sum(reshape(sum(HOG), [9 blockSize(1)]),2)');
HOG_allblocks = cellfun(HOGblock, HOGs_window, 'UniformOutput', false);

%% get feature vector of the window
feature_vector = cell2mat(reshape(HOG_allblocks, [1 numel(HOG_allblocks)]));

feature_vector(isnan(feature_vector)) = 0;
% feature_vector = {feature_vector};

end