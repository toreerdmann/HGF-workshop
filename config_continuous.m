function c = config_continuous
% PLACEHOLDER VALUES
% 99991   Value of the first input
%         Usually a good choice for mu_0mu(1)
% 99992   Variance of the first 20 inputs
%         Usually a good choice for mu_0sa(1)
% 99993   Log-variance of the first 20 inputs
%         Usually a good choice for logsa_0mu(1), and
%         its negative, ie the log-precision of the
%         first 20 inputs, for logpiumu
% 99994   Log-variance of the first 20 inputs minus two
%         Usually a good choice for ommu(1)

% Config structure
c = struct;
% Model name
c.model = 'hgf';
% Number of levels (minimum: 2)
c.n_levels = 2;
c.irregular_intervals = false;

c.mu_0mu    = [99991,       -2];
c.mu_0sa    = [1,            0];
c.logsa_0mu = [99993, log(0.1)];
c.logsa_0sa = [    1,        0];
c.rhomu     = [    0,        0];
c.rhosa     = [    0,        0];
c.logkamu   = [log(1)];
c.logkasa   = [     0];
% Omegas
% Format: row vector of length n_levels
c.ommu      = [    0,        0];
c.omsa      = [   10,        0];
% Pi_u
% Format: scalar
c.logpiumu = 1; c.logpiusa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.rhomu,...
    c.logkamu,...
    c.ommu,...
    c.logpiumu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.rhosa,...
    c.logkasa,...
    c.omsa,...
    c.logpiusa,...
         ];

% Check whether we have the right number of priors
expectedLength = 3*c.n_levels+2*(c.n_levels-1)+2;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Model function handle
c.prc_fun = @tapas_hgf;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_hgf_transp;

return;
