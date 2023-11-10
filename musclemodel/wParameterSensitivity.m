opts = [0.56*0.6 0.56 0.56*1.4];
figure;
for i = 1:6

    w = opts(i);

    lf = 0:0.001:0.1;
    lfopt = 0.05;

    part = (lf - lfopt) / (w * lfopt);
    fl = (1.0 - (part.^2) ); 

    %
    %
    if (fl < 0.0)
    fl = 0.0;
    end
    plot(lf ./ lfopt, fl);
    
    hold on;
    ylim([0 1.1])
    legend('0.3', '0.4', '0.56', '0.6', '0.7', '0.8')
end
