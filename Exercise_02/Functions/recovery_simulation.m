%% Recovery simulation for HGF

close all; clear variables; clc;
%addpath(genpath('..'));

%% Preparation of the model
% We start by initializing a structure to hold the HGF model 
% definition.

hgf = struct('c_prc', [], 'c_obs', []);
%% 
% Next, we need to choose a perceptual model and the corresponding reparameteriztion 
% function.

hgf.c_prc.prc_fun = @tapas_hgf_binary;
hgf.c_prc.transp_prc_fun = @tapas_hgf_binary_transp;
%% 
% Then we do the same for the observation model.

hgf.c_obs.obs_fun = @tapas_unitsq_sgm; 
hgf.c_obs.transp_obs_fun = @tapas_unitsq_sgm_transp; 
%% 
% Now we run the config function of the perceptual model and copy the priors 
% and number of levels of the perceptual model into the hgf structure.

config = tapas_hgf_binary_config();
hgf.c_prc.priormus = config.priormus;
hgf.c_prc.priorsas = config.priorsas;
hgf.c_prc.n_levels = config.n_levels;
clear config
%% 
% We set the priors of the observational model directly.

hgf.c_obs.priormus = 0.5;
hgf.c_obs.priorsas = 1;

%% Data simulation
% Now let us assume that our datasets are from 32 different subjects.

num_subjects = 32;
%% 
% For our simulations, we choose a range of values for the parameters $\omega_2$ 
% (tonic volatility at the second level) and $\zeta$ (inverse decision noise). 
% The rest of the parameters will be held constant.

om2 = [-5.0, -4.8, -4.7, -4.6, -4.5, -4.4, -4.3, -4.2,...
       -4.1, -4.0, -3.9, -3.8, -3.7, -3.6, -3.5, -3.4,...
       -3.3, -3.2, -3.1, -3.0, -3.0, -2.9, -2.9, -2.9,...
       -2.8, -2.8, -2.8, -2.7, -2.7, -2.6, -2.6, -2.4];

ze = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.0, 1.1,...
      1.1, 1.2, 1.2, 1.3, 1.3, 1.4, 1.4, 1.5,...
      1.6, 1.6, 1.7, 1.7, 1.7, 1.8, 1.8, 1.9,...
      1.9, 2.0, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5];
%% 
% We randomly permute the elements of $\zeta$ such that there is no systematic 
% association between high values of $\omega_2$ and high values of $\zeta$.

ze = ze(randperm(length(ze))); 
%% 
% Then we initialize structure arrays for the simulations and for the 'data' 
% argument of tapas_h2gf_estimate().

sim = struct('u', [],...
             'ign', [],...
             'c_sim', [],...
             'p_prc', [],...
             'c_prc', [],...
             'traj', [],...
             'p_obs', [],...
             'c_obs', [],...
             'y', []);

%%
data = struct('y', cell(num_subjects, 1),...
              'u', [],...
              'ign', [],...
              'irr', []);
%% 
% We load the example inputs $u$ and generate simulated data with the chosen 
% range of parameter settings

u = load('../data/inputs_binary_u.csv');
%%
for i = 1:num_subjects
    sim(i) = tapas_simModel(u,...
                            'tapas_hgf_binary', [NaN,...
                                                1,...
                                                1,...
                                                NaN,...
                                                1,...
                                                1,...
                                                NaN,...
                                                0,...
                                                0,...
                                                1,...
                                                1,...
                                                NaN,...
                                                om2(i),...
                                                -6],...
                         'tapas_unitsq_sgm', ze(i));
    % Simulated responses
    data(i).y = sim(i).y;
    % Experimental inputs
    data(i).u = sim(i).u;
end
%clear i u om2 ze
%% Sampler configuration
% The hgf uses sampling for inference on parameter values. To configure the 
% sampler, we first need to initialize the structure holding the parameters of 
% the inference.

pars = struct();
%% 
% We set some parameters explicitly:
% 
% Number of samples stored.

pars.niter = 100;
%% 
% Number of samples in the burn-in phase.

pars.nburnin = 100;
%% 
% Number of chains.

pars.nchains = 8;
%% 
% Parameters not explicitly defined here take the default values set in 
% tapas_h2gf_inference.m.
% 
% Before proceeding, we declutter the workspace.

clear num_subjects
%% Estimation
% Before we can run the estimation, we still need to initialize a structure 
% holding the results of the inference.

inference = struct();
%% 
% Finally, we can run the estimation.
est = struct;
for i=1:length(data)
    est(i).fit = tapas_fitModel(u, data(i).y, 'tapas_hgf_binary_config', ...
                                'tapas_unitsq_sgm_config');
end

%% 
% We can now look at the belief trajectories of individual subjects. These 
% are the trajectories implied by the median posterior parameter values.

tapas_hgf_binary_plotTraj(est(2).fit)
%%
% Extrac parameters

values = zeros(num_subjects, 3);
for i=1:num_subjects
        values(i, :) = est(i).fit.p_prc.om;
end


%% 
% Plot estimates versus true parameters
%
