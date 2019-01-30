function PlotDAF(DAF)
% Plot weights from Decay Assosciated Fit

% set up figure
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');
fits = length(DAF.fittimes);
hold on

% plot it
leg{1} = '';
for i = 1:fits
    plot(DAF.w,DAF.weights(:,i),'Linewidth',2,'Color',ColorGenerator(fits+1,i))
    leg{i} = [num2str(round(10*DAF.fittimes(i))/10) ' ps'];
end
plot(DAF.w,DAF.weights(:,end),'Linewidth',2,'Color',ColorGenerator(fits+1,fits+1))
leg{fits+1} = 'Long Time';
xlabel('Wavelength (nm)')
xlim([min(DAF.w) max(DAF.w)])
ylabel('Weight (a.u.)')
legend(leg)


end

