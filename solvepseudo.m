syms N R_x phi_x x F_x real

R_y=1;
F_x=N-R_x-2; 
F_y = F_x+R_x;
% [0,rho,0,phi_x] with rho=1[R_x] and phi_x is of F_x bits
% pseudo sig
% [0,0,1,phi_y] with R_y=1  and phi_y_e = 1[R_x] 0 phi_x of F_x+R_x+1 bits
% that is F_y_e = N-1
% effective F_y=N-R_y-2=N-3 
% so we need to remove 2 bit
phi_y_e = phi_x + 2^(F_x)*(2^R_x-2); %
phi_y=phi_y_e/4;
posit_x_inv = @(N,R_x,phi_x) 2^(-R_x)*(1+phi_x*2^-(N-R_x-2));
posit_x = @(N,R_x,phi_x) 2^(R_x-1)*(1+phi_x*2^-(N-R_x-2));
y = posit_x_inv(N,R_y,phi_y);
f = x == posit_x(N,R_x,phi_x);
phi_x_s = solve(f,phi_x);

y1 = collect(simplify(subs(y,phi_x,phi_x_s)),x);
latex(y1)

x_one = posit_x(N,1,0) % 01000000 ==> 00100000 0.5
y_one = subs(y1,{x,R_x},{1,1})

x_two = posit_x(N,2,0) % 01100000 ==> 00110000 ?
y_two = subs(y1,{x,R_x},{2,2})
x_four = posit_x(N,3,0) % 011100000 ==> 001110000 ?
y_four = subs(y1,{x,R_x},{4,3})
x_max = posit_x(N,N-1,0); % 01111111 ==> 00111111
y_max = simplify(subs(y1,{x,R_x},{2^(N-2),N-1}))

y2 = simplify(subs(y1,x,2^R_x))
pretty(y2)
ezplot(y2)
%%
% Then for original x negative

phi_y_e = phi_x + 2^(F_x); %
phi_y=phi_y_e/4;
y = posit_x_inv(N,R_y,phi_y);
f = x == posit_x_inv(N,R_x,phi_x);
phi_x_s = solve(f,phi_x);

y1 = collect(simplify(subs(y,phi_x,phi_x_s)),x);
latex(y1)

x_one = posit_x(N,1,0) % 01000000 ==> 00100000 0.5
y_one = subs(y1,{x,R_x},{1,1})

x_half = posit_x_inv(N,1,0) % 01100000 ==> 00110000 ?
y_half = subs(y1,{x,R_x},{0.5,1})


%%
syms q q0 real
qq=taylor(1/(1+exp(-q)),q,q0)
ezplot(qq)
% q^5 = exp(5 log(x))