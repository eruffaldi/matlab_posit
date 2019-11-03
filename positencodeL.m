function [p,pv] = positencodeL(ev,x)

if isinf(x)
    mi = find(isinf(ev.value),1,'first');
else
    [mv,mi] = min(abs(ev.value-x));
end
p = ev.raw(mi);
pv = ev.value(mi);
