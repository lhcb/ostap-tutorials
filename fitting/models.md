# PDFs and the basic models 

Ostap provides set of useful wrapper and helper classes that drastically simplify the construction and manipulations with `RooAbsPdf`-objects. These models can be accessed through `Ostap.FitModels`. 

E.g. consider the simplest case - creation of the Gaussian PDF using the standard way the standard way:
```python
x     = ROOT.RooRealVar ('x'    ,'x'   ,2,3) 
mean  = ROOT.RooRealVar ('mean' ,'mean' ,3.100,3.080,3.120) 
sigma = ROOT.RooRealVar ('sigma','sigma',0.015,0.010,0.025) 
bare  = ROOT.RooGaussian('Gauss','Gaussian', x , mean , sigma ) ## <--- HERE
```
In Ostap it can be done in a bit simpler way 
```python
gauss = Gauss_pdf  ( 'Gauss' , 
      	              xvar  = ( 2 , 3 ) , 
                      mean  = ( 3.100 , 3.080 , 3.120 ) ,
                      sigma = ( 0.015 , 0.010 , 0.025 ) )
gauss.draw() ## and one can immediately visualize the model 
```
{% discussion "How  to define parameter?" %}
There are may ways to define parameter
  1.  One can use the existing `RooAbsReal` object, e.g. `RooRealVar` or `RooConstVar`: 
```python
mean  = ROOT.RooRealVar ('mean' ,'mean' ,3.100,3.080,3.120) 
gauss = Gauss_pdf  ( 'Gauss' , 
      	              xvar  = ( 2 , 3 ) , 
                      mean  = mean , ## <--- HERE 
                      sigma = ( 0.015 , 0.010 , 0.025 ) )
```
  2. One can use the plain number `value`, 2- or 3-element tuple `(minval,maxval)`  or `(value, minval,maxval)`. In this  case the variable of the type `RooRealVar` will be automatically created using this specification. (In case of the plain number, the corresponding parameter will  be fixed in the fit).
```python
gauss = Gauss_pdf  ( 'Gauss' , 
      	              xvar  = ( 2 , 3 ) ,                 ## <-- HERE 
                      mean  = ( 3.100 , 3.080 , 3.120 ) , ## <-- HERE 
                      sigma =   0.015 )                   ## <-- HERE 
```
{% enddiscussion %}
For all models, all known parameter are  accessible (and documented)  as python _property_
```python
gauss = ...
help(gauss.xvar)
print gauss.sigma 
help(gauss.mean)
```

There are many predefined models, accesible  via `Ostap.FitModels` module:
```python
import Ostap.FitModels as Models
help(Models)
```

## Base class `PDF`
All  Ostap-based fit models and PDFs  (directy or indirectly) inherit from python base class `PDF`, that provides great additional functionality, 
in particular  the methods `fitTo` and `draw` that simplfy the fitting procedure itself and visualzation of the results:

### The method `fitTo`
```python
gauss   = Gauss_pdf ( ... ) 
dataset = ....
result , frame = gauss.fitTo ( dataset , silent = True , reFit = 2 ) 
print 'FitResults: %s' % result 
```
All the native `RooFit` _commands_ can be specified as optional arguments, as well as many commands specific for Ostap, 
e.g. `reFit=2` above means _in case of fit failure, try to refit it (up to 2 times)_, and the meaning of  `silent=True` is obvious.

### The method `draw` 
```python
gauss   = Gauss_pdf ( ... ) 
dataset = ....
result , frame = gauss.fitTo ( dataset , silent = True , reFit = 2 ) 
print 'FitResults: %s' % result 
frame = gauss.draw ( dataset , nbins = 100 ) 
```

_Fitting_  and _vizualisation_  can be combined:
```python
gauss   = Gauss_pdf ( ... ) 
dataset = ....
result , frame = gauss.fitTo ( dataset , draw  = True , nbins = 100 ) ## draw it after the fit 
```

### Access to the underlying `RooAbsPdf` object 

The access to the underlying bare `RooAbsPdf`-object can be done (if needed) via the propety `pdf` 
```python
gauss = Gauss_pdf ( ... ) 
root_pdf  = gauss.pdf 
```

### _Other methods_

`PDF` class is equipped with many other useful methods: 
  - `fitHisto`: The method `fitTo` can be _blindly_ applied not only to `RooDataSet`-objects, but also to the histograms:
