function [dataset, params, k] = simulate_mixture(u, models, nsubjects, seed)
% Simulates a data set that is a mixture of different models.
%
%

%% Set seed to make simulation reproducible
rng(seed);
seeds = round(rand(nsubjects, 1) .* 1000);


%% Draw model indices
nconfigs = numel(models);
k = randi(nconfigs, nsubjects, 1);


%% Simulate a dataset
params = cell(nsubjects,1);
dataset = zeros(length(u), nsubjects);
for i=1:nsubjects
    sim = tapas_sampleModel(u, models{k(i)}.m_prc, ...
                               models{k(i)}.m_obs, seeds(i));
    dataset(:,i) = sim.y;       
    params{i}.p_prc = sim.p_prc;
    params{i}.p_obs = sim.p_obs;
end


end

