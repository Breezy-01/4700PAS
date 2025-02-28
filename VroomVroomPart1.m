% Simulation Configuration
Coupled = 1;      % 1 = Poisson's equation is solved
TwoCarriers = 1;  % 1 = Simulate both electrons and holes
RC = 1;           % 1 = Include recombination

% Grid setup
nx = 201;         % Number of grid points
l = 1e-6;        % Device length (1 micron)

x = linspace(0, l, nx);
dx = x(2) - x(1);
xm = x(1:nx-1) + 0.5 * dx;

% ---- LINEAR DOPING GRADIENT ----
Nd_start = 1e16 * 1e6;     % Start doping (1/cm^3 converted to 1/m^3)
Nd_end = 20e16 * 1e6;      % End doping (1/cm^3 converted to 1/m^3)
NetDoping = linspace(Nd_start, Nd_end, nx); % Linearly varying doping

%EXPONENTIAL doping profile
lambda = l / 3; % Characteristic length scale
NetDoping = Nd_start * exp(x / lambda);

% ---- TURN OFF DISTURBANCE ----
npDisturbance = zeros(1, nx); % Disable initial disturbance

% Boundary Conditions
LVbc = 0;
RVbc = 0;

% Simulation time settings
TStop = 14200000 * 1e-18;
PlDelt = 100000 * 1e-18;


% PlotYAxis = {[-1e-15 2e-15] [-2e-9 2e-9] [-1.5e-12 1.5e-12]...
%    [1e22 2e22] [0 1e22] [0 20e43]...
%    [-20e33 15e33] [-2.5e34 2e34] [-1.1e8 1.1e8] ...
%    [-1e8 1e8] [-10e-3 10e-3] [0 2e22]};

% Plotting setup
doPlotImage = 0;
PlotFile = 'Gau2CarRC.gif';

