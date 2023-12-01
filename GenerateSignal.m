function y = GenerateSignal(varargin)
    p = inputParser;
    
    % If data input is scalar, then it will be the number of symbols
    % if it is an array, it will be considered the symbols.
    defaultData = 8;
    defaultSPS = 8;
    defaultModType = "bpsk";
    defaultNPreambleSyms = 0;
    defaultPreambleModType = "bpsk";
    
    
    addParameter(p, 'data', defaultData);
    addParameter(p, 'sps', defaultSPS);
    addParameter(p, 'modType', defaultModType);
    addParameter(p, 'preambleSyms', defaultNPreambleSyms);
    addParameter(p, 'preambleModType', defaultPreambleModType);
    
    parse(p, varargin{:});
    data = p.Results.data;
    sps = p.Results.sps;
    modType = p.Results.modType;
    nPreambleSyms = p.Results.preambleSyms;
    preambleModType = p.Results.preambleModType;
    
    generatingSymbols = false;
    
    % Validate arguments
    if length(data) == 0
        error("Data must not be= empty");
    elseif length(data) == 1
        generatingSymbols = true;
    end
    
    % Clean input data
    modType = lower(modType);
    
    % Get the max order for our mod type
    % so we can clean data, or generate it
    modOrder = getModOrder(modType);
    
    % Generate symbols if necessary
    if generatingSymbols
        nSyms = data - nPreambleSyms;
        data = randi(modOrder,[1,nSyms]) - 1;
    end
   
    % Ensure symbols are within modOrder
    if sum(data >= modOrder) ~= 0
        error("Data is out of range of your modulation order ('%d')", modOrder);
    end
    
    % Generate preamble symbols
    if nPreambleSyms > 0
        preambleModOrder = getModOrder(preambleModType);
        
        nPreambleCopies = ceil(nPreambleSyms / 2);
        preamble_data = repmat([0,1],[1,nPreambleCopies]);
        if mod(nPreambleSyms,2) == 1
            preamble_data = preamble_data(1:end-1);
        end
    
        % Ensure symbols are within modOrder
        if sum(preamble_data >= preambleModOrder) ~= 0
            error("Preamble data is out of range of your modulation order ('%d')", modOrder);
        end
    end
    

    
    % Modulate the data
    syms = modulate(data, modType);
    if nPreambleSyms > 0
        preamble_syms = modulate(preamble_data, preambleModType);
        syms = [preamble_syms, syms];
    end
    
    % Pulse shape the data
    filterSpan = 4;
    filterCoeffs = rcosdesign(0.35, filterSpan, sps);
    syms = [syms, zeros(1,floor(length(filterSpan/2)))];
    y = filter(filterCoeffs, 1, upsample(syms, sps));
end

function y = modulate(syms, modType)
    if modType == "bpsk"
        y = pskmod(syms, 2);
    elseif modType == "qpsk"
        y = pskmod(syms, 4);
    elseif modType == "8psk"
        y = pskmod(syms, 8);
    elseif modType == "16qam"
        y = qammod(syms, 16);
    elseif modType == "64qam"
        y = qammod(syms, 64);
    elseif modType == "pam4"
        y = pammod(syms, 4);
    else
        error(sprintf("Unknown modulaton type %s", modType));
    end
end

function order = getModOrder(modType)
    if modType == "bpsk"
        order = 2;
    elseif modType == "qpsk"
        order = 4;
    elseif modType == "8psk"
        order = 8;
    elseif modType == "16qam"
        order = 16;
    elseif modType == "64qam"
        order = 64;
    elseif modType == "pam4"
        order = 4;
    else
        error(sprintf("Unknown modulaton type %s", modType));
    end
end