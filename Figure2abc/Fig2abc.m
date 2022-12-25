clc
clearvars
close all
purple = [151, 118, 134]/256;
orange = [245, 141, 66]/256;
sapphire =  [23, 98, 131]/256;
%% small
load( 'smalltimeseries_RGG10000nodes_radius0.0220_term2e+07_epoch_3e+07.mat') %density

figure('Position',[200 200 446 143])
h = plot(density,'LineWidth',1.5); 
h(1).Color = purple;
h(1).LineWidth = 2.5;
h(2).Color = orange;
h(2).LineWidth = 2.5;
h(3).Color = sapphire;
h(3).LineWidth = 2.5;

ylim([0 1])
xlabel('time (generations)')
ylabel('x(t)')
set(gca,'FontSize',14)
set(gca,'YTickLabel',{'0' '1'},'YTick',[0 1])
set(gca,'XTickLabel',{'0' '250' '500'},'XTick',[0 250 500])
% print('fig2c','-dpng','-r300')
%% all2all
load('ALLtoALLtimesries_RGG10000nodes__term2e+06_epoch_3e+07_1.mat')

figure('Position',[200 200 446 143])
h = plot(density','LineWidth',1.5);
h(1).Color = purple;
h(1).LineWidth = 2.5;
h(2).Color = orange;
h(2).LineWidth = 2.5;
h(3).Color = sapphire;
h(3).LineWidth = 2.5;

ylim([0 1])
xlabel('time (generations)')
ylabel('x(t)')
set(gca,'FontSize',14)
set(gca,'YTickLabel',{'0' '1'},'YTick',[0 1])
set(gca,'XTickLabel',{'0' '250' '500'},'XTick',[0 250 500])
% print('fig2b','-dpng','-r300')
%% large
load('largetimeseries_d10000_radius0_1500.mat')

figure('Position',[200 200 446 143])
h = plot(density,'LineWidth',1.5);
h(1).Color = purple;
h(1).LineWidth = 2.5;
h(2).Color = orange;
h(2).LineWidth = 2.5;
h(3).Color = sapphire;
h(3).LineWidth = 2.5;

ylim([0 1])
xlabel('time (generations)')
ylabel('x(t)')
set(gca,'FontSize',14)
set(gca,'YTickLabel',{'0' '1'},'YTick',[0 1])
set(gca,'XTickLabel',{'0' '250' '500'},'XTick',[0 250 500])
% print('fig2a','-dpng','-r300')