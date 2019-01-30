function [subtracted_spectra] = SubtractPreZero(spectra,number_of_prezero_spectra)
% Subtracts out prezero spectra

% find average pretimezero point
prezero = nanmean(spectra(:,1:number_of_prezero_spectra),2);

% subtract it
subtracted_spectra = spectra-prezero*ones(1,size(spectra,2));
end