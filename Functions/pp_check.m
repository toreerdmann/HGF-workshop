function yrep = pp_check(i, j, nreps, u, dataset, results)
% Function for performing graphical posterior predictive checks.
%


% Simulate observations using the estimated parameters
yrep = zeros(length(u), nreps);
for rep=1:nreps
        s = tapas_simModel(u, ...
                           results(i, j).fit.c_prc.model, ...
                           results(i, j).fit.p_prc.p, ...
                           results(i, j).fit.c_obs.model, ...
                           results(i, j).fit.p_obs.p);
    yrep(:, rep) = s.y;
end

% Compare real and simulated observations.
plot(yrep, 'black');
hold on;
plot(dataset(:,i), 'red', 'LineWidth', 2);
hold off;

end