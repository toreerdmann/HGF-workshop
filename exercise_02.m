%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2018
% Unit 2
% Topic: Example analysis using the continuous HGF
% Author: Tore Erdmann
%#########################################################
% Here we go through the full analysis process given, again
% simulated, sample of data from imagined participants.
%
% We will analyse the data of two samples of participants.
% 
% In this file, we are working with continuous inputs and
% responses. The types of paradigms you can imagine for this are:
%  - participants trying to match time intervals
%  - reaction times in response to different pitches
%  - normalized activity in some brain region in response to a stimulus
%
% Here, we will be looking for differences in the omega_1 parameter
% estimates. We will initially fit a two-level continuous
% HGF.



%#########################################################
% 2.0. Creating a dataset
%#########################################################
% We start by creating inputs.



%% Ex_2.0.1: Create a sequence of inputs. 
%  The sequence should be created through these steps:
%  - Create a latent 'mean' process which is a step function that has three
%  steps and stable periods of 50 trials.
%  - Simulate the observed inputs as normally distributed around the
%  'mean' process.




%% Ex_2.0.2: 
%  From here on, use the inputs provided in the file
%  'data/inputs_continuous_u.csv'.
%  Simulate responses using the `tapas_simModel` function and 
%  the parameter vector below. Visualize the outcome using 
%  the function `tapas_hgf_plotTraj`.

%      mu0(1) mu0(2) sa0(1) sa0(1)  rho(1) rho(2)
pars = [2     0      .1      .1     0     0  ...
%     log(ka)     om(1)  om(2)  log(pi_u)
       log(1)       2      0        100];




%% Ex_2.0.2: Simulate a whole dataset.
%  Simulate 100 participants with the parameters from the above fit,
%  but the omega_1 values changed to the values that the code 
%  below produces. Save the resulting simulated responses in a file
%  named `data/responses_continuous_y.csv`.

n = 100;
rng(123);
om1 = [-2 + randn(n/2,1); -10 + randn(n/2,1)];





%#########################################################
% 2.1. Individual modelling and 2nd level anayses
%#########################################################
% You can find the behavioral data in a `.csv` file named 
% 'data/responses_continuous_y.csv'. It is a matrix that contains the 
% responses of each participant arranged by columns.



%% Ex_2.1.1: 
%  Fit the binary HGF to each participants responses
%  separately. Save the model fits into a file with the path
%  'data/fits_continuous.mat'. Use the `tapas_gaussian_obs` 
%  response model and the provided `config_continuous` configuration file. 




%% Ex_2.1.2: 
%  Create a plot and a statistical test for the
%  difference. Interpret the results.





%#########################################################
% 2.2. Diagnostics
%#########################################################
% Now we want to check our model using diagnostic plots and measures.
% Model checking is an important part of the modelling workflow and
% can (and will) lead to improvements of your model.



%% Ex_2.2.1: 
%  Inspect the residual diagnostics. Do you see any regularities? 
%  Extract the residuals from the saved fit objects and plot some of
%  them individually.





%% Ex_2.2.2: 
%  Perform a posterior predictive check. Sample response using the 
%  previously obtained estimates and compare them 
%  to the observed data.
%  - Start with two example subjects from each of the groups 
%  - Look at the trajectories of those participants, that have
%  estimates away from most of the others in their group
%  - What do you find?




%% Ex_2.2.3: 
%  Check identifiability: Plot the average posterior correlation
%  matrix. 





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
