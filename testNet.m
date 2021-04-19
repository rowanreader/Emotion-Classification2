% for my EEG data
% loads saved NN and classifies test data
% saves confusion matrix, prints accuracy
function testNet

load("originalNet.mat") % neural net
load("D:/CISC 867/MyTestTrain/myTestData2.mat"); % data to be classified

newAns = originalNet.classify(testData);
accuracy = sum(newAns == categorical(testAns)) / numel(testAns)

[C,order] = confusionmat(categorical(testAns), newAns);
conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
title = "Author's Test Confusion Matrix";
conf.Title = title;
saveas(gcf, title + ".jpg");

