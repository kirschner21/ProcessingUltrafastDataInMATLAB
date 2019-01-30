function [s] = ImportTASpectraST(filename,prezerospectra)
% Imports TA Data from Helios into a structured array
a = importdata(filename); %temporary array with all info from the dataset
time = a(1,2:length(a(1,:))); %time points
wavelengths = a(2:length(a(:,1)),1); %wavelength array
spectra = a(2:length(a(:,1)),2:length(a(1,:))); %TA spectra
subtractedspectra = SubtractPreZero(spectra,prezerospectra); %subtracting prezero data
s = struct('time',time,'wavelengths',wavelengths,'spectra',spectra,'sub',...
    subtractedspectra);
end

