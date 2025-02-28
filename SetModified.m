% Simulation Configuration
Coupled = 1;      % Enable Poisson's equation
TwoCarriers = 1;  % Simulate both electrons and holes
RC = 1;           % Enable recombination

% Grid setup
nx = 201;         % Number of grid points
l = 1e-6;        % Device length (1 micron)

x = linspace(0, l, nx);
dx = x(2) - x(1);
xm = x(1:nx-1) + 0.5 * dx;


Nd_min = 1e16 * 1e6;  % Lower doping in N-region
Nd_max = 4e16 * 1e6;  % Higher doping in N-region
Na_min = 1e16 * 1e6;  % Lower doping in P-region
Na_max = 4e16 * 1e6;  % Higher doping in P-region

% Create a linear gradient over each region
%ni = x < l/2;   % N-side mask
%pi = x >= l/2;  % P-side mask
mid_idx = floor (nx/2);

NetDoping = zeros(1, nx);  % Initialize doping array
NetDoping = linspace(Nd_max,-Nd_min,nx);
% NetDoping(1:mid_idx) = linspace(Na_max, Nd_min, sum(mid_idx));
% NetDoping(mid_idx +1:end) = -linspace(Na_max, Nd_min, sum(mid_idx));
%NetDoping(ni) = linspace(Nd_max, Nd_min, sum(ni));  % Gradual decrease in N-region
%NetDoping(pi) = -linspace(Na_min, Na_max, sum(pi)); % Gradual increase in P-region


npDisturbance = zeros(1, nx); % No initial disturbance

% Boundary Conditions
JBC = 1;
RVbc = 0;

% Compute built-in potential & depletion widths
Phi = C.Vt * log(Na_min * Nd_max / (niSi * niSi));  % Built-in potential
W = sqrt(2 * EpiSi * (Nd_max + Na_max) * (Phi) / (C.q_0 * Nd_max * Na_max));
Wn = W * Na_max / (Nd_max + Na_max);
Wp = (W - Wn);

LVbc = Phi;

% Simulation time settings
TStop = 80000000 * 1e-18;
PlDelt = 1000000 * 1e-18;

 %PlotYAxis = {[0 Phi+0.1] [0e5 40e5] [-20e2 40e2]...
   %[0e21 2.5e22] [0 1.1e22] [0 20e43]...
   %[-5e33 5e33] [-5e33 5e33] [-0e8 3e8] ...
   %[1e-3 1e8] [-3e6 1e6] [0 2.5e22]};

% Plot settings
doPlotImage = 1;
PlotFile = 'PNJctEqBias_LinGraded.gif';

% Second simulation for bias change
SecondSim = 1;
LVbc2 = Phi - 0.3;
TStop2 = TStop + 80000000 * 1e-18;

fprintf('Phi: %g W: %g Wn: %g Wp: %g \n', Phi, W, Wn, Wp);

