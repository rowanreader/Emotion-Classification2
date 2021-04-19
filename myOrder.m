% for my EEG data
% extracts wanted number of windows from data from separated and puts into
% image format (needs 3rd dim to be 1
function myOrder
% open all 5 files, store
dir = "D:/CISC 867/MyChoppedData/myEEG";

% num = 88500; % how many windows are in each file
num = 8000; % just use a smaller subset

testData = zeros(14, 1500, 1, num*4);
testAns = zeros(num*4,1);

% save goat data to separate file
goatSave = "D:/CISC 867/MyTestTrain/goatData.mat";
goatAns = zeros(num,1);
goatData = zeros(14, 1500, 1, num);
for i = [1,2,3,5]
    file = dir + i + ".mat";
    load(file);
    if i ~= 4 % don't include 4 (goat sim)
        if i == 5
            i = 4; % change to 4
        end 
        % get 4th 'section' of data - can be made to a random number
        % 4 was chosen arbitrarily
        n = 4; 
        testData(:,:,1, (i-1)*num+1: i*num) = windows(:,:,n*num:(n+1)*num-1);
        testAns((i-1)*num+1: i*num) = i;   
        disp(i);
    else
        goatData(:,:,1,:) = windows(:,:,4*num:5*num-1);
        goatAns(:,:) = i;
    end
end

savefile = "D:/CISC 867/MyTestTrain/myTestData2.mat";
save(savefile, 'testData', 'testAns', '-v7.3')

save(goatSave, 'goatData', 'goatAns', '-v7.3')