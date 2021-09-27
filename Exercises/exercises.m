%#########################################################
% HGF-toolbox Workshop, CP-course Zurich, 18.09.2021
% Topic: Modelling data with the HGF
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% At this point, you have downloaded and extracted 
% the `tapas` toolbox.
% Load the toolbox and some helper functions.
% (Make sure your working directory is set to the 'Exercises' folder.)

close all; clear variables; clc;
addpath('../hgf-toolbox');
addpath('../Functions');
addpath('../Models');
rng(123);


%% #########################################################
%  1.0 Fitting a HGF model
%  #########################################################
% In this script, we'll analyse a dataset holding the responses
% of 20 subjects. We'll start with loading and visualising the data.
%


%% Load inputs and dataset
% Run this code and have a look at the data. u holds the inputs for each
% trial and dataset holds the responses, with one column per subject.
% p holds the true underlying contingencies (probability of outcome 1).
u = load('../data/inputs_u.csv');
p = load('../data/inputs_p.csv');
dataset = load('../data/task_responses.csv');


%% Look at dataset and design
% Run this code
nt = size(dataset, 1);
figure;
scatter(1:nt, dataset(:,1) + randn(nt,1) .* .05)
hold on;
% scatter(1:nt, dataset(:,2) + randn(nt,1) .* .05)
plot(1:nt, dataset)
plot(u, 'p')
plot(p, 'p')
plot(mean(dataset,2))
hold off;
legend('y_1', 'y_2', 'u', 'p', 'avg y');


% What is the type of the responses? What kind of probability distribution
% could you use to simulate random numbers of the same type?


%% Ex_1.1: 
% Fit model and plot estimates for a single subject. Use the default
% configuration file that can be found in the toolbox.
%
% What model can you fit?
% a) perceptual model: tapas_hgf_*type of inputs*_config
% b) response   model: tapas_*type of responses*_obs_config

%=== begin: Edit here ===
% conifg_prc = 'tapas_hgf_*type of inputs*_config'
% config_obs = 'tapas_*type of responses*_obs_config'
%=== end: Edit here ===

% fit:
fit = tapas_fitModel(dataset(:, 1), u, ...
                     config_prc, ...
                     config_obs, config_optim);
% plot:
tapas_hgf_binary_plotTraj(fit)


% How does the fit look?
% - good / bad
% - are there systematic deviations? Are we missing something?

% Look at fit object:
% Where can you find what?
% - the estimates for the parameters: perceptual and response model

% - the prior settings: perceptual and response model

% - the belief trajectories

% - the model fit index (LME)


%% #########################################################
%  2.0 Changing the model / priors
%  #########################################################

%% Ex_2.1:
% Now let's change the model / priors: For this, we need to setup our 
% own config files: Start by looking up the default config file 
% 'tapas_ehgf_binary_config.m' and copy it to your current folder.
%
% Do read the comments in it, they are very useful.
% 
% Try the following configurations:
%
% 1. Try the following configurations: Fix all parameters except omega2 
%    and omega3, by setting their prior variances to 0.
%    Save the config file as: `config_ehgf.m`
%    
% 2. Add another perceptual model. Start by copying the default config 
%    file "tapas_rw_binary_config' from the folder of the HGF toolbox and 
%    name it `config_rw.m`.
%
% 3. Add a response model. Start by copying the default config 
%    file "tapas_beta_obs_config' from the folder of the HGF toolbox and 
%    name it `config_beta_obs.m`.
%
% Note: be careful to also change the name of the functions within the
% files.

% Once you have the config files, fit each of these models to the data of 
% a single subject by running the code below:
configs_prc = {config_rw, config_ehgf};
configs_obs = {config_beta_obs};
% Define the set of models by combining perceputal and response models.
models = make_models(configs_prc, configs_obs);
                                
%% Fit each of the models.
results = struct;
for i=1:size(models,1)
    for j=1:size(models,2)
        results(i,j).fit = tapas_fitModel(dataset(:, 1), u, ...
                                        models{i,j}.m_prc, ...
                                        models{i,j}.m_obs, ...
                                        config_optim);
    end
end

%% Look at the parameter estimates
results(1).fit.p_prc
results(1).fit.p_obs
results(2).fit.p_prc
results(2).fit.p_obs


%% Plot the belief trajectories of the hgf and rw models together:
figure;
scatter(1:nt, results(2).fit.u);
hold on;
scatter(1:nt, results(2).fit.y);
plot(results(1).fit.traj.v(:,1));
plot(results(2).fit.traj.muhat(:,1));
legend('u', 'y', 'M1_v', 'M2_\mu');
hold off;

% Why are we plotting muhat? Try plotting mu.

% Fit the data of another subject: dataset(:,1) -> dataset(:, 2).

% Describe the qualitative differences between the models.


%% Plot prediction errors
% Plot the prediction errors of the HGF (level 1 and level 3) and 
% those of the RW model together:

%=== begin: Edit here ===
figure;
% ?plot(results(1).fit.traj.da);
% old on;
plot(results(2).fit.traj.da);
% hold off;
legend('da_1', 'da_2', 'da_3');
%=== end: Edit here ===



%% Ex_2.2:
% We now do a posterior predictive check.
%
% Simulate from each model for one example participant.
% Read the documentation by calling `help tapas_simModel` and insert
% the right arguments in the function below.

