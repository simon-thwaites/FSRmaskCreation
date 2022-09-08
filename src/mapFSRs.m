function mappedData = mapFSRs(data, fsrCalibration, fileList)
% function to map FSR activiation for all motion trials to 0 - 100% FSR
% activation.
% output is the mapped data.
% mappedData = (value - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
%---------------------------------------------------------------------%
% created: 30/03/2020
%---------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%---------------------------------------------------------------------%
fsrList = {'fsr15_1', 'fsr15_2', 'fsr15_3', 'fsr15_4', ...
    'fsr16_1', 'fsr16_2', 'fsr16_3', 'fsr16_4'};
noFsrs = length(fsrList);

% mapping to 0 - 100%
toLow = 0;
toHigh = 100;
mappedData = data;
for iFile = 1:length(fileList)
    [~, fileName,~] = fileparts(fileList(iFile).name);
    if length(fileName) > 2
        % not a BW trial
        if ~strcmp(fileName(end-2:end), 'COP')
            % not COP trial
            for iFsr = 1:noFsrs
                fromLow = fsrCalibration.(fsrList{iFsr}).minValue;
                fromHigh = fsrCalibration.(fsrList{iFsr}).maxValue;
                mappedData.(fileName).(fsrList{iFsr}) = (data.(fileName).(fsrList{iFsr}) - fromLow) .* (toHigh - toLow) ./ (fromHigh - fromLow) + toLow;
            end
        end
    end
    
end
end