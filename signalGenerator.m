function [v_in,V,loss,fc] = signalGenerator(signal,Nsamples,A,fc,music_file,music_channel,voice_bitsPerSample,Nbins)
    %% generator and sampler
    if signal == "uniform"
        v_in = A*(2*rand(Nsamples,1)-1);
    elseif signal == "music"
        audioinfo(music_file)
        [v_in,fc] = audioread(music_file,[1 Nsamples]);
        v_in = v_in(:,music_channel);
    elseif signal == "voice"
        duration = Nsamples/fc;
        recorder = audiorecorder(fc,voice_bitsPerSample,1,-1)
        fprintf('starting voice recording (%f seconds)\n', duration);
        recordblocking(recorder,duration);
        fprintf('stopping voice recording\n');
        v_in = getaudiodata(recorder);
    else
        error("unrecognized signal type '%s'",signal);
    end
    V = max(abs(min(v_in)),max(v_in));
    loss = V^2/3/var(v_in);
    Signal = mlreportgen.utils.capitalizeFirstChar(signal);

    %% time behavior
    signalVsTime(v_in,fc,inf,sprintf("%s signal time behavior",Signal),sprintf("%s_sig.svg",signal));

    %% PDF
    figure;
    PDF = histogram(v_in,Nbins,'BinLimits',[-V,V],'Normalization','pdf');
    if signal == "music" || signal == "voice"
        PDF_fittype = fittype(sprintf('a/2/(1-exp(-a*%f))*exp(-a*abs(x))',V));
        PDF_x = transpose(PDF.BinEdges(1:Nbins)+V/Nbins);
        PDF_y = transpose(PDF.Values);
        PDF_fit = fit(PDF_x,PDF_y,PDF_fittype,'startpoint',1);
        PDF_a = PDF_fit.a;
        PDF_k = PDF_a/2/(1-exp(-PDF_a*V));
        hold on;
        plot(PDF_x,PDF_fit(PDF_x),'r');
        legend('simulation',sprintf('fit (%.1f*exp(-%.1f*|x|))',PDF_k,PDF_a));
    end
    title(sprintf("%s signal PDF",Signal));
    xlabel('x');
    ylabel('Frequency');
    saveas(gcf,sprintf("%s_pdf.svg",signal));

    %% PSD
    standardPsd(v_in,fc,0,true,inf,inf,sprintf("%s signal PSD",Signal),sprintf("%s_psd.svg",signal));

    %% save signal
    save(signal);
end