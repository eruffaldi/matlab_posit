function [n,e] = knownfloattypes(name)

switch name
    case 'float128'
        n=128;
        e=15;
    case {'double','float64'}
        n=64;
        e=11;
    case {'single','float32'}
        n=32;
        e=8;
    case 'float16'
        n=16;
        e=5;
    case {'float16alt','bfloat'}
        n=16;
        e=7;
    case 'pulp8'
        n=8;
        e=2;
end