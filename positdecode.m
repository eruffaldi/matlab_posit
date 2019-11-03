function r = positdecode(x,N,esbits,valueonly)
if nargin < 3
    esbits = 0;
end
if nargin < 4
    valueonly = 0;
end
assert(esbits==0);

% MAYBE REMOVE THIS
if x == 0
    if valueonly
        r = 0;
    else
        r = [];
        r.sign = false;
        r.below1 = true;
        r.powR = 0;
        r.frac = 0;
        r.value = 0;
    end
    return;    
end

s = x < 0;
x = abs(x);
invbit = 2.^(N-2);
r =[];
r.sign = s;
r.below1 = x < invbit;
if x >= invbit
    % 0 1[R] 0 phi[F] => 1 0[R] 1 ~phi[F] => 0 0[R] 1 ~phi[F]
    x = bitand(bitcmp(x),2^(N-1)-1); % 01.....
    np = int_makepow2(x);
    if x == np
        % 0 0[R] 1 0[F]
        sigma = np; % 2^F
        r.powR = bitshift(1,N-2)./sigma;
        r.frac = sigma-1; % all ones        
    else
        sigma = np/2;
        r.powR = bitshift(1,N-2)./sigma;
        r.frac = bitand(bitcmp(x-sigma),sigma-1);
    end
    % then continue decoding 2^(R-1)
    r.value = double(r.powR)/2*(1+double(r.frac)./double(sigma));
else
    np = int_makepow2(x);
    % 0 0[R] 1 phi[F]
    % 0 0[R] 1 0[F]
    % sigma = 2^F = 2^(N-R-2) = 2^N 2^-R 2^-2
    % 2^R = 2^N 2^-2 / sigma
    if x == np
        % zero fraction
        sigma = np;
        r.powR = bitshift(1,N-2)./sigma;
        r.frac = 0;
    else
        sigma = np/2;
        r.powR = bitshift(1,N-2)./sigma;
        r.frac = x-sigma;
    end
    % then continue decoding
    r.value = 1.0/double(r.powR)*(1+double(r.frac)./double(sigma));
end
if s
    r.value = -r.value;
end
if valueonly
    r = r.value;
end