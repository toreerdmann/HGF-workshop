function tapas_gridsim_hgf_binary_plotResults(estimates)
% This function plots the results from a grid simulation
%
% USAGE:
%     tapas_gridsim_hgf_binary_plotResults(estimates)


% Number of simulations per grid point
nsim = 1000;

% Reshape
est = reshape(estimates, 32*nsim, 2);

% Define the grid
omega2 = -8:1:-1;
zeta   = [0.5 1 6 24];

% Plot
scatter(est(:,1), est(:,2), '.')
axis([-9 0 -2 60])

end
