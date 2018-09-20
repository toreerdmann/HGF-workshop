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

% => 
grp = [zeros(50, 1); ones(50, 1)];
% /=> 



%% Ex_1.1.2: 
% Simulate fake 'parameter values' for each group and store them 
% in a single vector. Simulate the parameter values such
% that the values are normally distributed about their group-mean, with
% the patient group having a mean of -6 and the control group
% having a mean of -3, and the standard deviation being 1 for both groups.

% => 
seed = 123;
rng(seed)
om2 = [-3 + randn(50, 1); -6 + randn(50, 1)]
% /=> 



%% Ex_1.1.3: 
% Fit a linear model for the group effect on the
% parameter value. Does the effect appear as intended?

% => 
help fitlm
fitlm(grp, om2)
% /=> 



%% Ex_1.1.4: 
% Create a box- or scatterplot of the data.

% => 
figure;
plot(grp + rand(100,1) * .1, om2, '.', 'MarkerSize', 15);
axis([-.5, 1.5, -16, 0]);
xlabel('Group');
ylabel('Omega 2 value');
% /=> 




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

% => 
p = [repmat([.8], 100, 1),
     repmat([.2], 100, 1)];
u = zeros(length(p), 1)
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end
plot(p)
hold;
plot(u, '.');
axis([0 200 -.1 1.1])
hold off;
% /=> 



%% Ex_1.2.2: 
% Simulate a binary time-series that has several
% reversals. There should be a low and high volatility phase.
%
% (Volatility here means the tendency for the underlying process to change.)

% =>
p = [repmat([.9], 50, 1),
     repmat([.1], 50, 1),
     repmat([.9], 50, 1),
     repmat([.1], 15, 1),
     repmat([.9], 15, 1),
     repmat([.1], 15, 1),
     repmat([.9], 15, 1),
     repmat([.1], 15, 1),
     repmat([.9], 15, 1)]
u = p
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end
plot(p)
hold;
plot(u, '.');
axis([0 200 -.1 1.1])
hold off;

% csvwrite('data/inputs_binary_p.csv', p);
% csvwrite('data/inputs_binary_u.csv', u);
% /=> 



%% Ex_1.2.3: 
% Load the file 'data/inputs_binary_u.csv' containing the inputs
% that we will use from here on. Using the `tapas_fitModel`
% function, fit the RW and the HGF models using the default prior 
% configuration file and the 'bayes-optimal' observation model configuration file.

% =>
% u = load('data/inputs_binary_u.csv');
bopars_hgf = tapas_fitModel([],...
                            u,...
                            'tapas_hgf_binary_config',...
                            'tapas_bayes_optimal_binary_config');
bopars_rw = tapas_fitModel([],...
                           u,...
                           'tapas_rw_binary_config',...
                           'tapas_bayes_optimal_binary_config');
% /=> 



%% Ex_1.2.4: 
% Look at the help / manual to learn about the structures
% that were returned by the `tapas_fitModel` function. Where can
% you find the
% - prior settings? 
% - posterior parameter estimates?
% - estimates for the evolving belief about the win-probability for
% the first outcome?
% - estimate of the log-model-evidence (LME)?

% => 
% prior settings: bopars_hgf.c_prc
% posterior estimates: bopars_hgf.p_prc
% belief trajectories: bopars_hgf.traj.muhat
% LME: bopars_hgf.optim.LME
% /=> 



%% Ex_1.2.5: 
% Plot the belief trajectories together with the inputs
% and the true underlying probability.

% =>
figure;
plot(u, '.', 'Markersize', 15);
axis([1, length(u), -0.1, 1.1])
hold
p = load('data/inputs_binary_p.csv');
plot(p)
plot(bopars_hgf.traj.muhat(:,1))
plot(bopars_rw.traj.vhat)
legend('Inputs', 'Probability', 'HGF belief', 'RW belief');
hold off;
% /=> 



%% Ex_1.2.6: 
% Simulate data from the HGF with the parameters for the
% above fit using the `simModel` function and visualize the
% outcome using the appropriate `plotTraj` function. Use 
% `tapas_softmax_binary` for the response model with its zeta
% parameter set to 1. 
% Do the responses look sensible?

% => 
sim_hgf = tapas_simModel(u, ...
                         'tapas_hgf_binary', ...
                         bopars_hgf.p_prc.p, ...
                         'tapas_softmax_binary', ...
                         0);
tapas_hgf_binary_plotTraj(sim_hgf)
% A: Yes, they look sensible, although we sometimes see:
% - deviations
% - after a reversal, the respnoses naturally need a bit to catch up
% /=> 



%% Ex_1.2.7: 
% Do further simulations to investigate what influence the alpha
% parameter of the RW model has on the simulated responses.
% First, write down your approach. How can you access the simulated
% responses from the structure that `tapas_simModel` returns? Write
% down in one or two sentences what the difference between the
% models is.

% =>
% The strategy should be plotting the implied belief trajectories
% and data together to visually understand what influence the 
% parameter has.
resp_loalpha = tapas_simModel(u,...
                      'tapas_rw_binary',...
                      [.5, .01],...
                      'tapas_softmax_binary',...
                      1);  % parameter of observation model
