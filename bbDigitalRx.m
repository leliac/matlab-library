function [bits,symbols,samples] = bbDigitalRx(samples,fc,Rb,BpS,filter,fP,A,tSamp,mapping,alphas,thresholds)

    %% Initialization
    dF = fc/length(samples);
    f = (-fc/2:dF:fc/2-dF)';
    Rs = Rb/BpS;
    SpS = fc/Rs;
    Nsamples = length(samples);
    Nbits = Nsamples*Rb/fc;
    if isstring(filter) && filter == "sinc"
        H = fftshift(sinc(f/Rs));
        if isstring(tSamp) && tSamp == "optimal"
            tSamp = ceil(SpS/2);
        end
    elseif isstring(filter) && lower(filter) == "rc"
        H = fftshift(1./(1+1i*f/fP));
        if isstring(tSamp) && tSamp == "optimal"
            tSamp = SpS;
        end
    else
        H = fftshift(filter(f)); 
    end
    M = 2^BpS;
    if isstring(mapping) && mapping == "gray"
        mapping = de2bi(grays(BpS),BpS,'left-msb');
    elseif isstring(mapping) && mapping == "standard"
        mapping = de2bi(0:M-1,BpS,'left-msb');
    end
    if isstring(alphas) && alphas == "antipodal"
        alphas = (-M+1:2:M-1)';
        if isstring(thresholds) && thresholds == "centered"
            thresholds = alphas(1:M-1)+1;
        end
    elseif isstring(alphas) && alphas == "unipolar"
        alphas = (0:1:M-1)';
        if isstring(thresholds) && thresholds == "centered"
            thresholds = alphas(1:M-1)+1/2;
        end
    end
    
    %% Filter
    samples = A*real(ifft(fft(samples).*H));
    
    %% Sampler
    samples_chosen = samples(tSamp:SpS:Nsamples);

    %% Decider
    symbols = alphas(1)*(samples_chosen<=thresholds(1));
    for k = 1:length(thresholds)-1
        symbols = symbols+alphas(k+1)*((samples_chosen>thresholds(k)).*(samples_chosen<=thresholds(k+1)));
    end
    symbols = symbols+alphas(end)*(samples_chosen>thresholds(end));

    %% Symbol demapper
    [~,alpha_indexes] = ismember(symbols,alphas);
    bits = mapping(alpha_indexes,:);
    bits = reshape((bits)',Nbits,1);
end
