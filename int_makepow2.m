function q = int_makepow2(q)

    q = q - 1;
if isa(q,'int8')
q = bitor(q,bitshift(q,-1));
	q = bitor(q,bitshift(q,-2));
	q = bitor(q,bitshift(q,-4));
elseif isa(q,'int16')
	q = bitor(q,bitshift(q,-1));
	q = bitor(q,bitshift(q,-2));
	q = bitor(q,bitshift(q,-4));
	q = bitor(q,bitshift(q,-8));
elseif isa(q,'int32')
	q = bitor(q,bitshift(q,-1));
	q = bitor(q,bitshift(q,-2));
	q = bitor(q,bitshift(q,-4));
	q = bitor(q,bitshift(q,-8));
	q = bitor(q,bitshift(q,-16));
elseif isa(q,'int64')
	q = bitor(q,bitshift(q,-1));
	q = bitor(q,bitshift(q,-2));
	q = bitor(q,bitshift(q,-4));
	q = bitor(q,bitshift(q,-8));
	q = bitor(q,bitshift(q,-16));
	q = bitor(q,bitshift (q,-32));
end
	q = q + 1;
