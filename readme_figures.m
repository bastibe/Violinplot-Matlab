clearvars
close all
clc

%% figure 1

load carbig MPG Origin
Origin = cellstr(Origin);
figure
vs = violinplot(MPG, Origin);
ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);

set(gcf,"Units","pixels","Position",[100 100 560 420])

% save results
exportgraphics(gcf,"example.png")

%% figure 2
close all
clear vs

C = colormap("jet");

grouporder={'England','Sweden','Japan','Italy','Germany','France','USA'};

% England (just a dot)
vs = Violin({MPG(strcmp(Origin,'England'))},1);

% Sweden (different Bandwidths)
vs = Violin({MPG(strcmp(Origin,'Sweden'))},2,...
    "HalfViolin","left",...
    "Bandwidth",3);

vs = Violin({MPG(strcmp(Origin,'Sweden'))},2,...
    "HalfViolin","right",...
    "Bandwidth",12);

% Japan (show quartiles)
vs = Violin({MPG(strcmp(Origin,'Japan'))},3,...
    'QuartileStyle','shadow',... % boxplot, none
    'ShowBox',true);

% Italy left: standard
vs = Violin({MPG(strcmp(Origin,'Italy'))},4,...
    'QuartileStyle','shadow',... % boxplot, none
    'ShowBox',true,...
    "HalfViolin","left");

% Italy right: change color, offset
vs = Violin({MPG(strcmp(Origin,'Italy'))-15},4,...
    'QuartileStyle','shadow',... % boxplot, none
    'ShowBox',true,...
    "HalfViolin","right",...
    "ViolinColor",{C(7,:)});


% Germany left: standard
vs = Violin({MPG(strcmp(Origin,'Germany'))},5,...
    'QuartileStyle','none',... % boxplot, none
    'DataStyle', 'none',... % scatter, histogram
    'ShowMean',true,...
    "HalfViolin","left");

% Germany histogram
vs = Violin({MPG(strcmp(Origin,'Germany'))},5,...
    'QuartileStyle','none',... % boxplot, none
    'DataStyle', 'histogram',... % scatter, histogram
    'ShowMean',true,...
    "HalfViolin","left");

% France histogram
vs = Violin({MPG(strcmp(Origin,'France'))},6,...
    'QuartileStyle','none',... % boxplot, none
    'DataStyle', 'histogram',... % scatter, histogram
    'ShowMean',false,...
    "HalfViolin","right");

% USA histogram and quartiles
vs = Violin({MPG(strcmp(Origin,'USA'))},7,...
    'QuartileStyle','shadow',... % boxplot, none
    'DataStyle', 'histogram',... % scatter, histogram
    'ShowMean',false,...
    "HalfViolin","right");

% set correct labels
set(gca,xticklabels=grouporder)

ylabel('Fuel Economy in MPG');
xlim([0.5, 7.5]);
set(gca,"XTickLabelRotation",30)

set(gcf,"Units","pixels","Position",[200 200 560 420])

% save results
exportgraphics(gcf,"example2.png")
