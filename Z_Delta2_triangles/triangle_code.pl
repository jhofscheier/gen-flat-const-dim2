#################################################################
#----------------------------------------------------------------
# polymake code to compute the maximal widths of circumscribed tirangles
#----------------------------------------------------------------
# Author: Johannes Hofscheier
#----------------------------------------------------------------
#################################################################

use strict;

#################################################################
#----------------------------------------------------------------
# helper subroutines
#----------------------------------------------------------------

# Custom zip function.
# @param array reference $this_ref to this array
# @param array reference $other_ref to other array
# @return array of pairs (el of this array, el of other array)
#               dies if the length of the two arrays are different.
sub zip {
    my ($this_ref, $other_ref) = @_;

    die "Arrays must have equal length" if @$this_ref != @$other_ref;

    my $i = 0;
    return map { [ $this_ref->[ $i++], $_ ] } @$other_ref;
}

# Returns the string of the linear term determined by the arguments.
# @param Int $coeff the coefficient of the linear term
# @param String $variable name of the variable
# @return the linear term "[$coeff*$variable]"
#         takes care of special cases like coefficient is -1, 0, or 1.
#         positive coefficients get a preceeding "+".
sub to_term {
    my ($coeff, $variable) = @_;

    if($coeff > 0) {
        if($coeff == 1) {
            return '+'.$variable;
        } else {
            return '+'.convert_to<String>($coeff).'*'.$variable;
        }
    } elsif($coeff < 0) {
        if($coeff == -1) {
            return '-'.$variable;
        }
        return convert_to<String>($coeff).'*'.$variable;
    }
    return '';
}

# Joins list of terms represented by strings. Takes care of leading "+"
# @param Array<String> @terms array of terms represented as strings
# @return the expression represented by the terms in @terms removes leading "+"
sub join_terms {
    my @terms = @_;
    my $res_str = join('', @terms);
    if(substr($res_str,0,1) eq "+") {
        $res_str = substr($res_str, 1);
    }
    return $res_str;
}

# Returns string representing the linear form given by $vec and $var_names.
# @param Array<Int> $vec 3-dimensional array with coefficients of the
#                   linear form
# @param Array<String> $var_names 3-dimensional array with the variables names
#                      (default=['x', 'y', 'z'])
# @return string representing the linear form given by coefficient vector $vec.
sub lin_form {
    my $vec = shift;
    my $var_names = shift || ['x', 'y', 'z'];
    my @monomial_strs = map {to_term($_->[0], $_->[1])} zip($vec, $var_names);
    return join_terms(grep {$_ ne ""} @monomial_strs);
}

# Returns string representing the affine linear form given by
# $vec and $var_names.
# @param Array<Int> $vec 4-dimensional array containing the constant term
#                   (0th entry) and linear coefficients
# @param Array<String> $var_names 3-dimensional array the variable names
# @return the string representing the affine linear form given by $vec.
sub aff_lin_form {
    my $vec = shift;
    my $var_names = shift || ['x', 'y', 'z'];

    if($vec->[0]==0) {
        return lin_form($vec->slice([1,2,3]), $var_names);
    }

    my $res_str = convert_to<String>($vec->[0]);
    my @monomial_strs = map {to_term($_->[0], $_->[1])}
                                          zip($vec->slice([1,2,3]), $var_names);
    return $res_str.join('', @monomial_strs);
}

# Returns string of linear (in)equality given by the vector $vec
# @param Array<Int> $vec 4-dimensional array representing the (inequality)
#                   of the form
#                   $vec->[1]*x + $vec->[2]*y + $vec->[3]*z >=//= $vec->[0]
# @param Boolean (0 or 1) $is_eq indicating whether equality or inequality
# @return string representation of inequality given by $vec
sub expr_from_vec {
    my ($vec, $is_eq) = @_;
    return lin_form($vec->slice([1,2,3])).(($is_eq==1)?"=":">=").(-$vec->[0]);
}

# Computes the value of the affine linear form given by $coeff at $vec.
# @param Array<Rational> $vec 3-dimensional vector at which we want to
#                        evaluate the affine linear form
# @param Array<Int> $coeff 4-dimensional vector representing an
#                   affine linear form, namely if $vec == (d, a, b, c),
#                   then affine linear form is d + a*x + b*y + c*z
# @return the value of the affine linear form given by $coeff at $vec.
sub f {
    my ($vec, $coeff) = @_;
    my $sum = 0;
    map {$sum += $_ } ($coeff->[0], map {$_->[0]*$_->[1]}
                                                  zip($vec,[@{$coeff}[1,2,3]]));
    return $sum;
}

#----------------------------------------------------------------
#################################################################

# Returns expressions for widths with respect to directions given by tropical
# hyperplane $H of triangles given by parameter polytope $Q.
# @param $H
# @param $Q
# @return expressions of widths with respect to directions induced by $H of
# triangles determined by $Q.
sub width_of_triangle {
    my ($H, $Q) = @_;

    #switch to the tropical framework
    application "tropical";

    # tdehomog only available in application "tropiccal"
    # therefore compute hypersurface data here
    $H_vertices = Polymake::tropical::tdehomog($H->VERTICES);
    $H_lineality_space = Polymake::tropical::tdehomog($H->LINEALITY_SPACE);

    $fct_vecs  = new Vector<Rational>($H->COEFFICIENTS)
                      | new Matrix<Rational>($H->MONOMIALS->minor(All,[1,2,3]));

    #switch to polytope framework
    application "polytope";

    foreach my $cone (@{$H->REGIONS}) {
        $C = new Polytope<Rational>(POINTS=>$H_vertices->minor($cone,All),
                                           INPUT_LINEALITY=>$H_lineality_space);
        $curr_region = intersection($C,$Q);

        # a region could be empty
        if($curr_region->DIM>-1){
            @fct_vals = map {f($curr_region->VERTEX_BARYCENTER->slice([1,2,3]),
                                                              $_)} @{$fct_vecs};
            @min_ind = grep $fct_vals[$_] == minimum(\@fct_vals), 0..$#fct_vals;

            # regions is positive-dimensional
            if($curr_region->DIM>0){
                my $MathematicaCommand = "minimize (x*y*z + (1-x)*(1-y)*(1-z))/("
                              .aff_lin_form($fct_vecs->[$min_ind[0]]) . ") on ";
                @exprs = map {expr_from_vec($_, 0)} @{$curr_region->FACETS};
                push(@exprs, map {expr_from_vec($_,1)}
                                                  @{$curr_region->AFFINE_HULL});

                $MathematicaCommand .= join( ', ', @exprs);
                print $MathematicaCommand, "\n\n";
            }
            # region is just a point
            else{
                my $MathematicaCommand = "f(x,y,z)="
                .aff_lin_form($fct_vecs->[$min_ind[0]])." where (x,y,z)=("
                .join(",", map {convert_to<String>($_)}
                            @{$curr_region->VERTICES->[0]->slice([1,2,3])}).")";
                print $MathematicaCommand, "\n\n";
            }
        }
    }
}
