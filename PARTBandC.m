% Constants
e = 1.602176634e-19;      % Electron charge (C)
m_e = 9.10938356e-31;     % Electron mass (kg)

% Simulation Parameters
dt = 1e-15;               % Time step (s)
t_max = 1e-12;            % Total simulation time (s)
E = 1e5;                  % Electric field (V/m)

% Time Array
t = 0:dt:t_max;           % Time vector

% Initialize Position and Velocity Arrays
num_steps = length(t);
x = zeros(1, num_steps);  % Position (m)
v = zeros(1, num_steps);  % Velocity (m/s)

% Simulation Loop
for n = 2:num_steps
    % Compute acceleration due to electric field
    a = (e * E) / m_e;
    
    % Update velocity
    v(n) = v(n-1) + a * dt;
    
    % Update position
    x(n) = x(n-1) + v(n-1) * dt + 0.5 * a * dt^2;
end

% Plot Results
figure;
subplot(2,1,1);
plot(t, x);
xlabel('Time (s)');
ylabel('Position (m)');
title('Electron Position over Time');
grid on;

subplot(2,1,2);
plot(t, v);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Electron Velocity over Time');
grid on;
