%%
ev = buildlookup(8);

positencodeL(ev,2)
%%
syms N R2_x phi_x  R2_y Y y phi_y x X real


posit_x_inv = @(N,R2_x,phi_x) R2_x^-1*(1+phi_x*R2_x*2^-(N-2)); % 2^ -R_x
posit_x = @(N,R2_x,phi_x) R2_x/2*(1+phi_x*R2_x*2^-(N-2)); % 2^(R_x-1)

rposit_x_inv =@(N,R2_x,phi_x) R2_x^-1*2^(N-2) + phi_x; %  assume F > 0
rposit_x =@(N,R2_x,phi_x) R2_x^-1*2^(N-2+1)*(R2_x-1) + phi_x; % 0 1[R] 0 phi[F] assume F > 0

% verifies that 1 is covered on both value and repr
assert(posit_x_inv(8,1,0)==posit_x(8,2^1,0)); 
assert(rposit_x_inv(8,1,0)==rposit_x(8,2^1,0)); 

px = X == rposit_x(N,R2_x,phi_x);
fx = x == posit_x(N,R2_x,phi_x);
py = Y == rposit_x_inv(N,R2_y,phi_y);
fy = y == posit_x_inv(N,R2_y,phi_y);

% X(x,R2_x) with x >= 1
phi_xx = solve(fx,phi_x);
psu_x = subs(px,phi_x,phi_xx);
X_x = simplify(solve(psu_x,X)) 

% x(x,R2_x) with x >= 1
phi_XX = solve(px,phi_x);
fsu_x = subs(fx,phi_x,phi_XX);
x_X = simplify(solve(fsu_x,x)) % x(X,R2_x)

% Y(y,R2_y) = Y(y) with y positive <= 1
phi_yy = solve(fy,phi_y);
psu_y = subs(py,phi_y,phi_yy);
Y_y = simplify(solve(psu_y,Y)) 

% y(Y,R2_y) = y(Y) with y positive <= 1
phi_YY = solve(py,phi_y);
fsu_y = subs(fy,phi_y,phi_YY);
y_Y = simplify(solve(fsu_y,y)) 

% Y(y,R2_y) = Y(y) with y positive <= 1
psu_y0 = subs(py,phi_y,0);
Y_y0 = simplify(solve(psu_y0,Y)) 

% y(Y,R2_y) = y(Y) with y positive <= 1
fsu_y0 = subs(fy,phi_y,0);
y_Y0 = simplify(solve(fsu_y0,y)) 

%%
% compute inverse
q = simplify(x_X*y_Y == 1);

%q_r = subs(q,R2_y,R2_x/2); % independent of R2_y!
Y_invX = simplify(solve(q,Y))
symvar(Y_invX)
pretty(Y_invX)

q_r = subs(q,R2_x,R2_y); % we know this
X_invY = simplify(solve(q_r,X))
symvar(X_invY)
pretty(X_invY)

q0 = simplify(x_X*y_Y0 == 1);
q0_r = subs(q0,R2_x,R2_y); % we know this
X_invYf0 = simplify(solve(q0_r,X))
symvar(X_invYf0)
pretty(X_invYf0)

f_Y_invX = matlabFunction(Y_invX,'Vars',{N,R2_x,X});
f_X_invY = matlabFunction(X_invY,'Vars',{N,R2_y,Y});
f_X_invYf0 = matlabFunction(X_invYf0,'Vars',{N,R2_y,Y});

%%
latex(Y_invX)
latex(subs(X_invY,{R2_y,Y},{R2_x,X}))
latex(subs(X_invYf0,{R2_y,Y},{R2_x,X}))

%% test
%  2.125 98  --> 0.4704 (best 0.46875 vs 0.48438 as 30/31 with error  -0.0018, 0.0138, so smallest)
Nt = 8;
R2_xt = 2^2;
tt = @int8; 
ttn = @int32;
phi_xt = 10;

input_value = posit_x(Nt,R2_xt,phi_xt) % comples shall be 2.125
if abs(input_value) > 1
    f = f_Y_invX
    fs = Y_invX;
else
    f = f_X_invY
    fs = X_invY;
end

output_real = 1.0/input_value;
input_raw = tt(rposit_x(Nt,R2_xt,phi_xt));
[output_raw,output_value] = positencodeL(ev,output_real);
output_raw_dec = positdecode(double(output_raw),double(Nt))
output_raw_bin = dec2bin(double(output_raw),8)

output_estsym_raw = subs(Y_invX,{R2_x,X,N},{R2_xt,input_raw,Nt}) ;
output_estsym_bin = dec2bin(double(output_estsym_raw),8)
output_estsym_value = positdecode(tt(output_estsym_raw),Nt,0,1)
output_est_raw = f(ttn(Nt),ttn(R2_xt),ttn(input_raw));
output_est_value = positdecode(output_est_raw,Nt,0,1)

checkraw =[];
checkraw.est = output_est_raw;
checkraw.estsym = output_estsym_raw;
checkraw.opt = output_raw;

checkval =[];
checkval.est = output_est_value;
checkval.estsym = output_estsym_value;
checkval.opt = output_value;

checkraw
checkval

%% high
evp = ev(ev.raw >= 0 & isinf(ev.value)==0,:); % remove m,anually inf
N=8;
r =[];
t=@int8;
ttn = @int32;
% TODO: special case for raw(+-1) that is not 
for I=1:height(evp)
    s = [];    
    s.x_raw = evp.raw(I);
    s.x_val = evp.value(I);
    s.y_rea = 1.0/s.x_val;
    s.y_opt_raw = t(positencodeL(ev,s.y_rea));
    d = positdecode(s.y_opt_raw,N,0);
    s.y_opt_val = d.value; 
    s.x_powR = evp.powR(I);
    s.y_opt_powR = d.powR;
    s.x_frac = evp.frac(I);
    
    if (evp.raw(I)) == 0
        f = @(N,R,x) -(2^(N-2))*2; % 128
    elseif abs(evp.raw(I)) == 1
        f = @(N,R,x) x*(2^(N-1)-2);  % +-126
    elseif abs(evp.value(I)) >= 1
        f = f_Y_invX;
    else
        if evp.frac(I)==0
            f = f_X_invYf0;
        else
            f = f_X_invY;
        end
    end    
%    s.y_raw = t(f(ttn(N),ttn(evp.powR(I)),ttn(s.x_raw)));
    s.y_raw = t(f(double(N),double(evp.powR(I)),double(s.x_raw)));
    d = positdecode(s.y_raw,N,0,0);
    s.y_val = d.value;    
    s.y_powR = d.powR;
    s.dval = s.y_val-s.y_opt_val;
    s.draw = s.y_raw-s.y_opt_raw;
        r = [r; s];
end
r = struct2table(r)
r.dval(r.x_raw==0)= 0;
mean(r.dval)
mean(r.draw)
figure(1)
plot(r.x_raw,r.draw)
xlabel('x raw');
ylabel('diff raw');
figure(2)
plot(r.x_raw,r.dval)
xlabel('x raw');
ylabel('diff val');
