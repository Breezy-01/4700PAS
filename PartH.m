% Constants
e = 1.602176634e-19;
m_e = 9.10938356e-31;

% Parameters
dt = 1e-15;
t_max = 1e-12;
E = 1e5;
scatter_prob = 0.05;
num_particles = 1000;
mode = 'elastic';  % Options: 'inelastic' or 'elastic'

% Time Array
t = 0:dt:t_max;
num_steps = length(t);

% Initialize arrays
x = zeros(num_particles, num_steps);
v = zeros(num_particles, num_steps);

% Acceleration
a = (e * E) / m_e;

% Time Evolution
for n = 2:num_steps
    % Identify scattered particles
    scatter_events = rand(num_particles, 1) < scatter_prob;
    
    if strcmp(mode, 'inelastic')
        v(scatter_events, n-1) = 0;  % reset to 0
    elseif strcmp(mode, 'elastic')
        v(scatter_events, n-1) = -0.25 * v(scatter_events, n-1);  % reflection
    end

    % Update motion
    v(:,n) = v(:,n-1) + a * dt;
    x(:,n) = x(:,n-1) + v(:,n-1) * dt + 0.5 * a * dt^2;
end

% Drift velocity
x_avg = mean(x(:,end));
v_drift = x_avg / t(end);

% Plotting
figure('Name','Electron Drift Comparison','NumberTitle','off');
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

sgtitle(sprintf('%s Scattering: Drift Velocity = %.2e m/s', ...
        capitalize(mode), v_drift), 'FontWeight', 'bold');

% Helper function to capitalize strings
function out = capitalize(str)
    out = lower(str); out(1) = upper(out(1));
end
