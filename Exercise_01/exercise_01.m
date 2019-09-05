%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2019
% Unit 1
% Topic: Modelling data with the HGF
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% At this point, you have hopefully downloaded and extracted 
% the `tapas` toolbox.
% Load the toolbox and some helper functions

close all; clear variables; clc;
addpath('../HGF');
addpath('Functions');




%% #########################################################
%  1.1.0. Fitting a first HGF model
%  #########################################################
% In this script, we'll analyse a dataset holding the responses
% of 20 subjects. We'll start with loading and visualising the data.
%

%% Load inputs and dataset
% Run this code and have a look at the data. u holds the inputs for each
% trial and dataset holds the responses, with one column per subject:
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
% Fit model and plot estimates for a single subject.
%
% What model can you fit?
% a) perceptual model: tapas_hgf_*type of inputs*_config
% b) response   model: tapas_hgf_*type of responses*_obs_config

% fit:
fit = tapas_fitModel(dataset(:, 1), u, ...
               'tapas_hgf_binary_config', ...
               'tapas_beta_obs_config');
% plot:
tapas_hgf_binary_plotTraj(fit)


% How does the fit look?
% - good / bad
% - are there systematic deviations? Are we missing something?

% Look at fit object:
fit

% Where can you find what?
% - the estimates for the parameters: perceptual and response model

% - the prior settings: perceptual and response model

% - the belief trajectories

% - the model fit index (LME)




%% #########################################################
%  1.2.0. Changing the perceptual model
%  #########################################################
% Now let's change the model / priors: For this, we need to write our 
% own config file: Start by copying over the default config file 
% 'tapas_hgf_binary_config.m' and read the comments in it.
% 

%% Ex_1.2.1:
% Try the following changes:
% 1. Fix all parameters by setting their prior variance to 0: 
%    What values are sensible?
%    Save the config files as: custom_hgf_binary_config_1.m
%
% 2. Estimate omega2, mu0_3 seperately and also estimating them
%    at the same time.
%    Save the config files as: custom_hgf_binary_config_{2,3,4}.m
%
% 4. Try alternatives for the process model. For these, you can start 
%    by copying the default config files from the folder of the HGF 
%    toolbox and then adjust these.
%    a) RW belief model: use the default config file
%       -> `custom_rw_binary_config.m`
%    b) AR(1)  model: 
%       - try fixing phi and m (keeping all other parameters as in the
%         other configurations.
%       - fix m at the second level at .5 and estimate phi for the
%         second level.
%       -> `custom_hgf_ar1_binary_config_{1,2}.m`


% Once you have the config files, fit each of these models to the data of 
% a single subject by running the code below:
config_files = ["custom_hgf_binary_config_1", ...
                "custom_hgf_binary_config_2", ...
                "custom_hgf_binary_config_3", ...
                "custom_hgf_binary_config_4", ...
                "custom_hgf_ar1_binary_config_1", ...
                "custom_hgf_ar1_binary_config_2", ...
                "custom_rw_binary_config"];
            
results = struct;
for i=1:length(config_files)
    results(i).fit = tapas_fitModel(dataset(:, 1), u, ...
                         config_files(i), ...
                         'tapas_beta_obs_config');
end



%% Ex_1.2.2:
% Plot the belief trajectories of the hgf and rw models together:
plot(results(1).fit.traj.muhat(:,2))
hold on  
scatter(1:length(u), u);
for i=1:6
    plot(results(i).fit.traj.muhat(:,2))
end
plot(results(7).fit.traj.vhat)
hold off



%% Ex_1.2.3:
% Plot the prediction errors of the HGF (level 1 and level 3) and 
% those of the RW model together:
subplot(2, 1, 1)
plot(results(1).fit.traj.da(:,1))
hold on 
plot(results(3).fit.traj.da)
hold off
subplot(2, 1, 2)
plot(abs(results(1).fit.traj.da(:,3)))
hold on
pe = abs(diff(p))
plot([0; pe] * .000001)
hold off

%% Ex_1.2.4:
% Can you come up with interpretations for each model?




%% #########################################################
%  1.3.0. Checking the models
%  #########################################################
% We now do a posterior predictive check.

% Simulate from each model for an example participant.
i = 1;
j = 1;
nreps = 10;
yrep = zeros(length(dataset(:,i)), nreps);
for rep=1:nreps
    s = tapas_simModel(u, ...
                       results(j).fit.c_prc.model, ...
                       results(j).fit.p_prc.p, ...
                       results(j).fit.c_obs.model, ...
                       results(j).fit.p_obs.p);
    yrep(:, rep) = s.y;
end

% Compare real and simulated observations.
figure; 
plot(yrep, 'black')
hold on;
plot(dataset(:,i), 'red')
hold off;

% Are there systematic differences?


%% Ex_1.3.2:
% Simulate with changed parameters:
% Here we select one config file. We save the parameter 
% estimates and make some adjustments to them before simulating data.
% Pick a parameter (that was not fixed) and try adjusting it up or down.
% Can you interpret the meaning through the change in data?

% Pick model 1
j = 1;
% Change here:
parameters = results(j).fit.p_prc.p;
parameters(14) = parameters(14) + 3;
sim = tapas_simModel(u, ...
                   results(j).fit.c_prc.model, ...
                   parameters, ...
                   results(j).fit.c_obs.model, ...
                   results(j).fit.p_obs.p);


% Compare belief trajectories and responses:
plot(sim.traj.muhat(:, 2), 'black')
hold on;
T = length(u);
scatter(1:T, dataset(:,i))
scatter(1:T, sim.y)
plot(results(j).fit.traj.muhat(:, 2), 'red')
hold off;




%% #########################################################
%  1.4.0. Fitting multiple subjects and comparing models
%  #########################################################
%
% List the names of the config files you created in 'config_files' and
% use the function 'fit_model' below to fit all models to all subjects.

%% Ex_1.4.1:
% Read the code for the `fit_model` function and then run the code.

config_files = config_files([2, 5, 7]);
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


u = rand(100, 1) < .5;
nsubjects = 10;
seed = round(rand() * 1000);
run_simulation(nsubjects, seed)


%% Try inputs with implied changes in volatility
p = [repmat(.9, 50, 1)
     repmat(.1, 50, 1)
     repmat(.9, 50, 1)
     repmat(.1, 15, 1)
     repmat(.9, 15, 1)
     repmat(.1, 15, 1)
     repmat(.9, 15, 1)
     repmat(.1, 15, 1)
     repmat(.9, 15, 1)];
u = p;
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end
plot(p)
nsubjects = 10;
seed = round(rand() * 1000);
run_simulation(nsubjects, seed)
