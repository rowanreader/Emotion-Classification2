
function multiModel
saveFile = "multiPreds.mat";
load(saveFile);
load(file, 'testAns');

% Make NN
layers = [
    % pretend its an image, 14 channels x 128*6 (each window is 6 secs) x 1 
    featureInputLayer(num)    
%     fullyConnectedLayer(32);
%     reluLayer
%     fullyConnectedLayer(32);
%     reluLayer
    fullyConnectedLayer(64);
    reluLayer
    fullyConnectedLayer(64);
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
%     fullyConnectedLayer(256)
%     reluLayer
%     fullyConnectedLayer(256)
%     reluLayer
    fullyConnectedLayer(4) % 4 classes
    softmaxLayer
    classificationLayer];
% 
%     'LearnRateDropFactor', 0.9,...
%     'LearnRateDropPeriod', 2,...

% automatically shuffles once before training
miniBatchSize = 256;
options = trainingOptions( 'adam',...
'MiniBatchSize', miniBatchSize,...
'InitialLearnRate', 0.003,...
'MaxEpochs', 15,...
'ExecutionEnvironment', 'auto',...
'Plots', 'training-progress');
% send in predictions of other models
% from loaded file - don't need all since not all were used in the
% separation, only go up to points
% trainAns = trainAns(1:pts); - not loading anymore
 
splits = 5; % split into 5 sections
validAns = [];
for i = 1:splits
    % only takes the 1st pts for total dataset
    % split trainAns into confusion matrix
    [crossPredsTrain, crossTrainAns, crossPredsTest, crossTestAns] = ...
        crossValidSplit(preds, file, i, splits, pts, num);
    
    net = trainNetwork(crossPredsTrain, categorical(crossTrainAns), layers, options);	

    predLabelsTest = net.classify(predsTest);
    validAns(:,i) = predLabelsTest;
    accuracy = sum(predLabelsTest == categorical(testAns)) / numel(testAns)
    [C,order] = confusionmat(categorical(testAns), predLabelsTest);
    conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
    % change name if shuffled/unshuffled
    title = "MultiShuff Test " + subject + " for " + num + ...
        " nets Confusion Matrix " + i + " of " + splits;
    conf.Title = title;
    saveas(gcf, "Confusion Mats/Multi/" + title + ".jpg");
end

% go through validAns, pick most frequently chosen, get accuracy
disp("Cross Valid most frequent:");
ans = categorical(mode(validAns, 2));
accuracy = sum(ans == categorical(testAns)) / numel(testAns)
[C,order] = confusionmat(categorical(testAns), ans);
conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
% change name if shuffled/unshuffled
title = "MultiShuff Test Cross Final " + subject + " for " + num + ...
    " nets Confusion Matrix ";
conf.Title = title;
saveas(gcf, "Confusion Mats/Multi/" + title + ".jpg");