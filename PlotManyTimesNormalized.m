function PlotManyTimesNormalized(a,time,fw,lw)
%  Plots Normalized TA spectra s at times time

% make everything look nice
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');       
xlabel('Wavelength (nm)')
ylabel('Normalized \DeltaA (a.u.)')
hold on

% prepare things to be plotted
numtimes = length(time);
[fi,li] = DetermineIndices(a.wavelengths,fw,lw);
fi = min([fi,li]);
li = max([fi,li]);
x = a.wavelengths(fi:li);
leg{1} = '';

% actual plotting
for i = 1:length(time)
    [~,t_index] = min(abs(time(i)-a.time));
    y = Normalize(a.sub(fi:li,t_index));
    leg{i} = [num2str(round(10*a.time(t_index))/10) ' ps'];
    plot(x,Normalize(y),'Linewidth',2,'Color',ColorGenerator(numtimes,i))
end
legend(leg)

end

