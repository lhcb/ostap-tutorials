# Compound fit models 

## `1D`-case 
Ostap offers a very easy way to build the compound fit models from the individual components. E.g.the case of  the trivial fit model that consists of one signal and one background components:
```python
signal      = ... 
background  = ...
model    = Fit1D ( signal = signal , background = backround ) ## <-- HERE! 
dataset  = ...
result , frame = model.fitTo ( dataset , draw = True ) ## fit and vizualize  
```
The  fit model can contains several _signal_ and _backround_ components, and also _other_ components :
```python'
model    = Fit1D ( signal = signal ,
                   background       = backround , 
                   othersignals     = [ ... ]   , 
                   otherbackgrounds = [ ... ]   , 
                   others           = [ ... ]   ) 
```
In this case several _signal_, _backgrounds_ and/or _others_ components can be combined into single _signal_, 
_backround_ and/or _others_ components:
```python'
model    = Fit1D ( combine_signals     = True , 
                   combine_backgrounds = True , 
                   combine_others      = True , ... ) 
```
In practice it is very convinients approach is several signal/background/other componens are specified. 


On default _extended_ `RooAddPdf' fit model is created, however ,  one can force _non-extended_ model:
```python
model    = Fit1D ( extended = False , ... ) 
```
In this case one can also instruct the class `Fit1D` to create _recursive_ (default)  or _non-recursive_ fit fractions:
```python
model    = Fit1D ( extended = False , recursive = False , ... ) 
```


All components (_signal/background/others_)  can be specified as Ostap-based models. Also one can provide them in a form of bare `RooAbsPdf`, but for this case one needs to provide also `xvar`-variable
```python
mass  = ROOT.RooRealVar('mass','mass',2,3)
gauss = ROOT.RooGaussian( 'Gauss', 'Gauss', mass , ... )
model = Fit1D( signal = gauss , xvar = mass , ... )  
```
For  _background_ components there is also an alternative way to specify it: 
  - `None` : `RooPolynomial` of zero degree (uniform distribution) will be created and used as _background_ component
       * Attention: `background=None` does *not* imply the absence of background component
  - negative integer `n` :  Ostap model `PolyPos_pdf` will be created and used as _background_ component. This model corresponds to the _positive_ polynomial of  degree `-n`. The polinomial is constrained to be non-negative for the whole considered interval of `xvar`.  This constraint allows rather robust and stable fits, especialy  for the low-statistics case. 
  - non-negative integer `n`: Ostap model `Bkg_pdf`, that  is a product of the exponential function and the _positive_ polynomial of degree `n` will be created and used as _background_  component. Note: 
       * The `background=0` case corresponds to simple exponential backtround 
       * Since the polynomial is constrained  to be _non-negative_ this PDF is very stable and robust, especually for the low-statistic case,
  - as `RooAbsReal` object,  in this  case it is interpreted as the exponental slope
 

### Access to the model  componens 

The indiviaul components can be accessed  using python _properties_
```python
gaudd = Gauss_pdf ( ... 
model = Fit1D ( signal = gauss , ... ) 
print model.signal.sigma  ##   get sigma of Gauss 
print model.signal.mean   ##   get mean  of Gauss 
```

### Fit parameters 
The parametters of the created `RooAddPdf` can be accessed via python properties, 
e.g. for _extended_ fits:
```python
gaudd = Gauss_pdf ( ... 
model = Fit1D ( signal = gauss , ... ) 
print 'signal yield(s):' , model.S   
print 'background(s):'   , model.B
print 'others: '         , model.C
model.S = 100   ## set value of signal component to be 100 events 
model.B.fix(50) ## fix the yield of the background component at 50  events 
model.draw() 
```
Depending on the number of corresponsing componens and flags `combine_signals`, `combine_backgrounds`, `combine_others` these properties can be _scalar_ values or arrays/tuples.

For  `combine_signal=True`, `combine_backgrounds =True`,  `combine_others=True` cases oen also gets properrties `fS` , `fB` and `fC` that corresponds to the  fractions of individual _signal/backgroud/others_ components for the compound signal/ _signal/backgroud/others_.

For _non-extended_ fits, the main parameters are _fractions_:
```python
gaudd = Gauss_pdf ( ... 
model = Fit1D ( signal = gauss , ... , extended = False ) 
...
print 'fractions:' , model.F   
```

All the ways to deal with `Fit1D` objects are illustrated here:
<script src="https://gist.github.com/VanyaBelyaev/1aa3edda0d6b7370db5dd8c1124f5aff.js"/></script>
The  corresponding output can be inspected [here](https://gist.github.com/VanyaBelyaev/9bb427a2c93cba78e5aa4f4023d2686b)

## `2D`-case 
### Generic `2D`-case 
### Symmetric `2D`-case 

## `3D`-case 
### Generic `3D`-case 
### Symmetric `3D`-case 
### Mixed-symmetry`3D`-case 
