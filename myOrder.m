function myOrder
% open all 5 files, store
dir = "D:/CISC 867/MyChoppedData/myEEG";

% num = 88500; % how many windows are in each file
num = 8000; % just use a smaller subset
% testData = zeros(14, 1500, 1, num*4);
% testAns = zeros(num*4,1);
testData = zeros(14, 1500, 1, num*4);
testAns = zeros(num*4,1);

% just use all data for train, don't bother with test.

for i = [1,2,3,5]
    file = dir + i + ".mat";
    load(file);
    
%     trainData(:,:, 1,(i-1)*num+1: i*num) = windows;
%     trainAns((i-1)*num+1: i*num) = i;

    if i == 5
        i = 4; % change to 4
    end
%     trainData(:,:,1, (i-1)*num+1: i*num) = windows(:,:,1:num);
%     trainAns((i-1)*num+1: i*num) = i;   
    testData(:,:,1, (i-1)*num+1: i*num) = windows(:,:,4*num:5*num-1);
    testAns((i-1)*num+1: i*num) = i;   
    disp(i);
end
% savefile1 = "D:/CISC 867/MyTestTrain/myData1.mat";
% save(savefile1, 'trainData', 'trainAns', '-v7.3');

% savefile2 = "D:/CISC 867/MyTestTrain/myData2.mat";
% save(savefile2, 'trainData', 'trainAns', '-v7.3');

savefile3 = "D:/CISC 867/MyTestTrain/myTestData2.mat";
save(savefile3, 'testData', 'testAns', '-v7.3')