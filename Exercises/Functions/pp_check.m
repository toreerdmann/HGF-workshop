function yrep = pp_check(i, j, nreps, u, dataset, config_files, results)
% Function for performing graphical posterior predictive checks.
%

% Evaluate config_file of jth model (to get model name)
c = eval(config_files(j));

% Simulate observations using the estimated parameters
yrep = zeros(length(u), nreps);
for rep=1:nreps
        s = tapas_simModel(u, ...
                           c.model, ...
                           results(i, j).fit.p_prc.p, ...
                           'tapas_beta_obs', ...
                            results(i, j).fit.p_obs.p);
    yrep(:, rep) = s.y;
end

% Compare real and simulated observations.
plot(yrep, 'black');
hold on;
plot(dataset(:,i), 'red', 'LineWidth', 2);
hold off;

end