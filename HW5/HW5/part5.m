%Part 5


% Load the grayscale image
img = imread('circles1.gif');

% Apply gaussian filter to the image
img = imgaussfilt(img, 1);

% Apply edge detection
binaryEdgeImage = edge(img, 'Canny'); % Adjust parameters as needed

% Parameters
imageSize = size(img);
radiiRange = 20:5:100; % Example range, adjust based on expected circle sizes
HoughSpace = zeros(imageSize(1), imageSize(2), numel(radiiRange));

% Fill in Hough Space
[edgeY, edgeX] = find(binaryEdgeImage);
for rIndex = 1:length(radiiRange)
    r = radiiRange(rIndex);
    for i = 1:length(edgeX)
        for theta = 0:359
            x0 = round(edgeX(i) - r * cosd(theta));
            y0 = round(edgeY(i) - r * sind(theta));
            if x0 > 0 && x0 <= imageSize(2) && y0 > 0 && y0 <= imageSize(1)
                HoughSpace(y0, x0, rIndex) = HoughSpace(y0, x0, rIndex) + 1;
            end
        end
    end
end
% Apply a threshold
threshold = max(HoughSpace(:)) * 0.5; % Example threshold, adjust as necessary
HoughSpace(HoughSpace < threshold) = 0;

% Parameters for the Hough Space dimensions
xSize = imageSize(2);
ySize = imageSize(1);
rSize = numel(radiiRange);

% Iterate through the Hough Space
for x0 = 2:(xSize-1)
    for y0 = 2:(ySize-1)
        for rIndex = 2:(rSize-1)
            % Extract the local 3D neighborhood
            localPatch = HoughSpace(max(y0-1,1):min(y0+1,ySize), max(x0-1,1):min(x0+1,xSize), max(rIndex-1,1):min(rIndex+1,rSize));
            
            % Find the maximum value in the local 3D neighborhood
            localMax = max(localPatch(:));
            
            % Compare the current voxel to the local maximum
            if HoughSpace(y0, x0, rIndex) < localMax
                HoughSpace(y0, x0, rIndex) = 0; % Suppress non-maximum points
            end
        end
    end
end



% Find the maximum in Hough Space after suppression
[maxValue, linearIdx] = max(HoughSpace(:));
[y0, x0, rIndex] = ind2sub(size(HoughSpace), linearIdx);
detectedRadius = radiiRange(rIndex);

% Display the detected circle
figure;
imshow(img);
hold on;
viscircles([x0, y0], detectedRadius, 'EdgeColor', 'r');
title('Detected Circle');
hold off;
saveas(gcf, 'detected_circle.png'); % Save the figure if needed

% Display and save the Binary Edge Image
figure;
imshow(binaryEdgeImage);
title('Binary Edge Image');
saveas(gcf, 'binary_edge_image.png'); % Save the figure if needed

% Display and save the original grayscale image
figure;
imshow(img);
title('Original Grayscale Image');
saveas(gcf, 'original_grayscale_image.png'); % Save the figure if needed

%Print the detected circle parameters
fprintf('Detected circle parameters:\n');
fprintf('Center: (%d, %d)\n', x0, y0);
fprintf('Radius: %d\n', detectedRadius);
fprintf('Hough Space maximum value: %d\n', maxValue);
fprintf('Hough Space maximum location: (%d, %d, %d)\n', x0, y0, rIndex);
fprintf('Hough Space size: %d x %d x %d\n', xSize, ySize, rSize);






