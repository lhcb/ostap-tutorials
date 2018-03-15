# _Generic backrgound models_ 

Here is incomplete list of _background-like_ models - the models that often could be used to describe the background distribution

## _Polynomial models_ 

Here the list of the most useful polynomial models:
  - `PolyPos_pdf`  : positive (non-negative) polynomial 
  - `PolyEven_pdf` : positibe (non-negative) _symmetric_ polynomial:  `p(x)= p(2*x0-x)`, where `x0=0.5*(xmin+xmax)` 
  - `Monotonic_pdf` : positive (non-negative) polynomial with fixed sign of the first derivative: posynomial either non-decreasing or non-increasing
  - `Convex_pdf` : positive (non-negative) polynomial with fixed signs of the first (non-decreasing or non-increasing) and second (convex or concave) derivatives
  - `ConvexOnly_pdf` : positive (non-negative) polynomial with fixed sign of the second (convex or concave) derivative
  
## _Phasespace-based models_ 

Here the list of the most useful phasespace-based models:
  - `PS2_pdf`       : 2-body phase space (no parameters)
  - `PSLeft_pdf`    : Low  edge of N-body phase space 
  - `PSRight_pdf`   : High edge of L-body phase space from N-body decays  
  - `PSNL_pdf`      : approximation for L-body phase space from N-body decays  
  - `PS23L_pdf`     : 2-body phase space from 3-body decays with orbital momenta
  
## _Polynomial-based models_ 

  - `Bkg_pdf`      : The  exponential function, modulated by the positive polynomial. In practice it is the most useful function to describe the combinatorial background
  - `PSPol_pdf`    :  L-body phase space from N-body decays modulated by a positive polynomial  
  - `Sigmoid_pdf`  : sigmoid function (`atanh`) modulated by the positive polynomial 
  - `TwoExpoPoly_pdf` : difference of two exponents, modulated by the positive polynomial

## _Spline-based models_ 

The models, based on _B-splines_ : 
  - `PSpline_pdf`      : positive (non-negative)  spline 
  - `MSpline_pdf`      : positive (non-negative) monothonic (non-decreasing or non-increasing) spline 
  - `CSpline_pdf`      : positive (non-negative) monothonic (non-decreasing or non-inclreasing) convex or concave spline 
  - `CPSpline_pdf`     : positive (non-negative) convex or concave spline 

