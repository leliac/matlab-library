function snrGraph(signal,algorithm,Nbits,pe,SNR,loss)
    %% Graph initialization
    figure;
    set(gca,'XScale','log');
    hold on;
    pe_theory = logspace(log10(min(pe)),log10(max(pe)),1e4);
    color_de = 1;
    l = 1;
    Signal = mlreportgen.utils.capitalizeFirstChar(signal);
    if algorithm == "uniform"
        Algorithm = "uniform quantization";
    elseif algorithm == "mu"
        Algorithm = "\mu-law companding";
    elseif algorithm == "A"
        Algorithm = "A-law companding";
    elseif algorithm == "lloyd"
        Algorithm = "Lloyd algorithm";
    else
        error("unrecognized quantization method '%s'",algorithm);
    end
    
    %% BSC SNR (theory, uniform signal)
    if signal == "uniform"
        SNR_bsc = 0.25./pe_theory;
        plot(pe_theory,pow2db(SNR_bsc),'k--');
        labels{l} = 'BSC SNR (theory, uniform signal)';
        l = l+1;
    end

    %%
    for k = 1:length(Nbits)
        M = 2^Nbits(k);
        color_bi = de2bi(color_de,3,'left-msb');
        color_de = color_de+1;

        %% quantization SNR (theory, uniform signal)
        if signal == "uniform"
            SNR_quantization = M^2;
            plot(pe_theory,ones(1,length(pe_theory))*pow2db(SNR_quantization),'--','color',color_bi);
            labels{l} = sprintf('quantization SNR, n=%d (theory, uniform signal)',Nbits(k));
            l = l+1;
        end

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

        %% total SNR (simulation)
        plot(pe,pow2db(SNR{k}),'s','color',color_bi);
        labels{l} = sprintf('total SNR, n=%d (simulation)',Nbits(k));
        l = l+1;
    end

    %% Graph finalization
    xlim([min(pe) max(pe)]);
    if signal ~= "uniform"
        ylim([-10 60]);
    end
    grid on;
    title(sprintf("%s signal SNR (%s)",Signal,Algorithm));
    xlabel('P_e');
    ylabel('SNR [dB]');
    legend(labels);
    set(gcf,'units','normalized','outerposition',[1 1 0.5 0.5]);
    saveas(gcf,sprintf("%s_snr_%s.svg",signal,algorithm));
end