function [v_out,SNR] = pcm(v_in,Nbits,V,pe,algorithm,companding_parameter,lloyd_training_set)
    %% initialization
    v_out = cell(1,length(Nbits));
    SNR = cell(1,length(Nbits));
    
    %% compressor
    if algorithm == "mu" || algorithm == "A"
        v_in_compressed = compand(v_in,companding_parameter,V,sprintf('%s/compressor',algorithm));
    else
        v_in_compressed = v_in;
    end
    
    for k = 1:length(Nbits)
        v_out{k} = NaN(length(v_in),length(pe));
        SNR{k} = NaN(1,length(pe));
        
        %% quantizer
        dV = 2*V/2^Nbits(k);
        codebook = -V+dV/2:dV:V-dV/2;
        if algorithm == "lloyd"
            [partition,codebook] = lloyds(lloyd_training_set,codebook);
        else
            partition = -V+dV:dV:V-dV;
        end
        index_in = quantiz(v_in_compressed,partition,codebook);

        %% encoder
        words_in = de2bi(index_in,Nbits(k));

        for l = 1:length(pe)
            %% BSC
            words_out = bsc(words_in,pe(l));

            %% decoder
            index_out = bi2de(words_out);
            v_out{k}(:,l) = transpose(codebook(index_out+1));

            %% expander
            if algorithm == "mu" || algorithm == "A"
                v_out{k}(:,l) = compand(v_out{k}(:,l),companding_parameter,V,sprintf('%s/expander',algorithm));
            end

            %% SNR calculator
            SNR{k}(l) = var(v_in)/var(v_out{k}(:,l)-v_in);
        end
    end
end