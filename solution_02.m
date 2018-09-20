%#########################################################
% HGF-toolbox Workshop, CP course Zurich, September 2018
% Unit 2
% Topic: Example analysis using the continuous HGF
% Author: Tore Erdmann
%#########################################################
% Here we go through the full analysis process given, again
% simulated, sample of data from imagined participants.
%
% We will analyse the data of two samples of participants.
% 
% In this file, we are working with continuous inputs and
% responses. The types of paradigms you can imagine for this are:
%  - participants trying to match time intervals
%  - reaction times in response to different pitches
%  - normalized activity in some brain region in response to a stimulus
%
% Here, we will be looking for differences in the omega_1 parameter
% estimates. We will initially fit a two-level continuous
% HGF.



%#########################################################
% 2.0. Creating a dataset
%#########################################################
% We start by creating inputs.



%% Ex_2.0.1: Create a sequence of inputs. 
%  The sequence should be created through these steps:
%  - Create a latent 'mean' process which is a step function that has three
%  steps and stable periods of 50 trials.
%  - Simulate the observed inputs as normally distributed around the
%  'mean' process.

% =>
%% Create inputs
rng(123);
u = [2 + randn(50, 1) * .1,
     4 + randn(50, 1) * .1,
     2 + randn(20, 1) * .1,
     4 + randn(20, 1) * .1,
     2 + randn(20, 1) * .1,
     3 + randn(50, 1) * .1];
% plot(u);
csvwrite('data/inputs_continuous_u.csv', u)
% /=>



%% Ex_2.0.2: 
%  From here on, use the inputs provided in the file
%  'data/inputs_continuous_u.csv'.
%  Simulate responses using the `tapas_simModel` function and 
%  the parameter vector below. Visualize the outcome using 
%  the function `tapas_hgf_plotTraj`.

%      mu0(1) mu0(2) sa0(1) sa0(1)  rho(1) rho(2)
pars = [2     0      .1      .1     0     0  ...
%     log(ka)     om(1)  om(2)  log(pi_u)
       log(1)       2      0        100];

% =>
simdat = tapas_simModel(u,...
                        'tapas_hgf', ...
                        pars,...
                        'tapas_gaussian_obs',...
                        .001);  
tapas_hgf_plotTraj(simdat)
% /=>



%% Ex_2.0.2: Simulate a whole dataset.
%  Simulate 100 participants with the parameters from the above fit,
%  but the omega_1 values changed to the values that the code 
%  below produces. Save the resulting simulated responses in a file
%  named `data/responses_continuous_y.csv`.

n = 100;
rng(123);
om1 = [-2 + randn(n/2,1); -10 + randn(n/2,1)];

% =>
% pars = bopars.p_prc.p;
dat = zeros(length(u), n);
for ii = 1:n
    pars(8) = om1(ii);
    simdat = tapas_simModel(u,...
                            'tapas_hgf', ...
                            pars,...
                            'tapas_gaussian_obs',...
                            .001);  
    dat(:, ii) = simdat.y;
end
csvwrite('data/responses_continuous_y.csv', dat)
% /=>




%#########################################################
% 2.1. Individual modelling and 2nd level anayses
%#########################################################
% You can find the behavioral data in a `.csv` file named 
% 'data/responses_continuous_y.csv'. It is a matrix that contains the 
% responses of each participant arranged by columns.



%% Ex_2.1.1: 
%  Fit the binary HGF to each participants responses
%  separately. Save the model fits into a file with the path
%  'data/fits_continuous.mat'. Use the `tapas_gaussian_obs` 
%  response model and the provided `config_continuous` configuration file. 

% => 
% We start by loading the data and the inputs
dat = load('data/responses_continuous_y.csv');
all_fits = struct;
ids = 1:n
for ii=ids
    disp(ii);
    try
        fit = tapas_fitModel(dat(:,ii), ...
                             u, ...
                             'config_continuous', ...
                             'tapas_gaussian_obs_config');
        all_fits.fit{ii} = fit;
    catch
        % signal estimation failure
        all_fits.fit{ii} = NaN;
    end
end
% check for estimation failures
for ii = 1:n
    if ~isstruct(all_fits.fit{ii})
        disp(ii)
    end
end
% save parameters 
save('data/fits_continuous_default-config.mat', 'all_fits');
% /=> 



%% Ex_2.1.2: 
%  Create a plot and a statistical test for the
%  difference. Interpret the results.

% => 
% load('data/fits_continuous.mat');
% extract parameters
estimates = [];
for ii = 1:length(all_fits.fit)
    disp(ii);
    if isstruct(all_fits.fit{ii})
        estimates(ii, :) = [all_fits.fit{ii}.p_prc.om(1), ii];
    end
