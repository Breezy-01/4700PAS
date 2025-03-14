% Given parameters
Is = 0.01e-12;  % Forward bias saturation current (0.01 pA)
Ib = 0.1e-12;   % Breakdown saturation current (0.1 pA)
Vb = 1.3;       % Breakdown voltage (V)
Gp = 0.1;       % Parasitic parallel conductance (Ω⁻¹)

% Voltage vector from -1.95V to 0.7V with 200 steps
V = linspace(-1.95, 0.7, 200);

% Compute ideal diode current
I_ideal = Is .* (exp(1.2 .* V / 0.025) - 1) ... % Ideal diode term
         + Gp .* V ... % Parallel resistor term
         - Ib .* (exp(1.2 .* (- (V + Vb)) / 0.025) - 1); % Breakdown term

% Add 20% random noise to simulate experimental variation
noise = I_ideal .* (0.2 * randn(size(I_ideal))); 
I_noisy = I_ideal + noise;

% Plot data
figure;
subplot(2,1,1)
plot(V, I_ideal, 'b', 'LineWidth', 2); hold on;
plot(V, I_noisy, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Diode I-V Characteristics');
legend('Ideal Data', 'Noisy Data');
grid on;

% Logarithmic plot
subplot(2,1,2)
semilogy(V, abs(I_ideal), 'b', 'LineWidth', 2); hold on;
semilogy(V, abs(I_noisy), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
xlabel('Voltage (V)');
ylabel('Current (A) (Log Scale)');
title('Diode I-V Characteristics (Log Scale)');
legend('Ideal Data', 'Noisy Data');
grid on;
