function results = fit_models(u, dataset, models)
% Fit a dataset with a number of models that are defined through an array
% of config files.

nsubjects = size(dataset, 2);
nconfig   = length(models);

results = struct;
for i=1:nsubjects
    for j=1:nconfig
        results(i, j).fit = tapas_fitModel(dataset(:, i), u, ...
                            models{j}, ...
                            config_beta_obs);
    end
end

end