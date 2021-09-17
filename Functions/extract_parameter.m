function values = extract_parameter(results, param)

l = length(eval(['results(1,1).fit.', param]));
nsubjects = size(results, 1);
nconfigs   = size(results, 2);

% extract parameters for plotting
values = zeros(nsubjects, l, nconfigs);
for i=1:nsubjects
    for j=1:nconfigs
       values(i,:,j) = eval(['results(', ...
           char(string(i)), ',' char(string(j)), ').fit.', param]);
    end
end

end