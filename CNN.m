% for GAMEEMO dataset
% applies deep CNN to test and training data
function CNN(temp, i)
% define architecture
layers = [
    % pretend its an image, 14 channels x 128*6 (each window is 6 secs) x 1 
    imageInputLayer([14 128*6 1])    
    convolution2dLayer([14 32], 128,'Padding','same')
    reluLayer 
    convolution2dLayer([1 32], 128,'Padding','same')
    reluLayer
    convolution2dLayer([1 64], 64,'Padding','same')
    reluLayer
    maxPooling2dLayer([1 2],'Stride',2)
     
    fullyConnectedLayer(128)
    reluLayer
    
    % output layer - 4 emotions
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];
% 
%     'LearnRateDropFactor', 0.9,...
%     'LearnRateDropPeriod', 2,...

% automatically shuffles once before training
miniBatchSize = 256;
options = trainingOptions( 'sgdm',...
'MiniBatchSize', miniBatchSize,...
'InitialLearnRate', 0.001,...
'MaxEpochs', 1,...
'ExecutionEnvironment', 'auto',...
'Plots', 'training-progress');

% file to load data from
% shuffled
% file = "TestTrain/" + temp + ".mat";
% non shuffled
file = temp + ".mat";
load(file);
% now have trainData, trainAns, testData, testAns
% cut off to 110000
% ONLY FOR SHUFFLED - IF NOT, HAVE TO USE EVERYTHING
% testData1 = trainData(:,:,:,40001:end);
% testAns1 = trainAns(40001:end);
% trainData = trainData(:,:,:,1:40000);
% trainAns = trainAns(1:40000);


net = trainNetwork(trainData, categorical(trainAns), layers, options);	

% test
predLabelsTest = net.classify(testData);
% display answer
disp(i);
accuracy = sum(predLabelsTest == categorical(testAns)) / numel(testAns)


% generate confusion matrix
[C,order] = confusionmat(categorical(testAns), predLabelsTest);
conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
% change name if shuffled/unshuffled
title = "Unshuffled " + i + " Confusion Matrix";
conf.Title = title;
saveas(gcf, title + ".jpg");

