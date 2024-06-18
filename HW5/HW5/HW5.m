%Part 2
% Parameters
imageSize = [400, 400];
m = 1; % Slope of the line
b = -100; % Y-intercept of the line
circleCenter = [100, 200]; % Center of the circle
circleRadius = 50; % Radius of the circle

% Create empty image
image = false(imageSize);

% Generate line
for x = 1:imageSize(1)
    y = m*x + b;
    if y > 0 && y <= imageSize(2)
        image(round(y), x) = true;
    end
end

% Generate circle
theta = linspace(0, 2*pi, 360);
for i = 1:length(theta)
    x = round(circleCenter(1) + circleRadius*cos(theta(i)));
    y = round(circleCenter(2) + circleRadius*sin(theta(i)));
    if x > 0 && x <= imageSize(1) && y > 0 && y <= imageSize(2)
        image(y, x) = true;
    end
end

% Display the image
imshow(image);
title('Generated Binary Image with Line and Circle');

%Part 3
% Image dimensions
imageSize = [400, 400];
thetaRange = -90:1:89; % Degrees
rMax = hypot(imageSize(1), imageSize(2)); % Maximum distance from the origin to a corner
rRange = -rMax:1:rMax;
H = zeros(length(rRange), length(thetaRange)); % Hough accumulator array

[edgeY, edgeX] = find(image); % Assuming 'image' is the binary edge image

for i = 1:numel(edgeX)
    for theta = thetaRange
        r = edgeX(i) * cosd(theta) + edgeY(i) * sind(theta);
        rIndex = round(r + rMax) + 1;
        thetaIndex = theta + 91; % Adjusting index because theta starts at -90
        H(rIndex, thetaIndex) = H(rIndex, thetaIndex) + 1;
    end
end

[maxValue, linearIndex] = max(H(:));
[rIndex, thetaIndex] = ind2sub(size(H), linearIndex);
rDetected = rRange(rIndex);
thetaDetected = thetaRange(thetaIndex) - 91; % Adjust back to -90 to 89 range

mDetected = -cotd(thetaDetected);
bDetected = rDetected / sind(thetaDetected);

imagesc(thetaRange, rRange, H);
title('Hough Transform Space');
xlabel('\theta (degrees)');
ylabel('r');
colormap('hot');
colorbar;
saveas(gcf, 'HoughSpace.png');

%Print the detected line parameters
fprintf('Detected line: y = %.2fx + %.2f\n', mDetected, bDetected);
% Display the detected parameters in the command window
fprintf('Detected Line Parameters:\n');
fprintf('Theta (degrees): %.2f\n', thetaDetected);
fprintf('R: %.2f\n', rDetected);
fprintf('Slope (m): %.2f\n', mDetected);
fprintf('Y-intercept (b): %.2f\n', bDetected);


% Part 4
% Assuming imageSize is the size of your binary edge image
maxRadius = floor(hypot(imageSize(1), imageSize(2))/2); % Max radius
minRadius = 5; % Min radius for practical purposes
radii = minRadius:maxRadius;
HoughSpace = zeros(imageSize(1), imageSize(2), numel(radii));

[edgeY, edgeX] = find(image); % Edge pixels

for i = 1:length(edgeX)
    for rIndex = 1:length(radii)
        r = radii(rIndex);
        for theta = 0:360 % Complete circle
            x0 = round(edgeX(i) - r * cosd(theta));
            y0 = round(edgeY(i) - r * sind(theta));
            if x0 > 0 && x0 <= imageSize(1) && y0 > 0 && y0 <= imageSize(2)
                HoughSpace(y0, x0, rIndex) = HoughSpace(y0, x0, rIndex) + 1;
            end
        end
    end
end

[maxValue, linearIndex] = max(HoughSpace(:));
[y0Index, x0Index, rIndex] = ind2sub(size(HoughSpace), linearIndex);
detectedRadius = radii(rIndex);
detectedCenter = [x0Index, y0Index];

% Extract the 2D slice at the detected radius
slice = squeeze(HoughSpace(:,:,rIndex));
saveas(gcf, 'HoughSpace.png');

% Plot
figure;
imagesc(slice);
title(sprintf('Hough Space Slice for Radius = %d', detectedRadius));
xlabel('Center x-coordinate (x_0)');
ylabel('Center y-coordinate (y_0)');
colormap('jet');
colorbar;

%Save the figure

saveas(gcf, 'HoughSpaceSlice.png');


% Display the detected parameters in the command window
fprintf('Detected Circle Parameters:\n');
fprintf('Center: (%d, %d)\n', detectedCenter(1), detectedCenter(2));
fprintf('Radius: %d\n', detectedRadius);
%Display the maximum value in the Hough Space
fprintf('Maximum value in Hough Space: %d\n', maxValue);


