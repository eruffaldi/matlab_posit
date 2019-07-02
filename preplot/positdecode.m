function [s,R,E,F] = positdecode(X,n,e)
%
% s = sign
% R = regime +-
% E = exponent +
% F = fraction left aligned to uint32

hn=32;
X=bitshift(cast(X,'uint32'),hn-n); % left aligned

signbit = bitand(X,bitshift(uint32(1),hn-1));
rbit = bitand(X,bitshift(uint32(1),hn-2)); % set if > 1
s = signbit ~= 0;
X = bitshift(X,2); % kick sign and rbit
Y = X;
Y(rbit ~= 0) = bitcmp(Y(rbit ~= 0));
nb=min(findleftmost(Y),n-1); % limit bits
R = -(n-nb+1); % rbit == 0
R(rbit ~= 0) = (n-nb(rbit~=0)+1)-1; % rbit = 

% below 1 R: 0|1...10 
% above 1 R: 1|0..01
% specials:
%   0|0...0|empty => min
%   0|001|rest  => -2
%   0|01|rest   => -1
%   1|10|rest   => 0
%   1|110|rest  => 1
%   1|1...1|empty => max

X=bitshift(X,nb+1); % the bits and the terminator
E=bitshift(X,hn-e); % always positive
F=bitshift(X,e);
