function tapas_gridsim_hgf_binary(simno)
% This function simulates and inversts hgf_binary data. See also tapas_gridsim_wrapper_hgf_binary.m
%
% USAGE:
%     tapas_gridsim_hgf_binary(simno);
%
% INPUT:
%     simno  - a number serving as a simulation identifier that will be part of the name ofthe
%     file where the inversion result is stored
%
% OUTPUT:
%     estimates/omega2/zeta/est<simno>.mat - files containing the estimates

% Define the grid
omega2 = -8:1:-1;
zeta   = [0.5 1 6 24];

% Add toolbox path
toolboxpath = '/cluster/home03/itet/chmathys/Matlab/hgfToolBox_gridsim0.1';
addpath(genpath(toolboxpath));

% Load the inputs
u = load(fullfile(toolboxpath,'example_binary_input.txt'));

for i = omega2
    for j = zeta
        % Create the needed directories
        if ~exist('estimates', 'dir') mkdir('estimates'); end
        dirname = ['estimates/' num2str(i)];
        if ~exist(dirname, 'dir') mkdir(dirname); end
        dirname = ['estimates/' num2str(i) '/' num2str(j)];
        if ~exist(dirname, 'dir') mkdir(dirname); end

        try
            % Simulate
            sim = tapas_simModel(u, 'tapas_hgf_binary', [NaN 0 1 NaN 1 1 NaN 0 0 1 1 NaN i -6], 'tapas_unitsq_sgm', j);

            % Invert
            est = tapas_fitModel(sim.y, sim.u, 'tapas_hgf_binary_config', 'tapas_unitsq_sgm_config', 'tapas_quasinewton_optim_config');

            % Save to disk
            filename = fullfile('estimates', num2str(i), num2str(j), sprintf('est%04.0f.mat', simno));
            save(filename, 'est');
        catch
            str = 'fail';
            filename = fullfile('estimates', num2str(i), num2str(j), sprintf('failedest%04.0f.mat', simno));
            save(filename, 'str');
        end
    end
end

end
