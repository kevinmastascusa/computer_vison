function processAndSaveImage(imagePath)
    % Load the image
    image = imread(imagePath);

    % Compute the energy map and save
    energyMap = computeEnergyMap(image);
    imwrite(mat2gray(energyMap), replace(imagePath, '.', '_energy.'));
    disp(['Saved energy map for ', imagePath]);

    % Find and mark the optimal seam, then save
    seamMatrix = computeSeamMatrix(energyMap);
    seamPath = findOptimalSeam(seamMatrix);
    markedImage = markSeamOnImage(image, seamPath);
    imwrite(markedImage, replace(imagePath, '.', '_seam_marked.'));
    disp(['Saved marked seam image for ', imagePath]);

    % Remove the seam and save
    imageWithSeamRemoved = removeSeam(image, seamPath);
    imwrite(imageWithSeamRemoved, replace(imagePath, '.', '_seam_removed.'));
    disp(['Saved image with seam removed for ', imagePath]);
end

 function energyMap = computeEnergyMap(image)
    % Check if the image is RGB; if it has 3 layers, then it's RGB
    if size(image, 3) == 3
        % Convert the image to grayscale
        grayImage = rgb2gray(image);
    else
        % The image is already grayscale
        grayImage = image;
    end
    
    % Apply Gaussian smoothing
    smoothedImage = imgaussfilt(grayImage, 2); % Sigma = 2, adjust as needed
    
    % Compute the gradient magnitude
    [Gx, Gy] = imgradientxy(smoothedImage, 'sobel');
    energyMap = sqrt(Gx.^2 + Gy.^2);
end

    
    function seamMatrix = computeSeamMatrix(energyMap)
        [rows, cols] = size(energyMap);
        seamMatrix = zeros(rows, cols);
        seamMatrix(1, :) = energyMap(1, :);
    
        for i = 2:rows
            for j = 1:cols
                if j == 1
                    seamMatrix(i,j) = energyMap(i,j) + min([seamMatrix(i-1,j), seamMatrix(i-1,j+1)]);
                elseif j == cols
                    seamMatrix(i,j) = energyMap(i,j) + min([seamMatrix(i-1,j-1), seamMatrix(i-1,j)]);
                else
                    seamMatrix(i,j) = energyMap(i,j) + min([seamMatrix(i-1,j-1), seamMatrix(i-1,j), seamMatrix(i-1,j+1)]);
                end
            end
        end
    end

    function seamPath = findOptimalSeam(seamMatrix)
        [rows, cols] = size(seamMatrix);
        seamPath = zeros(rows, 1);
    
        [~, minCol] = min(seamMatrix(rows, :));
        seamPath(rows) = minCol;
    
        for i = rows-1:-1:1
            prevCol = seamPath(i+1);
            if prevCol == 1
                [~, offset] = min(seamMatrix(i, prevCol:prevCol+1));
                seamPath(i) = prevCol - 1 + offset;
            elseif prevCol == cols
                [~, offset] = min(seamMatrix(i, prevCol-1:prevCol));
                seamPath(i) = prevCol - 2 + offset;
            else
                [~, offset] = min(seamMatrix(i, prevCol-1:prevCol+1));
                seamPath(i) = prevCol - 2 + offset;
            end
        end
    end

    function markedImage = markSeamOnImage(image, seamPath)
        markedImage = image;
        for i = 1:length(seamPath)
            markedImage(i, seamPath(i), 1) = 255; % Red channel
            markedImage(i, seamPath(i), 2:3) = 0; % Green and Blue channels
        end
    end

    function im = removeSeam(im, seamPath)
        [rows, ~, numChannels] = size(im);
        for ch = 1:numChannels
            for i = 1:rows
                im(i, seamPath(i):end-1, ch) = im(i, seamPath(i)+1:end, ch);
            end
        end
        im = im(:,1:end-1,:);
    end


