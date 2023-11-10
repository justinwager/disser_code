% delta = linspace(0,2,21);
pwrcalc = zeros(size(delta));
pwrobs = zeros(size(delta));
for k=1:length(delta)

    sigma = 1;
    d = delta(k) ; % difference in means as a multiple of sigma
    mu1 = 10;
    mu2 = mu1 + d*sigma;
    n1 = 20;
    n2 = 30;
    alpha = 0.05;
    crit = tinv(alpha/2, n1+n2-2);
    p = nctcdf([crit,-crit], n1+n2-2, d/sqrt(1/n1+1/n2));
    pwrcalc(k) = p(1) + 1-p(2)

    numout = 0;
    n = 10000;
    for j=1:n
        x1 = normrnd(mu1,sigma,n1,1);
        x2 = normrnd(mu2,sigma,n2,1);
        numout = numout + ttest2(x1,x2);
    end
    pwrobs(k) = numout/n
end
plot(delta,pwrcalc,'b-', delta,pwrobs,'ro')