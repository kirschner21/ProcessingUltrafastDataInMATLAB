function [x,y] = PlotOneTime(a,time)
%  Plots TA spectra in structure s at a single time, outputs the data plot
    
% find appropriate time and extract x,y data
[~,t_index] = min(abs(time-a.time));
x = a.wavelengths;
y = a.sub(:,t_index);
    
% plotting the data
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');
hold on
plot(x,y,'Linewidth',2)
xlabel('Wavelength (nm)')
ylabel('\DeltaA (\DeltaOD)')
title([num2str(round(10*a.time(t_index))/10) ' ps'])
    
end

