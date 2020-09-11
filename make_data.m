addpath('Exercises/Functions/')
addpath('configs')

%% Load inputs
u = load('data/inputs_binary_u.csv');

%% Sim data
models = {config_rw, config_hgf_1, config_hgf_2};
     
nsubjects = 20;
seed = 123;
[dataset, k] = simulate_mixture(u, models, nsubjects, seed);

%% Save data
csvwrite('data/task_responses.csv', dataset);
csvwrite('data/task_k-true.csv', k);

