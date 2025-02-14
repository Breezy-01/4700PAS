% Grid Size
nx = 50; 
ny = 50; 
N = nx * ny;  % Total number of grid points

% Sparse matrix initialization
G = sparse(N, N);

% Finite Difference Coefficients for 5-point Laplacian
for i = 1:nx
    for j = 1:ny
        n = j + (i - 1) * ny;  % Mapping 2D indices to 1D index
        
        if i == 1 || i == nx || j == 1 || j == ny
            % Boundary Condition: u = 0
            G(n, :) = 0;    % Set entire row to 0
            G(n, n) = 1;    % Set diagonal entry to 1
        else
            % Interior points: Discretized 2D Laplacian (5-point stencil)
            G(n, n) = -4;
            G(n, n - 1) = 1;   % Left neighbor
            G(n, n + 1) = 1;   % Right neighbor
            G(n, n - ny) = 1;  % Bottom neighbor
            G(n, n + ny) = 1;  % Top neighbor
        end
    end
end

% Display matrix structure
spy(G);
title('Sparsity Pattern of G Matrix with Enforced BCs');
xlabel('Column Index');
ylabel('Row Index');
