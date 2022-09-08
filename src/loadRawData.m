function rawData = loadRawData(dataPath)
% function to load and return the stripped csv files with just FP and fsr
% activation.
%-------------------------------------------------------------------------%
% Created: 28/03/2020
%-------------------------------------------------------------------------%
% Simon Thwaites
%-------------------------------------------------------------------------%
cd(dataPath)
fileList = dir('*.csv'); % with extension
numFiles = length(fileList);

% tic;
for ind = 1:numFiles
    [~, fileName,~] = fileparts(fileList(ind).name);
    % raw data, rd
    rd.(fileName) = readtable(fileList(ind).name);
end
% disp('loaded all files!')
cd ..
% T = toc;
pause(0.5)
clc
% disp(['Loaded stripped data files! Took: ' num2str(T) ' secs'])

rawData = rd;

end