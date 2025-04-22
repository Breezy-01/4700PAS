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
