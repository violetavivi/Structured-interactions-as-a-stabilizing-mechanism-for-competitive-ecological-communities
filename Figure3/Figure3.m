%% Figure 3
% Uses function boundedline from: https://www.mathworks.com/matlabcentral/fileexchange/27485-boundedline-m
h4=figure;
set(h4,'PaperSize',[6 4.5]); %set the paper size to what you want  
%% Erdos Renyi
load MEAN_areas_ER.mat
load measuresER.mat
myColor = [93, 178, 232]./256;

bounds = [stdAreas95 stdAreas95];

[pointsP,transpP] = boundedline(kArray,meanAreas95,bounds,'-','alpha');
transpP.FaceColor = myColor;
pointsP.Color = myColor;
pointsP.LineWidth = 1.5;
poinstP.MarkerEdgeColor = 'w';
hold on 
simuP_ER = plot(kArray,meanAreas95,'-^');
simuP_ER.Color = myColor;
simuP_ER.MarkerFaceColor = myColor;
simuP_ER.MarkerEdgeColor = [1 1 1];
simuP_ER.MarkerSize = 8;
hold on
%% 2D lattice
load measuresCVN.mat
load  MEAN_areas_CVN.mat

myColor = [77, 186, 94]/256;

 bounds = [stdAreas95 stdAreas95];
[pointsP,transpP] = boundedline(kArray,meanAreas95,bounds,'-','alpha');
transpP.FaceColor = myColor;
poinstP.MarkerEdgeColor = 'w';
pointsP.Color = myColor;
pointsP.LineWidth = 1.5;

hold on 
simuP_CVN = plot(kArray,meanAreas95,'-s');
simuP_CVN.Color = myColor;
simuP_CVN.MarkerFaceColor = myColor;
simuP_CVN.MarkerEdgeColor = [1 1 1];
simuP_CVN.MarkerSize = 7;
hold on

%% RGG
load measuresRGG.mat
load MEAN_areas_RGG.mat
myColor = [237, 156, 168]/256;

kArray(16) = [];
kArray(1) = [];

bounds = [stdAreas95 stdAreas95];
[pointsP,transpP] = boundedline(kArray,meanAreas95,bounds,'-','alpha');
transpP.FaceColor = myColor;
pointsP.Color = myColor;
pointsP.LineWidth = 1.5;
poinstP.MarkerEdgeColor = 'w';
hold on 
simuP_RGG = plot(kArray,meanAreas95,'-o');
simuP_RGG.Color = myColor;
simuP_RGG.MarkerFaceColor = myColor;
simuP_RGG.MarkerEdgeColor = [1 1 1];
simuP_RGG.MarkerSize = 7;
hold on

%%
xlabel('Mean Degree, \langle k \rangle','FontName','Helvetica')
ylabel('Area in simplex','FontName','Helvetica')
set(gca,'FontSize',15)
set(gca,'XScale','log')
l = legend([simuP_ER, simuP_RGG, simuP_CVN],'Erdös-Rényi','RGG','2D-lattice','Location','southeast');
l.Box = 'off';
l.FontName = 'Helvetica';

ylim([0,0.87])
box on
%% ---------------------------------------
print(h4,'fig_3','-dpdf','-r300')