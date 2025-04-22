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
