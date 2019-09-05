function c = custom_hgf_ar1_binary_config_1

c = struct;
c.model = 'tapas_hgf_ar1_binary';
c.n_levels = 3;
c.irregular_intervals = false;


c.mu_0mu = [NaN, .5, -1];
c.mu_0sa = [NaN,  0,  0];
c.logsa_0mu = [NaN,        -1,    -.1];
c.logsa_0sa = [NaN,         0,      0];
c.logitphimu = [NaN, -Inf, -Inf];
c.logitphisa = [NaN,    0,   0];
c.mmu = [NaN, c.mu_0mu(2), c.mu_0mu(3)];
c.msa = [NaN,           0,           0];
c.logkamu = [     0,  0];
c.logkasa = [     0,  0];
c.ommu = [NaN,  -3,  -6];
c.omsa = [NaN,  10,   0];

c.logitphimu = [NaN, -Inf, tapas_logit(0.1,1)];
c.logitphisa = [NaN,    0,                  2];

% ms
% Format: row vector of length n_levels.
% This should be fixed for all levels where the omega of
% the next lowest level is not fixed because that offers
% an alternative parametrization of the same model.
c.mmu = [NaN, c.mu_0mu(2), c.mu_0mu(3)];
c.msa = [NaN,           0,           1];


c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.logitphimu,...
    c.mmu,...
    c.logkamu,...
    c.ommu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.logitphisa,...
    c.msa,...
    c.logkasa,...
    c.omsa,...
         ];

% Check whether we have the right number of priors
expectedLength = 5*c.n_levels+(c.n_levels-1);
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Model function handle
c.prc_fun = @tapas_hgf_ar1_binary;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_hgf_ar1_binary_transp;

return;
