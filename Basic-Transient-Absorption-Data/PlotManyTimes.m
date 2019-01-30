function PlotManyTimes(a,time)
%  Plots TA data in structure s at times time

% make everything look nice
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');       
xlabel('Wavelength (nm)')
ylabel('\DeltaA (\DeltaOD)')
hold on

% prepare things to be plot
numtimes = length(time);
x = a.wavelengths;
leg{1}='';

% actually plot the data
for i=1:length(time)
    [~,t_index] = min(abs(time(i)-a.time));
    y = a.sub(:,t_index);
    leg{i} = [num2str(round(10*a.time(t_index))/10) ' ps'];
    plot(x,y,'Linewidth',2,'Color',ColorGenerator(numtimes,i))
end
legend(leg)

end

