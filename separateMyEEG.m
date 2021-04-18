% chops up my EEG data
% sampled at 250Hz, reduce to 5 min sections (cut from ends)
% then make a window
% G1-4 were aquired by watching the 4 videos. 
% G5 is from me watching a video I actually found funny
% all files have at least 90000 datapoints (6 min)
function separateMyEEG
dir = "MyEEGData/G";
step = 250*6; % 250 Hz, 6 seconds
numPoints = 90000;
saveDir = "D:/CISC 867/MyChoppedData/myEEG";
for i = 1:5
    file = dir + i + ".mat";
    load(file);
    saveFile = saveDir + i + ".mat";
    % will have 18 rows, only care about 2-15 (1st is time, 16-18 are EEG
    % status)
    % get central 90000 points
    [~, m] = size(y);
    diff = ceil((m - numPoints)/2);
    array = y(2:15, diff:diff+numPoints-1);
    % must rearrange array into same order of elecrodes.
    % current order:
    % [AF3, AF4, F7, F8, F3, F4, O1, O2, FC5, P7, P8, T8, FC6, T7]
    % desired order:
    % [AF3, AF4, F3, F4, F7, F8, FC5, FC6, O1, O2, P7, P8, T7, T8]
    array(:,:) = array([1,2,5,6,3,4,9,13,7,8,10,11,14,12],:);
    numWindows = numPoints - step;
    % now chop array into windows
    windows = zeros(14, 1500, numWindows);
    for j = 1:numWindows
        windows(:,:,j) = array(:, j:j+step-1);
    end
    save(saveFile, 'windows', '-v7.3');
    disp(i);
end
