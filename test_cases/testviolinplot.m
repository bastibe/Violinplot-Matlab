
% TEST CASE 1
display('Test 1: Violin plot default options');
load carbig MPG Origin
Origin = cellstr(Origin);
figure
vs = violinplot(MPG, Origin);
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);

display('Test 1 passed ok');

% TEST CASE 2
display('Test 2: Test the plot ordering option');
grouporder={'USA','Sweden','Japan','Italy','Germany','France','England'};
    
figure;
vs2 = violinplot(MPG,Origin,'GroupOrder',grouporder);
display('Test 2 passed ok');

%other test cases could be added here
