function [s,E,F] = doubledecode(d)
% given double or int64 vector
%
% s = logical
% E = exponent biased (zero becomes: -1023 and special is 1024)
% F = mantissa (52bit right aligned)
%
% Emanuele Ruffaldi 2019
if isfloat(d)
    d = double(d);
else
    d = int64(d);
end
d=typecast(d,'int64');
s = d < 0;
maskM_e_low = bitshift(int64(1),11)-1;
E = bitand(bitshift(d,-52),maskM_e_low)-1023;

maskM_d = bitshift(int64(1),52)-1;
F = bitand(d,maskM_d);
