% Compute polynomial fits (4th and 8th order)
p4 = polyfit(V, I_noisy, 4);   % 4th order polynomial
p8 = polyfit(V, I_noisy, 8);   % 8th order polynomial

% Evaluate polynomials at V points
I_poly4 = polyval(p4, V);
I_poly8 = polyval(p8, V);

% Plot original data and polynomial fits
figure;
subplot(2,1,1);
plot(V, I_noisy, 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
plot(V, I_poly4, 'b', 'LineWidth', 2);
plot(V, I_poly8, 'g', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A)');
title('Polynomial Fitting to Noisy Data');
legend('Noisy Data', '4th Order Fit', '8th Order Fit');
grid on;

% Logarithmic plot
subplot(2,1,2);
semilogy(V, abs(I_noisy), 'ro', 'MarkerSize', 4, 'MarkerFaceColor', 'r'); hold on;
semilogy(V, abs(I_poly4), 'b', 'LineWidth', 2);
semilogy(V, abs(I_poly8), 'g', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('Current (A) (Log Scale)');
title('Polynomial Fitting (Log Scale)');
legend('Noisy Data', '4th Order Fit', '8th Order Fit');
grid on;
