%% Sediment transport
% 1D Ripple model
% JSB March 31,2016

clear all
figure(1)
clf

%% Initialize

D = 0.001; % grain size

% x array
dx = 10*D; % x step mm
xmax = 2; % xmax m
x = 0:dx:xmax; % x array
jmax = length(x);

% z array
z = 0.001*rand(size(x)); % randomized initial topo

% now assess how many grains are in each bin
N = (z*dx)/(D^2); % number of grains per pin

% time array
dt = 1; % impact step
tmax = 10000; % max number of impacts
t = 0:dt:tmax; % time array

imax = length(t);

% beam
slope = -0.2; % 11.31 degree angle with slope of .2
multfactor = ((-slope)*xmax); % max y intercept - mulitiply by random number generator

% plot animation
n=200; %number of plots
tplot = tmax/n; % time step of plot

%% run
for i = 1:imax % Calculates each time step
    % defining zbeam at each impact
    b = rand(1); % generate random number between 0 and 1
    b = b*multfactor; % b between 0 and max intercept
    zbeam = (slope*x)+b; % zbeam line for each impact
    
    % finding where the beam hits the topography
    below = [];
    below = find(zbeam <= z); % find all points where zbeam is <= topo
    if isempty(below)==1
        hit = 1+floor(jmax*rand);
    else
        hit = below(1); % only want the first point where zbeam is <= topo
    end
    
    N(hit) = N(hit)- 5; % remove 5
    N(max(1,mod(hit+3,jmax)))=N(max(1,mod(hit+3,jmax)))+1; %add 1
    N(max(1,mod(hit+4,jmax)))=N(max(1,mod(hit+4,jmax)))+3; %add 3
    N(max(1,mod(hit+5,jmax)))=N(max(1,mod(hit+5,jmax)))+1; %add 1
    
    
    z = N*(D*D)/dx; % calculate new z
       
    z(1) = z(end); % wrap around boundary condition
    
if  (rem(t(i),tplot)==0) % decrease plotting frequency - speed up animation
    figure(1), clf
    plot(x,z*100); % plot topography
    hold on
    plot(x(1:hit),zbeam(1:hit)*100); % plot beam until it hits topo
    axis([0 xmax -0.05*100 0.05*100]) % hold axis constant
    hold off

    xlabel('Distance [m]')
    ylabel('depth [cm]')
    set(gca,'fontsize',14,'fontname','arial')
    title(['Ripple evolution after ',num2str(t(i)),' impacts'])
    pause(0.05)
end

end

