# PDFs and the basic models 

Ostap provides set of useful wrapper and helper  class that drastically simplify the construction and manipulations with `RooAbsPdf`-objects.

E.g. consider the simplest case - creation of the Gaussian PDF using the standard way the standard way:
```python
x     = ROOT.RooRealVar ('x'    ,'x'   ,2,3) 
mean  = ROOT.RooRealVar ('mean' ,'mean' ,3.100,3.080,3.120) 
sigma = ROOT.RooRealVar ('sigma','sigma',0.015,0.010,0.025) 
pdf   = ROOT.RooGaussian('Gauss','Gaussian', x , mean , sigma )
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
 2. One can use 2  or 3-element tuple  `(minval,maxval)`  or `(value, minval,maxval)` or plain single number. In this  case the variable of the type `RooRealVar` will be automatically created using this  specification
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
 - `minmax`   : mane the estimates for minimal and maximal values for the PDF.  For some models it is done analytically or semianalitycally, for remainnig models it is doen  using  random shoots. 
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

... 

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

## `2D` and `3D`-cases
For `2D` and `3D` cases there  are base classes `PDF2` and `PDF3` that in turn inhetic from `PDF` and gets all the nice functionality.
Of course several new method specific  for `2D` and `3D`-cases  are added and th ebehaviosu of some `1D`-specific methods is  fixed. 

