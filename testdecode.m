
%% low
N=8;
r =[];
t=@int8;
for I=0:64
    qq = positdecode(t(I),N,0);
    qq.raw = I;
    r = [r; qq];
end
r = struct2table(r)

%% high
% low
N=8;
r =[];
t=@int8;
for I=64:127
    r = [r; positdecode(t(I),N,0)];
end
r = struct2table(r)
