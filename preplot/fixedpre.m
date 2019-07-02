function [m,l] = fixedpre(n,ip,value)


% n bits in total
% ip bits of integer length (even negative)
m = repmat(ip,length(value),1);
l = repmat(ip-n,length(value),1);
