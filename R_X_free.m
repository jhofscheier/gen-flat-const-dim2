// returns true if polygon P is R-Delta_2-free
// if not it also returns tuples (S, P \div S) where S is a Z-unimodular copy
// of Delta_2 in Int(P+[0,1]^2) and P \div S = { x in R^2 | S+x \subset P }
function IsRDelta2Free(P)
    VerticesOfP := Vertices(P);
    Delta2Copies := [];
    // since we are only interested in 2-dim parllel bodies P \div S, it
    // suffices to consider the interior lattice points of P+[0,1]^2
    for V in Subsets(InteriorPoints(P + BoxPolytope(2)), 3) do
        Verts := SetToSequence(V);
        if Abs(Determinant(Matrix([x-Verts[1] : x in Verts[2..#Verts]]))) eq 1 then
            tranV := &meet [P-x : x in Verts];
            if Dimension(tranV) eq 2 then
                Append(~Delta2Copies, <V, Vertices(tranV)>);
            end if;
        end if;
    end for;
    return <Delta2Copies eq [], Delta2Copies>;
end function;

// cross-polytope
printf "cross-polytope is R-Delta_2-free:\t%o\n\n",
                        IsRDelta2Free(Polytope([[1,0],[0,1],[-1,0],[0,-1]]));

// reflexive simplex
printf "reflexive simplex is R-Delta_2_free:\t%o\n\n",
                                IsRDelta2Free(Polytope([[-1,-1],[1,0],[0,1]]));

// examples from Figure 18
P1 := Polytope([
    [-21/100,11/100],
    [46/100,98/100],
    [142/100,102/100],
    [82/100,-42/100]
]);

P2 := Polytope([
    [0,70/100],
    [0,125/100],
    [40/100,145/100],
    [137/100,72/100],
    [120/100,-5/100],
    [60/100,10/100]
]);

printf "left example in Figure 18 is R-Delta_2-free:\t%o\n\n", IsRDelta2Free(P1);
printf "right example in Figure 18 is R-Delta_2-free:\t%o\n\n", IsRDelta2Free(P2);