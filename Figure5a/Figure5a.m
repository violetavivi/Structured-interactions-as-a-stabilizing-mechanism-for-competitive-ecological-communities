%%Figure 5 panel a
close all

purple = [151, 118, 134]/256;
orange = [245, 141, 66]/256;
sapphire =  [46, 114, 143]/256;
gray = .5*[1 1 1 1];

%% first load timeseries to inspect
load('RGG10000nodes_radius0.0220_term5e+07_epochs_5e+07_steps_1e+04_per0.900_conquestFactor_001.mat');
% this means:
% Network = RGG of  10000nodes and radius0.0220
% simulated during 5e+07 timesteps (one timestep = one death event), after a termalization of 5e+07 timesteps
% saving the densities every 1e+04 steps
% perturbation size = 90%
%conquestFactor isi just the counter

h4=figure;
set(h4,'PaperSize',[6.5 5]); %set the paper size to what you want
%%
filePattern = fullfile(pwd, ['RGG*per0.9*.mat']);
txtFiles = dir(filePattern);
nSpecies = 3;
%%
load(txtFiles(1).name);
meanDensity = density;
averageTimes = length(txtFiles)-1;
for k = 2:averageTimes
    load(txtFiles(k).name);
    meanDensity = density + meanDensity;
end

meanDensity = meanDensity/(k+1);


minPeakDistance = 40; % this value is chosen by looking at the first figure. Units = time a.u.
%perturbation occurs at t = 5000
[pksBEFORE,~] = findpeaks(meanDensity(4000:4999,1),'MinPeakDistance',minPeakDistance);
meanPksBEFORE = mean(pksBEFORE);
stdPksBEFORE = std(pksBEFORE);
[pksAFTER,locsAFTER] = findpeaks(meanDensity(5000:6000,1),'MinPeakDistance',minPeakDistance);
nnz(pksAFTER <= meanPksBEFORE + stdPksBEFORE);
%%


h = plot(meanDensity(5000:5500,2),'LineWidth',2.5);
h.HandleVisibility = 'off';
h.Color = [gray];
hold on
h = plot(meanDensity(5000:5500,3),'LineWidth',2.5);
h.HandleVisibility = 'off';
h.Color = [gray ];
hold on

h = plot(meanDensity(5000:5500,1),'LineWidth',4);
h.HandleVisibility = 'off';
h.Color = 'w';
hold on
h = plot(meanDensity(5000:5500,1),'LineWidth',2.5);
h.HandleVisibility = 'off';
h.Color = sapphire;

ss = scatter(locsAFTER,pksAFTER,100);
ss.Marker = 'x';
ss.MarkerFaceColor = 'w';
ss.MarkerEdgeColor = 'w';
ss.HandleVisibility = 'off';
ss.LineWidth = 4;
hold on
ss = scatter(locsAFTER,pksAFTER,100);
ss.Marker = 'x';
ss.MarkerFaceColor = sapphire;
ss.MarkerEdgeColor = [46, 114, 143]/256;
ss.HandleVisibility = 'off';
ss.LineWidth = 2;


f = fit(locsAFTER,pksAFTER,'exp2');
beta0 = [0.5 -0.005 0.4 1e-5];
mdl = fitnlm(locsAFTER,pksAFTER,@(b,x) b(1)*exp(b(2).*x) + b(3)*exp(b(4).*x) ,beta0)
pp = plot(f,locsAFTER,pksAFTER)
pp2 = pp(2);
pp2.Color = [255 26 26]/256;
pp2.LineWidth = 2;
pp2.LineStyle = '--';
pp1 = pp(1);
pp1.HandleVisibility = 'off';

xlim([0 500])
ylim([0 1])
xlabel('time (generations)')
ylabel('x(t)')
set(gca,'FontSize',15)
leg = legend('exp. decay');
leg.Box = 'off';
leg.FontSize = 14;

%%
print(h4,'fig_5a','-dpdf','-r300')
