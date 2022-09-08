%% fsr_config_image_ROI.m
% define config image ROI points
% this will save the  ROI masks for the fsr config image
%
% created: 26/03/2020
%
% Simon Thwaites
function [FSR_config_roi, I_fsrConfig_labelled] = generateFSRconfigLabelledImageROI(fsrConfig_labelledPath)
cd(fsrConfig_labelledPath)
if ~isfile('fsrConfigLabelled.jpg')
    errorMsg  = 'ERROR! No  labelled FSR config photo!';
    error(errorMsg)
end

I_fsrConfig_labelled = imread([fsrConfig_labelledPath, 'fsrConfigLabelled.jpg']);


if ~isfile('FSR_config_roi_masks.mat')
    
    % no config ROI masks, create them
    patchColour = 'r';
    patchAlpha = 0.5;
    answer = 'No';
    channelMasks = {'mask15_1', 'mask15_2', 'mask15_3', 'mask15_4', ...
        'mask16_1', 'mask16_2', 'mask16_3', 'mask16_4'};
    noChannels = 8;
    for iChannel = 1: noChannels
        channel = channelMasks{iChannel};
        while strcmp(answer,'No')
            I_fsrConfig_labelled = imread([fsrConfig_labelledPath, 'fsrConfigLabelled.jpg']);
            % starting at 15.1 cycle through and select ROI for all fsrs
            figure(1);
            %     imshow(I_fsrConfig_labelled)    % display image
            FSR_config_roi.(channel) = roipoly(I_fsrConfig_labelled);      % create region of interest masks from user input
            L = bwlabel(FSR_config_roi.(channel));
            s = regionprops(L, 'Extrema');
            imshow(I_fsrConfig_labelled)    % display image
            hold on
            x = s.Extrema(:,1);
            y = s.Extrema(:,2);
            patch(x, y, patchColour, 'FaceAlpha', patchAlpha)
            hold off
            answer = questdlg('Continue to next ROI?', ...
                'ROI selection', ...
                'Yes','No','No');
            clf
        end
        answer = 'No';
    end
    
    %% save the masks to file
    save('FSR_config_roi_masks.mat', 'FSR_config_roi')    
    
end
% .mat file exists for the ROIs, load it
FSR_config_roi = load([fsrConfig_labelledPath,'FSR_config_roi_masks.mat']);
FSR_config_roi = FSR_config_roi.FSR_config_roi;


end
