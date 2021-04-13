% applies deep CNN to ordered test and training data
% boring, calm, horror, funny
function CNNOrdered(temp, i)
% define architecture
layers = [
    % pretend its an image, 14 channels x 128*6 (each window is 6 secs)
    imageInputLayer([14 128*6 1])    
    convolution2dLayer([14 32], 128,'Padding','same')
    reluLayer 
    convolution2dLayer([1 32], 128,'Padding','same')
    reluLayer
    maxPooling2dLayer([1 2],'Stride',2)
    convolution2dLayer([1 64], 64,'Padding','same')
    reluLayer
    maxPooling2dLayer([1 2], 'Stride', 2)
    
    fullyConnectedLayer(128)
    reluLayer
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];
% 
%     'LearnRateDropFactor', 0.9,...
%     'LearnRateDropPeriod', 2,...
miniBatchSize = 128;
    options = trainingOptions( 'sgdm',...
    'MiniBatchSize', miniBatchSize,...
    'InitialLearnRate', 0.001,...
    'MaxEpochs', 5,...
    'ExecutionEnvironment', 'auto',...
    'Plots', 'training-progress');

% file to save data to
file = temp + ".mat";
load(file);
% now have trainData, trainAns, testData, testAns
% cut off to 110000

% calmTrain = trainData(1,:,:,:,:);
% boredTrain = trainData(2,:,:,:,:);
% horrorTrain = trainData(3,:,:,:,:);
% funnyTrain = trainData(4,:,:,:,:);

% calmTrainAns = trainAns(1,:);
% boredTrainAns = trainAns(2,:);
% horrorTrainAns = trainAns(3,:);
% funnyTrainAns = trainAns(4,:);

% calmTest = testData(1,:,:,:,:);
% boredTest = testData(2,:,:,:,:);
% horrorTest = testData(3,:,:,:,:);
% funnyTest = testData(4,:,:,:,:);

% calmTestAns = testAns(1,:);
% boredTestAns = testAns(2,:);
% horrorTestAns = testAns(3,:);
% funnyTestAns = testAns(4,:);


totalTrainData = [trainData(1,:,:,:,:); trainData(2,:,:,:,:);...
    trainData(3,:,:,:,:); trainData(4,:,:,:,:)];
totalTrainAns = [trainAns(1,:); trainAns(2,:);...
    trainAns(3,:); trainAns(4,:)];
clear trainData;
clear trainAns;
totalTestData = [testData(1,:,:,:,:); testData(2,:,:,:,:);...
    testData(3,:,:,:,:); testData(4,:,:,:,:)];
totalTestAns = [testAns(1,:); testAns(2,:); testAns(3,:); testAns(4,:)];
clear testData;
clear testAns;

net = trainNetwork(totalTrainData, categorical(totalTrainAns), layers, options);	

% test
predLabelsTest = net.classify(totalTestData);
% display answer
disp(i);
accuracy = sum(predLabelsTest == categorical(totalTestAns)) / numel(totalTestAns)

[C,order] = confusionmat(categorical(totalTestAns), predLabelsTest);
conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
title = "Ordered Subject " + i + " Confusion Matrix";
conf.Title = title;
saveas(gcf, title + ".jpg");

