% Binarize the image using manual threshold values.
function [binaryImage] = getBinaryImage(originalImage)

    % Split colour channels.
    R = originalImage(:,:,1);
    G = originalImage(:,:,2);
    B = originalImage(:,:,3);

    % Perform red channel band-pass with threshold values.
    t1 = 145;
    t2 = 255;
    binaryRed  = R >= t1 & R <= t2;

    % Perform green channel band-pass with threshold values.
    t3 = 125;
    t4 = 255;
    binaryGreen  = G >= t3 & G <= t4;

    % Perform blue channel band-pass with threshold values.
    t5 = 0;
    t6 = 49;
    binaryBlue  = B >= t5 & B <= t6;

    % Combine channels into final binary image.
    binaryImage = binaryRed & binaryGreen & binaryBlue;

end