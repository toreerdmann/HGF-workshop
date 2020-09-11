%#########################################################
% HGF-toolbox Workshop, CP course Zurich, 12.09.2020
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

%=== begin: Edit here ===
% config_prc = tapas_ehgf_***_config;
% config_rsp = tapas_***_obs_config;
%=== end: Edit here ===

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


%% #########################################################
%  2.0 Changing the model / priors
%  #########################################################

%% Ex_2.1:
% Now let's change the model / priors: For this, we need to setup our 
% own config file: Start by looking up the default config file 
% 'tapas_ehgf_binary_config.m' and read the comments in it.
% You can find a copy of this file (with all comments stripped out)
% in the file 'config_hgf_1.m'. 
% 
% Try the following configurations:
%
% 1. Fix all parameters except omega2 and omega3, by setting their prior
%    variances to 0. 
%    Save the config file as: `config_hgf_1.m`
%
% 2. Create another prior setting named `config_hgf_2.m` with the same
%    settings, except with mu_0mu(3) set to -4.
%    
% 3. Try another perceptual model. Start by copying the default config 
%    file "tapas_rw_binary_config' from the folder of the HGF toolbox and 
%    name it `config_rw.m`.

% Once you have the config files, fit each of these models to the data of 
% a single subject by running the code below:
config_files = ["config_rw", ...
                "config_hgf_1", ...
                "config_hgf_2"];
            
% Fit each of the perceptual models, with the observational model fixed.
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
legend('u', 'y', 'M1_v', 'M2_mu', 'M3_mu');
hold off;

% Why are we plotting muhat? Try plotting mu.

% Fit the data of another subject: dataset(:,1) -> dataset(:, 2).

% Describe the qualitative differences between the models.


%% Plot prediction errors
% Plot the prediction errors of the HGF (level 1 and level 3) and 
% those of the RW model together:

%=== begin: Edit here ===
% plot(results(3).fit.__);
% hold on;
% plot(results(3).fit.__);
% hold off;
%=== end: Edit here ===



%% Ex_2.2:
% We now do a posterior predictive check.
%
% Simulate from each model for one example participant.
% Read the documentation by calling `help tapas_simModel` and insert
% the right arguments in the function below.

nreps = 10;
yrep = zeros(length(u), nreps, 3);
for rep=1:nreps
    for j=1:3
        sim = tapas_simModel(u, ...
                            results(j).fit.c_prc.model, ...
                            results(j).fit.p_prc.p, ...
                            'tapas_beta_obs', ...
                            results(j).fit.p_obs.p);
        yrep(:, rep, j) = sim.y;
    end
end

%% Compare real and simulated observations.
figure; 
for j=1:3
subplot(3, 1, j);
plot(yrep(:,:,j), 'black')
hold on;
plot(dataset(:,1), 'red', 'linewidth', 5)
hold off;
end

% Are there systematic differences?


%% #########################################################
%  3.0. Prior predictive simulations
%  #########################################################

%% Ex_3.1:
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
% Make a copy of the configuration: 
my_config2 = my_config1;
% Adjust the value for omega_2: -30
%=== begin: Edit here ===
% my_config2.__ = __;
% my_config2.__ = __;
%=== end: Edit here ===
config_obs = config_beta_obs();
config_obs.lognuprmu = 5;
config_obs.lognuprsa = 0;


%% Run both models:
samples1 = tapas_sampleModel(u, my_config1, config_obs);
samples2 = tapas_sampleModel(u, my_config2, config_obs);

% Plot the responses:
scatter(1:240, samples1.y);
hold on;
scatter(1:240, samples2.y);
scatter(1:240, u);
hold off;

%% Plot the trajectories of the beliefs about volatility
%=== begin: Edit here ===
% plot(samples1.traj.___);
% hold on;
% plot(samples2.traj.___);
% hold off;
%=== end: Edit here ===

% What do you see?

%% #########################################################
%  4.0. Fitting multiple subjects and comparing models
%  #########################################################
%
% List the names of the config files you created in 'config_files' and
% use the function 'fit_model' below to fit all models to all subjects.
%
%% Ex_4.1:
% Read the code for the `fit_model` function and then run the code.
results = fit_models(u, dataset, config_files);


% Extract omega parameters of the HGF models for plotting
values = extract_parameter(results(:,2:3), 'p_prc.om');

%% Plot boxplot for omega2 and omega3 for config 1
figure; 
boxplot(values(:, 2:3, 1), 'labels', {'M2_om2', 'M2_om3'});
figure;
boxplot(values(:, 2:3, 2), 'labels', {'M3_om2', 'M3_om3'});

% What do you make of this difference in estimates?
% How did the prior specification differ?


%% Ex_4.2:
% Use the function 'pp_check' to look at other subjects and models.

i = 1;
figure;
for j=1:3
    subplot(3, 1, j);
    yrep = pp_check(i, j, 10, u, dataset, config_files, results);
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
% - try random design: u = randi(0:1, 240, 1)
% - try more or less volatile designs
% - try placing the volatile phase in the first half

% run_simulation(10, 123);


