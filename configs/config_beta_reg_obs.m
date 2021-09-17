function c = config_beta_reg_obs
% Contains the configuration for the beta observation model for responses in the unit interval
%


% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'tapas_beta_und_obs';

% Sufficient statistics of Gaussian parameter priors

c.b0numu = 5;
c.b0nusa = 1;
c.b1numu = -.1;
c.b1nusa = 1;


% Gather prior settings in vectors
c.priormus = [
        c.b0numu,...
        c.b1numu,...
         ];

c.priorsas = [
        c.b0nusa,...
        c.b1nusa,... 
        ];

% Model filehandle
c.obs_fun = @tapas_beta_reg_obs;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_beta_reg_obs_transp;

return;
