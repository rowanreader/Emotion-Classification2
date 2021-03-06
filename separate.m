% for GAMEEMO dataset
% separates the data into testing and training data
% for each of the subjects, open files with windows
% shuffles windows, randomly select 'test' percent of windows, remove and store
% do for all files, shuffle final test and train, then save
function separate
% if shuffle = 0: don't shuffle
% if shuffle = 1: shuffle
shuffle = 0;

% set the percent of data to be saved for test and the percent for train
testPercent = 0.2;
trainPercent = 0.8;
% number of windows (14 dimensional) in each game file (there are 4)
% just hard code, you'll have to change if you modify the window
num = 37484;
step = 128*6;
% the actual number of windows sectioned into the test and train arrays
% only actually need one but have both just in case
testNum = floor(testPercent * num);
trainNum = num - testNum;
for i = 1:28
    if i < 10
        temp = "ProcessedData/S0" + i;
    else
        temp = "ProcessedData/S" + i;
    end 
    % file to save data to
    if shuffle == 1
        saveFile = "D:/CISC 867/TestTrainShuffled/" + temp + ".mat";
    else
        saveFile = "D:/CISC 867/TestTrainUnshuffled/" + temp + ".mat";
    end
    % each value will be a 14x(128*6) window
    
    trainData = zeros(14, step, 1, trainNum * 4);
    testData = zeros(14, step, 1, testNum * 4);
    % corresponding labels
    trainAns = zeros(trainNum * 4, 1);
    testAns = zeros(testNum * 4, 1);
    for j = 1:4
        file = temp + j + ".mat";
        load(file);
        % shuffle by generating randomperm
        if shuffle == 1
            p = randperm(num);
        else
            p = [1:num]; % don't shuffle
        end
        newWindows = windows(p, 1);
        count = 1;
        % assign to train and test
        for k = (j-1)*trainNum + 1:j*trainNum
            trainData(:, :, :, k) = cell2mat(newWindows(count));
            count = count + 1;
            trainAns(k) = j;
        end
        for k = (j-1)*testNum + 1:j*testNum
            testData(:,:,:,k) = cell2mat(newWindows(count));
            count = count + 1;
            % also fill in answers
            testAns(k) = j;
        end
    end
    % shuffle so that all the windows are mixed in with other genres
    if shuffle == 1
        p = randperm(4*trainNum);
    
    else
        p = [1:4*trainNum];
    end
    trainData = trainData(:,:,:,p);
    trainAns = trainAns(p,1);
    if shuffle == 1
        p = randperm(4*testNum);
    else
        p = [1:4*testNum];
    end
    testData = testData(:,:,:,p);
    testAns = testAns(p, 1);
    save(saveFile,'trainData', 'trainAns', 'testData', 'testAns', '-v7.3');
    disp(i);
end