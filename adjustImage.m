% Increase the contrast of the image by reducing the strength of shadows.
function [contrastAdjustedImage] = adjustImage(imageToAdjust)

    LIGHTNESS = 1;

    % Use imadjust with the L*A*B* colour space to adjust image lightness.
    labImage                = rgb2lab(imageToAdjust);
    labImage(:,:,LIGHTNESS)	= imadjust(labImage(:,:,LIGHTNESS)/100)*100;
    contrastAdjustedImage   = lab2rgb(labImage);

end