resp_hialpha = tapas_simModel(u,...
                      'tapas_rw_binary',...
                      [.5, .9],...
                      'tapas_softmax_binary',...
                      1);  % parameter of observation model

figure;
plot(u, '.', 'Markersize', 15);
axis([1, length(u), -0.1, 1.1])
hold
plot(p)
% plot((.05 + resp_loalpha.y) * .9, '.', 'Markersize', 15)
% plot((.10 + resp_hialpha.y) * .8, '.', 'Markersize', 15)
plot(bopars_rw.traj.vhat)
plot(resp_loalpha.traj.vhat)
plot(resp_hialpha.traj.vhat)
legend('Inputs', 'Probability', 'Bayes optimal RW belief', ...
    'RW belief low alpha', 'RW belief high alpha');
% legend('Inputs', 'Probability', 'Low alpha responses', ...
%    'High alpha responses', 'Bayes optimal RW belief', ...
%    'RW belief low alpha', 'RW belief high alpha');
hold off;
% /=> 



%% Ex_1.2.8: 
% Learn about the influence of the zeta parameter on the HGF by 
% simulating data with high and low values for this parameter. 
% Write down what influence you think the parameters have.

% =>
resp_lozeta = tapas_simModel(u,...
                              'tapas_hgf_binary',...
                              bopars_hgf.p_prc.p,...
                              'tapas_softmax_binary',...
                              .001);  
resp_hizeta = tapas_simModel(u,...
                              'tapas_hgf_binary',...
                              bopars_hgf.p_prc.p,...
                              'tapas_softmax_binary',...
                              10);  
plot(u, '.', 'Markersize', 15);
axis([1, length(u), -0.1, 1.1])
hold
plot(p)
plot(bopars_hgf.traj.muhat(:,1))
plot(resp_lozeta.traj.muhat(:,1))
plot(resp_hizeta.traj.muhat(:,1))
plot((.05 + resp_lozeta.y) * .9, '.', 'Markersize', 15)
plot((.10 + resp_hizeta.y) * .8, '.', 'Markersize', 15)
legend('Inputs', 'Probability', 'Bayes optimal HGF belief', ...
    'Low zeta HGF belief', 'High zeta HGF belief', ...
    'Low zeta responses', 'High zeta responses');
hold off;
% Answer:
% - Zeta is a parameter of the response model, so you can only see a 
% difference in the simulated responses - the belief trajectories are
% completely determined by the perceptual parameters. Note that this
% is only true for simulations: when fitting the model to actual data,
% differences due to different underlying zeta values can also trans-
% late to the estimation of perceptual paramaters, as all of them are 
% estimated together.
% - Low zeta makes behavior more random: even if the belief is close
% to zero or one, responses are still fluctuating between yes and no.
% High zeta values mean that the agent always chooses the options 
% with the higher (p>0.5) belief.
% /=> 



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

% => 
% The HGF should be able to learn from the first reversal and
% hence be able to adapt to the second reversal more quickly than
% the RW model with its fixed learning rate.
% /=> 



%% Ex_1.3.2: 
% Do a simulation to check your previous answer. This means,
% generate inputs, find sensible parameters and simulate with these.

% =>
p = [repmat([.95], 50, 1),
     repmat([.1], 15, 1),
     repmat([.9], 15, 1)];
u = zeros(length(p), 1);
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end
bopars_hgf = tapas_fitModel([],...
                            u,...
                            'tapas_hgf_binary_config',...
                            'tapas_bayes_optimal_binary_config');
resp_hgf = tapas_simModel(u,...
                          'tapas_hgf_binary',...
                          bopars_hgf.p_prc.p,...
                          'tapas_softmax_binary',...
                          1);  
bopars_rw = tapas_fitModel([],...
                           u,...
                           'tapas_rw_binary_config',...
                           'tapas_bayes_optimal_binary_config');
resp_rw = tapas_simModel(u,...
                         'tapas_rw_binary',...
                         [.5, .1],...
                         'tapas_softmax_binary',...
                         1);  

figure;
plot(u, '.', 'Markersize', 15);
axis([1, length(u), -0.1, 2]);
hold;
plot(p);
plot(bopars_rw.traj.vhat);
plot(bopars_hgf.traj.muhat(:,1));
plot(bopars_hgf.traj.muhat(:,3));
legend('Inputs', 'Probability', 'RW belief', 'HGF belief', ...
       'HGF volatility belief');
% % optionally, look at responses:
% plot(resp_rw.traj.vhat);
% plot(resp_hgf.traj.muhat(:,1));
% plot(resp_hgf.traj.muhat(:,3));
% plot((.05 + resp_rw.y) * .9, '.', 'Markersize', 15)
% plot((.10 + resp_hgf.y) * .8, '.', 'Markersize', 15)
%legend('Inputs', 'Probability', 'RW belief', 'HGF belief', ...
%    'HGF volatility belief', 'RW responses', 'HGF responses');
hold off;
% As can be seen, the HGF trajectory comes up a little faster. 
% Intuitively, it learned from a previous big change and therefore
% upregulates its learning rate.
% If we simulate some more input sequences, we can see that the
% inference on the beliefs depends quite a bit on the inputs!
% /=> 




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
