% Clear workspace and setup
clearvars
clearvars -GLOBAL
close all
format shorte
set(0, 'DefaultFigureWindowStyle', 'docked')

% Define global variables
global C V Mun Mup Gv Dn Dp Bv Em DnM MunM DpM MupM np pp x xm n p
global Rho divFp divFn niSi TwoCarriers t EpiSi n0 p0 tauSi
global Coupled NetDoping l PlotYAxis PlotSS im map
global PlotCount doPlotImage

% Define physical constants
C.q_0 = 1.60217653e-19;   % Electron charge (C)
C.hb = 1.054571596e-34;   % Dirac constant (J·s)
C.h = C.hb * 2 * pi;      % Planck constant (J·s)
C.m_0 = 9.10938215e-31;   % Electron mass (kg)
C.kb = 1.3806504e-23;     % Boltzmann constant (J/K)
C.eps_0 = 8.854187817e-12; % Vacuum permittivity (F/m)
C.Mun_0 = 1.2566370614e-6; % Vacuum permeability (H/m)
C.c = 299792458;          % Speed of light (m/s)

% Set temperature and thermal voltage
Temp = 300; 
C.Vt = C.kb * Temp / C.q_0;

% Define silicon material properties
EpiSi = C.eps_0 * 11.68;
MunSi = 1400e-4;  % Electron mobility (m^2/V·s)
DnSi = MunSi * C.kb * Temp / C.q_0; % Electron diffusion coefficient
MupSi = 450e-4;   % Hole mobility (m^2/V·s)
DpSi = MunSi * C.kb * Temp / C.q_0; % Hole diffusion coefficient
tauSi = 1e-8;     
niSi = 1e10 * 1e6; % Intrinsic carrier concentration (1/m^3)

% Boundary condition setup
JBC = 0;  
RVbc = 0;  
SecondSim = 0;

% Plot settings
PlotSS = 1;
PlotFile = 'image.gif';
PlotCount = 0;
doPlotImage = 0;

% Choose simulation
%Simulation = 'GaussianTwoCarRC';  % Default
Simulation ='Modified PN Junction';  % Uncomment to run new simulation

% Select parameters based on simulation choice
if strcmp(Simulation, 'GaussianTwoCar')
    eval('SetGaussian2CarParas');
elseif strcmp(Simulation, 'GaussianTwoCarRC')
    eval('SetGaussian2CarParasRCOnly');
elseif strcmp(Simulation, 'GaussianTwoCarRCLinGrad')
    eval('SetGaussian2CarParasRCOnlyLinGrad');
elseif strcmp(Simulation, 'GaussianSingle0V')
    eval('SetGaussian1CarParas0V');
elseif strcmp(Simulation, 'GaussianSingle1V')
    eval('SetGaussian1CarParas1V');
elseif strcmp(Simulation, 'ExpDoping')
    eval('SetExpDopingParas');
elseif strcmp(Simulation, 'PNJct')
    eval('SetPNJctParas');
elseif strcmp(Simulation, 'PNJctEq')
    eval('SetPNJctParasEqBC');
elseif strcmp(Simulation, 'PNJctEqBias')
    eval('SetPNJctParasEqBCBias');
elseif strcmp(Simulation, 'VROOMVROOM') % New simulation case
    eval('VroomVroomPart1');
elseif strcmp(Simulation, 'Modified PN Junction')
    eval('SetModified');
end

% Solve Poisson equation
FormGv(nx, LVbc, RVbc);
[L, U] = lu(Gv);

% Initialize carrier mobilities and diffusion coefficients
Mun = ones(1, nx) * MunSi;
Dn = ones(1, nx) * DnSi;
MunM(1:nx-1) = (Mun(1:nx-1) + Mun(2:nx)) / 2;
DnM(1:nx-1) = (Dn(1:nx-1) + Dn(2:nx)) / 2;
n = zeros(1, nx);

Mup = ones(1, nx) * MupSi;
Dp = ones(1, nx) * DpSi;
MupM(1:nx-1) = (Mup(1:nx-1) + Mup(2:nx)) / 2;
DpM(1:nx-1) = (Dp(1:nx-1) + Dp(2:nx)) / 2;
p = zeros(1, nx);

% Compute equilibrium carrier densities
if TwoCarriers == 1
    ni = NetDoping >= 0;
    n0(ni) = (NetDoping(ni) + sqrt(NetDoping(ni).^2 + 4 * niSi^2)) / 2;
    p0(ni) = niSi^2 ./ n0(ni);
    
    pi = ~ni;
    p0(pi) = (-NetDoping(pi) + sqrt(NetDoping(pi).^2 + 4 * niSi^2)) / 2;
    n0(pi) = niSi^2 ./ p0(pi);
else
    n0 = NetDoping;
    p0 = zeros(1, nx);
end

% Add disturbance
n0 = n0 + npDisturbance;
if TwoCarriers == 1
    p0 = p0 + npDisturbance;
end

% Initialize field and charge density
divFn = zeros(1, nx);
divFp = zeros(1, nx);
Rho = zeros(1, nx);

if Coupled
    Rho = C.q_0 * (NetDoping - n0 + p0);
    Rho([1, nx]) = 0; % Boundary conditions
end

% Solve Poisson equation for potential
V = U \ (L \ (-dx^2 / EpiSi * Rho' + Bv'));
Em(1:nx-1) = -(V(2:nx) - V(1:nx-1)) / dx;
MaxEm = max(abs(Em));

% Compute characteristic length and time steps
Maxn = max(n0);
Ld = sqrt(EpiSi / (C.q_0 * Maxn));
dxMax = Ld / 5;
dtMax = min(dx^2 / (2 * max(Dn)), dx^2 / (2 * max(Dp)));

if MaxEm > 0
    dt = min([2 * dx / MaxEm, dtMax]) / 4;
else
    dt = dtMax / 4;
end

% Initialize simulation variables
t = 0;
n = n0;
np = n0;
p = p0;
pp = p0;

% Plot initial values
PlotVals(nx, dx, 'on', l, TStop, PlotYAxis);

% Run first simulation
SimulateFlow(TStop, nx, dx, dtMax, JBC, RC, U, L, PlDelt);

% Run second simulation if enabled
if SecondSim == 1
    FormGv(nx, LVbc2, RVbc);
    [L, U] = lu(Gv);
    SimulateFlow(TStop2, nx, dx, dtMax, JBC, RC, U, L, PlDelt);
end


% Save image if needed
if doPlotImage
    imwrite(im, map, PlotFile, 'DelayTime', 0.2, 'LoopCount', inf);
end

% Final plotting
PlotVals(nx, dx, 'off', l, TStop, []);

if doPlotImage
    f = getframe(fig2);
    [im, map] = rgb2ind(f.cdata, 256, 'nodither');
    imwrite(im, map, ['final-', PlotFile]);
end
