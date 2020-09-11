%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2020
% Topic: Modelling data with the HGF
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% At this point, you have downloaded and extracted 
% the `tapas` toolbox.
% Load the toolbox and some helper functions

close all; clear variables; clc;
addpath('../../../repos/hgf-toolbox');
addpath('Functions');




%% #########################################################
%  1.0 Fitting a HGF model
%  #########################################################
% In this script, we'll analyse a dataset holding the responses
% of 20 subjects. We'll start with loading and visualising the data.
%


%% Load inputs and dataset
% Run this code and have a look at the data. u holds the inputs for each
% trial and dataset holds the responses, with one column per subject.
u = load('../data/inputs_binary_u.csv');
p = load('../data/inputs_binary_p.csv');
dataset = load('../data/task_responses.csv');


%% Look at dataset and design
% Run this code
figure;
plot(dataset)
hold on;
plot(u, 'p')
plot(p, 'p')
hold off;

% What is the type of the responses? What kind of probability distribution
% could you use to simulate random numbers of the same type?


%% Ex_1.1: 
% Fit model and plot estimates for a single subject. Use the default
% configuration file that can be found in the toolbox.
%
% What model can you fit?
% a) perceptual model: tapas_hgf_*type of inputs*_config
% b) response   model: tapas_hgf_*type of responses*_obs_config

% == Edit here ==
% config_prc = tapas_ehgf_***_config;
% config_rsp = tapas_***_obs_config;
config_prc = tapas_ehgf_binary_config;
config_rsp = tapas_beta_obs_config;
% == Edit here ==

% fit:
fit = tapas_fitModel(dataset(:, 1), u, ...
               config_prc, ...
               config_rsp);
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



%% Ex_1.2:
% Now let's change the model / priors: For this, we need to setup our 
% own config file: Start by copying over the default config file 
% 'tapas_ehgf_binary_config.m' and read the comments in it.
% 
% Try the following configurations:
%
% 1. Fix all parameters except omega2 and omega3, by setting their prior
%    variances to 0. 
%    Save the config file as: `config_hgf_1.m`
%
% 2. Create another prior setting named `config_hgf_2.m` with the same
%    settings, except for mu_0mu(3).
%    
% 3. Try alternatives for the process model. For these, you can start 
%    by copying the default config files from the folder of the HGF 
%    toolbox and then adjust these.
%    a) RW belief model: use the default config file
%       name it `config_rw.m`

% Once you have the config files, fit each of these models to the data of 
% a single subject by running the code below:
config_files = ["config_rw", ...
                "config_hgf_1", ...
                "config_hgf_2"];
            
results = struct;
for i=1:length(config_files)
    results(i).fit = tapas_fitModel(dataset(:, 1), u, ...
                                    eval(config_files(i)), ...
                                    config_beta_obs);
end


%% Plot the belief trajectories of the hgf and rw models together:
scatter(1:240, results(2).fit.u);
hold on;
scatter(1:240, results(2).fit.y);
plot(results(1).fit.traj.v(:,1));
plot(results(2).fit.traj.muhat(:,1));
plot(results(3).fit.traj.muhat(:,1));
hold off;


%% Plot prediction errors
% Plot the prediction errors of the HGF (level 1 and level 3) and 
% those of the RW model together:

plot(results(3).fit.traj.da(:,1));
hold on;
plot(results(3).fit.traj.da(:,3));
hold off;

%% Describe the qualitative differences between the models.

% RW: constant learning rate
% hgf1: constant learning rate

% hgf model with high / low belief in volatility
% priors affect estimate of mu0_3, but estimates look similar

%% #########################################################
%  1.3.0. Checking the models
%  #########################################################
% We now do a posterior predictive check.

%% Ex_1.3.1:
% Simulate from each model for one example participant.
% Read the documentation by calling `help tapas_simModel` and insert
% the right arguments in the function below.

