%%FIGURE 6
h4=figure;
set(h4,'PaperSize',[6.5 4]); %set the paper size to what you want  
%% LONG
% Import vector path from .mat file.
myFolder = pwd;
filePatternSCA = fullfile(myFolder, 'scalingM*.mat');
txtFilesSCA = dir(filePatternSCA);

filePatternMEAS = fullfile(myFolder, 'measuresRGG*.mat');
txtFilesMEAS = dir(filePatternMEAS);


range = 500; 
kTarget = 1000; 
names = {'long-range'};
colorVector = [158, 102, 0]/255;
scaSaved = cell(1,length(range));
N = zeros(length(txtFilesSCA),1);

for ii = 1:length(range)
    for k = 2:length(txtFilesSCA)
        % Uploading
        baseFileNameSCA = txtFilesSCA(k).name;
        load(baseFileNameSCA) %radius, scaling
        
        baseFileNameMEAS = txtFilesMEAS(k).name;
        load(baseFileNameMEAS) %radius, k,gc,cc
        N(k) = str2double(baseFileNameSCA(end-8:end-3));
        
        cond = kTarget(ii) - range(ii) <= kArray & kArray <= kTarget(ii) + range(ii);
        idx = find(cond);
        if ~isempty(idx)
            scaSaved{ii}(k) = scaling(idx(1));
        else
            scaSaved{ii}(k) = 0;
        end
        kArray(idx)
    end
    
    N(scaSaved{ii} == 0) = [];
    scaSaved{ii}(scaSaved{ii} == 0) = [];
    if ~isempty(scaSaved{ii})      
        ajuste = polyfit(log(N),log(scaSaved{ii}).',1);
        z = polyval(ajuste,log(N));
        pp = loglog(N,exp(z));
        pp.Color = colorVector(ii,:);
        pp.LineWidth = 1.5;
        pp.HandleVisibility = 'off';
        hold on
        
        p = loglog(N,scaSaved{ii},'s','DisplayName',sprintf('%s (%d \xb1 %d)',names{ii},kTarget(ii),range(ii)));
        p.Color = 'w';
        p.MarkerSize = 10;
        p.HandleVisibility = 'off';
        hold on  
        
        p = loglog(N,scaSaved{ii},'o','DisplayName',sprintf('%s (%d \xb1 %d)',names{ii},kTarget(ii),range(ii)));
        p.Color = colorVector(ii,:);
        p.MarkerEdgeColor = colorVector(ii,:);
        p.MarkerSize = 8;
        hold on  
    end
   
end
%% SHORT
filePatternSCA = fullfile(myFolder, 'scalingM*.mat');
txtFilesSCA = dir(filePatternSCA);

filePatternMEAS = fullfile(myFolder, 'measuresRGG*.mat');
txtFilesMEAS = dir(filePatternMEAS);

lineFit = @(c,x) c(1)*(log(x.')) + c(2);
c0 = [-0.5 1];
%
range = 2; 
kTarget = 15; 
names = {'short-range'};
colorVector = [255,165,0]/255;
kSaved = cell(1,length(range));
N = zeros(length(txtFilesSCA),1);

for ii = 1:length(range)
    for k = 2:length(txtFilesSCA)
        % Uploading
        baseFileNameSCA = txtFilesSCA(k).name;
        load(baseFileNameSCA) %radius, scaling
        
        baseFileNameMEAS = txtFilesMEAS(k).name;
        load(baseFileNameMEAS) %radius, k,gc,cc
        
        N(k) = str2double(baseFileNameSCA(end-8:end-3));
        
        if k == length(txtFilesSCA) || k == length(txtFilesSCA)-1
            scaling = scaling/0.37;             %forgot to divide by the mean density
        end
        cond = kTarget(ii) - range(ii) <= kArray & kArray <= kTarget(ii) + range(ii);
        idx = find(cond);
        if ~isempty(idx)
            kSaved{ii}(k) = scaling(idx(1));
        else
            kSaved{ii}(k) = 0;
        end
        kArray(idx)
    end
    
    N(kSaved{ii} == 0) = [];
    kSaved{ii}(kSaved{ii} == 0) = [];
    if ~isempty(kSaved{ii})
         ajuste = polyfit(log(N),log(kSaved{ii}).',1);
        z = polyval(ajuste,log(N));
        pp = loglog(N,exp(z));
        pp.Color = colorVector(ii,:);
        pp.LineWidth = 1.5;
        pp.HandleVisibility = 'off';
        hold on
        
        p = loglog(N,kSaved{ii},'o','DisplayName',sprintf('%s (%d \xb1 %d)',names{ii},kTarget(ii),range(ii)));
        p.Color = 'w';
        p.MarkerFaceColor = 'w';
        p.MarkerSize = 10;
        p.HandleVisibility = 'off';
        hold on
        
        p = loglog(N,kSaved{ii},'o','DisplayName',sprintf('%s (%d \xb1 %d)',names{ii},kTarget(ii),range(ii)));
        p.Color = colorVector(ii,:);
        p.MarkerFaceColor = colorVector(ii,:);
        p.MarkerSize = 8;
       
    end
end
hold on
text(1,1,'-0.47')
%%
ff = gcf;
ff.Position = [898 329 588 334];
ylabel({'fluctuations'' size,';'\sigma_1 / \langle x_1 \rangle'},'FontSize',16)
xlabel('system size, N','FontSize',15)
set(gca,'FontSize',15)
legend('long range','short range','Location','southwest','Box','off','FontSize',13)

print(h4,'fig_6','-dpdf','-r300')