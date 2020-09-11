function u = tapas_ar1_gen(t, init, m, variance, phi)
% Generates a first order autoregressive (AR(1)) process
%
% USAGE:
%     u = ar1_gen(t, init, m, variance, phi);
%
% INPUTS ARGUMENTS:
%     t           A column vector of time intervals between steps. The
%                 length of t defines the number of steps. Use a
%                 column of ones for steps at regular intervals where
%                 the interval duration is irrelevant.
%     init        A scalar defining the initial point
%     m           The equilibrium distribution mean
%     variance    The equilibrium distribution variance
%     phi         The reversion parameter (0 <= phi <= 1)
%
% OUTPUT:
%     u    A matrix containing the generated values in the first
%          column and t in the second column. This can be fed into
%          tapas_simModel() or tapas_fitModel().
%     
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Check if t looks like a column vector
if size(t,1) <= size(t,2)
    disp(' ')
    disp('Warning: ensure that t is a COLUMN vector.')
end

% Determine number of steps
n = size(t,1);

% Initialize u
u = NaN(n, 2);
u(1,1) = init;
u(:,end) = t;

% Generate diffusion steps
diffusion = sqrt(variance)*randn(n, 1);

% Do the process
for i = 2:n
    u(i,1) = u(i-1,1) +t(i)*phi*(m -u(i-1,1)) +t(i)*diffusion(i);
end

return;
