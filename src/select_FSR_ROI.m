function roi = select_FSR_ROI(I_fsrConfig_labelled, I, FSR_config_roi)
% user input to select FSR ROIs for heat map plotting. Input is original
% FSR config image, and I is the image for the session
figSize = [0.1 0.1 0.8 0.8];
figure('units','normalized','outerposition',figSize)
mainTitleText = 'Use mouse to define ROI. Double click to finish.';
FSR_config_patchColour = 'r';
FSR_config_patchAlpha = 0.5;
patchColour = 'r';
patchAlpha = 0.5;
answer = 'No';
channelMasks = {'mask15_1', 'mask15_2', 'mask15_3', 'mask15_4', ...
    'mask16_1', 'mask16_2', 'mask16_3', 'mask16_4'};
ROI_labels = {'15.1', '15.2', '15.3', '15.4', ...
    '16.1', '16.2', '16.3', '16.4'};
% update all the previously selected masks by combining together and
% patching over this
all_ROI_masks = zeros(size(I,1:2));

% If it's grayscale, convert to color
numberOfColorChannels = size(I,3);
if numberOfColorChannels < 3
  catImage = cat(3, I, I, I);
else
  % It's really an RGB image already.
  catImage = I;
end
% Specify the color we want to make this area.
desiredColor = [146, 40, 146]; % Purple

noFSRchannels = 8;
for iChannel = 1: noFSRchannels
    channel = channelMasks{iChannel};
    ROI_label = ROI_labels{iChannel};
    
    while strcmp(answer,'No')
        tempImage = catImage;
        redChannel = tempImage(:, :, 1);
        greenChannel = tempImage(:, :, 2);
        blueChannel = tempImage(:, :, 3);
        subplot(1, 2, 1)
        FSR_config_L = bwlabel(FSR_config_roi.(channel));
        FSR_config_s = regionprops(FSR_config_L, 'Extrema');
        imshow(I_fsrConfig_labelled)    % display config image 
        hold on
        FSR_config_x = FSR_config_s.Extrema(:,1);
        FSR_config_y = FSR_config_s.Extrema(:,2);
        patch(FSR_config_x, FSR_config_y, FSR_config_patchColour, 'FaceAlpha', patchAlpha)
        hold off
        subplot(1, 2, 2); hold on;
        title(['Select ROI for ', ROI_label])
        sgtitle(mainTitleText)
        roi.(channel) = roipoly(catImage);      % create region of interest masks from user input
        
        % Make the red channel that color
        redChannel(roi.(channel)) = desiredColor(1);
        greenChannel(roi.(channel)) = desiredColor(2);
        blueChannel(roi.(channel)) = desiredColor(3);
        tempImage = cat(3, redChannel, greenChannel, blueChannel);
        imshow(tempImage)
        answer = questdlg('Continue to next ROI?', ...
            'ROI selection', ...
            'Yes','No','No');
    end
    answer = 'No';
    % update all_ROI_masks which is a binary image
    all_ROI_masks = all_ROI_masks | roi.(channel);
    % Make the red channel that color
    redChannel(all_ROI_masks) = desiredColor(1);
    greenChannel(all_ROI_masks) = desiredColor(2);
    blueChannel(all_ROI_masks) = desiredColor(3);
    % Recombine separate color channels into a single, true color RGB image.
    catImage = cat(3, redChannel, greenChannel, blueChannel);

    clf
end
roi.all_ROI_masks = all_ROI_masks;
close
end