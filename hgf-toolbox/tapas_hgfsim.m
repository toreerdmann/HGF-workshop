function r = tapas_hgfsim
%% Simulates data from an HGF-model process

% --------------------------------------------------------------------------------------------------
% Copyright (C) 2015 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

%% Set parameters

% Number of samples
s = 640;

% Number of levels
l = 2;

% Initial values
x0 = [0 0];

% ms
m = [0 0];

% Phis
phi = [0.01 0.01]; 

% Kappas
ka = [1];

% Omegas
om = [-1 -1];


%% Simulate

u = normrnd(0,1,s+1,l);
x = NaN(s+1,l);
x(1,:) = x0;
for k = 2:s+1
    x(k,l) = x(k-1,l) +phi(l)*(m(l) -x(k-1,l)) +exp(om(2))*u(k,l);
    for j = l-1:-1:1
        x(k,j) = x(k-1,j) +phi(j)*(m(j) -x(k-1,j)) +exp(ka(j)*x(k,j+1) +om(j))*u(k,j);
    end
end
u(1,:) = [];
x(1,:) = [];

ek = kurtosis(x) -3;


%% Gather results

r.s  = s;
r.l  = l;
r.x0 = x0;
r.ka = ka;
r.om = om;
r.u  = u;
r.x  = x;
r.ek = ek;
