function u = tapas_grw_gen(t, init, drift, variance)
% Generates a Gaussian random walk
%
% USAGE:
%     u = gtapas_rw_gen(t, init, drift, variance);
%
% INPUTS ARGUMENTS:
%     t           A column vector of time intervals between steps. The
%                 length of t defines the number of steps. Use a
%                 column of ones for steps at regular intervals where
%                 the interval duration is irrelevant.
%     init        A scalar defining the initial point
%     drift       A scalar defining drift per time unit
%     variance    A scalar defining variance per time unit
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

% Do the walk
for i = 2:n
    u(i,1) = u(i-1,1) +t(i)*drift +t(i)*diffusion(i);
end

return;
