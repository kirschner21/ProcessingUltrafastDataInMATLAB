function EyeDAFS(s,a,ft,lt,numfig)
% visualize decay assosciated fits, s is data, a is fit, ft is the first
% time, lt is the last time, numfig is number of figures you want to
% visualize

% unpack the data
numfits = length(a.fittimes); %number of fits
lw = length(a.w); %number of wavelengths fit
numinds = floor(lw/numfig); %fits per figure
tfl = min(abs(ft));
tll = max(abs(lt));

% prepare the legend
leg{1} = 'Actual Data';
for i = 1:numfits
    leg{i+1} = num2str(a.fittimes(i));
end
leg{numfits+2} = 'Long time';
leg{numfits+3} = 'Total fit';

% resample the data so it matches up with the sampling rate used in the fit
for i = 1:length(s.wavelengths)-a.samplingrate
    temp(i) = mean(s.wavelengths(i:i-1+a.samplingrate));
end
initialw = find(temp == a.w(1));
oiw = round((a.w(1)-initialw)/a.samplingrate)+1;
values = initialw:numinds*a.samplingrate:initialw+(lw-1)*a.samplingrate;

% making the actual plots
for j = 1:numfig;
    i = values(j);
    
    % initialize the fit to be built
    tempfit = 0;
    
    % plot the data
    figure
    semilogx(s.time,mean(s.sub(i:i+numinds*a.samplingrate-1,:)),...
        'Linewidth',2,'Color','Black')
    xlim([tfl tll])
    hold on
    
    % plot each fit individually
    for j = 1:numfits
        
        % reset a variable which will be used to calculate the fit from a
        % single exponential decay
        tempfita = zeros(1,length(s.time));
        
        % build single exponential decay
        for k = i:i+numinds*a.samplingrate-1
            % add the fit at each index, needs to be done as each figure
            % consists of the average of fits at multiple wavelengths
            tempfitb = a.weights(floor((k-initialw)/a.samplingrate)+1,j)...
                *exp(-s.time/a.fittimes(j));
            tempfita = tempfita+tempfitb/(numinds*a.samplingrate);
        end
        
        % plot that fit and add it to the overall fit being built
        plot(s.time,tempfita,'Linewidth',2,'Color',ColorGenerator(numfits+1,j))
        tempfit = tempfit+tempfita;
    end
    
    % here we add in the offset term
    tempfita=0;
    for k = i:i+numinds*a.samplingrate-1
        tempfitb = a.weights(floor((k-initialw)/a.samplingrate)+1,numfits+1)...
            *ones(1,length(s.time));
        tempfita = tempfita+tempfitb/(numinds*a.samplingrate);
    end
    
    
    tempfit = tempfit+tempfita;
    plot(s.time,tempfita,'Linewidth',2,'Color',ColorGenerator(numfits+1,numfits+1))
    
    %plot the total fit
    plot(s.time,tempfit,'Linewidth',3,'Color','g','Linestyle','--')
    title([num2str(s.wavelengths(i)) ' nm'])
    legend(leg)
    xlabel('Wavelength (nm)')
    ylabel('\DeltaA (\DeltaOD)')
    
end

end
