function models = make_models(configs_prc, configs_obs)

n = length(configs_prc);
m = length(configs_obs);
models = cell(n, m);

for i=1:n
    for j=1:m
        models{i,j} = struct;
        models{i,j}.m_prc = configs_prc{i};
        models{i,j}.m_obs = configs_obs{j};
    end
end
        
