% This script is designed to walk the user through the basics of this
% MATLAB library to analyze transient absorption data. It begins with
% assumption that the data is exported from a ufs file as a csv

%% Background subtraction

% We'll want to subtract some pretime zero points to remove any
% background. To do this, we'll look for when we can start to see the laser
% in the TA spectra and average together and subtract away all the spectra
% prior to this time.

filename = 'example.csv';% put in the name of the file you want to import as a string


% runs a gui to find the number of pretime zero spectra to subtract, left
% clicking/up arrow will increase the number of  spectra used and right
% clicking/down arrow will decrease it
backgrounds_to_subtract = FindTimeZero(filename); 


%% Loading in the data

% The function below will import the data as a structured array with a time
% field, wavelength field, raw 2D data field (spectra), and background
% subtracted spectra (sub). You don't need to do anything but run this
% section

data = ImportTASpectraST(filename,backgrounds_to_subtract);

% The remainder of this script assumes you've imported the data as a
% structured array, but an alternative is to store all the variables
% separately, which is currently commented out.

% [time,wavelengths,spectra] = ImportTASpectra(filename)

% If we want to import several files at the same time we can uncomment the
% function below which will prompt you to find the folder that contains the
% files and imports them all. This assumes that you want to subtract away
% the same number of pretime zero points which is reasonable unless you've
% changed things substaintially.

% sa = ImportMassTA(backgrounds_to_subtract) 


%% Chirp correction 
% Now we chirp correct the data. We'll run a gui that prompts the user to
% click on a number of wavelengths (within a selectable wavelength range
% and then click on time zero at those wavelengths.

first_wavelength_cc = 450; % The first wavelength chirp corrected
last_wavelength_cc = 750; % The last wavelength chirp corrected
num_wavelengths_cc = 10; % The number of wavelengths at which you want to identify timezero

data = ChirpCorrection(data,first_wavelength_cc,last_wavelength_cc,num_wavelengths_cc);


%% Data Visualization

% To visualize the data we'll use DynamicSurface. Left click to see the
% spectrum at a given time and the dynamics at a given wavelength. Any other
% button will stop the function.

tl = [1 1000]; %time limit to examine

wl = [450 750]; %wavelengths to examine

%DynamicSurface(data,tl,wl)


% We can also stare at data at individual wavelengths/times

% to plot the spectrum at an individual time
% one_time = 10; % single time we want plotted
% [x,y] = PlotOneTime(data,one_time); % returns x and y of the plot

% to plot the dynamics at a single wavelength
% one_wavelength = 500; % single wavelength we want plotted
% [x,y] = PlotOneWavelength(data,500); % returns x and y of the plot

% to plot the spectra at several times
% many_times = [10, 100, 1000]; % array of times we want plotted
% PlotManyTimes(data,many_times);

% we can also normalize the spectra, there's an upper and lower bound to
% the plot so we aren't normalizing to something outside our region of
% interest
% min_wl_norm = 450; % first wavelength for our normalization
% max_wl_norm = 650; % last wavelength for our normalization
% PlotManyTimesNormalized(data,many_times,min_wl_norm,max_wl_norm);

% same as above but with kinetics
% many_wavelengths = [500,550,600,650]; % array of wavelengths we want
% PlotManyWavelengths(data,many_wavelengths);
% PlotManyWavelengthsNormalized(data,many_wavelengths);


%% Decay Assosciated Fits 

% We'll fit the data to a decay assosciated model. Essentially, we are
% globally fitting the data to a series of exponentials (with an offset
% term) where the preexponential factors are able to vary at every
% wavelength.

first_wavelength_fit = 450; % first wavelength fit
last_wavelength_fit = 560; % last wavelength fit
first_time_fit = 1; % first time fit
last_time_fit = 6000; % last time fit

% Initial guesses for the fit. The quality of the fit will be highly
% dependent on this value so you probably want to try a variety of values.
% The function can take in an arbitrary number of exponential fits with
% each being initial guess being of the form [lower bound, initial value,
% upper boound;]
initial_guesses = [1, 10, 100; 80,1000,Inf; 1000, 3000, Inf]; % initial guesses 

% To make the fit more computationally tractable, we can sample the data.
% Importantly, if you try to fit too much, it might take up too much of
% your memory calculating the confidence intervals and crash
sampling_rate = 3;

% The actual fit
[DAF] = DecayAssosciatedFit(data,first_wavelength_fit,last_wavelength_fit,...
    first_time_fit,last_time_fit,initial_guesses,sampling_rate);

% Check if the fit is okay
num_fits_to_check = 10; % number of figures to generate while visualizing

EyeDAFS(data,DAF,first_time_fit,last_time_fit,num_fits_to_check)


% Plot to see what the weights look like
PlotDAF(DAF)