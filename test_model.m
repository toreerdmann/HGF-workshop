%
% This script is for experimenting with new response models.
%
%

%% Setup
clear;
close all;
addpath('Exercises');
addpath('Models');
addpath('Configs');
addpath('Functions');

%% Choose inputs
p = [repmat([.85], 40, 1),
     repmat([.15], 40, 1),
     repmat([.85], 10, 1),
     repmat([.15], 10, 1),
     repmat([.85], 10, 1),
     repmat([.15], 10, 1),
     repmat([.85], 40, 1),
     repmat([.15], 40, 1)];
u = zeros(length(p), 1);
for ii = 1:length(p)
    u(ii) = rand() < p(ii);
end
nt = length(u);

%% Fit perceptual beliefs
fit = tapas_fitModel([], u, ...
               'config_ehgf', ...
               'tapas_bayes_optimal_binary_config', ...
                config_optim);
tapas_hgf_binary_plotTraj(fit)

%% simulate decisions

% construct infstates manually
infStates = NaN(nt, 3, 4);
infStates(:,:,1) = fit.traj.muhat;
infStates(:,:,2) = fit.traj.sahat;
infStates(:,:,3) = fit.traj.mu;
infStates(:,:,4) = fit.traj.sa;
fit.c_sim = struct;
fit.c_sim.seed = NaN;
% sim response model
y = tapas_beta_reg_obs_sim(fit, infStates, [5, -.01]);

% plot simulated responses
figure;
hold on
plot(fit.traj.muhat(:,1));
scatter(1:nt, y)

%% change parameter and sim again
y = tapas_beta_reg_obs_sim(fit, infStates, [5, -.05]);
scatter(1:nt, y)
hold off

%% fit simulated data
fit = tapas_fitModel(y, u, ...
               'config_ehgf', ...
               'config_beta_reg_obs', ...
                config_optim);
% -> works for low values of b1

%% check fit
tapas_hgf_binary_plotTraj(fit)
fit.p_obs
