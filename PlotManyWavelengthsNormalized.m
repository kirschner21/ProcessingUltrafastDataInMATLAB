function PlotManyWavelengthsNormalized(a,wavelength)
%  Plots normalized kinetics of TA data in structure s at wavelengths
%  wavelength

% make everything look nice
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');       
xlabel('Time (ps)')
ylabel('Normalized \DeltaA (a.u.)')
hold on

% preparing to plot
numwavelength = length(wavelength);
x = a.time;
leg{1} = '';

% plotting the data
for i = 1:numwavelength
    [~,w_index] = min(abs(wavelength(i)-a.wavelengths));
    y = a.sub(w_index,:);
    leg{i} = [num2str(round(10*a.wavelengths(w_index))/10) ' ps'];
    plot(x,Normalize(y),'Linewidth',2,'Color',ColorGenerator(numwavelength,i))
end
legend(leg)

end

