function [UVVis] = ImportFilesUVVis
% import a series of text files, specifically designed for UV-Vis files but
% generally applicable to other types of data


% Select folder of files to import
a = uigetdir;
% Get files from that folder
dirarray = dir(a);
% Iteration variable
aa = 1;

% find the files in that folder that you want
for i = 1:length(dirarray)
    if ~dirarray(i).isdir
        if ~isempty(findstr(dirarray(i).name,'.txt'))
            files{aa} = dirarray(i).name;
            aa = aa+1;
        end
    end
end

% number of samples to import
numberofsamples = length(files);



for i = 1:numberofsamples
    % Import File
    temp = importdata(strcat(a,'\',files{i}));
    % Get the data
    data = temp.data;
    indices = find(~isnan(data(:,2)));
    % Remove nan data points
    if isempty(indices)
        indices = 1;
    end
    templabel = strsplit(files{i},'.');
    
    % Make the output structures
    UVVis(i) = struct('Wavelengths',data(indices,1),'Absorption',...
        data(indices,2),'Label',templabel{1});
end

end