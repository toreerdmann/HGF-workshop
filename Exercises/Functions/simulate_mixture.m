function [dataset, k] = simulate_mixture(u, models, nsubjects, seed)
% Simulates a data set that is a mixture of different models.
%
%

%% Set seed to make simulation reproducible
rng(seed);
seeds = round(rand(nsubjects, 1) .* 1000);


%% Draw model indices
nconfigs = length(models);
k = randi(nconfigs, nsubjects, 1);


%% Simulate a dataset
dataset = zeros(length(u), nsubjects);
for i=1:nsubjects
    sim = tapas_sampleModel(u, models{k(i)}, ...
                               config_beta_obs, seeds(i));
    dataset(:,i) = sim.y;       
end



end

