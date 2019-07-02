function [s,E,F] = floatdecode(X,n,e)

if isfloat(X)
    X = typecast(double(X),'uint64');
end

if ischar(n)
    [n,e] = knownfloattypes(n);
end
assert(n <= 64,'not possible over 64');
f=int64(n-1-e);
X = abs(X); % NOTE

emaxraw = int64(bitshift(1,e)-1);
ebias = int64(bitshift(1,e-1)-1);
emax  = (emaxraw-1)-ebias; % emaxraw-1-ebias
emin=-ebias;
maskE = int64(bitshift(1,e)-1);
maskM = int64(bitshift(1,f)-1);

especial = int64(bitshift(1,e)-1);
F = bitand(X,maskM);
Eraw = int64(bitand(int64(bitshift(X,-f)),maskE)); % Eraw
E = Eraw-ebias;
E(Eraw == emaxraw) = emax;
F(Eraw == emaxraw) = 0;
F(Eraw == 0) = 0;
