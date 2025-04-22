% Component values
R1 = 1;        % Ohms
R2 = 2;        % Ohms
R3 = 10;       % Ohms
R4 = 0.1;      % Ohms
RO = 1000;     % Ohms
C = 0.25;      % Farads
L = 0.2;       % Henrys
alpha = 100;   % Unitless

% Conductance matrix G
G = [ 1/R1,       -1/R1,           0,            0,           0,           0,           0;
     -1/R1,        1/R1 + 1/R2,    -1/R2,        0,           0,           0,           0;
      0,          -1/R2,           1/R2 + 1/R3,  0,          -1,           0,           0;
      0,           0,              0,           -1/R4,        1,          -alpha,       0;
      0,           0,              0,            0,           0,          -alpha,       1/RO;
      0,           0,              0,            0,          -1,           0,           0;
      0,           0,              0,            0,           0,          -alpha,       1 ];

% Capacitance/Inductance matrix C
C_matrix = diag([C, 0, 0, 0, 0, L, 0]);

% Source vector F (will be defined in each analysis)
F = zeros(7, 1);

% DC sweep for V_in from -10V to 10V
V_in = linspace(-10, 10, 100);
V3 = zeros(size(V_in));
V5 = zeros(size(V_in));

% Modify G matrix for DC (capacitors open, inductors short)
G_dc = G;
G_dc(1, 1) = G_dc(1, 1) - 1i*0;  % Remove jωC term
G_dc(6, 4) = 0;                  % Short inductor
G_dc(6, 6) = 1;                  % Replace with 1 for current source

for k = 1:length(V_in)
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

% Frequency range for AC analysis
frequencies = logspace(-1, 3, 500);  % From 0.1 Hz to 1000 Hz
omega = 2 * pi * frequencies;
V_in_ac = 1;  % AC input magnitude

V5_ac = zeros(size(omega));
gain_dB = zeros(size(omega));

for k = 1:length(omega)
    s = 1i * omega(k);
    A = G + s * C_matrix;
    F_ac = zeros(7, 1);
    F_ac(1) = V_in_ac;
    V = A \ F_ac;
    V5_ac(k) = V(5);
    gain_dB(k) = 20 * log10(abs(V5_ac(k)) / V_in_ac);
end

% Plot results
figure;
subplot(2, 1, 1);
semilogx(frequencies, abs(V5_ac), 'b', 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('|V_5| (V)');
title('Output Voltage Magnitude |V_5| vs. Frequency');
grid on;

subplot(2, 1, 2);
semilogx(frequencies, gain_dB, 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title('Gain |V_5 / V_{in}| (dB) vs. Frequency');
grid on;

% Define the number of perturbation samples
num_samples = 1000;
C_mean = 0.25;         % Mean value of C
C_std = 0.05;          % Standard deviation
omega = pi;            % Frequency at which to analyze

% Generate random perturbed values of C
C_values = C_mean + C_std * randn(num_samples, 1);

% Array to store gain values
gain_values = zeros(num_samples, 1);

% Loop over each perturbed value of C
for i = 1:num_samples
    % Update C matrix for the current perturbed value
    C_perturbed = [1i * omega * C_values(i), 0, 0, 0, 0, 0, 0;
                   0, 0, 0, 0, 0, 0, 0;
                   0, 0, 0, 0, 0, 0, 0;
                   0, 0, 0, 0, 0, 0, 0;
                   0, 0, 0, 0, 0, 0, 0;
                   0, 0, 0, 1i * omega * L, 0, 0, 0;
                   0, 0, 0, 0, 0, 0, 0];

    % Solve for voltages using (G + jωC) V = F
    V = (G + C_perturbed) \ F;

    % Compute the gain V5 / Vin
    gain_values(i) = abs(V(5)); % Magnitude of V5
end

% Plot histogram of the gain
figure;
histogram(gain_values, 50); % 50 bins for better resolution
xlabel('Gain (V5 / Vin)');
ylabel('Frequency');
title('Histogram of Gain with Random C Perturbations');
grid on;
