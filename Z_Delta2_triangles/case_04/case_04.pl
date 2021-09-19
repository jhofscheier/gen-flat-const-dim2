# Generalised flatness constants: a framework applied in dimension 2
# Giulia Codenotti, Thomas Hall, and Johannes Hofscheier
######################################################################
# polymake script to reproduce the computations of case 1 of Table 1
# of inclusion maximal \Z-\Delta_2-free triangles.
##########
# The output of this script is meant to be fed into Mathematica which
# will determine the maximal width and the parameters where the
# extremum is achieved.
######################################################################
# Author: Johannes Hofscheier

script("../triangle_code.pl");

#switch to the tropical framework
application "tropical";

$H = new Hypersurface<Min>(POLYNOMIAL=>
     toTropicalPolynomial("min(2*x1)", "x0", "x1", "x2", "x3"));

#switch to polytope framework
application "polytope";

$Q = new Polytope<Rational>(INEQUALITIES=>[
    [  0,  1,  0,  0],
    [  1, -1,  0,  0],
    [  0,  0,  1,  0],
    [  1,  0, -1,  0],
    [  0,  0,  0,  1],
    [  1,  0,  0, -1], # until here inequalities for unit cube [0,1]^3
    [ -1,  1,  1,  0],
    [ -1,  1,  0,  1],
    [  5, -5, -4,  0],
    [  1,  3,  0, -1],
    [ -4,  0,  4,  1]]);

width_of_triangle($H, $Q);