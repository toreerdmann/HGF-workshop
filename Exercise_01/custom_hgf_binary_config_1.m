function c = custom_hgf_binary_config_1

c = struct;
c.model = 'tapas_hgf_binary';
c.n_levels = 3;
c.irregular_intervals = false;

c.mu_0mu = [NaN, .5, -3];
c.mu_0sa = [NaN,  0, 0];
c.logsa_0mu = [NaN,        -1,    -.1];
c.logsa_0sa = [NaN,         0,      0];
c.rhomu = [NaN, 0, 0];
c.rhosa = [NaN, 0, 0];
c.logkamu = [     0,  0];
c.logkasa = [     0,  0];
c.ommu = [NaN,  -3,  -6];
c.omsa = [NaN,   0,   0];

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.rhomu,...
    c.logkamu,...
    c.ommu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.rhosa,...
    c.logkasa,...
    c.omsa,...
         ];

% Check whether we have the right number of priors
expectedLength = 3*c.n_levels+2*(c.n_levels-1)+1;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Model function handle
c.prc_fun = @tapas_hgf_binary;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_hgf_binary_transp;

return;
