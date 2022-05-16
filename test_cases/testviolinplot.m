figure(); 
% One could use tiled layout for better plotting them but it would be
% incompatible with older versions
subplot(2,4,1); 

% TEST CASE 1
disp('Test 1: Violin plot default options');
load carbig MPG Origin
Origin = cellstr(Origin);
vs = violinplot(MPG, Origin);
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);
disp('Test 1 passed ok');

% TEST CASE 2
disp('Test 2: Test the plot ordering option');
grouporder={'USA','Sweden','Japan','Italy','Germany','France','England'};
    
subplot(2,4,2); 
vs2 = violinplot(MPG,Origin,'GroupOrder',grouporder);
disp('Test 2 passed ok');
xlim([0.5, 7.5]);

% TEST CASE 3
disp('Test 3: Test the numeric input construction mode');
subplot(2,4,3); 
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
subplot(2,4,4); 
C = colororder;
vs4 = violinplot({thisData,repmat(thisData(:,5),1,7)},catnames_labels,'ViolinColor',{C,C(5,:)},'ViolinAlpha',{0.3 0.3});
xlim([0.5, 7.5]);
disp('Test 4 passed ok');
% Todo: scatter goes in the other side

% TEST CASE 5
disp('Test 5: Test shadow for quartiles.');
subplot(2,4,5); 
vs5 = violinplot(MPG, Origin, 'qStyles','shadow');
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);
disp('Test 5 passed ok');

% TEST CASE 6
disp('Test 6: Test plotting only right side & bar plot, disable scatter.');
subplot(2,4,6); 
vs5 = violinplot(MPG, Origin, 'qStyles','boxplot', 'vHalf','right',...
    'scpltBool', false, 'barpltBool', true);
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);
disp('Test 6 passed ok');

% TEST CASE 7
disp('Test 7: Test plotting only left side & bar plot, and quartiles as boxplot.');
subplot(2,4,7); 
vs5 = violinplot(MPG, Origin, 'qStyles','shadow', 'vHalf','left',...
     'scpltBool', false,'barpltBool', true, 'ShowMean', true);
ylabel('Fuel Economy in MPG ');
xlim([0, 8]); 
disp('Test 7 passed ok');



%other test cases could be added here
