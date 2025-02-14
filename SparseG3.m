% Grid Size
nx = 50; 
ny = 50; 
N = nx * ny;  % Total number of grid points

% Sparse matrix initialization
G = sparse(N, N);

% Constructing the finite-difference matrix
for i = 1:nx
    for j = 1:ny
        n = j + (i - 1) * ny;  % Convert 2D index to 1D index
        
        if i == 1 || i == nx || j == 1 || j == ny
            % Boundary Condition: u = 0
            G(n, :) = 0;    % Zero out the row
            G(n, n) = 1;    % Set diagonal to 1
        else
            % Interior nodes: Apply 5-point stencil for 2D Laplacian
            G(n, n) = -4;
            G(n, n - 1) = 1;   % Left neighbor
            G(n, n + 1) = 1;   % Right neighbor
            G(n, n - ny) = 1;  % Bottom neighbor
            G(n, n + ny) = 1;  % Top neighbor
        end
    end
end

% Display sparsity pattern of matrix G
spy(G);
title('Sparsity Pattern of G Matrix with FD Equations Applied');
xlabel('Column Index');
ylabel('Row Index');
