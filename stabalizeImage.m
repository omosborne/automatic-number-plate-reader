% Rotate the image so that it is parallel to the x-axis (0 degrees).
function [rotatedMask, rotatedImage] = stabalizeImage(areaOfInterest, originalImage)

    % Get the index for the largest cluster (registration plate).
    region      = regionprops(areaOfInterest, 'Area', 'Orientation');
    regionAreas = [region.Area];
    [~, index]  = max(regionAreas);

    % Calculate angle to counter-rotate plate.
    normalisedPlateAngle            = mod(region(index).Orientation, 360);
    normalisedPlateAngleDifference  = mod(0-normalisedPlateAngle, 360);
    angleToRotate                   = abs(normalisedPlateAngleDifference);

    % Perform counter-rotation to stabalise plate.
    rotatedMask     = imrotate(areaOfInterest, angleToRotate, 'bicubic');
    rotatedImage    = imrotate(originalImage, angleToRotate, 'bicubic');

end