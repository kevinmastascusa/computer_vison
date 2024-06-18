% Load the grayscale image
imgPath = 'circles1.gif'; % Specify the path to your image
img = imread(imgPath);

% Check if the image is color and convert to grayscale
if size(img, 3) == 3
    imgGray = rgb2gray(img);
else
    imgGray = img;
end

% Apply a Gaussian filter to smooth the image
imgSmoothed = imgaussfilt(imgGray, 1);

% Apply edge detection
binaryEdgeImage = edge(imgSmoothed, 'Canny'); % Adjust parameters as needed

% Parameters for Hough Transform
imageSize = size(imgSmoothed);
radiiRange = 20:5:100; % Example range, adjust based on expected circle sizes
HoughSpace = zeros(imageSize(1), imageSize(2), numel(radiiRange));

% Fill in Hough Space based on the binary edge image
[edgeY, edgeX] = find(binaryEdgeImage);
for rIndex = 1:numel(radiiRange)
    r = radiiRange(rIndex);
    for i = 1:numel(edgeX)
        for theta = 0:359
            x0 = round(edgeX(i) - r * cosd(theta));
            y0 = round(edgeY(i) - r * sind(theta));
            if x0 > 0 && x0 <= imageSize(2) && y0 > 0 && y0 <= imageSize(1)
                HoughSpace(y0, x0, rIndex) = HoughSpace(y0, x0, rIndex) + 1;
            end
        end
    end
end

% Apply a threshold to reduce noise
thresholdValue = 0.6 * max(HoughSpace(:));  % Adjust this multiplier as needed; % Example threshold
HoughSpace(HoughSpace < thresholdValue) = 0;

% Advanced 3D Non-Maximum Suppression
for x0 = 2:(imageSize(2)-1)
    for y0 = 2:(imageSize(1)-1)
        for rIndex = 2:(rSize-1)
            localPatch = HoughSpace(y0-1:y0+1, x0-1:x0+1, rIndex-1:rIndex+1);
            localMax = max(localPatch(:));
            if HoughSpace(y0, x0, rIndex) < localMax
                HoughSpace(y0, x0, rIndex) = 0; % Suppress non-maximum points
            end
        end
    end
end

% Extract and display all detected circles
detectedCircles = [];
[peakY, peakX, peakR] = ind2sub(size(HoughSpace), find(HoughSpace > thresholdValue));
for i = 1:length(peakY)
    detectedCircles(i,:) = [peakX(i), peakY(i), radiiRange(peakR(i))];
end

% Visualization
figure; imshow(imgGray); hold on;
for i = 1:size(detectedCircles, 1)
    viscircles(detectedCircles(i,1:2), detectedCircles(i,3), 'EdgeColor', 'r');
end
title('Detected Circles');

% Generate unique timestamp
timestamp = datestr(now, 'yyyy-mm-dd_HHMMSS');
% Define filenames for saving images and circle parameters with the unique timestamp
circleParamsFilename = sprintf('detected_circle_params_%s.txt', timestamp);

% Save the figure with all detected circles using a unique name
detectedCirclesFilename = sprintf('all_detected_circles_%s.png', timestamp);
saveas(gcf, detectedCirclesFilename);
close(gcf); % Close the figure

% Save the binary edge image with a unique name
binaryEdgeImageFilename = sprintf('binary_edge_image_%s.png', timestamp);
imwrite(binaryEdgeImage, binaryEdgeImageFilename);

% Save the original grayscale image with a unique name
originalGrayscaleImageFilename = sprintf('original_grayscale_image_%s.png', timestamp);
imwrite(imgGray, originalGrayscaleImageFilename);

% Now, save the circle parameters to a text file
fileID = fopen(circleParamsFilename, 'w');
if fileID == -1
    error('Failed to open file for writing circle parameters.');
end
fprintf(fileID, 'Detected Circle Parameters\n');
fprintf(fileID, 'Center_X, Center_Y, Radius\n');
for i = 1:size(detectedCircles, 1)
    fprintf(fileID, '%d, %d, %d\n', detectedCircles(i, 1), detectedCircles(i, 2), detectedCircles(i, 3));
end
fclose(fileID);