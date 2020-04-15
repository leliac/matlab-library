function [f,psd] = standardPsd(samples,fc,centerFreq,graph,limX,limY,plotTitle,saveTitle)
    psd = fftshift(abs(fft(samples)).^2);
    dF = fc/length(samples);
    f = (centerFreq-fc/2:dF:centerFreq+fc/2-dF)';
    if graph
        figure;
        plot(f,psd);
        if limX ~= inf
            xlim(limX);
        else
            xlim([min(f) max(f)]);
        end
        if limY ~= inf
            ylim(limY);
        else
            ylim([min(psd) max(psd)]);
        end
        if plotTitle ~= ""
            title(plotTitle);
        end
        xlabel('f [Hz]');
        ylabel('PSD');
        if saveTitle ~= ""
            saveas(gcf,saveTitle);
        end
    end
end