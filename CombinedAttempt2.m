% ELEC 4700 - MNA Building Assignment
% MATLAB Code to Solve DC and AC Analysis Using MNA

clc; clear; close all;

%% Given circuit parameters
R1 = 1;      % Ohms
C = 0.25;    % Farads
R2 = 2;      % Ohms
L = 0.2;     % Henry
R3 = 10;     % Ohms
alpha = 100; % Controlled source coefficient
R4 = 0.1;    % Ohms
RO = 1000;   % Ohms

%% Construct C matrix (Capacitance/Inductance)
C_matrix = [ C  -C   0   0   0   0;
            -C   C   0   0   0   0;
             0   0   0   0   0   0;
             0   0   0   0   0   0;
             0   0   0   0   0   0;
             0  -L   1   0   0   0];

%% Construct G matrix (Conductance)
G_matrix = [ 1/R1  -1/R1    0     0     0     0;
            -1/R1  1/R1+1/R2 0     0     0     0;
             0      0      1/R3    0     0     1;
             0      0       0      1     0   -alpha;
             0      0       0   -1/R4  1/R4+1/RO  0;
             0      0      -1     0     0     0];

%% Part 2(a) - DC Analysis: Sweep Vin from -10V to 10V
Vin_values = linspace(-60, 60, 100); % 100 points from -10V to 10V
Vout_DC = zeros(size(Vin_values));  % Store output voltage
V3_DC = zeros(size(Vin_values));    % Store V3 voltage  

for i = 1:length(Vin_values)
    Is = Vin_values(i); % Source current is equivalent to input voltage
    F_vector = [-Is; 0; 0; 0; 0; 0]; % Define the source vector
    V = G_matrix \ F_vector; % Solve for nodal voltages
    Vout_DC(i) = V(5);  % Vout is at node 5
    V3_DC(i) = V(3);    % Store V3
end

% Plot DC Sweep Results
figure;
plot(Vin_values, Vout_DC, 'b', 'LineWidth', 2);
hold on;
plot(Vin_values, V3_DC, 'r', 'LineWidth', 2);
xlabel('V_{in} (V)');
ylabel('Voltage (V)');
title('DC Analysis: Vout and V3 vs. Vin');
legend('Vout', 'V3');
grid on;

%% Part 2(b) - AC Analysis: Frequency Response
freq = logspace(0, 6, 1000); % Frequency range from 1 Hz to 1 MHz
omega = 2 * pi * freq; % Convert to angular frequency
Vout_AC = zeros(size(omega)); % Store AC response

for i = 1:length(omega)
    A_matrix = G_matrix + 1j * omega(i) * C_matrix; % Compute (G + jωC)
    F_vector = [-1; 0; 0; 0; 0; 0]; % AC input (normalized to -1)
    V = A_matrix \ F_vector; % Solve for AC response
    Vout_AC(i) = V(5); % Output voltage at node 5
end

% Compute Gain in dB
Gain_dB = 20 * log10(abs(Vout_AC));

% Plot Frequency Response
figure;
semilogx(freq, abs(Vout_AC), 'b', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('|V_{out}| (V)');
title('AC Analysis: Magnitude Response');
grid on;

% Plot Gain in dB
figure;
semilogx(freq, Gain_dB, 'r', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title('AC Analysis: Gain vs Frequency');
grid on;

%% Part 2(c) - Perturbation Analysis on C at ω = π
num_samples = 10000; % Number of random samples
C_perturbed = C + 0.05 * C * randn(num_samples, 1); % Apply normal perturbation

Gain_perturbed = zeros(num_samples, 1);

for i = 1:num_samples
    C_matrix_perturbed = [ C_perturbed(i)  -C_perturbed(i)   0   0   0   0;
                          -C_perturbed(i)   C_perturbed(i)   0   0   0   0;
                           0   0   0   0   0   0;
                           0   0   0   0   0   0;
                           0   0   0   0   0   0;
                           0  -L   1   0   0   0];
    
    omega_pi = pi; % Frequency ω = π
    A_matrix_perturbed = G_matrix + 1j * omega_pi * C_matrix_perturbed;
    V = A_matrix_perturbed \ F_vector;
    Gain_perturbed(i) = 20 * log10(abs(V(5))); % Compute Gain in dB
end

% Plot Histogram of Gain Variations
figure;
histogram(Gain_perturbed, 50, 'FaceColor', 'b', 'EdgeColor', 'k');
xlabel('Gain (dB)');
ylabel('Frequency');
title('Histogram of Gain under C Perturbations');
grid on;
