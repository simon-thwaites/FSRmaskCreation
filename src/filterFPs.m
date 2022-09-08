function filteredFPdata = filterFPs(rawData, fileList, noFiles)
% function to return filtered force platform data.
% Uses a 4th order butterworth, zero lag with filtfilt.
% Must be x,y,z data in a table form
% fc = cutoff freq
% fs = sample freq
%-------------------------------------------------------------------------%
% Created: 28/03/2020
%-------------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%-------------------------------------------------------------------------%
fc = 12; % cutoff freq
fs = 2000; % sample freq
butterOrder = 4;
[b,a] = butter(butterOrder,fc/(fs/2));

for ind = 1:noFiles
    [~, fileName,~] = fileparts(fileList(ind).name);
    if length(fileName) > 2
        % not a BW trial
        filteredFPdata.(fileName) = rawData.(fileName);
        filteredFPdata.(fileName).fp1x = filtfilt(b,a,rawData.(fileName).fp1x);
        filteredFPdata.(fileName).fp1y = filtfilt(b,a,rawData.(fileName).fp1y);
        filteredFPdata.(fileName).fp1z = -1*filtfilt(b,a,rawData.(fileName).fp1z);
        filteredFPdata.(fileName).fp2x = filtfilt(b,a,rawData.(fileName).fp2x);
        filteredFPdata.(fileName).fp2y = filtfilt(b,a,rawData.(fileName).fp2y);
        filteredFPdata.(fileName).fp2z = -1*filtfilt(b,a,rawData.(fileName).fp2z);
    end
end

end