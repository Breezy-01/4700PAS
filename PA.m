% Parameters  
num_atoms = 6;           % Total number of atoms (2 anchors + 4 mobile)
mass = 1;                % Mass of each atom (arbitrary units)
k = 1.5;                   % Force constant (spring constant)
x0 = 1;                  % Equilibrium distance between neighboring atoms
dt = 0.01;               % Time step
num_steps = 2000;        % Number of simulation steps
perturbation_factor = 0.2; % Perturbation as a fraction of x0

% Initial positions (uniformly spaced)
positions = linspace(0, (num_atoms - 1) * x0, num_atoms);

% Add small perturbations to mobile atoms (atoms 2 to 5)
perturbation = perturbation_factor * x0 * (rand(1, num_atoms - 2) - 0.5);
positions(2:end-1) = positions(2:end-1) + perturbation;

% Initial velocities (starting from rest)
velocities = zeros(1, num_atoms);

% Simulation loop
for step = 1:num_steps
    % Compute forces
    forces = zeros(1, num_atoms);
    for i = 2:num_atoms-1
        % Force due to left neighbor
        left_distance = positions(i) - positions(i-1);
        forces(i) = forces(i) - k * (left_distance - x0);
        
        % Force due to right neighbor
        right_distance = positions(i+1) - positions(i);
        forces(i) = forces(i) + k * (right_distance - x0);
    end
    
    % Update positions and velocities for mobile atoms
    for i = 2:num_atoms-1
        % Update acceleration
        acceleration = forces(i) / mass;
        
        % Velocity Verlet integration
        velocities(i) = velocities(i) + 0.5 * acceleration * dt;
        positions(i) = positions(i) + velocities(i) * dt;
        velocities(i) = velocities(i) + 0.5 * acceleration * dt;
    end
    
    % Visualization (optional)
    if mod(step, 10) == 0
        plot(positions, zeros(1, num_atoms), 'bo-', 'MarkerFaceColor', 'b');
        hold on;
        plot(positions([1, num_atoms]), zeros(1, 2), 'rs', 'MarkerFaceColor', 'r');
        hold off;
        axis([positions(1)-1, positions(end)+1, -1, 1]);
        xlabel('Position');
        ylabel('Atom Index');
        title(['Step: ', num2str(step)]);
        drawnow;
    end
end