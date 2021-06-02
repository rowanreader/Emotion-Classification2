% run this before multiModel to generate new models/subject

% runs input thru num other models that don't belong to subject
% takes their output as input for final classification
function multiModelAns(num)
% num = 15; % any positive int less than 28 (number of nets)
nets = cell(num,1);
pts = 110000;
pts2 = 29984;
% get predictions on train data
preds = zeros(pts,num); % how many samples
% get predictions on test data
predsTest = zeros(pts2, num);
base = "D:/CISC 867/Nets/Filtered";
% pick networks and training subject
allSub = randperm(28); % random permutation of 28 numbers (how many subjects we had)
netSubs = allSub(1:num)
subject = allSub(num+1)

count = 1;
for i = netSubs
    load(base+i);
    nets{count} = originalNet;
    count = count + 1;
end
clear originalNet;
if subject < 10
    file = "D:/CISC 867/TestTrainUnshuffled/ProcessedData/S0" + subject + ".mat";
else
    file = "D:/CISC 867/TestTrainUnshuffled/ProcessedData/S" + subject + ".mat";
end
load(file);
% run through all nets, get accuracy
trainData = trainData(:,:,:,1:pts);
trainAns = trainAns(1:pts);
% go through all train answers, save these, they'll be used for training on
% k fold cross
for i = 1:num
    predLabelsTrain = nets{i}.classify(trainData);
    predLabelsTest = nets{i}.classify(testData);
    preds(:,i) = predLabelsTrain;
    predsTest(:,i) = predLabelsTest;
    % display answer
    disp(i);
    accuracy = sum(predLabelsTrain == categorical(trainAns)) / numel(trainAns)
    [C,order] = confusionmat(categorical(trainAns), predLabelsTrain);
    conf = confusionchart(C, {'Boring','Calm','Horror','Funny'});
    % change name if shuffled/unshuffled
    title = "MultiShuff " + subject + "-" + netSubs(i) + " Confusion Matrix";
    conf.Title = title;
    saveas(gcf, "Confusion Mats/Multi/" + title + ".jpg");
end

% for i = 1:pts
%    preds{i} = temp(i,:)'; 
% end
saveFile = "multiPreds.mat";
save(saveFile, 'preds', 'predsTest', 'file', 'pts', 'num', 'subject', '-v7.3');

