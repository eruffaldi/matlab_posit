function r = buildlookup(N,es,t)


if nargin < 3
    t = @int8;
end
if nargin < 2
    es = 0;
end

r =[];
for I=(-(2^(N-1))):(2^(N-1)-1)
    qq = positdecode(t(I),N,es);
    qq.raw = I;
    r = [r; qq];
end
r = struct2table(r);
