function [] = PlotUVVisNorm(UVVis)
% plots UVVis data normalized to the maximum value in each spectra

% prepare the figure
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',18);
box(axes1,'on');
hold on

% plot the data
leg{1} = UVVis(1).Label;
for i = 1:length(UVVis)
plot(UVVis(i).Wavelengths,Normalize(UVVis(i).Absorption,'max'),'LineWidth',...
    2,'Color',ColorGenerator(length(UVVis),i))
leg{i} = UVVis(i).Label;
end
legend(leg)
xlabel('Wavelength (nm)')
ylabel('Absorbance')

end

