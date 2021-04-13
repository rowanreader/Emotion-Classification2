% iterate through files, load, train, test, report
for i = 21  
    if i < 10
        temp = "D:/CISC 867/TestTrain/ProcessedData/S0" + i;
%         temp = "ProcessedData/S0" + i;
    else  
        temp = "D:/CISC 867/TestTrain/ProcessedData/S" + i;
%         temp = "ProcessedData/S" + i;
    end 
    CNN(temp, i);
%    CNNOrdered(temp, i); 
end