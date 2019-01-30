function [sa] = ImportMassTA(n)
% Imports a bunch of TA spectra and subtracts away n spectra

% Select a folder to import from

a = uigetdir;

dirarray = dir(a);

% iterator variable
aa = 1;

% Get files to import
for i = 1:length(dirarray)
    if ~dirarray(i).isdir
        files{aa} = dirarray(i).name;
        aa = aa+1;
    end
end

numberofsamples = length(files);


% Import all the files
for i = 1:numberofsamples
    templabel = strsplit(files{i},'.');
    temps = ImportTASpectraST(strcat(a,'\',files{i}),n);
    % All the structures in one array need to have the same fields, so we
    % need to create a dummy structure to add the label field to
    temps.label = templabel{1};
    % Make the structured array
    sa(i) = temps;
end

end