%% Import vector path from .mat file.

load('largetimeseries_d10000_radius0_1500.mat') %density
tot = length(density);
maxColor = 3;
minColor = 1;
%% Plotting simplex

density = double(density.');
    colorVectorTime = linspace(minColor,maxColor,length(density(1,:)));
    
    f = figure;
    grid off
    set(gca,'DataAspectRatio',[1 1 1])
    axis off
    
    view([1 1 1])
    hold on
    
    ff= plot3([1,0,0,1],[0,1,0,0],[0,0,1,0],'k');
    ff.LineWidth = 0.25;
    
    ax = gca;
    ax.YRuler.FirstCrossoverValue  = 0;
    ylh = ylabel('species 2');
    ylh.Position(2) = ylh.Position(2) + abs(ylh.Position(2) * 8.5);
    ylh.Position(1) = ylh.Position(1) -  abs(ylh.Position(1) * 7);
    hold on
    
h = scatter3(density(1,:),density(2,:),density(3,:),15,colorVectorTime,'filled');

    
    hold on
   ss =  scatter3(0.38,0.39,0.25,25,'MarkerEdgeColor','k',...
        'MarkerFaceColor','k','MarkerFaceAlpha',1,'Marker','x');
    ss.LineWidth = 0.5;
    colormap(parula(length(colorVectorTime)))
    c = colorbar('Ticks',[1,2.998],...
         'TickLabels',{'0','500'});
     c.Label.String = 'time (generations)';
     set(gca,'Fontsize',14)
      print('fig_2e','-dpng','-r300')
