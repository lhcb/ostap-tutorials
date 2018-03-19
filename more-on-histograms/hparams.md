# _Histogram parameterization_ 

Often one needs to parameterize the historgam in terms of some predefined function or expansion - e.g. parameterize the efficiency.  
Ostap offers a wide range of embedded parameterization 
 - in terms of _Bernstein polynomials_ 
   - simple _Bernstein sum_, aka _Bezier sum_ 
   - _even Bernstein sum_, such as `f(x)=f(2*x0-x)`,  where `x0=0.5*(xmin+xmax)` 
   - non-negative  _Bernstein sum_
   - non-negative monothonic _Bernstein sum_ 
   - non-negative monothonic convex or concave _Bernstein sum_ 
   - non-negative convex or concave _Bernstein sum_ 
 - in term of _Legendre polynomials_ 
 - in term of _Chebyshev polynomials_ 
 - in terms of _Fourier series_ 
 - in terms of _Fourier cosine series_ 
 - in terms of _Basic splines_
   - non-negative _B-spline_ 
   - non-negative monothonic _B-spline_ 
   - non-negative monothonic convex or concave _B-spline_ 
   - non-negative convex or concave _B-spline_ 

From technical side, there are three branches of methods 
  - methods that uses only histogram values: 
    - these are safe, robust but they ignore the uncertainties 
  - methods that relies on `ROOT.THF1.Fit`
    - typically not very  good CPU performance 
    - sometimes fragile  
  - methods that relies on `RooFit`
    - often the best series of methods 

## _Simple  parameterization_ 

This group of methods allows to make easy and robust  histogram parameterization, ignooring histogram unncertainties
```python
histo  = ...
b1 = histo.bernstein_sum     (  6 ) ## parameterize as degree-6 Bernstein sum
b2 = histo.bernsteineven_sum (  6 ) ## parameterize as degree-6 Bernstein "even"-sum
l  = histo.legendre_sum      (  6 ) ## parameterize as degree-6 Legendre sum
ch = histo.chebyshev_sum     (  6 ) ## parameterize as degree-6 Chebyshev sum
f  = histo.fourier_sum       ( 12 ) ## parameterize as order-12 Fourier sum
c  = histo.cosine_sum        ( 12 ) ## parameterize as order-12 Fourier Cosine sum
```

##  `ROOT.TH1.Fit`-_based parameterizations_




