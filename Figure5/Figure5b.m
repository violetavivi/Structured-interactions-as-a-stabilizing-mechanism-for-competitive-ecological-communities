%% Import data from text file.
close all
myFolder = pwd;
radiusVector = [0.022, 0.0292 0.0391, 0.0522 0.0696,  0.0928 0.1237,  0.165 0.22];
perturVector = [0.9];
iterations = 50;
extinctMatrix = zeros(length(radiusVector), length(perturVector));
timeMatrix = zeros(length(radiusVector), length(perturVector));
stdMatrix = zeros(length(radiusVector), length(perturVector));

degreeVector = [15.1713  26.711  47.9247 85.4380 151.0750  267.3166 469.5787   824.0463 1.4165e+03]; %manualy checked
for rr = 1:length(radiusVector)
    radius = num2str(radiusVector(rr));
    
    for pp = 1:length(perturVector)
        pertur = num2str(perturVector(pp));
        
        pattern = ['pulse*' radius '*' pertur '*.mat'];
        filePattern = fullfile(myFolder, pattern);
        txtFiles = dir(filePattern);
        aux = zeros(iterations,1);
        
        for kk = 1:length(txtFiles)
            baseFileName = txtFiles(kk).name;
            filename = fullfile(myFolder, baseFileName);
            load(baseFileName)
            
            extinctMatrix(rr,pp) = extinctMatrix(rr,pp) + extinct;
            if final_time < total_hypo_time + 1
                timeMatrix(rr,pp) = timeMatrix(rr,pp) + 1;
                aux(kk) = 1;
            end            
        end
        stdMatrix(rr,pp) = std(aux);
    end    
end

%% Plot figure
mycolors = [ 237, 106, 90]/256;
fig = figure;
fig.Position = [  680        1642         625 416];

X = log10(degreeVector);
b = bar(X,extinctMatrix/iterations,0.6);
hold on
for kk = 1:length(perturVector)
    b(kk).FaceColor = mycolors(kk,:);
    b(kk).EdgeColor = [ 1 1 1];
    
er = errorbar(X,extinctMatrix/iterations, 4*stdMatrix'/1e2);
er.LineStyle = 'none';
er.LineWidth = 1;
er.Color = [64, 71, 109]/256;
end

ylabel('Extinction prob.');
xlabel('Mean Degree, \langle k \rangle');
set(gca,'Fontsize',15)
ylim([0 1.02])
xlim([1, 3.3])
set(gca,'Xtick',1:3.5);
set(gca,'Xticklabel',10.^get(gca,'Xtick')); %// use labels with linear values

print(fig,'fig5b','-dpdf','-r300')