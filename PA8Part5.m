% Define inputs (voltage) and targets (current)
inputs = V.';      % Voltage as column vector
targets = I_noisy.';  % Noisy current data as column vector

% Train GPR model
gprModel = fitrgp(inputs, targets);

% Predict current values using the trained GPR model
I_gpr = predict(gprModel, inputs);

% Plot original data and GPR fit
figure;
subplot(2,1,1);
plot(V, I_noisy, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
plot(V, I_gpr, 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Gaussian Process Regression (GPR) Fit for Diode Data');
legend('Noisy Data', 'GPR Fit');
grid on;

% Logarithmic plot
subplot(2,1,2);
semilogy(V, abs(I_noisy), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
semilogy(V, abs(I_gpr), 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A) (Log Scale)');
title('Gaussian Process Regression Fit (Log Scale)');
legend('Noisy Data', 'GPR Fit');
grid on;

% Display GPR model details
disp('Trained Gaussian Process Regression Model:');
disp(gprModel);
