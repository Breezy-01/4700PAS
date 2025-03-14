% Define inputs (voltage) and targets (current)
inputs = V.';    % Voltage as column vector
targets = I_noisy.';  % Noisy current data as column vector

% Define neural network structure
hiddenLayerSize = 10;   % 10 neurons in hidden layer
net = fitnet(hiddenLayerSize);

% Configure training parameters
net.divideParam.trainRatio = 70/100;  % 70% training data
net.divideParam.valRatio = 15/100;    % 15% validation data
net.divideParam.testRatio = 15/100;   % 15% test data

% Train the neural network
[net, tr] = train(net, inputs, targets);

% Use trained network to generate output predictions
outputs = net(inputs);

% Compute errors and performance
errors = gsubtract(outputs, targets);
performance = perform(net, targets, outputs);

% Display neural network model
view(net);

% Plot the results
figure;
subplot(2,1,1);
plot(V, I_noisy, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
plot(V, outputs, 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Neural Network Fitting for Diode Data');
legend('Noisy Data', 'Neural Net Fit');
grid on;

% Logarithmic plot
subplot(2,1,2);
semilogy(V, abs(I_noisy), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
semilogy(V, abs(outputs), 'b', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A) (Log Scale)');
title('Neural Network Fit (Log Scale)');
legend('Noisy Data', 'Neural Net Fit');
grid on;

% Display performance
fprintf('Neural Network Performance: %.6f\n', performance);