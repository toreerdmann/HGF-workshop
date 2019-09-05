%%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2019
% Unit 2
% Topic: Findings the HGF
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% Load the toolbox and some helper functions
addpath('../HGF');



%#########################################################
% Determining the sensitive range for a parameter
%#########################################################
% In this exercise, we want to find the region of the parameter space
% where we can reliably estimate the parameters of the HGF.
%
% We'll use the continuous HGF with the inputs provided in the 
% data folder.
u = load('../data/inputs_continuous_u.csv');



%% Ex_2.
% Write a function to perform a recovery simulation:
% 1. Decide for a gird of om2 values.
% 2. For each value in the grid, simulate 100 datasets.
% 3. Fit all of the dataset (possibly varying the prior settings).
% 4. Visualize the results appropriately.



