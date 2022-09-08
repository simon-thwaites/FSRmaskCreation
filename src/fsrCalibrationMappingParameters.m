function fsrCalibration = fsrCalibrationMappingParameters(calibData, fsrDataPath, calibFileList, noCalibFiles)
% function to map max and min values of fsr channel to 0 - 100% and to get
% the value in N as well.
%-------------------------------------------------------------------------%
% created: 29/03/2020
%-------------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%-------------------------------------------------------------------------%
% These should be the max annd min values for the FSRs.
minFSR = -1.25;
maxFSR = 1.24996;

fsrList = {'fsr15_1', 'fsr15_2', 'fsr15_3', 'fsr15_4', ...
    'fsr16_1', 'fsr16_2', 'fsr16_3', 'fsr16_4'};
noFsrs = length(fsrList);


% get max and min values for channel 15
for iFsr = 1:noFsrs
    if iFsr < 5
        calibFile = 'calib_15';
    else
        calibFile = 'calib_16';
    end
    % get max and min values
    [f.(fsrList{iFsr}).maxValue, f.(fsrList{iFsr}).maxIndex] = max(calibData.(calibFile).(fsrList{iFsr}));
    f.(fsrList{iFsr}).minValue = min(calibData.(calibFile).(fsrList{iFsr}));
    
    % find the FP valaues when fsr are at max and when they are not at min
    f.(fsrList{iFsr}).FPatMaxFSR = calibData.(calibFile).fp1z(f.(fsrList{iFsr}).maxIndex);
    minIdx = find(calibData.(calibFile).(fsrList{iFsr})>minFSR,1);
    f.(fsrList{iFsr}).FPatMinFSR = calibData.(calibFile).fp1z(minIdx);
    
    if f.(fsrList{iFsr}).maxValue ~= maxFSR
        warningMsg = [fsrList{iFsr}, ' does not reach maxFSR value. Calibration will be inaccurate.'];
        warning(warningMsg)
        % if no. calib files equals three, then it has to be the other one,
        % if not then get user to select the appropriate calib file fofr
        % the given fsr. should hopefully only normally be 2 files.
        if noCalibFiles == 3
            for ind = 1:noCalibFiles
                [~, calibFile,~] = fileparts(calibFileList(ind).name);
                if ~strcmp(calibFile, {'calib_15', 'calib_16'})
                    % update max and min values
                    [f.(fsrList{iFsr}).maxValue, f.(fsrList{iFsr}).maxIndex] = max(calibData.(calibFile).(fsrList{iFsr}));
                    f.(fsrList{iFsr}).minValue = min(calibData.(calibFile).(fsrList{iFsr}));
                    
                    % update FP values
                    f.(fsrList{iFsr}).FPatMaxFSR = calibData.(calibFile).fp1z(f.(fsrList{iFsr}).maxIndex);
                    minIdx = find(calibData.(calibFile).(fsrList{iFsr})>minFSR,1);
                    f.(fsrList{iFsr}).FPatMinFSR = calibData.(calibFile).fp1z(minIdx);
                    
                    disp(['Using ', calibFile, ' for ', fsrList{iFsr}, ' calibration mapping.'])
                    if f.(fsrList{iFsr}).maxValue ~= maxFSR
                        warningMsg = [fsrList{iFsr}, ' Still does not reach maxFSR value. Calibration will be inaccurate.'];
                        warning(warningMsg)
                    else
                        disp([fsrList{iFsr}, ' now reaches maxFSR. Calibration should be accurate.']);
                    end
                end
            end
        else % if no. files is not equal to three then selecet the
            % appropriate calibration file for the channel
            disp('More than 3 calib files exist. User selection for FSR calibration files ...')
            cd(fsrDataPath)
            % user selection for calib file
            [calibFile, ~, ~] = uigetfile('*.csv', ['Select the calibration file for ', fsrList{iFsr}]);
            % strip the extension
            [~, calibFile, ~] = fileparts(calibFile);
            
            % update the min and max values
            [f.(fsrList{iFsr}).maxValue, f.(fsrList{iFsr}).maxIndex] = max(calibData.(calibFile).(fsrList{iFsr}));
            f.(fsrList{iFsr}).minValue = min(calibData.(calibFile).(fsrList{iFsr}));
            
            % update FP values
            f.(fsrList{iFsr}).FPatMaxFSR = calibData.(calibFile).fp1z(f.(fsrList{iFsr}).maxIndex);
            minIdx = find(calibData.(calibFile).(fsrList{iFsr})>minFSR,1);
            f.(fsrList{iFsr}).FPatMinFSR = calibData.(calibFile).fp1z(minIdx);
            
            disp(['Using ', calibFile, ' for ', fsrList{iFsr}, ' calibration mapping.'])
            if f.(fsrList{iFsr}).maxValue ~= maxFSR
                warningMsg = [fsrList{iFsr}, ' Still does not reach maxFSR value. Calibration will be inaccurate.'];
                warning(warningMsg)
            else
                disp([fsrList{iFsr}, ' now reaches maxFSR. Calibration should be accurate.']);
            end
        end
        
        
    end
    if f.(fsrList{iFsr}).minValue ~= minFSR
        warningMsg = ['WARNING!' , fsrList{iFsr}, 'minFSR value is inconsistent. Sensor might be faulty. Calibration will be inaccurate.'];
        warning(warningMsg)
    end
end



disp('All FSRs successfully mapped to max and min values.')
fsrCalibration = f;

end