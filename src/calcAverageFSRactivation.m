function avgFSR = calcAverageFSRactivation(dMapped, fileList, selectedSessionFolder)
% calculate the average FSR activation for each trial
%---------------------------------------------------------------------%
% created: 31/03/2020
%---------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%---------------------------------------------------------------------%

d = dMapped;
fsrList = {'fsr15_1', 'fsr15_2', 'fsr15_3', 'fsr15_4', ...
    'fsr16_1', 'fsr16_2', 'fsr16_3', 'fsr16_4'};

for iFile = 1:length(fileList)
    [~, fileName,~] = fileparts(fileList(iFile).name);
    % if not BM trial
    if length(fileName) > 2
        for iFsr = 1:length(fsrList)
            % mean for the trial
            avgFSR.(fileName).(fsrList{iFsr}) = ...
                ceil(mean(d.(fileName).(fsrList{iFsr})))/100;
        end
    end
end

cd(selectedSessionFolder)
if ~isfolder('Results')
    mkdir('Results')
end
cd('.\Results')
if ~isfile('avgFSR.mat')
    save('avgFSR.mat', 'avgFSR')
    disp('Saved avgFSR.mat file')
else
    avgFSR = load('avgFSR.mat');
    avgFSR = avgFSR.avgFSR;
    disp('Loaded existing avgFSR.mat file.')
end

end
