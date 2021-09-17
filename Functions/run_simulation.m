function run_simulation(nsubjects, models, seed)

%% Choose inputs
p = [repmat([.85], 40, 1),
     repmat([.15], 40, 1),
     repmat([.85], 10, 1),
     repmat([.15], 10, 1),
     repmat([.85], 10, 1),
     repmat([.15], 10, 1),
     repmat([.85], 40, 1),
     repmat([.15], 40, 1)];
u = zeros(length(p), 1);
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end


%% Simulate
[dataset, params, k] = simulate_mixture(u, models, nsubjects, seed);

                            
%% Fit 
c_opt = config_optim;
% Increase number of re-starts to improve chances of finding optimum
c_opt.nRandInit = 10;
results = fit_models(u, dataset, models, c_opt);


%% For each subject, who is described best by each model?
nconfigs = length(models);
values = zeros(nsubjects, length(models));

% Look at the fit indices.
for i=1:nsubjects
    for j=1:length(models)
        % use LME:
        % values(i,j) = results(i, j).fit.optim.LME;
        % use SSE:
        values(i,j) = sum(results(i, j).fit.optim.res.^2);

    end
end
disp(values);

%% Plot by true model

fig = figure;
for i=1:nconfigs
    subplot(nconfigs,1,i);
    boxplot(values(k == i,:));
    hold on;
    xcoords = repmat(1:nconfigs, nsubjects, 1) + ...
                     .3 * (rand(nsubjects, nconfigs) - .5);
    plot(xcoords(k==i,:), values(k==i,:), 'p');
    hold off;
end
disp(fig);


%% Estimate k from model evidence

kest = zeros(nsubjects, 1);
for i=1:nsubjects
    [~, j] = max(values(i,:));
    kest(i) = j;
end
% number of correctly classified individuals
sum(kest == k)


