function results = fit_models(u, dataset, config_files)
% Fit a dataset with a number of models that are defined through an array
% of config files.

nsubjects = size(dataset, 2);
nconfig   = length(config_files);

results = struct;
for i=1:nsubjects
    for j=1:nconfig
        results(i, j).fit = tapas_fitModel(dataset(:, i), u, ...
                            config_files(j), ...
                            'tapas_beta_obs_config');
    end
end

end