%Set Default figure wondow style
winstyle = 'docked';
% winstyle = 'normal'; 

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight


%Grid Scaling Factors
dels = 0.75;
spatialFactor = 1;

%Physical Constants
c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);

%Simulation Time and Parameters
tSim = 200e-15;
f = 460e12; %New Freq
%f = 230e12; %Normal Freq
lambda = c_c/f;

%Define Computational domain size
xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};

%Number of regions
Reg.n = 1;

%Initialize material property matrices
mu{1} = ones(nx{1},ny{1})*c_mu_0;
epi{1} = ones(nx{1},ny{1})*c_eps_0;

%DiElectic inclusion addition
% epi{1}(125:150,55:95)= c_eps_0*11.3; %This is the code for inclusion when
%commented out it will cause the simulation to behave as if the material is
%just free space everywhere with a relative permittivity of 11.3

%Conductivity initially zero everywhere
sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

%Spaitial and temporal discretization
dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx;

%Plotting and visualization settings
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

%Define wave source parameters
%bc{1}.NumS = 1; %Number of sources in the sim for 1 source
bc{1}.NumS = 2;  % Two sources now

% First Source (Left Side)
bc{1}.s(1).xpos = nx{1}/4; % Left source
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;


% Second Source (Right Side)
bc{1}.s(2).xpos = 3*nx{1}/4; % Right source
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;


bc{1}.s(1).xpos = nx{1}/(4) + 1; %Source position
%bc{1}.s(1).xpos = nx{1}/(2); %Modified Source position
bc{1}.s(1).type = 'ss'; %Soft Source
bc{1}.s(1).fct = @PlaneWaveBC; %Function that defines the plane wave
% mag = -1/c_eta_0;

%Wave Properties
%mag = 1; %Normal wave amp
mag = 5; % Increased Wave Amp
phi = 0; %Initial phase
omega = f*2*pi; %angular frequency
betap = 0; %phase shift
%t0 = 30e-15; %center time of gaussian pulse
t0 = 100e-15; %New center time of gaussian pulse
%st = 15e-15; %Width of gaussian pulse
st = 50e-15; %New Width of gaussian pulse
%s = 0; %Default Shift
s = 50e-15; %Delays wave shift
y0 = yMax/2; %Center of wave in y direction
sty = 1.5*lambda; %Spaitial width of wave in y direction

%Store Wave Parameters
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};
%Set y-coordinates for plotting
Plot.y0 = round(y0/dx);

%Absorbing boundary conditions a is the absorbing boundary condition
bc{1}.xm.type = 'a'; %Absorbing boundary to the left (x-)
bc{1}.xp.type = 'a'; %to the right (x+)
bc{1}.ym.type = 'a'; %to the bottom (y-)
bc{1}.yp.type = 'a'; %to the top (y+)

%Peefectly matched layers settings
pml.width = 20 * spatialFactor;
pml.m = 3.5;

%Region Offset Settings
Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

%Run the FDTD sim using the Yee algorithm
RunYeeReg

figure;
for t = 1:10:nSteps
    imagesc(Ez'); % Plot the electric field (Ez)
    colorbar;
    clim([-1 1]); % Normalize color scale
    title(['Electric Field (Ez) at time step ', num2str(t)]);
    xlabel('x-axis');
    ylabel('y-axis');
    pause(0.05);
end