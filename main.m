% iterate through files, load, train, test, report
for i = 21:28
    if i < 10
%         temp = "D:/CISC 867/TestTrain/ProcessedData/S0" + i;
        % shuffled
        temp = "ProcessedData/S0" + i;
    else  
%         temp = "D:/CISC 867/TestTrain/ProcessedData/S" + i;
        temp = "ProcessedData/S" + i;
    end 
    CNN(temp, i);
end