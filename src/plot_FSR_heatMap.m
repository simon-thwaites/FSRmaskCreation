%% plot_FSR_heatMap.m
% Script to plot heat map over user-specified region of interest.
% Images are the FSR configuration used during the kneeling tests.
%-------------------------------------------------------------------------%
% created: 26/03/2020
% updated: 27/03/2020 - fsrMask created from roi user poly select
%          28/03/2020 - calibrateFSRS.m FSRs added
%          30/03/2020 - mapFSRs and defineROMregions added
%          25/06/2021 - adding in option to re-run calcs to have only first
%          5 secs of the awb trials.
%          22/07/2021 - added section to write the time normalise fsr
%          acivation to file, i.e., 0 - 100% via a vector length 1001
%-------------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%-------------------------------------------------------------------------%
%% Initialise
close all; clear all; clc;

% get source path
srcPath = pwd;
fsrConfig_labelledPath = [srcPath, '\fsrConfigLabelled\'];
cd(['.\fsrData'])
wd = cd;

%% select session
fsrDataPath = uigetdir(wd, 'Select Session');
cd(fsrDataPath)
[~, timePoint] = fileparts(fsrDataPath);

calibFolder = 'fsrCalibration';
numFsrChannels = 8;

minFSR = -1.250000000000000;
maxFSR = 1.249960000000000;

fileList = dir('*.csv'); % with extension
numFiles = length(fileList);

if isempty(numFiles)
    errorMsg  = ['ERROR! No  FSR data! Check README for correct data structure'];
    error(errorMsg)
end


if ~isfolder('fsrConfig')
    errorMsg  = ['ERROR! fsrConfig folder does not exist.', ...
        ' Please create fsrConfig folder and place .jpeg image of the fsr',...
        ' configuration in the folder'];
    error(errorMsg)
end

fsrConfigPath = fullfile(cd,'fsrConfig');      % fsr config image must be in this directory


%% get fsr photo for the timepoint
cd(fsrConfigPath)
close all;

fsrImage.fileList = dir('*.jpg'); % with extension
fsrImage.numFiles = length(fsrImage.fileList);

if fsrImage.numFiles > 1
    % more than one image
    errorMsg  = ['ERROR! More than one FSR photo for the session!'];
    error(errorMsg)
else
    % only one image so select it
    fsrImage.fileName = fsrImage.fileList.name;
end

%%
% get the labelled original config image and its ROI masks from file, or
% create the ROI .mat file if it doesn't exist yet
cd(srcPath)
[FSR_config_roi, I_fsrConfig_labelled] = generateFSRconfigLabelledImageROI(fsrConfig_labelledPath);

% now get this session's image
I = imread([fsrImage.fileList.folder, '\', fsrImage.fileName]);

%% Create the ROI mask for the new fsrConfig image. USes the OG config image to show channel.
cd(srcPath);
%
% switch ans5sec
%     case 'No'
[fsrConfigMaskPath, fsrImage] = createFSRmasks(I, I_fsrConfig_labelled, fsrConfigPath, srcPath, fsrImage, FSR_config_roi);

%     case 'Yes'
%         cd(fsrConfigPath)
%         maskFolder = 'roiMasks';
%         fsrConfigMaskPath = fullfile(cd,maskFolder);
%         cd(fsrConfigMaskPath)
%         fsrImage.roi = load('Masks.mat');
%         fsrImage.roi = fsrImage.roi.roiMasks;
% end



%% calibrate the FSRs from the fsrCalib folder
% this gives the force platform 1 & 2 values for the max FSR activation
% reading and, i.e., from the index at FSR peak, what is the FP1 Fz value.
% and for the min value takes the FP value to register the change from
% -1.25V and takes the FP value that does this.
cd(srcPath);
fsrCalibration = calibrarteFSRs(fsrDataPath, srcPath);

%% load motion trials
% get csv file list
cd(fsrDataPath);
fileList = dir('*.csv'); % with extension
numFiles = length(fileList);

cd(srcPath)
rd = loadRawData(fsrDataPath); % raw motion data

%% filter fp data
cd(srcPath)
d = filterFPs(rd, fileList, numFiles); % filtered motion data

%% apply calibration file to fsr data in the heat map
dMapped = mapFSRs(d, fsrCalibration, fileList);

%% get average FSR activation across all trials
cd(srcPath)

% need to change this to take in the ans5sec variable and then change this
% function to adapt to the 5 sec interval
avgFSR = calcAverageFSRactivation(dMapped, fileList, fsrDataPath);

%% map average FSR activation to colormap
cd(srcPath)
fsrROImappedMasks =  map_avgFSR_to_ROImasks(avgFSR, fsrImage, fileList);

%% plot!
cd(srcPath)
createGrayPlots_w_fsrActivationMapping(I, avgFSR, fsrImage, fsrROImappedMasks, fileList, fsrDataPath)