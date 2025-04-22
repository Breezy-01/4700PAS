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
