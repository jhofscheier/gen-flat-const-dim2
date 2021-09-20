# Generalised Flatness Constants in Dimension 2

Scripts for the paper "Generalised Flatness Constants: A Framework Applied in Dimension 2" (written with Giulia Codenotti and Thomas Hall). The code is written in [polymake](https://polymake.org/doku.php), [MAGMA](http://magma.maths.usyd.edu.au/magma/) (Magma Computational Algebra System), and [python](https://www.python.org).

Content | Description
------- | -----------
gen_flat_dim1.m | MAGMA script to compute generalised flatness constants of closed intervals [x,y] in 1 dimensions 
R_X_free.m | MAGMA script to check the inclusion-maximal &#8477;-&#916;&#x2082;-free examples from Section 5.1 in the paper
Z_Delta2_triangles | folder with python and polymake scripts computing the maximal width of triangles circumscribed around the four polygons from Table 1 in the paper. PDF files provide further details about the mathematical steps involved.

## Setup
Before running the python scripts in the folder `Z_Delta2_triangles` install the dependencies. Note: You may optionally wish to create a [python virtual environment](https://docs.python.org/3/tutorial/venv.html) to prevent conflicts with your system's python environment. Run the following command in the folder `Z_Delta2_triangles`:
```bash
python3 -m pip install -e .
```

## Folder: Z_Delta2_triangles

The scripts are organised in four subfolders `case01`,&#8230;, `case04` corresponding to the four cases in Table 1 in the paper. Preferably the polymake scripts `case_0x.pl` are run within the respective `case0x` folder since `triangle_code.pl` (located in the parent folder) is loaded using relative paths. The polymake scripts output [WolframAlpha](https://www.wolframalpha.com) code that can be piped through. WolframAlpha then computes the inverse of the maximal widths of circumscribed triangles together with the maximisers. (WolframAlpha's optimisers seem to handle minimas better than maximas in this case; therefore we compute the inverse of the maximum.)

The python scripts `case0x.py` are used for auxilliary computations such as explicit computation of widths along certain directions or the vertices of the maximising triangles.

We refer to the PDF files in the respective subfolders for further information about what computations each script exactly performs and further details on the mathematics.
