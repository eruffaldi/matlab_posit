function n = findledtmost(X)
% returns the leftmost bit set counted from left (log2)
%
% 1 returns 0
% 0 returns 1
%
assert(isa(X,'uint32'),'needed uint32');
[~,n] = log2(double(bitor(X,1)));
n=n-1;

% https://stackoverflow.com/questions/671815/what-is-the-fastest-most-efficient-way-to-find-the-highest-set-bit-msb-in-an-i
%
% Options for Matlab
% - shifts and ors
% - cast 32bit to float and use exponent-1