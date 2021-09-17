function y = tapas_beta_reg_obs_sim(r, infStates, p)
% Simulates observations from a Beta distribution


% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Inferred states
if strcmp(r.c_prc.model,'tapas_rw_binary')
    error('This response model is not compatible with the RW perceptual model.')
else
    mu1hat = infStates(:,1,1); % Default: predictions (ie, mu1hat)
    %     mu3 = infStates(:,3,3); 
    %     sa1hat = infStates(:,1,2);
end

% Parameter nu
b0_nu = p(1);
b1_nu = p(2);

nt = size(infStates,1);
mu = mu1hat;
nu = 2 + exp(b0_nu  + b1_nu .* linspace(1,nt, nt)');
al = mu .* nu;
be = (1-mu) .* nu;

y = betarnd(al, be);

return;
