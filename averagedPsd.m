function [f,psd] = averagedPsd(samples,fC,centerFreq,samplesPerPsd,graph,limX,limY,plotTitle,saveTitle)
    numPsds = length(samples)/samplesPerPsd;
    psd = NaN(samplesPerPsd,numPsds);
    for k = 1:numPsds
        psd(:,k) = abs(fft(samples(1+(k-1)*samplesPerPsd:k*samplesPerPsd))).^2;
    end
    psd = fftshift(sum(psd,2)/numPsds);
    dF = fC/samplesPerPsd;
    f = (centerFreq-fC/2:dF:centerFreq+fC/2-dF)';
    if graph
        figure;
        plot(f,psd);
        if limX ~= inf
            xlim(limX);
        end
        if limY ~= inf
            ylim(limY);
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