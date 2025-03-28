% Constants
e = 1.602176634e-19;      % Electron charge (C)
m_e = 9.10938356e-31;     % Electron mass (kg)

% Simulation Parameters
dt = 1e-15;               % Time step (s)
t_max = 1e-12;            % Total simulation time (s)
E = 1e5;                  % Electric field (V/m)
scatter_prob = 0.05;      % Probability of scattering at each time step

% Time Array
t = 0:dt:t_max;           
num_steps = length(t);

% Initialize Arrays
x = zeros(1, num_steps);  % Position (m)
v = zeros(1, num_steps);  % Velocity (m/s)

% Acceleration (constant)
a = (e * E) / m_e;

% Initialize Figure
fig = figure('Name','1D Electron Simulation with Scattering','NumberTitle','off');

subplot(2,2,1); % Position vs Time
xlabel('Time (s)'); ylabel('Position (m)');
title('Position vs Time'); grid on; hold on;

subplot(2,2,2); % Velocity vs Time
xlabel('Time (s)'); ylabel('Velocity (m/s)');
title('Velocity vs Time'); grid on; hold on;

subplot(2,2,[3 4]); % Velocity vs Position (Phase Space)
xlabel('Position (m)'); ylabel('Velocity (m/s)');
title('Velocity vs Position'); grid on; hold on;

% Simulation Loop with Scattering and Animation
for n = 2:num_steps
    % Check for scattering
    if rand() < scatter_prob
        v(n-1) = 0;  % Scattered, zero previous velocity
    end

    % Update velocity and position
    v(n) = v(n-1) + a * dt;
    x(n) = x(n-1) + v(n-1) * dt + 0.5 * a * dt^2;

    % Plot Updates
    subplot(2,2,1); plot(t(1:n), x(1:n), 'b'); drawnow;
    subplot(2,2,2); plot(t(1:n), v(1:n), 'r'); drawnow;
    subplot(2,2,[3 4]); plot(x(1:n), v(1:n), 'k'); drawnow;
end

% Calculate and Display Drift Velocity
v_drift = x(end) / t(end);
sgtitle(sprintf('Drift Velocity = %.2e m/s', v_drift), 'FontWeight', 'bold');