nreps = 10;
yrep = zeros(length(u), nreps, 3);
for rep=1:nreps
    s1 = tapas_simModel(u, ...
                        'tapas_rw_binary', ...
                        results(1).fit.p_prc.p, ...
                        'tapas_beta_obs', ...
                        1);
    s2 = tapas_simModel(u, ...
                        'tapas_ehgf_binary', ...
                        results(2).fit.p_prc.p, ...
                        'tapas_beta_obs', ...
                        1);
    s3 = tapas_simModel(u, ...
                        'tapas_ehgf_binary', ...
                        results(3).fit.p_prc.p, ...
                        'tapas_beta_obs', ...
                        1);
    yrep(:, rep, 1) = s1.y;
    yrep(:, rep, 2) = s2.y;
    yrep(:, rep, 3) = s3.y;
end

%% Compare real and simulated observations.
figure; 
subplot(3, 1, 1);
plot(yrep(:,:,1), 'black')
hold on;
plot(dataset(:,1), 'red', 'linewidth', 5)
hold off;
subplot(3, 1, 2);
plot(yrep(:,:,2), 'blue')
hold on;
plot(dataset(:,1), 'red', 'linewidth', 5)
hold off;subplot(3, 1, 3);
plot(yrep(:,:,3), 'green')
hold on;
plot(dataset(:,1), 'red', 'linewidth', 5)
hold off;

% Are there systematic differences?


%% Ex_1.3.2:
% To reason about the model and try ideas for setting the priors,
% one should do some prior simulations. For these, simulate data
% from two models only differing in a single parameter.
%
% Find out the effect of the om(3) parameter.
%
% Do the following:
% 1. Load one of your HGF configurations.
% 2. Change one parameter, and making sure that the rest is fixed.
% 3. Simulate data and inspect it.
% Can you interpret the meaning through the change in data?


% Get the configuration of the perceptual model
my_config1 = tapas_ehgf_binary_config();
% Make a copy of the configuration and change the value for omega_2
my_config2 = my_config1;
% Adjust the value for omega 2:

% == Edit here ==
% my_config2.__ = __;
my_config1.ommu(3) = 2;
my_config2.ommu(3) = -30;
my_config1.omsa(2) = 0;
my_config2.omsa(2) = 0;
% == Edit here ==

% Adjust the observation configuration
beta_obs_conf = tapas_beta_obs_config;
beta_obs_conf.model = 'tapas_beta_obs';
beta_obs_conf.predorpost = 2;

%% Run both models:
samples1 = tapas_sampleModel(u, my_config1, beta_obs_conf);
samples2 = tapas_sampleModel(u, my_config2, beta_obs_conf);


% Plot the responses:
scatter(1:240, samples1.y);
hold on;
scatter(1:240, samples2.y);
scatter(1:240, u);
hold off;


% -> difference can be seen in trajectory for mu3


%% #########################################################
%  1.4.0. Fitting multiple subjects and comparing models
%  #########################################################
%
% List the names of the config files you created in 'config_files' and
% use the function 'fit_model' below to fit all models to all subjects.

%% Ex_1.4.1:
% Read the code for the `fit_model` function and then run the code.

results = fit_models(u, dataset, config_files);

% extract omega parameter for plotting
values = extract_parameter(results(:,1:2), 'p_prc.om');

% Plot boxplot for omega2 and omega3 for config 1
figure; 
subplot(2,1,1)
boxplot(values(:, 2:3, 1))
subplot(2,1,2)
boxplot(values(:, 2:3, 2))



%% Ex_1.4.2:
% Read the code for the `extract_parameter` function and then run 
% the code below.

% Look at the fit indices.
values = extract_parameter(results, 'optim.LME');
boxplot(permute(values, [1,3,2]));


% For each subject, who is described best by each model?


% What does this pattern tell you?



%% Ex_1.4.3:
% Use the function 'pp_check' to look at other subjects and models.

i = 2;
figure;
for j=1:3
    subplot(3, 1, j);
    yrep = pp_check(i, j, 5, u, dataset, config_files, results);
end

% Are there systematic deviations?




%% #########################################################
%  1.5.0. Try other designs
%  #########################################################
% 
% We've seen that there are different "kinds" of subjects.
% Now we want to try different designs and repeat the whole analysis.

% Some designs will work better than others: Think about what should 
% make the differences come out more pronounced in the analysis.

%% Ex_1.5.1:
% Read the code of the `run_simulation` function.
% Try it out:
% - try random design
% - try more or less volatile designs

out = run_simulation(5, 5)
