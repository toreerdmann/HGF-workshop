function run_simulation(nsubjects, seed)

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
[dataset, k] = simulate_mixture(u, nsubjects, seed);

                            
%% fit 
config_files = ["custom_hgf_binary_config_2", ...
                "custom_hgf_ar1_binary_config_2", ...
                "custom_rw_binary_config"];
results = fit_models(u, dataset, config_files);


%% For each subject, who is described best by each model?
nconfigs = length(config_files);
values = zeros(nsubjects, length(config_files));

% Look at the fit indices.
for i=1:nsubjects
    for j=1:length(config_files)
        values(i,j) = results(i, j).fit.optim.LME;
    end
end


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
    [m, j] = max(values(i,:));
    kest(i) = j;
end
% number of correctly classified individuals
sum(kest == k)

end