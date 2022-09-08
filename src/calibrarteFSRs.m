function fsrCalibration = calibrarteFSRs(fsrDataPath, srcPath)
% function to calibrate FSRs based on calibration trials with each FSR
% being pressed onto FP1. File should be labelled:
%   - calib1_15
%   - calib_16
%   - or if missing one then something like calib_15_154only
% The 'fsrCalib' directory needs to be either in the session directory or
% in the participant directory. Or else find it ...
%-------------------------------------------------------------------------%
% created: 28/03/2020
%-------------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%-------------------------------------------------------------------------%


cd(fsrDataPath)
% check if fsrCalib folder exists in session folder
if ~isfolder('fsrCalib')
    % fsrCalib not in the session folder, check up a level
    cd ..
    if ~isfolder('fsrCalib')
        % fsrCalib fodler doesn't exist at all.
        warningMsg = 'Warning! fsrCalib folder does not exist';
        warning(warningMsg)
        
        answer = questdlg('Select fsrCalib folder?', ...
            'WARNING: fsrCalib folder does not exist.', ...
            'Yes','No','Yes');
        switch answer
            case 'Yes'
                fsrCalibPath = uigetdir(fsrDataPath, ...
                    'Select fsrCalib folder');
            case 'No'
                errorMsg = ['ERROR: fsrCalib folder does not exist and ',...
                    'alternate calibration folder not selected.'];
                error(errorMsg)
        end
    else
        cd('.\fsrCalib')
        fsrCalibPath = pwd;
    end
else
    cd('.\fsrCalib')
    fsrCalibPath = pwd;
end

calibFileList = dir('*.csv'); % with extension
noCalibFiles = length(calibFileList);
% check if fsrCalibPath has the fsrCalibration.mat
if ~isfile('fsrCalibration.mat')
    % doesn't exist, create it,
    disp('fsrCalibration.mat does not exist. Creating fsrCalibration.mat ...')
    
    % load raw data
    cd(srcPath)
    calibDataPath = [fsrDataPath, '.\fsrCalib'];
    rd = loadRawData(calibDataPath);
    
    % filter fp data
    cd(srcPath)
    d = filterFPs(rd, calibFileList, noCalibFiles);
    
    fsrCalibration = fsrCalibrationMappingParameters(d, fsrDataPath, calibFileList, noCalibFiles);
    
    % save the calibration file
    cd(fsrCalibPath)
    save('fsrCalibration.mat', 'fsrCalibration')
    disp('Created fsrCalibration.mat!')
    
else
    % load it
    disp('fsrCalibration.mat exists. Loading fsrCalibration.')
    fsrCalibration = load('fsrCalibration.mat');
    fsrCalibration = fsrCalibration.fsrCalibration;
    
end

end