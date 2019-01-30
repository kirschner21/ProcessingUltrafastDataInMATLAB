function yfit = subDAFN(params,X)
% function for decay assosciated fit

% unpack x data
T = X(:,1);        % time
dsid = X(:,2);     % dataset id

% determine how many exponential fits are fit at how many wavelengths
wavelengths = max(dsid);
decays = floor(length(params)/wavelengths)-1;

% prepare all the fit parameters
for i = 1:decays
    Td(i) = params(i);
    A(i,:) = params(1+decays+wavelengths*(i-1):decays+wavelengths*i)'; % different A1 for each dataset
end
Offset = params(decays+1+wavelengths*(decays):decays+(wavelengths*(decays+1)))';

% build the fit
yfit = 0;
for i = 1:decays
yfit = yfit + A(i,dsid).*exp(-T./Td(i))';
end
% include the offset term
yfit = yfit+Offset(dsid)';

end
