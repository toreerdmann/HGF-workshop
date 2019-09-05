addpath('Exercise_01/Functions/')

%% Load inputs
u = load('data/inputs_binary_u.csv');

%% Sim data
nsubjects = 20;
seed = 123;
[dataset, nus, k] = simulate_mixture(u, nsubjects, seed);

%% Save data
csvwrite('data/task_responses.csv', dataset);
csvwrite('data/task_nus.csv', dataset);
csvwrite('data/task_k-true.csv', k);