```python
histo = ...
r, f   = gauss.fitTo ( histo , draw = True ) 
```
However the dedicated method `fitHisto` sometimes could be more usefu 
```python
histo = ...
gauss.fitHisto ( histo , draw = True ) 
```
  - `draw_nll`: vizualize  NLL-scans and LL-profiles 
```python
r , f = gauss.fitTo ( dataset , draw = False )
nll     , f1 = gauss.draw_nll ( 'sigma' ,  dataset )                  ## NLL
profile , f2 = gauss.draw_nll ( 'sigma' ,  dataset , profile = True ) ## PROFILE 
```
 - `generate` : tiny but useful wrapper for `RooAbsPdf::generate`
 - `minmax`   : make the estimates for the minimal and maximal values for the PDF.  For some models it is done analytically or semianalitycally, for remainig models it is done using  random shoots. 
```python
mn,mx = gauss.minmax( 500000 ) 
```
 - `__call__` : it  allows to use `PDF` as simple _function_
```python
gauss = ...
print gauss( 3.090 ), gauss( 3.100 ), gauss( 3.110 )
```  
 - Several _statistical_   functions. For some models analytical orsemianalitycal calculations are used, for  remnig models numerical estimations are performed using `scipy` 
    * `rms`            :   _rms_ for  the distribution 
    * `fwhm`           :  _full width  at half maximum_  
    * `fwhm`           :  _full width  at half maximum_  
    * `moment`         :  the _moment_ of the distribution   
    * `central_moment` :  the _central moment_ of the distribution   
    * `skewness`   : _skewness_ for the  distribution 
    * `kurtosis`   : _kurtosis_ for the  distribution 
    * `mode`       : the _mode_ for the distribution 
    * `median`     : _median_ value for the distribution
    * `get_mean`   : _mean_ value for the distribution
    * `cl_symm`    : _symmetric confidence interval_ 
    * `cl_asymm`   : _asymmetric confidence interval_ 
    * `quantile`   : _quantile_ value for the distribution 
    * `integral`   : _integral_ for the distribution 
    * `derivative` : _derivative_ of the PDF at the given point

### Convolution 

Ostap  provides helper class that  simplify construction of fit models taking into accotun  resolution functions:
```python
pdf = ...
cnv_pdf = Convolution_pdf ( 'Cnv            ' , 
                             pdf = pdf        , 
                             resolution = ... )
```
As `resolution` one can specify 
  1.  Any resolutuon model (`RooAbsPdf`)
  2.  simple number `s`, in this case the  gaussian resolution model with sigma = `s` will be used 
  3.  Any `RooAbsReal` objetct, it will be used as sigma for gaussian resoltuion model

There are  several optional flags 
  -  `useFFT=True`  : use _Fast-Fourier-Transform_ or plain numerical convolution ?
  -  `nbins=100000` : sampling for _Fast-Fourier-Transform_
  -  `buffer=0.25`  : buffer size for _Fast-Fourier-Transform_, argument for `setBufferFraction` call
  -  `nsigmas=6`    : window size for plain numeric convolution, the argument  for `setConvolutionWindow` call

## Generic Wrapper  _Generic1D_pdf_ 
 
The bare `RooAbsPdf` could be easily converted to Ostap-form using the generic wrapper `Generic1D_pdf`:
```python
bare = ROOT.RooGaussian('Gauss','Gaussian', x , mean , sigma )
gauss = Generic1D_pdf ( pdf = bare , xvar = x ) 
gauss.draw() ## one can immediately use the full power of Ostap-PDF
```
In a similar way there are generic wrappers for `2D` and `3D`-models:
```python
bare2D = ... 
bare3D = ... 
ostap_2d =  Generic2D_pdf ( pdf = bare2D , xvar = x ,  xvar = y ) 
ostap_3d =  Generic2D_pdf ( pdf = bare3D , xvar = x ,  xvar = y , zvar = z ) 
```

## `1D`-models

There are many predefined models, accessible  via `Ostap.FitModels` module:
```python
import Ostap.FitModels as Models
help(Models)
```

### _Generic backrgound models_ 

#### _Polynomial models_ 

Here the list of the most useful polynomial models:
  - `PolyPos_pdf`  : positive (non-negative) polynomial 
  - `PolyEven_pdf` : positibe (non-negative) _symmetric_ polynomial:  `p(x)= p(2*x0-x)`, where `x0=0.5*(xmin+xmax)` 
  - `Monotonic_pdf` : positive (non-negative) polynomial with fixed sign of the first derivative: posynomial either non-decreasing or non-increasing
  - `Convex_pdf` : positive (non-negative) polynomial with fixed signs of the first (non-decreasing or non-increasing) and second (convex or concave) derivatives
  - `ConvexOnly_pdf` : positive (non-negative) polynomial with fixed sign of the second (convex or concave) derivative
  
