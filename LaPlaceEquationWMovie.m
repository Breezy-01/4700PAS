%Define Grid Size
nx = 50;
ny = 50;
V = zeros(nx,ny);

%Iterarion Parameters
maxIter = 5000;
tolerance = 1e-6;
error = inf;
iter = 0;

figure;
colormap(jet);
frames = struct('cdata', [], 'colormap', []);

%Iterative Solution using Gaussian method
while error > tolerance && iter < maxIter
    V_old = V;
    for i = 2:nx-1
        for j = 2:ny-1
            V(i,j) = 0.25 * (V(i+1,j) + V(i-1,j) + V(i, j+1) + V(i, j-1));
        end
    end

    %Apply Boundary Conditions
    V(:,1) = 1;
    V(:,end) = 0;
    V(1,:) = V(2,:);
    V(end,:) = V(end-1,:);

    %Compute the Error
    error = max(max(abs(V-V_old)));
    iter = iter +1;

    imagesc(V);
    colorbar;
    title(sprintf('Iteration: %d', iter));
    xlabel('X');
    ylabel('Y');
    set(gca, 'YDir', 'normal');

    if mod(iter, 10) == 0
        frames(iter/10) = getframe(gcf);
    end

    %Display Progress of 100 iters
    if mod(iter, 100) == 0
        fprintf('Iteration: %d, Max error: %.6f\n', iter, error);
    end
end


if error < tolerance
     fprintf('Converge after %d iterations with max error %.6f\n', iter, error);
else
     fprintf('Stopped after %d iterations with max error %.6e (did not fully converge)\n', iter, error);
end

figure;
movie(frames, 3, 10);
title('Evolution of Laplace Solution')