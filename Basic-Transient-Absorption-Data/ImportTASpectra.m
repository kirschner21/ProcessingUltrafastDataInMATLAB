function [time,wavelengths,spectra] = ImportTASpectra(filename)
% Imports TA Data not in a structure
a = importdata(filename);
time = a(1,2:length(a(1,:)));
wavelengths = a(2:length(a(:,1)),1);
spectra = a(2:length(a(:,1)),2:length(a(1,:)));

end
