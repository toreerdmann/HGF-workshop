function c = custom_rw_binary_config

% Config structure
c = struct;
% Model name
c.model = 'tapas_rw_binary';
% Initial v
c.logitv_0mu = tapas_logit(0.5, 1);
c.logitv_0sa = 0;
% Alpha
c.logitalmu = tapas_logit(0.1, 1);
c.logitalsa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logitv_0mu,...
    c.logitalmu,...
         ];

c.priorsas = [
    c.logitv_0sa,...
    c.logitalsa,...
         ];

% Model function handle
c.prc_fun = @tapas_rw_binary;

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = @tapas_rw_binary_transp;

return;
