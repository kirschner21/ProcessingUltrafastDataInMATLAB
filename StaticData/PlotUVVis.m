function [] = PlotUVVis(UVVis)
% Plots imported UVVis data

% prepare the figure
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',18);
box(axes1,'on');
hold on

% plots the data
leg{1} = UVVis(1).Label;
for i = 1:length(UVVis)
plot(UVVis(i).Wavelengths,((UVVis(i).Absorption)),'LineWidth',2,'Color',...
    ColorGenerator(length(UVis),i))
leg{i} = UVVis(i).Label;
end
legend(leg)
xlabel('Wavelength (nm)')
ylabel('Absorbance')

end

