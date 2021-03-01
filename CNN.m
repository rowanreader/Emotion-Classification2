% applies deep CNN to test and training data
function CNN
% define architecture
layers = [
    % pretend its an image, 14 channels x 
    imageInputLayer([14 128 1])    
    convolution2dLayer([1 5],128,'Padding','same')
    reluLayer    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer([1 5],64,'Padding','same')
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer([1 5],64,'Padding','same')
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    
    fullyConnectedLayer(128)
    softmaxLayer
    % number of classes
%     fullyConnectedLayer(100)
%     softmaxLayer
    
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];


% iterate through files, load, train, test, report
for i = 1:28
    if i < 10
        temp = "ProcessedData/S0" + i;
    else
        temp = "ProcessedData/S" + i;
    end 
    % file to save data to
    file = "TestTrain/" + temp + ".mat";
    load(file);
    % now have trainData, trainAns, testData, testAns
    
    miniBatchSize = 1000;
    options = trainingOptions( 'sgdm',...
    'MiniBatchSize', miniBatchSize,...
    'InitialLearnRate', 0.001,...
    'MaxEpochs',10,...
    'ExecutionEnvironment', 'auto',...
    'Plots', 'training-progress');

    net = trainNetwork(trainData, categorical(trainAns), layers, options);	
    
    % test
    predLabelsTest = net.classify(testData);
    % display answer
    disp(i);
    accuracy = sum(predLabelsTest == categorical(testAns)) / numel(testAns)
end