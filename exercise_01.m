%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2018
% Unit 1
% Topic: Binary HGF
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% At this point, you have hopefully downloaded and extracted 
% the `tapas` toolbox.
% To use it, adjust the path and run the line below.
%   addpath 'path/to/hgf-toolbox'



%#########################################################
% 1.0. Getting to know the binary HGF
%#########################################################
% We start with assuming a context. Say we have this experiment: We want
% to characterize the learning behavior of a certain patient
% population. Our hypothesis is, that individuals with
% diagnosis XYZ have some physiological difference that lets them overestimate 
% the volatility of their environment.

% We translate this hypothesis into a hypothesis test:
% The grouping variable will predict the value of the parameter in
% our learning model that represents the tonic volatility estimate.

% Here, for simplicity, we will consider the omega_2 parameter of
% the HGF to be representing this high tonic volatility. However,
% one could well argue for a different modelling approach. We will 
% come back to this later. 


%#########################################################
% 1.1. Simulation of a 2nd level analysis
%#########################################################
% We start at the end, assuming we had analyzed the data of 
% the individual participants and want to check for a difference
% in the parameter estimates across groups.

%% Ex_1.1.1: 
% Create a grouping variable for 50 patients and controls.




%% Ex_1.1.2: 
% Simulate fake 'parameter values' for each group and store them 
% in a single vector. Simulate the parameter values such
% that the values are normally distributed about their group-mean, with
% the patient group having a mean of -6 and the control group
% having a mean of -3, and the standard deviation being 1 for both groups.




%% Ex_1.1.3: 
% Fit a linear model for the group effect on the
% parameter value. Does the effect appear as intended?




%% Ex_1.1.4: 
% Create a box- or scatterplot of the data.





%#########################################################
% 1.2. Designing inputs
%#########################################################
% For the HGF, we cannot choose the parameter values completely
% freely, but want to choose them such that when we simulate data 
% it looks sensible. Hence, we have to generate inputs first.
%
% The experiment will be a 2AFC task. The participants can choose
% one from two decks of cards and get a reward for each choice. 
% We will model how the participants will learn about the reward
% distributions and how they adapt their behavior when the
% underlying process changes (after a reversal).



%% Ex_1.2.1: 
% Simulate a binary time-series with a reversal in the
% underlying probability. 
% Have the sequence start with probability 0.8, and, after 100
% trials, make it jump to 0.2 for another 100 trials.
%
% First, generate a latent sequence of probabilities and then draw the
% binary variable for each time point according to the latent
% probability. As a check, plot the time-course of the latent process
% and the realizations of the binary variable together.




%% Ex_1.2.2: 
% Simulate a binary time-series that has several
% reversals. There should be a low and high volatility phase.
%
% (Volatility here means the tendency for the underlying process to change.)




%% Ex_1.2.3: 
% Load the file 'data/inputs_binary_u.csv' containing the inputs
% that we will use from here on. Using the `tapas_fitModel`
% function, fit the RW and the HGF models using the default prior 
% configuration file and the 'bayes-optimal' observation model configuration file.




%% Ex_1.2.4: 
% Look at the help / manual to learn about the structures
% that were returned by the `tapas_fitModel` function. Where can
% you find the
% - prior settings? 
% - posterior parameter estimates?
% - estimates for the evolving belief about the win-probability for
% the first outcome?
% - estimate of the log-model-evidence (LME)?




%% Ex_1.2.5: 
% Plot the belief trajectories together with the inputs
% and the true underlying probability.




%% Ex_1.2.6: 
% Simulate data from the HGF with the parameters for the
% above fit using the `simModel` function and visualize the
% outcome using the appropriate `plotTraj` function. Use 
% `tapas_softmax_binary` for the response model with its zeta
% parameter set to 1. 
% Do the responses look sensible?




%% Ex_1.2.7: 
% Do further simulations to investigate what influence the alpha
% parameter of the RW model has on the simulated responses.
% First, write down your approach. How can you access the simulated
% responses from the structure that `tapas_simModel` returns? Write
% down in one or two sentences what the difference between the
% models is.




%% Ex_1.2.8: 
% Learn about the influence of the zeta parameter on the HGF by 
% simulating data with high and low values for this parameter. 
% Write down what influence you think the parameters have.




%#########################################################
% 1.3. The gain of volatility tracking
%#########################################################
% Here we will see how additionally tracking the volatility (next
% to the latent variable) can help a learning system to adapt
% itself to its environment.

%% Ex_1.3.1: 
% Given the previous exercises, imagine an input-sequence with two
% reversals, shortly apart (20 trials). How will the two
% model differ?




%% Ex_1.3.2: 
% Do a simulation to check your previous answer. This means,
% generate inputs, find sensible parameters and simulate with these.





%#########################################################
% Make sure that this file runs through completely:
% 
% 1. Clear the workspace using:
%      clear;
% 
% 2. Run the whole script:
%      Select the whole file and hit 'Run' in the matlab IDE.
% 
%########################################################
