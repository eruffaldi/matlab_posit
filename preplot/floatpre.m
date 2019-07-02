function [m,l,Y,Eraw] =floatpre(n,e,X)

% for float with n bits and e bits of exponent
%
% n can be: single,double,float16,float16alt,bfloat,
%   
if ischar(n)
    [n,e] = knownfloattypes(n);
end
if n > 64
    error('not possible over 64');
end
f=int64(n-1-e);
X = abs(X); % NOTE

emaxraw = int64(bitshift(1,e)-1);
ebias = int64(bitshift(1,e-1)-1);
emax  = (emaxraw-1)-ebias; % emaxraw-1-ebias
emin=-ebias;
maskE = int64(bitshift(1,e)-1);
maskM = int64(bitshift(1,f)-1);

e_d = int64(11);
ebias_d = int64(1023);
f_d = int64(52);
maskM_d = int64(bitshift(1,f_d)-1);
maskE_d = int64(bitshift(1,e_d)-1);
emaxraw_d = int64(bitshift(1,e_d)-1);
assert(f <= f_d & e <= e_d,'smaller than double is needed');
    
if isfloat(X)
    % X = pow2(F,E)
    % [F,E] = log2(X) 
    % F are typically in the range 0.5 <= abs(F) < 1.
    % n = hex2num(S)
    % num2hex(X)
    % str = dec2hex(d, n)
    
    % Solution 1: use log2
    % Solution 2: use hex of double
    %[F,E] = log2(double(X));    
    %F(E < emin) = 0;
    % todo check range
    if nargout > 2
        d = int64(hex2dec(num2hex(X)));
        F = bitand(d,maskM_d);
        Eraw = int64(bitand(int64(bitshift(d,-f_d)),maskE_d)); % Eraw
        E = Eraw-ebias_d;
        E(Eraw == emaxraw_d) = emax;
        F(Eraw == 0) = 0;
        d = bitor(bitshift(E+ebias,f),bitshift(F,f-f_d)); % align bits left
        Y = reshape(d,size(X)); %hex2num(dec2hex(d,16)),size(X));
     end
else
    % decompose in F and E
    X = int64(X);
    especial = int64(bitshift(1,e)-1);
    F = bitand(X,maskM);
    Eraw = int64(bitand(int64(bitshift(X,-f)),maskE)); % Eraw
    E = Eraw-ebias;
    E(Eraw == emaxraw) = emax;
    F(Eraw == emaxraw) = 0;
    F(Eraw == 0) = 0;
    % Eraw==0 zero and subnormals
    % Emaxraw
    %Denormal numbers provide the guarantee that addition and subtraction of floating-point numbers never underflows; two nearby floating-point numbers always have a representable non-zero difference. Without gradual underflow, the subtraction a ? b can underflow and produce zero even though the values are not equal. This can, in turn, lead to division by zero errors that cannot occur when gradual underflow is used.[1]
    if nargout > 2
        % make the exadecimal over 64bits as double
        d = bitor(bitshift(E+ebias_d,f_d),bitshift(F,f_d-f)); % align bits left
        Y = reshape(hex2num(dec2hex(d,16)),size(X));
        
    end
end
m=reshape(E,size(X));
l=m-f;

