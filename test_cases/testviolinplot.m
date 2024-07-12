function testviolinplot()
figure(); 
% One could use tiled layout for better plotting them but it would be
% incompatible with older versions
subplot(2,4,1); 

% TEST CASE 1
disp('Test 1: Violin plot default options');
load carbig MPG Origin
Origin = cellstr(Origin);
vs = violinplot(MPG, Origin);
plotdetails(1);

% TEST CASE 2
disp('Test 2: Test the plot ordering option');
grouporder={'USA','Sweden','Japan','Italy','Germany','France','England'};
    
subplot(2,4,2); 
vs2 = violinplot(MPG,Origin,'GroupOrder',grouporder);
plotdetails(2);

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
plotdetails(3);

% TEST CASE 4
disp('Test 4: Test two sided violin plots. Japan is being compared.');
subplot(2,4,4); 
C = colororder;
vs4 = violinplot({thisData,repmat(thisData(:,5),1,7)},catnames_labels,'ViolinColor',{C,C(5,:)},'ViolinAlpha',{0.3 0.3}, 'ShowMean', true, 'MarkerSize',8);
plotdetails(4);

% TEST CASE 5
disp('Test 5: Test shadow for quartiles.');
subplot(2,4,5); 
vs5 = violinplot(MPG, Origin, 'QuartileStyle','shadow');
plotdetails(5);

% TEST CASE 6
disp('Test 6: Test plotting only right side & histogram plot, with quartiles as boxplot.');
subplot(2,4,6); 
vs6 = violinplot(MPG, Origin, 'QuartileStyle','boxplot', 'HalfViolin','right',...
    'DataStyle', 'histogram');
plotdetails(6);

% TEST CASE 7
disp('Test 7: Test plotting only left side & histogram plot, and quartiles as shadow.');
subplot(2,4,7); 
vs7 = violinplot(MPG, Origin, 'QuartileStyle','shadow', 'HalfViolin','left',...
     'DataStyle', 'histogram', 'ShowMean', true);
plotdetails(7);


% TEST CASE 8
disp('Test 8: Same as previous one, just removing the data of half of the violins afterwards.');
subplot(2,4,8); 
vs8 = violinplot([MPG; 5;5;5;5;5], [Origin; 'test';'test';'test';'test';'test'], 'QuartileStyle','shadow', 'HalfViolin','full',...
     'DataStyle', 'scatter', 'ShowMean', false);
plotdetails(8);
for n= 1:round(length(vs8)/2)
    vs8(1,n).ShowData = 0;
end
xlim([0, 9]);

% TEST CASE 9
disp('Test 9: Test parent property.');
figure
for i = 1:4
    ax(i) = subplot(2,2,i);
end
vs9 = violinplot(MPG, Origin,'parent',ax(3));
title(ax(3),sprintf('Test %02.0f \n',9));
ylabel(ax(3),'Fuel Economy in MPG ');
xlim(ax(3),[0, 8]);
grid(ax(3),'minor');
set(ax(3), 'color', 'none');
xtickangle(ax(3),-30);
fprintf('Test %02.0f passed ok! \n ',9);

% TEST CASE 10
disp('Test 10: Test of axis orientation.');
vs10 = violinplot(MPG, Origin,'parent',ax(2),'Orientation','horizontal');
title(ax(2),sprintf('Test %02.0f \n',10));
xlabel(ax(2),'Fuel Economy in MPG ');
ylim(ax(2),[0, 8]);
grid(ax(2),'minor');
set(ax(2), 'color', 'none');
ytickangle(ax(2),0);
fprintf('Test %02.0f passed ok! \n ',10);

%other test cases could be added here
end 

function plotdetails(n)
title(sprintf('Test %02.0f \n',n));
ylabel('Fuel Economy in MPG ');
xlim([0, 8]); grid minor;
set(gca, 'color', 'none');
xtickangle(-30);
fprintf('Test %02.0f passed ok! \n ',n);
end

