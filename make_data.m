clear;
close all;
addpath('hgf-toolbox')
addpath('Functions')
% these are the 'true' config files
addpath('Configs')
addpath('Models')

%% Load inputs
%u = load('data/inputs_binary_u.csv');

%% Simulate inputs
rng(123);
prob = .7;
p = [repmat(prob, 50, 1); repmat(1-prob, 50, 1); ...
     repmat(prob, 50, 1); repmat(1-prob, 20, 1); ...
     repmat(prob, 20, 1); repmat(1-prob, 20, 1); ...
     repmat(prob, 20, 1); repmat(1-prob, 20, 1)];
u = rand(length(p), 1) < p;

%% Make models
configs_prc = {config_rw, config_ehgf};
configs_obs = {config_beta_obs};

models = make_models(configs_prc, configs_obs);
% models(3) = [];

%% Sim data     
nsubjects = 20;
seed = 123;
[dataset, params, k] = simulate_mixture(u, models, nsubjects, seed);

%% Save data
csvwrite('Data/inputs_u.csv', u);
csvwrite('Data/inputs_p.csv', p);
csvwrite('Data/task_responses.csv', dataset);
csvwrite('Data/task_k-true.csv', k);
save('Data/params.mat', 'params');