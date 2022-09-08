function fsrROImappedMasks =  map_avgFSR_to_ROImasks(avgFSR,fsrImage, fileList)
% Map the average FSR activataio nvalues to the binary masks.
%---------------------------------------------------------------------%
% created: 31/03/2020
%---------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%---------------------------------------------------------------------%
fsrList = {'fsr15_1', 'fsr15_2', 'fsr15_3', 'fsr15_4', ...
    'fsr16_1', 'fsr16_2', 'fsr16_3', 'fsr16_4'};
maskList = {'mask15_1', 'mask15_2', 'mask15_3', 'mask15_4', ...
    'mask16_1', 'mask16_2', 'mask16_3', 'mask16_4','all_ROI_masks'};

for iFile = 1:length(fileList)
    [~, fileName,~] = fileparts(fileList(iFile).name);
    % if not BM trial
    if length(fileName) > 2
        % not bm trial
        for iFsr = 1:length(fsrList)
            if ~strcmp(maskList{iFsr}, 'all_ROI_masks')
                fsrROImappedMasks.(fileName).(fsrList{iFsr}) = ...
                    avgFSR.(fileName).(fsrList{iFsr}).*fsrImage.roi.(maskList{iFsr});
            else
                errorMsg = 'all_ROI_masks has been used for region mapping. Check FSR ROI.';
                error(errorMsg)
            end
        end
    end
end
end