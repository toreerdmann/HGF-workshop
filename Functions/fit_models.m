function results = fit_models(u, dataset, models, c_opt)
% Fit a dataset with a number of models that are defined through an array
% of config files.

nsubjects = size(dataset, 2);
nconfig   = length(models);

results = struct;
for i=1:nsubjects
    for j=1:nconfig
        disp(['Subject: ', num2str(i), '  ---  Model: ', num2str(j)]);
        if strcmp(models{j}.m_prc.model, 'tapas_rw_binary')
            c_opt.maxIter = 100;
            c_opt.maxRegu = 5;
            c_opt.maxRst  = 10;
            c_opt.nRandInit = 0;
            results(i, j).fit = tapas_fitModel(dataset(:, i), u, ...
                models{j}.m_prc, ...
                models{j}.m_obs, c_opt);
            
        else
            results(i, j).fit = tapas_fitModel(dataset(:, i), u, ...
                models{j}.m_prc, ...
                models{j}.m_obs, ...
                c_opt);
        end
    end
end

