% used on GAMEEMO dataset
% opens EEG data files, generates Hamming windows (stride of 1)
% saves windows as a 4D matrix (EEG channels x pts x 1 (grayscale) x numWindows)
function chop(file, saveFile)
% loads all 14 electrods, each is a 38252x1 array
load(file);
% AF3, AF4, F3, F4, F7, F8, FC5, FC6, O1, O2, P7, P8, T7, T8
electrodes = {AF3, AF4, F3, F4, F7, F8, FC5, FC6, O1, O2, P7, P8, T7, T8};

% each window should be 14x128 -> electrodes x pts/sec
% there should be a total of 300 windows, however 148 pts are missing
% will be a total of 298 windows
step = 128*6; % how many points are in each window (Hz * sec)
[num,~] = size(AF3);
numWindows = num - step;
% each window will be 14x128
windows = cell(numWindows,1);
count = 0;
for i = 1:numWindows
%     % this is the electrode we're currently working with
%     temp = electrodes{i};
    % hopefully all files have enough for the same number of windows. 
    % If not, can change it so its variable, but that'll be a pain
    
    count = count + 1;
    % indexing includes end point so subtract 1
    % get all columns (all electrodes) and next 128 datapoints
    window = zeros(14, step);
    for j = 1:14
        window(j,:) = electrodes{j}(count:count+step-1);
    end
    windows{i} = window;
end
% have all chopped windows, save to mat file
save(saveFile, 'windows', '-v7.3');