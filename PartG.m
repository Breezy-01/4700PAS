% Constants
e = 1.602176634e-19;      % Electron charge (C)
m_e = 9.10938356e-31;     % Electron mass (kg)

% Simulation Parameters
dt = 1e-15;               % Time step (s)
t_max = 1e-12;            % Total simulation time (s)
E = 1e5;                  % Electric field (V/m)
scatter_prob = 0.05;      % Probability of scattering
num_particles = 1000;     % Number of electrons

% Time Array
t = 0:dt:t_max;
num_steps = length(t);

% Initialize Position and Velocity Arrays
x = zeros(num_particles, num_steps);
v = zeros(num_particles, num_steps);

% Constant Acceleration
a = (e * E) / m_e;

% Simulation Loop for All Particles
for n = 2:num_steps
    % Check for scattering: each particle may scatter independently
    scatter_events = rand(num_particles, 1) < scatter_prob;
    v(scatter_events, n-1) = 0;

    % Update velocity and position
    v(:,n) = v(:,n-1) + a * dt;
    x(:,n) = x(:,n-1) + v(:,n-1) * dt + 0.5 * a * dt^2;
end

% Calculate Average Drift Velocity
x_avg = mean(x(:,end));
v_drift = x_avg / t(end);

% Plot Average Position and Velocity Over Time
figure('Name','Multi-Electron 1D Simulation','NumberTitle','off');

subplot(2,2,1);
plot(t, mean(x,1), 'b');
xlabel('Time (s)'); ylabel('Avg. Position (m)');
title('Average Position vs Time'); grid on;

subplot(2,2,2);
plot(t, mean(v,1), 'r');
xlabel('Time (s)'); ylabel('Avg. Velocity (m/s)');
title('Average Velocity vs Time'); grid on;

subplot(2,2,[3 4]);
plot(mean(x,1), mean(v,1), 'k');
xlabel('Avg. Position (m)'); ylabel('Avg. Velocity (m/s)');
title('Average Phase Space Trajectory'); grid on;

sgtitle(sprintf('Drift Velocity (%.0f particles) = %.2e m/s', num_particles, v_drift), ...
        'FontWeight', 'bold');
