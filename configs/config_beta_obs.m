function c = config_beta_obs

c = struct;

c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'tapas_beta_obs';

% Sufficient statistics of Gaussian parameter priors

% nu'
c.lognuprmu = log(128);
c.lognuprsa = 3;

% Gather prior settings in vectors
c.priormus = [
    c.lognuprmu,...
         ];

c.priorsas = [
    c.lognuprsa,...
         ];

% Model filehandle
c.obs_fun = @tapas_beta_obs;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_beta_obs_transp;

return;