nreps = 10;
nm = numel(models);
yrep = zeros(length(u), nreps, nm);
for rep=1:nreps
    for j=1:nm
        sim = tapas_simModel(u, ...
                            results(j).fit.c_prc.model, ...
                            results(j).fit.p_prc.p, ...
                            results(j).fit.c_obs.model, ...
                            results(j).fit.p_obs.p);
        yrep(:, rep, j) = sim.y;
    end
end

%% Compare real and simulated observations.
% Read the code of the function below and run the code.
plot_sim_obs(yrep(:,:,:), dataset(:,1));

% Are there systematic differences?

% Which model seems to visually fit best?

% Try repeating the above steps for the data from other participants.


%% #########################################################
%  3.0. Prior predictive simulations
%  #########################################################

%% Ex_3.1:
% To reason about the model and try ideas for setting the priors,
% one should do some prior simulations. For these, simulate data
% from two models only differing in a single parameter.
%
% Find out the effect of some of the parameters.
%
% Do the following:
% 1. Load one of your HGF configurations.
% 2. Change one parameter, and making sure that the rest is fixed.
% 3. Simulate data and inspect it.
% Can you interpret the meaning through the change in data?


% Get the configuration of the perceptual model
my_config1 = config_ehgf();
% Make a copy of the configuration: 
my_config2 = my_config1;
% - Try comparing low/high values for omega_2.
% (Remember to fix all other parameters.)
% - Try the same for omega_3.
% - Try exploring the response model parameters.

% After setting the values

%=== begin: Edit here ===
% my_config1.parameter  =  ....
% my_config2.parameter  = ....
%=== end: Edit here ===

% Make sure settings in config files are consistent.
my_config1 = tapas_align_priors(my_config1);
my_config2 = tapas_align_priors(my_config2);
config_obs = config_beta_obs();
config_obs.lognuprmu = 30;
config_obs.lognuprsa = 0;


%% Run both models:
seed = 123;
samples1 = tapas_sampleModel(u, my_config1, config_obs, seed);
samples2 = tapas_sampleModel(u, my_config2, config_obs, seed);

% Plot the responses:
figure;
scatter(1:nt, samples1.y);
hold on;
scatter(1:nt, samples2.y);
scatter(1:nt, u);
hold off;
legend('config 1', 'config 2');


%% Plot the trajectories of the beliefs

%=== begin: Edit here ===
% plot(samples1.___);
% hold on;
% plot(samples2.___);
% hold off;
% legend('config 1', 'config 2');
%=== end: Edit here ===

% What do you see? What effect does the parameter you are varying have?



%% #########################################################
%  4.0. Fitting multiple subjects and comparing models
%  #########################################################
%
% List the names of the config files you created in 'config_files' and
% use the function 'fit_model' below to fit all models to all subjects.
%
%% Ex_4.1:
% Read the code for the `fit_model` function and then run the code.
results_all = fit_models(u, dataset, models, config_optim);
% This can take a little while (couple minutes).

% Save the model fits.
save('../Data/results_all.mat', 'results_all');

% Extract omega parameters of the HGF models for plotting
values = extract_parameter(results_all(:,2), 'p_prc.om');


%% Plot boxplot for omega2 and omega3 for config 1
figure; 
boxplot(values(:, 2:3, 1), 'labels', {'M2_om2', 'M2_om3'});
figure;
boxplot(values(:, 2:3, 2), 'labels', {'M3_om2', 'M3_om3'});

% What do you make of this difference in estimates?
% How did the prior specification differ?

%% Compare estimates with true parameters
load('../Data/params.mat');
k = load('../data/task_k-true.csv');


% Look at omega 2...
plot_compare_params(results_all, params, k, 2, 'p_prc.om(2)');
% and omega 3
plot_compare_params(results_all, params, k, 2, 'p_prc.om(3)');


%% For each subject, who is described best by each model?
nconfigs  = length(models);
nsubjects = size(dataset,2);
values    = zeros(nsubjects, length(models));

% Look at the fit indices.
for i=1:nsubjects
    for j=1:length(models)
        values(i,j) = sum(results_all(i, j).fit.optim.res.^2);
    end
end
% Look at true index vs. fit indices per model 
% (rows: subjects, columns: values)
disp([k values]);


%% Ex_4.2:
% Use the function 'pp_check' to look at other subjects and models.

i = 1;
figure;
for j=1:numel(models)
    subplot(numel(models), 1, j);
    yrep = pp_check(i, j, 10, u, dataset, results_all);
end

% Which model fits best?



%% #########################################################
%  5.0. Try other designs
%  #########################################################
% 
% We've seen that there are different "kinds" of subjects.
% Now we want to try different designs and repeat the whole analysis.
% We will be simulating behavior from different models, fitting them
% with priors and see if we can detect from which model they were
% simulated.
% 
% Some designs will work better than others: Think about what should 
% make the differences come out more pronounced in the analysis.


%% Ex_5.1:
% Read the code of the `run_simulation` function.
%
% Try it out:
% - try random design: u = randi(0:1, 250, 1)
% - try more or less volatile designs
% - try placing the volatile phase in the first half
%
% Note: You might want to fix more parameters in the config files used
% to simulate the data. Otherwise, noise in the parameeters might be too
% large to distinguish between models. Once you have something working,
% you can start increasing the variance assess the sensitivity of the 
% analysis.
%
% run_simulation(10, 123);


