function signalVsTime(samples,fc,limY,plotTitle,saveTitle)
    t = 0:1/fc:(length(samples)-1)/fc;
    figure;
    plot(t,samples);
    xlim([min(t) max(t)]);
    if limY ~= inf
        ylim(limY);
    else
        ylim([min(samples) max(samples)]);
    end
    if plotTitle ~= ""
        title(plotTitle);
    end
    xlabel('t [s]');
    ylabel('x(t)');
    if saveTitle ~= ""
        saveas(gcf,saveTitle);
    end
end