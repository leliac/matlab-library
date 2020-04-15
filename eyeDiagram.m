function eyeDiagram(samples,Neyes,SpS,limX,limY,plotTitle,saveTitle)
    samplesMax=1e4;

    eyediagram(samples(1:min(length(samples),samplesMax)),Neyes*SpS,Neyes*SpS);
    if limX ~= inf
        xlim(limX);
    end
    if limY ~= inf
        ylim(limY);
    end
    if plotTitle ~= ""
        title(plotTitle);
    end
    xlabel('Sample number');
    if saveTitle ~= ""
        saveas(gcf,saveTitle);
    end
end