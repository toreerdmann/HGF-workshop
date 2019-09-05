function [dataset, nus, k] = simulate_mixture(u, nsubjects, seed)
% Simulates a data set and then fits the data.
%
%


%% Define models and their parameters
models = ["tapas_hgf_binary", "tapas_hgf_ar1_binary", "tapas_rw_binary"];
parameters = struct;
parameters(1).p = [
        NaN ;       % mu_0^1
         .5 ;       % mu_0^2
         -3 ;       % mu_0^3
          
        NaN ;       % sa_0^1
        2.7 ;       % sa_0^2
         .9 ;       % sa_0^3
          
        NaN ;       % rho^1
          0 ;       % rho^2
          0 ;       % rho^3
          
          1 ;       % kappa^1
          1 ;       % kappa^2
          
        NaN ;       % omega^1
         -4 ;       % omega^2
         -6];       % omega^3 / theta

parameters(2).p = [
        NaN ;       % mu_0^1
         .5 ;       % mu_0^2
         -3 ;       % mu_0^3
          
        NaN ;       % sa_0^1
        2.7 ;       % sa_0^2
         .9 ;       % sa_0^3
          
        NaN ;       % phi^1
         .6 ;       % phi^2
          0 ;       % phi^3
         
        NaN ;       % m^1, undefined
         .5 ;       % m^2
          0 ;       % m^3
          
          1 ;       % kappa^1
          1 ;       % kappa^2
          
        NaN ;       % omega^1
         -8 ;       % omega^2
         -6];       % omega^3 / theta

parameters(3).p = [
         .5 ;       % v_0
         .5];       % alpha


%% Set seed to make simulation reproducible
rng(seed);
seeds = round(rand(nsubjects, 1) .* 1000);


%% Draw model indices
nconfigs = length(models);
k = randi(nconfigs, nsubjects, 1);


%% Draw parameters of response models
nus = abs(25 + randn(nsubjects, 1) * 20);


%% Simulate a dataset
dataset = zeros(length(u), nsubjects);
for i=1:nsubjects
    sim = tapas_simModel(u, ...
                         char(models(k(i))), ...
                         parameters(k(i)).p, ...
                         'tapas_beta_obs', nus(i), seeds(i));
    dataset(:,i) = sim.y;       
end
            


end

