function tapas_plot_sgmGaussian(mu,sa)
    d = @(y) sigmoidGaussian(y,mu,sa);
    fplot(d,[0,1]);
end

function f = sigmoidGaussian(y,mu,sigma)
    f = 1./(y.*(1-y)).*gaussian(log(y./(1-y)),mu,sigma);
end

function p = gaussian(x,mu,sigma)
    p = 1/sqrt(2.*pi.*sigma).*exp(-(x-mu).^2./(2.*sigma));
end
