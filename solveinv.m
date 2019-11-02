syms N R2_x phi_x  R2_y Y y phi_y x X real


posit_x_inv = @(N,R2_x,phi_x) R2_x^-1*(1+phi_x*R2_x*2^-(N-2)); % 2^ -R_x
posit_x = @(N,R2_x,phi_x) R2_x/2*(1+phi_x*R2_x*2^-(N-2)); % 2^(R_x-1)

rposit_x_inv =@(N,R2_x,phi_x) R2_x^-1*2^(N-2) + phi_x; %  assume F > 0
rposit_x =@(N,R2_x,phi_x) R2_x^-1*2^(N-2+1)*(R2_x-1) + phi_x; % 0 1[R] 0 phi[F] assume F > 0


assert(posit_x_inv(8,1,0)==posit_x(8,2^1,0)); 
assert(rposit_x_inv(8,1,0)==rposit_x(8,2^1,0)); 


f = x == posit_x(N,R2_x,phi_x);
phi_xx = solve(f,phi_x);
p = X == rposit_x(N,R2_x,phi_x);
psu = subs(p,phi_x,phi_xx);
X_xx = simplify(solve(psu,X)) % X(x,R2_x)

phi_XX = solve(p,phi_x);
fsu = subs(f,phi_x,phi_XX);
x_XX = simplify(solve(fsu,x)) % x(X,R2_x)
pretty(x_XX)

% make the same for Y < 1
py = Y == rposit_x_inv(N,R2_y,phi_y);
fy = y == posit_x_inv(N,R2_y,phi_y);
phi_YY = solve(py,phi_y);
fsuy = subs(fy,phi_y,phi_YY);
y_YY = simplify(solve(fsuy,y)) % y(Y,R2_y) fixed point

q = simplify(x_XX*y_YY == 1)
symvar(q)

%q_r = subs(q,R2_y,R2_x/2); % independent of R2_y!
Y_solved = simplify(solve(q,Y))
pretty(Y_solved)
posit_reci2 = @(N,R2_x,X) 2^(2*N)/(6*2^N*R2_x + 8*R2_x^2*X - 4*2^N*R2_x^2)

q_r = subs(q,R2_x,R2_y*2); % we know this
X_solved = simplify(solve(q_r,X))
pretty(X_solved)
posit_reci2_inv = @(N,R2_y,Y) (2^N*(16*Y*R2_y^2 - 12*Y*R2_y + 2^N))/(32*R2_y^2*Y);


%% test
%  2.125 98  --> 0.4704 (best 0.46875 vs 0.48438 as 30/31 with error  -0.0018, 0.0138, so smallest)
Nt = 8;
R2_xt = 2^2;
R2_yt = 2^2;
tt = @int8; 
ttn = @int32;
phi_xt = 2;
phi_yt = 14; %
input_value = posit_x(Nt,R2_xt,phi_xt) % comples shall be 2.125
input_raw = tt(rposit_x(Nt,R2_xt,phi_xt))
realinv = 1.0/input_value
%TODO compute inverse of realinv using positencode
output_val = posit_x_inv(Nt,R2_yt,phi_yt) % unknow
output_raw = rposit_x_inv(Nt,R2_yt,phi_yt)
output_raw_dec = positdecode(double(output_raw),double(Nt))
output_eff= subs(Y_solved,{R2_x,X,N},{R2_xt,input_raw,Nt}) ;
output_raw_bin = dec2bin(double(output_raw),8)
output_eff_bin = dec2bin(double(output_eff),8)
r = positdecode(tt(output_eff),Nt,0)
output_raw_nonsym = posit_reci2(ttn(Nt),ttn(R2_xt),ttn(input_raw)) 

% backward
inv_output_eff= subs(X_solved,{R2_y,Y,N},{R2_yt,output_raw,Nt}) 
inv_output_eff-input_raw


%% high
% low
N=8;
r =[];
t=@int8;
ttn = @int32;
for I=1:126
    x = positdecode(t(I),N,0);
    if I < 64
        % wrong
        iX = posit_reci2_inv(ttn(N),ttn(x.powR),ttn(I));
    else
        iX = posit_reci2(ttn(N),ttn(x.powR),ttn(I));
    end
    ix = positdecode(iX,N,0);
    s = [];
    s.iraw = I;
    s.x = x.value;
    s.ix_real =1.0/x.value;
    s.ix_est = ix.value
    s.dix = s.ix_real-s.ix_est;
    r = [r; s];
end
r = struct2table(r)
mean(r.dix)
plot(r.dix)
