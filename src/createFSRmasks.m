function [fsrConfigMaskPath, fsrImage] = createFSRmasks(I, I_fsrConfig_labelled, fsrConfigPath, srcPath, fsrImage, FSR_config_roi)
% script to generate the ROI masks from user input. Saves each mask is saved 
% as a structure in mat file in the fsrConfig folder for the session. The
% boundaries for each mask are selcted from user input using the
% select_FSR_ROI.m function.
%---------------------------------------------------------------------%
% created: 27/03/2020
%---------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%---------------------------------------------------------------------%
cd(fsrConfigPath)

maskFolder = 'roiMasks';
if ~isfolder(maskFolder)
    mkdir(maskFolder)
    fsrConfigMaskPath = fullfile(cd,maskFolder);
    cd(srcPath);
    [fsrImage.roi] = select_FSR_ROI(I_fsrConfig_labelled, I, FSR_config_roi);
    % save the mask
    cd(fsrConfigMaskPath)
    roiMasks = fsrImage.roi;
    save('Masks.mat', 'roiMasks')
else
    fsrConfigMaskPath = fullfile(cd,maskFolder);
    cd(fsrConfigMaskPath)
    if isfile('Masks.mat')
        
        answer = questdlg('Select FSR ROI? Note this will override previous masks.', ...
            'ROI Selection', ...
            'Yes','No','No');
        switch answer
            case 'Yes'
                cd(srcPath);
                [fsrImage.roi] = select_FSR_ROI(I_fsrConfig_labelled, I, FSR_config_roi);
                % save the mask
                cd(fsrConfigMaskPath)
                roiMasks = fsrImage.roi;
                save('Masks.mat', 'roiMasks')
                
            case 'No'
                % load it
                cd(fsrConfigMaskPath)
                fsrImage.roi = load('Masks.mat');
                fsrImage.roi = fsrImage.roi.roiMasks;
        end
    else
        % user selects FSR regions
        cd(srcPath);
        [fsrImage.roi] = select_FSR_ROI(I_fsrConfig_labelled, I, FSR_config_roi);
        % save the mask
        cd(fsrConfigMaskPath)
        roiMasks = fsrImage.roi;
        save('Masks.mat', 'roiMasks')
    end
end
end