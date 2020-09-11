function tapas_plot_logGaussian(mu,sa,upperxlim)
    d = @(y) logGaussian(y,mu,sa);
    fplot(d,[0,upperxlim]);
end

function f = logGaussian(y,mu,sigma)
    f = 1./(y.*sqrt(2.*pi.*sigma)).*exp(-(log(y)-mu).^2./(2.*sigma));
end
