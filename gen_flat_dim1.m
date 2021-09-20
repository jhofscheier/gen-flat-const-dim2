
///
// returns the Z-generalised flatness constant of the closed interval [x,y]
// in 1 dimensions (see Theorem 3.1 in the paper for further details)
///
function GenFlt1Z(x, y)
    // make sure x<=y
    assert x le y;

	delta := Floor(x) + Ceiling(y);
	if (Ceiling(x)-x) ge (y-Floor(y)) then
		return Maximum({delta-2*x, 1+2*y-delta});
	end if;
	return Maximum({2*y-delta, 1+delta-2*x});
end function;

// verify that GenFlt1Z is not linear, i.e., in general
// GenFlt1Z(k*[x,y]) != k*GenFlt1Z([x,y])
GenFlt1Z(0,2/3);
GenFlt1Z(0,4/3);
