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
% Remember: We hypothesized that the patient group would be
% overestimating the volatility of their environment. 
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
%  Estimate and plot the trajectories of the model for the prior
%  parameters in the default configuration file. Describe what you see.
%  




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
%  response model and the default `tapas_hgf` configuration. 




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
%  Perform a posterior predictive check. Sample from the estimates
%  of both groups and compare them to the observed data.




%% Ex_2.2.3: 
%  Check identifiability: Plot the average posterior correlation
%  matrix. 





%#########################################################
% 2.3. Changing the priors
%#########################################################
% We saw in the previous section that the model did not fit
% the data perfectly for one of the groups. 
%
% Here we'll try changing the prior.

%% Ex_2.3.1: 
%  Create your own config file and change the values for
%  the priors of the following parameters:
%  - om2:   Fixed
%  - mu_10: Fixed
%  - mu_20: Fixed





%#########################################################
% 2.4. Comparison with 3-level model
%#########################################################
% Here, we will compare our previous model to a 3-level model.



%% Ex_2.4.1: 
%  Create a new config file for a 3-level model and fit
%  it to the data.




%% Ex_2.4.2: 
%  Compare the 2- and 3-level models. For this, compute the
%  difference in LME values summed over the subjects in each group.





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
