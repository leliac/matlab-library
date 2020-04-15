function [samples_tx,symbols_tx] = bbDigitalTx(bits_tx,fc,Rb,BpS,mapping,symbols,pulse)

    %% Initialization
    Nsymbols = length(bits_tx)/BpS;
    M = 2^BpS;
    if isstring(mapping) && mapping == "gray"
        mapping = de2bi(grays(BpS),BpS,'left-msb');
    elseif isstring(mapping) && mapping == "standard"
        mapping = de2bi(0:M-1,BpS,'left-msb');
    end
    if isstring(symbols) && symbols == "antipodal"
        symbols = (-M+1:2:M-1)';
    elseif isstring(symbols) && symbols == "unipolar"
        symbols = (0:1:M-1)';
    end
    Rs = Rb/BpS;
    SpS = fc/Rs;
    Nsamples = Nsymbols*SpS;

    %% Symbol mapper
    bits_tx = reshape(bits_tx,BpS,Nsymbols)';
    [~,symbols_tx_indices] = ismember(bits_tx,mapping,'rows');
    symbols_tx = symbols(symbols_tx_indices);

    %% Driver
    if isstring(pulse) && pulse == "nrz"
        samples_tx = rectpulse(symbols_tx,SpS);
    else
        S = zeros(Nsamples,Nsymbols);
        for k = 0:Nsamples-1
            for l = 0:Nsymbols-1
                S(k+1,l+1) = pulse((k/SpS-l)/Rs);
            end
        end
        samples_tx = S*symbols_tx;
    end
