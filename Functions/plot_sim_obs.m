function plot_sim_obs(yrep, y)


[nt, nreps, nm] = size(yrep);

figure; 
for j=1:nm
subplot(nm, 1, j);
plot(1:nt, yrep(:,1,j) + randn(nt, 1) * .1, 'black')
hold on
for i=2:nreps
    plot(1:nt, yrep(:,i,j) + randn(nt, 1) * .1, 'black')
end
hold on;
plot(1:nt, y, 'red', 'linewidth', 3)
hold off;
end

% For binary responses: compare performance
% figure;
% for j=1:nm
% subplot(3, 1, j);
% histogram(sum(yrep(:,:,j) == u));
% hold on;
% scatter(sum(y == u), 1, 'red');
% hold off;
% end
