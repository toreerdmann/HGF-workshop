%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2018
% Unit 3
% Topic: Extra exercises 
% Author: Tore Erdmann
%#########################################################
% In this file are some extra exercises. For some of them,
% there is not yet a model-solution.



%% Ex_x_1_1: 
%  Simulate data for a custom response model. Let the responses be a
%  linear function of the following variables:
%  - Indicator for the case that there was an error in the previous trial
%  - Current belief muhat1, specifically the observations suprise.
%  The formula for suprise in this case is:
%  surp = -1/2. * log(2.*pi.*sigma) - (x-mu).^2./(2.*sigma);



%% Ex_x_1_2: 
% Define your own response model for the continuous responses.
% - Check the manual to see what files you need to create. 
% - Copy the corresponding files from an related and existing
% response model and modify them
% - Fit your new response model and compare it to another one.




%% Ex_x_1: 
% When you try to publish, you will have to show that the model you 
% are using is a sensible  choice. Next to doing the appropriate
% diagnostic checks, you will have to compare your model with
% alternative models.
% 
% Make sure, that the behavior could not also be explained by a
% simpler model, for one where the belief about the volatility is fixed.
% 
% - Find out, how to adjust the prior configuration file, so that
% mu_3 is fixed.
% - Adjust the fitting code form exercise 2.1.1. so that you also fit
% a Rescorla-Wagner model (using `tapas_rw_binary`) and save the
% LME. 
% - Compare the sums of the individual LME values for each model.




%% Ex_x_2:
% What are modelling alternatives for the model that we chose in
% the example analysis for the binary HGF.
% 
% There, we said that overestimating volatility. 
% 
% For solving this exercise, one could:
%  - analyze the update equations of the HGF was presented in
%  Mathys et al., 2014, Uncertainty in perception and the HGF, or
%  - simulate data in such a way that the difference in the models
%  can be seen in the simulated responses.
% 




%% Ex_x_3:
% What influence do the responses of the participants
% have on the estimation of the belief trajectories? 
% 
% Simulate two datasets with different values of zeta and check how these
% differ in the estimated belief trajectories.
%
% Do this for both the binary and the continuous HGF, using the
% inputs given in the files 'data/inputs_binary_u.csv' and 
% 'data/inputs_continuous_u.csv'.
% 
% 





%% Ex_x_4: 
% Check identifiability: Plot the LME surface for grid of
% values for om2 and om3.
% NOTE: this will take a long time to run!



%% Ex_x_5: 
%  Checking identifiability: Plot the LME surface for grid of
%  values for om2 and om3.
%  NOTE: this will take a long time to run!


