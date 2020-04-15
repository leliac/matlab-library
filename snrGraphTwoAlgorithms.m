function snrGraphTwoAlgorithms(signal,algorithm1,algorithm2,Nbits,pe,SNR1,SNR2,loss)
    %% Graph initialization
    figure;
    set(gca,'XScale','log');
    hold on;
    pe_theory = logspace(log10(min(pe)),log10(max(pe)),1e4);
    color_de = 1;
    l = 1;
    Signal = mlreportgen.utils.capitalizeFirstChar(signal);
    if algorithm1 == "uniform"
        Algorithm1 = "uniform quantization";
    elseif algorithm1 == "mu"
        Algorithm1 = "\mu-law companding";
    elseif algorithm1 == "A"
        Algorithm1 = "A-law companding";
    elseif algorithm1 == "lloyd"
        Algorithm1 = "Lloyd algorithm";
    else
        error("unrecognized quantization method '%s'",algorithm1);
    end
    if algorithm2 == "uniform"
        Algorithm2 = "uniform quantization";
    elseif algorithm2 == "mu"
        Algorithm2 = "\mu-law companding";
    elseif algorithm2 == "A"
        Algorithm2 = "A-law companding";
    elseif algorithm2 == "lloyd"
        Algorithm2 = "Lloyd algorithm";
    else
        error("unrecognized quantization method '%s'",algorithm2);
    end

    %%
    for k = 1:length(Nbits)
        M = 2^Nbits(k);
        color_bi = de2bi(color_de,3,'left-msb');
        color_de = color_de+1;

        %% total SNR (theory, uniform signal)
        SNR_theory_uniform = M^2./(1+4*(M^2-1)*pe_theory);
        plot(pe_theory,pow2db(SNR_theory_uniform),'color',color_bi);
        labels{l} = sprintf('total SNR, n=%d (theory, uniform signal)',Nbits(k));
        l = l+1;

        %% total SNR (theory, non-uniform signal)
        if signal ~= "uniform"
            SNR_theory_non_uniform = SNR_theory_uniform/loss;
            plot(pe_theory,pow2db(SNR_theory_non_uniform),'-.','color',color_bi);
            labels{l} = sprintf('total SNR, n=%d (theory, non-uniform signal)',Nbits(k));
            l = l+1;
        end

        %% total SNR (simulation 1)
        plot(pe,pow2db(SNR1{k}),'o','color',color_bi);
        labels{l} = sprintf('total SNR, n=%d (simulation, %s)',Nbits(k),Algorithm1);
        l = l+1;
        
        %% total SNR (simulation 1)
        plot(pe,pow2db(SNR2{k}),'x','color',color_bi);
        labels{l} = sprintf('total SNR, n=%d (simulation, %s)',Nbits(k),Algorithm2);
        l = l+1;
    end

    %% Graph finalization
    xlim([min(pe) max(pe)]);
    if signal ~= "uniform"
        ylim([-10 60]);
    end
    grid on;
    title(sprintf("%s signal SNR (%s and %s)",Signal,Algorithm1,Algorithm2));
    xlabel('P_e');
    ylabel('SNR [dB]');
    legend(labels);
    set(gcf,'units','normalized','outerposition',[1 1 0.5 0.5]);
    saveas(gcf,sprintf("%s_snr_%s_%s.svg",signal,algorithm1,algorithm2));
end