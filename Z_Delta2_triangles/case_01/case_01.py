"""Generalised flatness constants: a framework applied in dimension 2
   Giulia Codenotti, Thomas Hall, and Johannes Hofscheier

   This code can be used to reproduce the computations of case 1 of
   Table 1 of inclusion-maximal \Z-\Delta_2-free triangles.
"""
# Author: Johannes Hofscheier.


import sympy as sp
from pretty_concat import join_pretty


l, m, n = sp.symbols('\u03BB \u03BC \u03BD')

# Locking points
A = sp.Point2D([1, 1])
B = sp.Point2D([0, -1])
C = sp.Point2D([0, 1])

delta = l*m*n+(1-l)*(1-m)*(1-n)
M = 1/delta*sp.Matrix([[-m*(1-n), (1-l)*(1-n), l*m],
                       [m*n, -(1-l)*n, (1-l)*(1-m)],
                       [(1-m)*(1-n), l*n, -l*(1-m)]])

# 3x2 - matrix whose rows consist of the points X, Y, Z
v = M*sp.Matrix([list(A), list(B), list(C)])

X = sp.Point2D([v[0, 0], v[0, 1]])
Y = sp.Point2D(v[1, 0], v[1, 1])
Z = sp.Point2D(v[2, 0], v[2, 1])

# the slopes
m_XY = sp.simplify((X-Y)[1]/(X-Y)[0])
m_YZ = sp.simplify((Y-Z)[1]/(Y-Z)[0])
m_ZX = sp.simplify((Z-X)[1]/(Z-X)[0])

print(join_pretty(["m_XY = ", sp.pretty(m_XY)])+"\n")
print(join_pretty(["m_YZ = ", sp.pretty(m_YZ)])+"\n")
print(join_pretty(["m_ZX = ", sp.pretty(m_ZX)])+"\n")


print(join_pretty(["width_{e_1^*}(P) = ", sp.pretty((Z-X)[0])])+"\n")
print(join_pretty(["width_{e_2^*}(P) = ", sp.pretty((Y-X)[1])]) + "\n")
print(join_pretty(["width_{e_1^*-e_2^*}(P) = ",
                   sp.pretty(sp.simplify((Z-Y)[0]-(Z-Y)[1]))])+"\n")

# using polymake and Mathematica we get:
# max_width = 10/3
# parameters (l,m,n)=(3/5,2/5,1/5)
X = X.subs({l: 3/5, m: 2/5, n: 1/5})
Y = Y.subs({l: 3/5, m: 2/5, n: 1/5})
Z = Z.subs({l: 3/5, m: 2/5, n: 1/5})

print(join_pretty(["Vertices = ", sp.pretty(
    sp.Matrix([[X[0], Y[0], Z[0]], [X[1], Y[1], Z[1]]]))]))
