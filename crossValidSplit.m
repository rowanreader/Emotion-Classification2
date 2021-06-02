% takes in predictions of nets, file directory of subject, ith split out of
% splits, number of points in the training set in total (which we pull
% the test set from), number of nets used (features)
function [crossPredsTrain, crossTrainAns, crossPredsTest, crossTestAns] = ...
    crossValidSplit(preds, file, i, splits, pts, num)
quarter = pts/4; % since 4 classes stacked one after the other

start = quarter/splits*(i-1) + 1;
stop = quarter/splits*i+1;

load(file);
crossPredsTrain = zeros(4*(quarter - (stop - start)), num);
crossTrainAns = zeros(4*(quarter - (stop - start)), 1);
count1 = 1;
count2 = 1;
diff = stop-start;
for j = 1:4
    
    % loop through data
    % start and stop reference what section is extracted as test data
    % don't need i anymore, just overwrite

    % write to train    
    
    crossPredsTrain(count1:count1+start-1,:) = ...
        preds(quarter*(j-1)+1:quarter*(j-1) + start,:);
    crossTrainAns(count1:count1 + start-1) = trainAns(quarter*(j-1) + 1:quarter*(j-1) + start);
    count1 = count1 + start -1;
    
    % write to test
    crossPredsTest(count2:count2+diff-1,:) = preds(quarter*(j-1) + start:quarter*(j-1) + stop-1,:);
    crossTestAns(count2:count2+diff-1) = trainAns(quarter*(j-1) + start:quarter*(j-1) + stop-1);
    count2 = count2 + diff;
     
    % write to train
    crossPredsTrain(count1:(quarter-diff)*j, :) = preds(quarter*(j-1)+stop:quarter*j,:);
    crossTrainAns(count1:(quarter-diff)*j) = trainAns(quarter*(j-1)+ stop:quarter*j);
    count1 = (quarter-diff)*j+1;
end

