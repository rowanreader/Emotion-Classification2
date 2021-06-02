function averages

% 19 and 5 have astonishingly high accuracies
averages = cell(11, 4);

% others = [19, 2, 5, 8, 10, 12, 14, 16, 22, 23, 26];
others = [19, 2, 5];

[~, n] = size(others);
count = 1;
for i = others
    if i < 10
        temp = "S0" + i;
    else
        temp = "S" + i;
    end
    
    for j = 1:4
        file = "GAMEEMO/(" + temp + ")/Preprocessed EEG Data/.mat format/" + temp + "G" + j + "AllChannels.mat";
        load(file);
        electrodes = {AF3, AF4, F3, F4, F7, F8, FC5, FC6, O1, O2, P7, P8, T7, T8};
        holdAve = zeros(1,14);
        for k = 1:14
            holdAve(k) = mean(electrodes{k});
        end
        averages{count,j} = holdAve;
    end 
    count = count + 1;
end
% figure();
% plot averages
% x is electrode (1-14), y is value
% colour coded by person, diff shape by category (emotion)
colours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
toFill = zeros(14,1);
emotion = ["Bored", "Calm", "Horror", "Funny"];
for j = 1:4
    figure;
    for i = 1:n
        scatter(1:14, averages{i,j}, [], toFill+colours(i))
        hold on;
    end
    xlabel("Electrodes [AF3, AF4, F3, F4, F7, F8, FC5, FC6, O1, O2, P7, P8, T7, T8]")
    ylabel("Average");
    legend("Subject 19","Subject 2","Subject 5")
    str = "Average Value for each Electrode for " + emotion(j);
    title(str);
    saveas(gcf, str+".jpg");

end
% legend("Subject 19", "Subject 2", "Subject 5", "Subject 8", ...
% "Subject 10", "Subject 12", "Subject 14", "Subject 16", "Subject 20",...
% "Subject 23", "Subject 26");
