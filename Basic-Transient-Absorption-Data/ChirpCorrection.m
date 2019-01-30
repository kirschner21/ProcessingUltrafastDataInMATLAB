function [news] = ChirpCorrection(s,fw,lw,points)
%Chirp correct the data. Select points wavelengths at which to identify
%timezero. The resulting relationship is then fit to a quadratic function
%to chirp correct the data.

% select points wavelengths and then identify timezero
[wl_chirp,t0_chirp] = GUI_point_select_funct(s,fw,lw,points); 

% quadratic fit
p = chirp_curve_fit(wl_chirp, t0_chirp); 

% apply that fit
news = unchirp_adaptive(s,p);

end



function [wl_sel,t0_store] = GUI_point_select_funct(s,fw,lw,points)
% click on wavelengths and timezero at those wavelengths


% unpack data from structure and limit it to ROI
data = s.sub;
t = s.time;
w1 = s.wavelengths;
[tmp1,tmp2] = DetermineIndices(t,-1,4);
t_2 = t(tmp1:tmp2); % shortening time from start to end
[tmp3,tmp4] = DetermineIndices(w1,fw,lw); % relevant wavelength range
wl_chirp = w1(tmp3:tmp4);
chirp_segment = data(tmp3:tmp4,tmp1:tmp2);


% Create figure
figure1 = figure;
colormap('jet');
axes1 = axes('Parent',figure1);
hold(axes1,'on');
surf(t_2,wl_chirp,chirp_segment,'Parent',axes1,'EdgeColor','none');
view(axes1,[90 90]);
grid(axes1,'on');
ylim([fw lw])

% select points wavelengths for chirp correction
[~,wl_sel] = ginput(points);


% plot the dynamics at each selected wavelength and the user clicks on time
% zero

figure2 = figure;
t0_store = zeros(1,length(points));

for i = 1:points
    figure2;
    % find and plot the wavelength
    [~,tempind] = min(abs(wl_sel(i)-w1));
    plot(t,mean(data(tempind-5:tempind+5,:)))
    xlim([-1,3])
    % select timezero
    [t0_store(i),~] = ginput(1);
end

end


function [p] = chirp_curve_fit(wl_chirp, t0_chirp)
% Fit the data to a second order polynomial

p = polyfit(wl_chirp, t0_chirp',2);

% plot the fits
figure
plot(wl_chirp,t0_chirp,'Marker','.','Linestyle','none','Markersize',12)
hold on
plot(wl_chirp(1):wl_chirp(end),p(1)*(wl_chirp(1):wl_chirp(end)).^2+p(2)*...
    (wl_chirp(1):wl_chirp(end))+p(3),'Linewidth',2);
xlabel('Wavelength (nm)')
ylabel('Time (ps)')
legend('data','fit')

end



function [news] = unchirp_adaptive(s,p)
%removes chirp from data. requires a parabolic fit of the chirp curve


% unpack data
wl = s.wavelengths;
t = s.time;
data = s.sub;

% enter parameters of chirp curve from curve fitting tool
chirp_eqn = p(1)*wl.^2 + p(2)*wl + p(3);

corrected_data = zeros(size(data));

%this loop actually corrects for the chirp using the above equation

for i = 1:length(wl) %run through wl     
    t0_adjust = chirp_eqn(i); %gets the value of t0 from chirp curve
    t_adj = t-t0_adjust; %shifts the t values by the amount from the chirp curve
    trace_adj = interp1(t_adj,data(i,:),t); 
    %interpolates by saying the adjusted curve is the actual time and t(old
    %time) is the new times, making the new points line up with t
    corrected_data(i,1:end) = trace_adj; %fills in corrected data
end

% put the new data into a structure
news = s;
news.sub = corrected_data;

end
