% applies deep CNN to test and training data
function myCNN()
% if funny = 1, use data from John Mulaney skit (actually funny)
% otherwise use data collected from watching the gameplay
funny = 1; 

% define architecture
layers = [
    % pretend its an image, 14 channels x 128*6 (each window is 6 secs)
    imageInputLayer([14 250*6 1])    
    convolution2dLayer([14 64], 128,'Padding','same')
    reluLayer 
    convolution2dLayer([1 64], 128,'Padding','same')
    reluLayer
    convolution2dLayer([1 128], 64,'Padding','same')
    reluLayer
    maxPooling2dLayer([1 4],'Stride',2)
    
    convolution2dLayer([1 128], 64,'Padding','same')
    reluLayer
    convolution2dLayer([1 128], 64,'Padding','same')
    reluLayer
    maxPooling2dLayer([1 4],'Stride',2)

    fullyConnectedLayer(128)
    reluLayer
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];

% automatically shuffles once before training
miniBatchSize = 64;
options = trainingOptions( 'sgdm',...
'MiniBatchSize', miniBatchSize,...
'InitialLearnRate', 0.00001,...
'MaxEpochs', 1,...
'ExecutionEnvironment', 'auto',...
'Plots', 'training-progress');

if funny == 0
   dir = "D:/CISC 867/MyTestTrain/myData1.mat";
else
    dir = "D:/CISC 867/MyTestTrain/myData2.mat";
end

load(dir);

net = trainNetwork(trainData, categorical(trainAns), layers, options);	

% save model
originalNet = net;
save originalNet;

predLabelsTest = net.classify(trainData);
accuracy = sum(predLabelsTest == categorical(trainAns)) / numel(trainAns)

[C,order] = confusionmat(categorical(trainAns), predLabelsTest);
conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
title = "Author's Training Confusion Matrix";
conf.Title = title;
saveas(gcf, title + ".jpg");