end
grp = estimates(:,2) > n/2;
figure;
boxplot(estimates(:,1), grp);
hold;
plot(grp + 1 + rand(length(grp), 1) * .1 - .05, ...
     estimates(:,1), '.', 'Markersize', 12);
hold off;
fitlm(estimates(:,2), grp)

% A: Some of the estimations are a bit off for the second group. 
% Next, we will look at the fit and perform diagnostics!
% /=> 




%#########################################################
% 2.2. Diagnostics
%#########################################################
% Now we want to check our model using diagnostic plots and measures.
% Model checking is an important part of the modelling workflow and
% can (and will) lead to improvements of your model.



%% Ex_2.2.1: 
%  Inspect the residual diagnostics. Do you see any regularities? 
%  Extract the residuals from the saved fit objects and plot some of
%  them individually.

% =>
% The residuals can be loaded from the file 'data/fits_continuous.mat'
load('data/fits_continuous_default-config.mat');
% plot the residuals of some individuals
tapas_fit_plotResidualDiagnostics(all_fits.fit{1});
tapas_fit_plotResidualDiagnostics(all_fits.fit{52});
% plot residuals in one plot window
figure;
plot(all_fits.fit{1}.optim.res)
hold;
plot(all_fits.fit{52}.optim.res)
hold off;
% A: A bit of structure can be seen.
% /=>




%% Ex_2.2.2: 
%  Perform a posterior predictive check. Sample response using the 
%  previously obtained estimates and compare them 
%  to the observed data.
%  - Start with two example subjects from each of the groups 
%  - Look at the trajectories of those participants, that have
%  estimates away from most of the others in their group
%  - What do you find?

% =>
%% Plot the simulated against the actual data
idx1 = 1;
idx2 = 51;
sim1 = tapas_simModel(u,...
                      'tapas_hgf',...
                      all_fits.fit{idx1}.p_prc.p,...
                      'tapas_gaussian_obs',...
                      .001);  
sim2 = tapas_simModel(u,...
                      'tapas_hgf',...
                      all_fits.fit{idx2}.p_prc.p,...
                      'tapas_gaussian_obs',...
                      .001);  
dat = load('data/responses_continuous_y.csv');
figure;
subplot(1,2,1);
plot(sim1.y, '.', 'Markersize', 15)
hold;
plot(dat(:, idx1), '.', 'Markersize', 15)
subplot(1,2,2);
plot(sim2.y, '.', 'Markersize', 15)
hold;
plot(dat(:, idx2), '.', 'Markersize', 15)
hold off;

%% Look at the trajectories of the 'outliers'
ids = 50 + find(estimates(51:100,1) > 0);
for ii = ids'
    sim1 = tapas_simModel(u,...
                          'tapas_hgf',...
                          all_fits.fit{ii}.p_prc.p,...
                          'tapas_gaussian_obs',...
                          .001);  
    figure;
    plot(sim1.y, '.', 'Markersize', 15)
    hold;
    plot(dat(:,ii), '.', 'Markersize', 15)
    legend('simulated responses', 'actual responses');
end

% A: The fits look fine, with no structural differences
%    between simulated and actual responses.

% /=>



%% Ex_2.2.3: 
%  Check identifiability: Plot the average posterior correlation
%  matrix. 

% => 
% The is the function `tapas_fit_plotCorr(est)`, but it only plots
% the matrix for a single fit.
% Average the posterior correlation matrices
% (you could also check the max)
load('data/fits_continuous_default-config.mat');
meanCorr = zeros(5,5)
for ii = 1:n
    disp(ii)
    meanCorr = meanCorr + all_fits.fit{ii}.optim.Corr;
end
meanCorr = meanCorr / n
figure;
imagesc(meanCorr, [-1 1]);
axis('square');
colorbar;
title('Parameter correlation', 'FontSize', 15, 'FontWeight', 'bold');

% A: There appear to be some correlations. Thus, let's check the
% matrices of some individuals in the two groups.
tapas_fit_plotCorr(all_fits.fit{3})
tapas_fit_plotCorr(all_fits.fit{51})

% A:
% We can see different patterns of correlations for the two groups.
% Some fits for the second group show correlations between omega
% and pi_u.
% In order to get better estimates and reduce the correlations, we
% could try to set a tighter prior or even fix pi_u (which is not
% of interest in this analysis).
% /=> 




%#########################################################
% Make sure that this file runs through completely:
% 
% 1. Clear the workspace using:
%      clear;
% 
% 2. Run the whole script:
%      Select the whole file and hit 'Run' in the matlab IDE.
% 
%########################################################
