function [maskedRGBImage,coloredObjectsMask] = Find_Yellow(rgbImage) 
    % Convert RGB image to HSV
    hsvImage = rgb2hsv(rgbImage);
    
    % Extract out the H, S, and V images individually
    hImage = hsvImage(:,:,1);
    sImage = hsvImage(:,:,2);
    vImage = hsvImage(:,:,3);

    % Define thresholds for 'Hue'. Modify these values to filter out different range of colors.
    hueThresholdLow = 0.1;
    hueThresholdHigh = 0.15;
    saturationThresholdLow = 0.5;
    saturationThresholdHigh = 1;
    valueThresholdLow = 0.25;
    valueThresholdHigh = 1.0;

    % Create mask based on chosen histogram thresholds
    hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
    saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
    valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);
    coloredObjectsMask = uint8(hueMask & saturationMask & valueMask);

    smallestAcceptableArea = 100; % Keep areas only if they're bigger than this.
    coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, smallestAcceptableArea));

    % Smooth the border using a morphological closing operation, imclose().
    structuringElement = strel('disk', 4);
    coloredObjectsMask = imclose(coloredObjectsMask, structuringElement);
    coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');
    coloredObjectsMask = bwareafilt(coloredObjectsMask, 1);
    coloredObjectsMask = cast(coloredObjectsMask, 'like', rgbImage); 

    % Use the colored object mask to mask out the colored-only portions of the rgb image.
    maskedImageR = coloredObjectsMask .* rgbImage(:,:,1);
    maskedImageG = coloredObjectsMask .* rgbImage(:,:,2);
    maskedImageB = coloredObjectsMask .* rgbImage(:,:,3);

    % Concatenate the masked color bands to form the rgb image.
    maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
end