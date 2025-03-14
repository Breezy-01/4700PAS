% Given parameters (used for data generation)
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

% Define the custom nonlinear model
model = fittype('A*(exp(1.2*x/0.025)-1) + B*x - C*(exp(1.2*(-(x+D))/0.025)-1)', ...
                'independent', 'x', 'coefficients', {'A', 'B', 'C', 'D'});

% Initial guesses for the parameters
initial_guesses = [1e-12, 0.01, 1e-12, 1];

% Fit the model to the noisy data
[fit_result, gof] = fit(V.', I_noisy.', model, 'StartPoint', initial_guesses);

% Extract the fitted parameters
A_fit = fit_result.A;
B_fit = fit_result.B;
C_fit = fit_result.C;
D_fit = fit_result.D;

% Generate fitted current values
I_fit = A_fit * (exp(1.2 * V / 0.025) - 1) + B_fit * V - C_fit * (exp(1.2 * (-(V + D_fit)) / 0.025) - 1);

% Plot the data and the fitted curve
figure;
subplot(2,1,1);
plot(V, I_noisy, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
plot(V, I_fit, 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Nonlinear Curve Fitting to Noisy Data');
legend('Noisy Data', 'Fitted Curve');
grid on;

% Logarithmic plot
subplot(2,1,2);
semilogy(V, abs(I_noisy), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
semilogy(V, abs(I_fit), 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A) (Log Scale)');
title('Nonlinear Curve Fitting (Log Scale)');
legend('Noisy Data', 'Fitted Curve');
grid on;

% Display the fitted parameters
disp('Fitted Parameters:');
fprintf('A (Is)  = %.3e A\n', A_fit);
fprintf('B (Gp)  = %.3e Ω⁻¹\n', B_fit);
fprintf('C (Ib)  = %.3e A\n', C_fit);
fprintf('D (Vb)  = %.3f V\n', D_fit);
