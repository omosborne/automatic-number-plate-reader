% Create an area of interest using morphological operations.
function [binaryImageMorphed] = morphBinaryImage(binaryImage)

    % Perform morphological operations to isolate number plate.
    %   Close:    Fill in number plate to single cluster.
    %   Open:     Split false positives.
    %   Erode:    Remove false positives.
    %   Dilate:   Fix number plate from previous 2 operations.
    morphed = binaryImage;
    morphed = imclose(morphed, strel('disk', 10));
    morphed = imopen(morphed, strel('disk', 10));
    morphed = imerode(morphed, strel('disk', 15));
    morphed = imdilate(morphed, strel('disk', 10));

    binaryImageMorphed = morphed;

end