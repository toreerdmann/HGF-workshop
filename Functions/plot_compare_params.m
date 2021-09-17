function plot_compare_params(results, params, k, m_idx, p_name)

% select subjects that were generated from model m_idx
inds = find(k == m_idx);

% extract true parameters from `params`
for i=1:length(inds)
    p_true(i) = eval(['params{', num2str(inds(i)), '}.', p_name]);
end

% extract estimates from fitting results
p_estimates = extract_parameter(results(inds,m_idx), p_name);

figure;
scatter(p_estimates, p_true)
hold on;
plot(-10:1:10, -10:1:10)
hold off;




