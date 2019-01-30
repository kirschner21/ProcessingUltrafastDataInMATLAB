function [output] = DecayAssosciatedFit(s,fw,lw,ft,lt,initialguesses,samplingrate)
% Decay assosciated fit s=structure element, fw first wavelength, lw last
% wavelength, ft first time, lt last time, initialguesses initial fit
% conditions, samplingrate reduces the wavelengths fit to make more
% computationally tractable

% set up the wavelengths and times fit
[wfi,wli] = DetermineIndices(s.wavelengths,fw,lw);
[tfi,tli] = DetermineIndices(s.time,ft,lt);
wfi = min([wfi,wli]);
wli = max([wfi,wli]);
tfi = min([tfi,tli]);
tli = max([tfi,tli]);

% number of wavelengths and exponential fits
nwavelengths = floor((wli-wfi)/samplingrate)+1;
numfits = size(initialguesses,1);

% fit options can be modified
options = optimset('MaxIter',10000,'MaxFunEvals',10000,'TolX',1e-28,'TolFun',1e-24);

% initialize iterator
jj = 1;

% make X data and y data with dsid being dataset id
for i = wfi:samplingrate:wli
    for j = tfi:tli
        T(jj) = s.time(j);
        Y(jj) = nanmean(s.sub(i:i+samplingrate-1,j));
        dsid(jj) = (i-wfi)/samplingrate+1;
        jj = jj+1;
    end
end

% create initial guess arrays
for i = 1:numfits
    lb(i) = initialguesses(i,1);
    guessfit(i) = initialguesses(i,2);
    ub(i) = initialguesses(i,3);
end

% set initial values for prefactors and offsets
for i = 1:nwavelengths
    for j = 0:numfits-1
        guessfit(numfits+nwavelengths*j+i) = 1;
        lb(numfits+nwavelengths*j+i) = -Inf;
        ub(numfits+nwavelengths*j+i) = Inf;
    end
    guessfit(numfits+nwavelengths*numfits+i) = 0;
    lb(numfits+nwavelengths*numfits+i) = -Inf;
    ub(numfits+nwavelengths*numfits+i) = Inf;
end

% combine into a single variable
X = [T' dsid'];

% the actual fitting
[ahat,~,residual,~,~,~,jac] = lsqcurvefit(@subDAFN,guessfit,X,Y,lb,ub,options);

% calculates confidence interval, can eat up a lot of memory, make sure
% you're not fitting too many wavelengths at the same time or your computer
% will crash
ci = nlparci(ahat,residual,'jacobian',jac);

% unpack the fit
for i = 1:nwavelengths
    for j = 0:numfits
        bigd(i,j+1) = ahat(numfits+nwavelengths*j+i);
    end
    w(i) = mean(s.wavelengths(wfi+(i-1)*samplingrate:wfi+(i)*samplingrate-1));
end

% put it in a structure
output = struct('fittimes',ahat(1:numfits),'confint',abs(ci(1:numfits,1)'-...
    ahat(1:numfits)),'weights',bigd,'w',w,'samplingrate',samplingrate);

end