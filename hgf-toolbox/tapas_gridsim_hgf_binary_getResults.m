function tapas_gridsim_hgf_binary_getResults
% This function collects the results from a grid simulation and
% saves them in a structure
%
% USAGE:
%     tapas_gridsim_hgf_binary_getResults
%
% OUTPUT:
%     gridestimates.mat - file containing the estimates

% Number of simulations per grid point
nsim = 1000;

% Define the grid
omega2 = -8:1:-1;
zeta   = [0.5 1 6 24];

% Initialize estimate structure
estimates = NaN(length(omega2),length(zeta),nsim,2);

for i = 1:length(omega2)
    for j = 1:length(zeta)
        for k = 1:nsim
            filename = fullfile('estimates', num2str(omega2(i)), num2str(zeta(j)), sprintf('est%04.0f.mat', k));
            load(filename);
            estimates(i,j,k,1) = est.p_prc.om(2);
            estimates(i,j,k,2) = est.p_obs.ze;
            %disp([est.p_prc.om(2) est.p_obs.ze])
            %disp(filename)
            %disp(' ')
        end
    end
end

save('gridestimates.mat', 'estimates');

end