#### _Phasespace-based models_ 

Here the list of the most useful phasespace-based models:
  - `PS2_pdf`       : 2-body phase space (no parameters)
  - `PSLeft_pdf`    : Low  edge of N-body phase space 
  - `PSRight_pdf`   : High edge of L-body phase space from N-body decays  
  - `PSNL_pdf`      : approximation for L-body phase space from N-body decays  
  - `PS23L_pdf`     : 2-body phase space from 3-body decays with orbital momenta
  
#### _Polynomial-based models_ 

  - `Bkg_pdf`      : The  exponential function, modulated by the positive polynomial. In practice it is the most useful function to describe the combinatorial background
  - `PSPol_pdf`    :  L-body phase space from N-body decays modulated by a positive polynomial  
  - `Sigmoid_pdf`  : sigmoid function (`atanh`) modulated by the positive polynomial 
  - `TwoExpoPoly_pdf` : difference of two exponents, modulated by the positive polynomial

#### _Spline-based models_ 

The models, based on _B-splines_ : 
  - `PSpline_pdf`      : positive (non-negative)  spline 
  - `MSpline_pdf`      : positive (non-negative) monothonic (non-decreasing or non-increasing) spline 
  - `CSpline_pdf`      : positive (non-negative) monothonic (non-decreasing or non-inclreasing) convex or concave spline 
  - `CPSpline_pdf`     : positive (non-negative) convex or concave spline 

### _Generic signal models_ 

The signal-like models (peaks):
 
    'Gauss_pdf'              , ## simple     Gauss
    'CrystalBall_pdf'        , ## Crystal-ball function
    'CrystalBallRS_pdf'      , ## right-side Crystal-ball function
    'CB2_pdf'                , ## double-sided Crystal Ball function    
    'Needham_pdf'            , ## Needham function for J/psi or Y fits 
    'Apolonios_pdf'          , ## Apolonios function         
    'Apolonios2_pdf'         , ## Apolonios function         
    'BifurcatedGauss_pdf'    , ## bifurcated Gauss
    'DoubleGauss_pdf'        , ## double Gauss
    'GenGaussV1_pdf'         , ## generalized normal v1  
    'GenGaussV2_pdf'         , ## generalized normal v2 
    'SkewGauss_pdf'          , ## skewed gaussian (temporarily removed)
    'Bukin_pdf'              , ## generic Bukin PDF: skewed gaussian with exponential tails
    'StudentT_pdf'           , ## Student-T function 
    'BifurcatedStudentT_pdf' , ## bifurcated Student-T function
    'SinhAsinh_pdf'          , ## "Sinh-arcsinh distributions". Biometrika 96 (4): 761
    'JohnsonSU_pdf'          , ## JonhsonSU-distribution 
    'Atlas_pdf'              , ## modified gaussian with exponenital tails 
    'Slash_pdf'              , ## symmetric peakk wot very heavy tails 
    'RaisingCosine_pdf'      , ## Raising  Cosine distribution
    'QGaussian_pdf'          , ## Q-gaussian distribution
    'AsymmetricLaplace_pdf'  , ## asymmetric laplace 
    'Sech_pdf'               , ## hyperboilic secant  (inverse-cosh) 
    'Logistic_pdf'           , ## Logistic aka "sech-squared"   
    #
    ## pdfs for "wide" peaks, to be used with care - phase space corrections are large!
    # 
    'BreitWigner_pdf'      , ## (relativistic) 2-body Breit-Wigner
    'Flatte_pdf'           , ## Flatte-function  (pipi)
    'Flatte2_pdf'          , ## Flatte-function  (KK) 
    'LASS_pdf'             , ## kappa-pole
    'Bugg_pdf'             , ## sigma-pole
    'Swanson_pdf'          , ## Swanson's S-wave cusp 
    ##
    'Voigt_pdf'            , ## Voigt-profile
    'PseudoVoigt_pdf'      , ## PseudoVoigt-profile
    'BW23L_pdf'            , ## BW23L
 
 
## `2D` and `3D`-cases
For `2D` and `3D` cases there  are base classes `PDF2` and `PDF3` that in turn inhetic from `PDF` and gets all the nice functionality.
Of course several new method specific  for `2D` and `3D`-cases  are added and th ebehaviosu of some `1D`-specific methods is  fixed. 

