function surfTA(s,tl,wl)
% plot 2D TA surface

% make figure
figure1=figure;
axes1 = axes('Parent',figure1);

% unpack data
b=s.wavelengths;
a=s.time;
c=s.sub;

% find values to make a nice colormap
ms = nanmedian(nanmean(c,2));
ss = nanstd(nanmean(c,2));
ms = median(mean(c(c>=ms-3*ss & c<=ms+3*ss),2));
ss = std(mean(c(c>=ms-3*ss & c<=ms+3*ss),2));

% plot data
surf(a,b,c,'EdgeColor','none')

% make it look nice
view(axes1,[0.5 90]);
ylabel('Wavelength (nm)')
xlabel('Time (ps)')
colormap('jet')
xlim(tl)
ylim(wl)
caxis([ms-3*ss ms+3*ss])

end

