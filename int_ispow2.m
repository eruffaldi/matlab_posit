function y = int_ispow(x)

%  (v & (v - 1)) == 0;
y = bitand(x,x-1)==0;
