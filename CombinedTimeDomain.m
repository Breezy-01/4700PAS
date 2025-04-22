clear; clc; close all;

% Component values
R1 = 1;        % Ohms
R2 = 2;        % Ohms
R3 = 10;       % Ohms
R4 = 0.1;      % Ohms
RO = 1000;     % Ohms
C = 0.25;      % Farads
L = 0.2;       % Henrys
alpha = 100;   % Unitless

% Time-domain Conductance Matrix G (No frequency-dependent terms)
G = [ 1/R1, -1/R1,           0,           0,           0,           0,           0;
     -1/R1,  1/R1 + 1/R2,   -1/R2,        0,           0,           0,           0;
      0,    -1/R2,           1/R2 + 1/R3, 0,          -1,           0,           0;
      0,     0,              0,          -1/R4,       1,          -alpha,       0;
      0,     0,              0,           0,           0,         -alpha,       1/RO;
      0,     0,              0,           0,          -1,           0,           0;
      0,     0,              0,           0,           0,         -alpha,        1];

% Time-domain Capacitance/Inductance Matrix C
C_matrix = diag([C, 0, 0, 0, 0, L, 0]);

% Initial Conditions (all voltages and currents start at 0)
V0 = zeros(7, 1);

% Time span for simulation
tspan = [0, 5];  % Simulate from 0 to 5 seconds

% Define input voltage function (Example: Step input at t = 0.5s)
Vin_func = @(t) (t >= 0.5) * 5;  % 5V step at t = 0.5s

% Define the ODE system: dV/dt = C^(-1) * (F - G * V)
ode_func = @(t, V) C_matrix \ (-G * V + [Vin_func(t); 0; 0; 0; 0; 0; 0]);

% Solve the system using ODE45
[t, V] = ode45(ode_func, tspan, V0);

% Extract node voltages
V1 = V(:, 1);
V3 = V(:, 3);
V5 = V(:, 5);  % Output voltage

% Plot results
figure;
subplot(3, 1, 1);
plot(t, V1, 'k', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('V_1 (V)');
title('Input Voltage V_1 (Step Response)');
grid on;

subplot(3, 1, 2);
plot(t, V3, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('V_3 (V)');
title('Voltage at Node V_3 Over Time');
grid on;

subplot(3, 1, 3);
plot(t, V5, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('V_5 (V)');
title('Output Voltage V_5 Over Time');
grid on;

% DC Sweep: V_in from -10V to 10V
V_in = linspace(-10, 10, 100);
V3 = zeros(size(V_in));
V5 = zeros(size(V_in));

% Solve for each V_in value
for k = 1:length(V_in)
    F = zeros(7, 1); % Reset source vector
    F(1) = V_in(k);  % Set input voltage
    V = G_dc \ F;    % Solve for node voltages
    V3(k) = V(3);    % Voltage at node V3
    V5(k) = V(5);    % Output voltage V5
end

% Plot results
figure;
subplot(2, 1, 1);
plot(V_in, V3, 'b', 'LineWidth', 1.5);
xlabel('V_{in} (V)');
ylabel('V_3 (V)');
title('Voltage at V_3 vs. V_{in}');
grid on;

subplot(2, 1, 2);
plot(V_in, V5, 'r', 'LineWidth', 1.5);
xlabel('V_{in} (V)');
ylabel('V_5 (V)');
title('Output Voltage V_5 vs. V_{in}');
grid on;