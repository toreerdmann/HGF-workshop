function tapas_gridsim_wrapper_hgf_binary
% Wrapper for simulating and inverting hgf_binary data. This function submits
% jobs to Brutus that execute tapas_gridsim_hgf_binary for a single simulation
% at a given grid point.
%
% USAGE:
%     tapas_wrapper_gridsim_hgf_binary
%
% OUTPUT:
%     estimates/omega2/omega3/est<simno>.mat - files containing the estimates

% Number of simulations per grid point
nsim = 1000;

% Add toolbox path
addpath(genpath('/cluster/home03/itet/chmathys/Matlab/hgfToolBox_gridsim0.1'));

for k = 1:nsim
    commandstring = ['bsub -W 8:00 matlab -nojvm -nodisplay -singleCompThread -r tapas_gridsim_hgf_binary\(' num2str(k) '\)'];
    system(commandstring);
end

exit
