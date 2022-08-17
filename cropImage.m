% Cut the original image using the values from the area of interest.
function [croppedPlate] = cropImage(areaOfInterest, originalImage)

    % Get the index for the largest cluster (registration plate).
    region      = regionprops(areaOfInterest);
    regionAreas = [region.Area];
    [~, index]  = max(regionAreas);

    % Crop image size to the area of interest for better reading.
    croppedPlate = imcrop(originalImage,region(index).BoundingBox);

end