function  DynamicSurface(a,tl,wl)
%This is a matlab version of ufs surface explorer, a is the structured
%array, tl is the time range, wl is the wavelength range


% make a new figure and establish the handle for that figure
figure1 = figure;
% making the new figure a subplot
subplot(2,2,1)
% generating the initial 2D map
surfTAtemp(a,figure1,tl,wl)
% initializing the while loop
button = 1;

while button == 1;
    % making the input come from the 2D map
    subplot(2,2,1)
    % select a time and a wavelength
    [t_pull,w1_pull,button] = ginput(1);
    % if not left clicked, exits the loop
    if button ~= 1
         break
    end
    % reset the 2D map
    surfTAtemp(a,figure1,tl,wl)    
    hold on
    % makes lines to show you the time and wavelength selected
    plot3([t_pull t_pull],[min(wl) max(wl)], [10 10],'LineWidth',2,'Color',[.5 .5 .5],'LineStyle','-')
    plot3([min(tl) max(tl)],[w1_pull w1_pull], [10 10],'LineWidth',2,'Color',[.5 .5 .5],'LineStyle','-')
    % allow you to reset 2D map
    hold off
    
    % find time closest to time selected
    [~,t_index] = min(abs(t_pull-a.time));
    subplot(2,2,2)
    % plot spectra at that time
    plot(a.wavelengths,a.sub(:,t_index),'Linewidth',2)
    title([num2str(round(a.time(t_index))) 'ps'])
    xlim(wl)
    xlabel('Wavelength (nm)')
    ylabel('\Delta A')

    % find wavelength closest to the wavelength selected
    [~,w_index] = min(abs(w1_pull-a.wavelengths));
    subplot(2,2,3)
    % plot kinetics at that wavelength
    plot(a.time,(a.sub(w_index,:)),'Linewidth',2)
    xlabel('Time (ps)')
    ylabel('\Delta A')
    xlim(tl)
    title([num2str(round(w1_pull)) 'nm'])
    
    % semilog plot
    subplot(2,2,4)
    semilogx(a.time(a.time>0),(a.sub(w_index,a.time>0)),'Linewidth',2)
    xlabel('Time (ps)')
    ylabel('\Delta A')
    xlim(tl)
    title([num2str(round(w1_pull)) 'nm'])
    
    % repeats the loop, until there's no left click
end

end

function surfTAtemp(s,figure1,xl,yl)
% plot 2D map

% select the subplot
subplot1 = subplot(2,2,1,'Parent',figure1);

% unpack the data
b = s.wavelengths;
a = s.time;
c = (s.sub);

% find values to make a nice colormap
ms = nanmedian(nanmean(c,2));
ss = nanstd(nanmean(c,2));
ms = median(mean(c(c>=ms-3*ss & c<=ms+3*ss),2));
ss = std(mean(c(c>=ms-3*ss & c<=ms+3*ss),2));


% plot it
surf(a,b,c,'EdgeColor','none')

% make it look nice
xlim(xl)
ylim(yl)
view(subplot1,[0.5 90]);
ylabel('Wavelength (nm)')
xlabel('Time (ps)')
colormap('jet')
caxis([ms-3*ss ms+3*ss])

end


