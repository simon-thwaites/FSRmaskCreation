function createGrayPlots_w_fsrActivationMapping(I, avgFSR, fsrImage, fsrROImappedMasks, fileList, fsrDataPath)
% Grayscale the fsr config image (I) then overlay the fsrActvation mapping
%---------------------------------------------------------------------%
% created: 31/03/2020
%---------------------------------------------------------------------%
% Simon Thwaites
% simon.thwaites.biomech@gmail.com
%---------------------------------------------------------------------%
fsrList = {'fsr15_1', 'fsr15_2', 'fsr15_3', 'fsr15_4', ...
    'fsr16_1', 'fsr16_2', 'fsr16_3', 'fsr16_4'};
romList = {'upright1', 'flexed', 'upright2', 'forward', 'upright3', 'left', 'upright4', 'right'};
maskList = {'mask15_1', 'mask15_2', 'mask15_3', 'mask15_4', ...
    'mask16_1', 'mask16_2', 'mask16_3', 'mask16_4','all_ROI_masks'};

% define colourmap
cmap = jet(101);
colorbarTicks = (0:0.1:1);
colorbarTickLabels = cellstr(split(num2str(0:10:100)));
colorbarLabel = 'FSR activation (%)';
fontSize = 16;
colorbarFontSize = 12;

grayImage = rgb2gray(I);

[rows, columns, numberOfColorChannels] = size(grayImage);

cd(fsrDataPath)

if ~isfolder('Plots')
    mkdir('Plots')
end
cd('.\Plots')

% If it's grayscale, convert to color
if numberOfColorChannels < 3
    rgbImage = cat(3, grayImage, grayImage, grayImage);
else
    % It's really an RGB image already.
    rgbImage = grayImage;
end

for iFile = 1:length(fileList)
    [~, fileName,~] = fileparts(fileList(iFile).name);
    % if not BM trial
    if length(fileName) > 2
        for iFsr = 1:length(fsrList)
            binaryImage = fsrImage.roi.(maskList{iFsr});
            
            % Extract the individual red, green, and blue color channels.
            redChannel = rgbImage(:, :, 1);
            greenChannel = rgbImage(:, :, 2);
            blueChannel = rgbImage(:, :, 3);
            
            % Specify the color we want to make this area.
            desiredColor = cmap(round(avgFSR.(fileName).(fsrList{iFsr})*100+1),:);  % as double RGB triplet [0, 1]
            desiredColor = uint8(desiredColor * 255 + 0.5);     % UINT8 array, the values are in the interval [0, 255]
            % Make the red channel that color
            redChannel(binaryImage) = desiredColor(1);
            greenChannel(binaryImage) = desiredColor(2);
            blueChannel(binaryImage) = desiredColor(3);
            % Recombine separate color channels into a single, true color RGB image.
            rgbImage = cat(3, redChannel, greenChannel, blueChannel);
        end
        figure;
        imshow(rgbImage);
        titleText = ['FSR heat map, trial ', fileName];
        title(titleText, 'FontSize', fontSize, 'Interpreter', 'none');
        colormap(cmap);
        c = colorbar('TickLabels',colorbarTickLabels,'Ticks',colorbarTicks, 'FontSize', colorbarFontSize);
        c.Label.String = colorbarLabel;
        saveas(gcf,[titleText,'.png'])
        close
        
    end
end
end