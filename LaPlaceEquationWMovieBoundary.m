% Define grid size
nx = 50; % Number of points in x-direction
ny = 50; % Number of points in y-direction
V = zeros(nx, ny); % Initialize potential matrix

% Iteration parameters
maxIter = 5000;    % Maximum number of iterations
tolerance = 1e-6;  % Convergence criterion
error = inf;       % Initialize error
iter = 0;          % Iteration counter

% Set up figure for visualization
figure;
colormap(jet);
frames = struct('cdata', [], 'colormap', []); % Preallocate movie frames

%% --- First Phase: Original BCs ---
fprintf('Solving with initial boundary conditions...\n');

% Apply initial boundary conditions
V(:,1) = 1;      % Left boundary (V = 1)
V(:,end) = 0;    % Right boundary (V = 0)
V(1,:) = V(2,:); % Top boundary (Neumann: ∂V/∂y = 0)
V(end,:) = V(end-1,:); % Bottom boundary (Neumann: ∂V/∂y = 0)

while error > tolerance && iter < maxIter
    V_old = V; % Store previous iteration
   
    % Update the solution for interior points
    for i = 2:nx-1
        for j = 2:ny-1
            V(i,j) = 0.25 * (V(i+1,j) + V(i-1,j) + V(i,j+1) + V(i,j-1));
        end
    end

    % Reapply boundary conditions
    V(:,1) = 1;      
    V(:,end) = 0;    
    V(1,:) = V(2,:);
    V(end,:) = V(end-1,:);

    % Compute error
    error = max(max(abs(V - V_old)));
    iter = iter + 1;
   
    % Plot and capture frames
    imagesc(V);
    colorbar;
    title(sprintf('Phase 1: Iteration %d', iter));
    xlabel('X'); ylabel('Y');
    set(gca, 'YDir', 'normal');
    drawnow;
   
    % Capture frame every 10 iterations
    if mod(iter, 10) == 0
        frames(iter/10) = getframe(gcf);
    end
   
    % Display progress
    if mod(iter, 100) == 0
        fprintf('Iteration: %d, Max Error: %.6e\n', iter, error);
    end
end

fprintf('Phase 1 converged after %d iterations with max error %.6e\n', iter, error);

%% --- Second Phase: Reset BCs ---
fprintf('Resetting boundary conditions...\n');
error = inf; % Reset error
iter = 0;    % Reset iteration counter

% Apply new boundary conditions
V(:,1) = 1;   % Left boundary (V = 1)
V(:,end) = 1; % Right boundary (V = 1)
V(1,:) = 0;   % Top boundary (V = 0)
V(end,:) = 0; % Bottom boundary (V = 0)

while error > tolerance && iter < maxIter
    V_old = V; % Store previous iteration
   
    % Update the solution for interior points
    for i = 2:nx-1
        for j = 2:ny-1
            V(i,j) = 0.25 * (V(i+1,j) + V(i-1,j) + V(i,j+1) + V(i,j-1));
        end
    end

    % Reapply new boundary conditions
    V(:,1) = 1;  
    V(:,end) = 1;
    V(1,:) = 0;  
    V(end,:) = 0;

    % Compute error
    error = max(max(abs(V - V_old)));
    iter = iter + 1;
   
    % Plot and capture frames
    imagesc(V);
    colorbar;
    title(sprintf('Phase 2: Iteration %d', iter));
    xlabel('X'); ylabel('Y');
    set(gca, 'YDir', 'normal');
    drawnow;
   
    % Capture frame every 10 iterations
    if mod(iter, 10) == 0
        frames(iter/10 + maxIter/10) = getframe(gcf);
    end
   
    % Display progress
    if mod(iter, 100) == 0
        fprintf('Iteration: %d, Max Error: %.6e\n', iter, error);
    end
end

fprintf('Phase 2 converged after %d iterations with max error %.6e\n', iter, error);

%% --- Play Movie of Both Phases ---
figure;
movie(frames, 3, 10); % Play movie 3 times at 10 frames per second
title('Evolution of Laplace Solution (Both Phases)');