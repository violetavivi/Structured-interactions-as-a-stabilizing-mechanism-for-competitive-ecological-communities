%% Import data from text file.
close all
myFolder = [pwd '/data'];
filePattern = fullfile(myFolder, 'pulse*0.90*.txt'); 
txtFiles = dir(filePattern);
%%
for k = 1:length(txtFiles)
    baseFileName = txtFiles(k).name;
    filename = fullfile(myFolder, baseFileName);
    %% Format for each line of text:
    %   column1: double (%f)
    %	column2: double (%f)
    %   column3: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%f %f %f%[^\n\r]';
    %% Open the text file.
    fileID = fopen(filename,'r');
    %% Read columns of data according to the format.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
    %% Close the text file.
    fclose(fileID);
    %% Create output variable
    abundance = [dataArray{1:end-1}];
    name = [baseFileName(1:end-4) '.mat'];    
    
    final_time = length(abundance)
    extinct = nnz(abundance(end,:)) ~= 3;
    if sum(abundance(end,:) > 1) % no he dividido por nTrees al guardar
        abundance(end,:) = abundance(end,:)/1e4;
    end
    final_abun = abundance(end,:);
    pulse_time = str2double(baseFileName(38:42))/str2double(baseFileName(63:67));
    total_hypo_time = (str2double(baseFileName(38:42)) + str2double(baseFileName(51:55)))/str2double(baseFileName(63:67));
    save(name,'final_abun','extinct','final_time','pulse_time','total_hypo_time')
    %% Clear temporary variables
    clearvars formatSpec fileID dataArray ans;
    %% Ploting
%     tot = length(abundance);
%     figure
%     h = plot(1:tot, abundance,'LineWidth',1.5);
%     title(name(28:32))
    
end