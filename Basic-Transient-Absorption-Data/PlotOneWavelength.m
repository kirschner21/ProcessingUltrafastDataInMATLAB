function [x,y] = PlotOneWavelength(a,w)
%  Plots TA kinetics in structure s at wavelength w, outputs the data plot
    
% find appropriate wavelength and extract x,y data
[~,w_index] = min(abs(w-a.wavelengths));
x = a.time;
y = a.sub(w_index,:);

% plotting the data
figure1 = figure;
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');
hold on
plot(x,y,'Linewidth',2)
xlabel('Time (ps)')
ylabel('\DeltaA')
title([num2str(round(10*a.wavelengths(w_index))/10) ' nm'])

end

