clear all;
close all;
clc;

video = VideoReader('testVideo.mov');
correctNumberPlate  = 'KT66 AUO';
correctReadings = 0;

figure;

% This loop will display each frame in the figure consecutively.
for frame=1:video.NumFrames
    
    % Get the original image for the current frame.
    originalImage = read(video, frame);
    
    % Perform image manipulation workflow.
    binaryImage                 = getBinaryImage(originalImage);
    binaryImageMorphed          = morphBinaryImage(binaryImage);
    [rotatedMask, rotatedImage] = stabalizeImage(binaryImageMorphed, originalImage);
    croppedPlate                = cropImage(rotatedMask, rotatedImage);
    scaledImage                 = imresize(croppedPlate, 3);
    contrastAdjustedImage       = adjustImage(scaledImage);
    
    % Convert image to binary for better plate reading.
    bwImage = double(im2bw(contrastAdjustedImage));
    
    % Remove artifacts like plate manufacture names.
    finalImage = imdilate(bwImage, strel('disk', 5));
    finalImage = imerode(finalImage, strel('disk', 4));
    
    % OCR has been trained on the official UK number plate font.
    ocrResult = ocr(finalImage, 'TextLayout', 'Line', 'Language', 'UKNumberPlate\tessdata\UKNumberPlate.traineddata');
    
    % Clean OCR output.
    ocrNumberPlate = strtrim(ocrResult.Text);
    ocrNumberPlate = regexprep(ocrNumberPlate, '[^A-Z0-9 ]', '');
    
    % Clean and format OCR confidence results for each character.
    ocrCharAccuracy                             = ocrResult.CharacterConfidences;
    ocrCharAccuracy(isnan(ocrCharAccuracy))     = 0;
    ocrCharAccuracy(isempty(ocrCharAccuracy))   = 0;
    ocrCharAccuracy                             = uint8(ocrCharAccuracy*100)+"%";
    
    % Clean and format OCR confidence average.
    ocrPlateAccuracy = ocrResult.CharacterConfidences(~isnan(ocrResult.CharacterConfidences));
    ocrPlateAccuracy = uint8(mean(ocrPlateAccuracy)*100);
    
    % Prevent OCR confidence value errors.
    if isempty(ocrResult.CharacterConfidences)
        ocrPlateAccuracy = 0;
    elseif isnan(ocrPlateAccuracy)
        ocrPlateAccuracy = 0;
    end
    
    % Display character boxes on the final image.
    finalImage = insertObjectAnnotation(finalImage, 'rectangle', ocrResult.CharacterBoundingBoxes, ocrCharAccuracy, 'Color', 'red');
    
    % Display the original image frame with frame number.
    subplot(2,1,1);
    imagesc(originalImage);
    axis image;
    axis off;
    colormap gray;
    title({'\fontsize{20}Original Image';['\fontsize{11}Frame = ',num2str(frame),'/',num2str(video.NumFrames)]});
    
    % Display the annotated image, OCR result, and OCR confidence average.
    subplot(2,1,2);
    imagesc(finalImage);
    axis image;
    axis off;
    colormap gray;
    title({'\fontsize{20}Final Image';['\fontsize{11}OCR = {\color{red}',ocrNumberPlate,'}'];['Confidence = {\color{red}',num2str(ocrPlateAccuracy),'%}']});
    
    % Count correct plate readings to identify effectiveness.
    if strcmp(ocrNumberPlate, correctNumberPlate)
        correctReadings = correctReadings + 1;
    end
    
    % Display number plate reading with frame number in command window.
    fprintf('Frame: %d, Plate: %s\n',frame, ocrNumberPlate);
    
    % Allow for results to be displayed briefly.
    pause(0.1);
    
end

% Display the number of times OCR read the plate correctly.
fprintf('\nCorrect Readings: %d of %d, Accuracy: %.2f%%\n', correctReadings, video.NumFrames, correctReadings/video.NumFrames*100);
