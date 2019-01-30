function [prezero] = FindTimeZero(filename)
%Assists in the identification of time zero
%   Simultaneously plots first number_of_spectra spectra
%   which allows you to find the number of pre-pump spectra
%   that can be subtracted, left clicking/up arrow will increase

% make a new figure
figure

%import the data and unpack it
a=importdata(filename);
wavelengths=a(2:length(a(:,1)),1);
spectra=a(2:length(a(:,1)),2:length(a(1,:)));

% flag to let us know how long to be in the while loop
flag=1;
prezero=5;
button=5;
while flag==1
    flag=0;
    temp=spectra(:,1:prezero);
    plot(wavelengths,temp)
    a=nanmedian(nanmean(temp,2));
    b=nanstd(nanmean(temp,2));
    a=median(mean(temp(temp>=a-3*b & temp<=a+3*b),2));
    b=std(mean(temp(temp>=a-3*b & temp<=a+3*b),2));
    ylim([a-b*3,a+b*3])
    xlabel('Wavelength (nm)')
    ylabel('\DeltaA')
    title([num2str(prezero) ' pretime zero spectra'])
    [~,~,button]=ginput(1);
   
   if button==1 || button==30
       flag=1;
       prezero=min([prezero+1,size(spectra,2)]);
   end
      
   if button==3 || button==31
       flag=1;
       prezero=max([prezero-1,1]);
   end
   
end
    
end
