% iterate through files, load, train, test, report
for i = 20:28
    if i < 10
        temp = "ProcessedData/S0" + i;
    else  
        temp = "ProcessedData/S" + i;
    end 
   CNN(temp, i); 
end