% separates the data into testing and training data
% for each of the subjects, open files with windows
% shuffles windows, randomly select 'test' percent of windows, remove and store
% do for all files, shuffle final test and train, then save
function separate_ordered

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
    saveFile = "D:/CISC 867/TestTrain/" + temp + ".mat";
    % each value will be a 14x(128*6) window, 4 files, each separated
    % save different files
    trainData = zeros(4, 14, step, 1, trainNum);
    testData = zeros(4, 14, step, 1, testNum);
    % corresponding labels
    trainAns = zeros(4, trainNum, 1);
    testAns = zeros(4, testNum, 1);
    for j = 1:4
        file = temp + j + ".mat";
        load(file);
        count = 1;
        % assign to train and test
        for k = (j-1)*trainNum + 1:j*trainNum
            trainData(j, :, :, :, k) = cell2mat(windows(count));
            count = count + 1;
            trainAns(k) = j;
        end
        for k = (j-1)*testNum + 1:j*testNum
            testData(j, :, :, :, k) = cell2mat(windows(count));
            count = count + 1;
            % also fill in answers
            testAns(k) = j;
        end
    end
    save(saveFile,'trainData', 'trainAns', 'testData', 'testAns', '-v7.3');
    disp(i);
end