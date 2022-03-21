
% TEST CASE 1
disp('Test 1: Violin plot default options');
load carbig MPG Origin
Origin = cellstr(Origin);
figure
vs = violinplot(MPG, Origin);
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);

disp('Test 1 passed ok');

% TEST CASE 2
disp('Test 2: Test the plot ordering option');
grouporder={'USA','Sweden','Japan','Italy','Germany','France','England'};
    
figure;
vs2 = violinplot(MPG,Origin,'GroupOrder',grouporder);
disp('Test 2 passed ok');
xlim([0.5, 7.5]);

% TEST CASE 3
disp('Test 3: Test the numeric input construction mode');
figure
cats = categorical(Origin);
catnames = (unique(cats)); % this ignores categories without any data
catnames_labels = {};
thisData = NaN(length(MPG),length(catnames));
for n = 1:length(catnames)
    thisCat = catnames(n);
    catnames_labels{n} = char(thisCat);
    thisData(1:length(MPG(cats == thisCat)),n) = MPG(cats == thisCat);
end
vs3 = violinplot(thisData,catnames_labels);
xlim([0.5, 7.5]);
disp('Test 3 passed ok');

% TEST CASE 4
disp('Test 4: Test two sided violin plots. Japan is being compared.');
figure
C = colororder;
vs4 = violinplot({thisData,repmat(thisData(:,5),1,7)},catnames_labels,'ViolinColor',{C,C(5,:)},'ViolinAlpha',{0.3 0.3});
xlim([0.5, 7.5]);
disp('Test 4 passed ok');


%other test cases could be added here
