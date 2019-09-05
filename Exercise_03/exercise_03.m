%%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2019
% Unit 3
% Topic: Developing a custom response model
% Author: Tore Erdmann
%#########################################################
% Setup
%#########################################################
% Load the toolbox and some helper functions
addpath('../HGF');



%#########################################################
% Developing a custom response model
%#########################################################
%% Develop design and model
% Here we will try to investigate different designs and response
% models.

% Think of a task:
% - Choose a perceptual model (based on inputs)
% - Choose a response model 
% - Try to improve upon the default response model by
%   writing your own! This might: 
%   - use another variable of the belief trajectory
%   - output a multidimensional response
% 