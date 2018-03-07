# Simple operations with histograms

## Historgam content
 
`Ostap.PyRoUts` module provides two ways to access the histogram content
 - by bin index, using operator `[]`: for 1D historgam index is a simple integer number, for 2D and 3D-histograms the bin index is a 2 or 3-element tuple
 - using _functional_ interface with operator`()`.
```python
histo = ...
print histo[2]    ## print the value/error associated with the 2nd bin 
print histo(2.21) ## print the value/error at x=2.21 
```
Note that the result in both cases is of type `VE`, _value+/-uncertainty_, and the interpolation is involved in the second case. The interpolation can be controlled using `interpolation` argument 
```python
print histo ( 2.1 , interpolation = 0 ) ## no interpolation 
print histo ( 2.1 , interpolation = 1 ) ## linear interpolation 
print histo ( 2.1 , interpolation = 2 ) ## parabolic interpolation 
print histo ( 2.1 , interpolation = 3 ) ## cubic interpolation
```
Similarly for 2D and 3D cases, `interpolation` parameter is 2 or 3-element tuple, e.g. 
`(2,2)` `(3,2,2)` , `(3,0,0)`, ...

Set  bin content
```python
histo[1] = VE(10,10)
histo[2] = VE(20,20)
```

Loops over the histogram content:
```python
for i in histo : 
    print 'Bin# %s, the content%s' % ( i, histo[i] ) 
for entry in histo.iteritems() : 
    print 'item  ', entry 
```

The _reversed_ iterations are also  supported
```python
for i in reversed(histo) : 
    print 'Bin# %s, the content%s' % ( i, histo[i] ) 
```

## Histogram slicing 

The slicing of 1D-historgam can be done easily using native `slice` in python
```python
h1 = h[3:8]
```

For 2D and 3D-casss the slicing is less trivial, but still simple 
```python
histo2D = ...
h1 = histo2D.sliceX ( 1 ) 
h2 = histo2D.sliceY ( [1,3,5] ) 
h3 = histo2D.sliceY ( 3 ) 
h4 = histo2D.sliceY ( [3,4,5] ) 
```

##  _Operators and operations_

A lot of operators and operations are defined for histograms.
```python
histo += 1 
histo /= 10 
histo  = 1     + histo      ## operations with constants    
histo  = histo + math.cos   ## operations with functions 
histo /= lambda x : 1 + x   ## lambdas are also functions 
```
Also binary operations are defined 
```python
h1 = ...
h2 = ...
h3 = h1 + h2 
h4 = h1 / h2 
h5 = h1 * h2 
h6 = h1 - h2 
```
For the binary operations the action is defiened accordinh to the rule
  - the type of the result is defined by the first operand (type, and binning) 
  - for each bin `i` the result is estimated as `a oper b`, where:
     - `oper` stands for corresponding operator (`+,-,*,/,**)`
     - `a = h1[i]` is a value of the first operand at bin `i`
     - `b = h2(x)`, where `x` is a bin-center of bin`i`

###  _More operations_

There are many other useful opetations:
 - `abs` :  apply `abs` function bin-by-bin 
 - `asym` : equivalent to `(h1-h2)/(h1+h2)` with correct treatment of correlated uncertainties 
 - `frac` : equivalent to `(h1)/(h1+h2)` with correct treatment of correlated uncertainties 
 - `average` : make an average of two historgam 
 - `chi2`  : bin-by-bin chi2-tension between two historgams 
 - ... and many more 

### _Transformations_ 
```python
h1 = histo.transform ( lambda x,y : y    ) ## identical transformation (copy) 
h2 = histo.transform ( lambda x,y : y**3 ) ## get the third power of the histogram content 
h3 = histo.transform ( lambda x,y : y/x  ) ## less trivial functional transformation 
```

###  _Math functions_

The standard math-functions can be applied to the histoigram (bin-by-bin):
```python
from LHCbMath.math_ve import *
h1 = sin ( histo ) 
h2 = exp ( histo ) 
h3 = exp ( abs ( histo ) ) 
...
```

###  _Sampling_
There is an easy way to sample the histograms according to their content, e.g. for toy-experiments:
```python
h1 = histo.sample() ## make a random histogram with content sampled according to bin+-error in original histo
h2 = histo.sample( accept = lambda s : s > 0 ) ##sample but require that sampled values are positive 
```

### Smearing/convolution with gaussian
It is very easy to smear 1D histogram according to gaussian resolution 
```python
h1 = histo.smear ( 0.015 ) ## apply "smearing" with sigma = 0.015 
h2 = histo.smear ( sigma = lambda x :  0.1*x ) ## smear using 'running' sigma of 10% resolution
```


### Rebin 
```python
original = ... ## the original historgam to be rebinned 
template = ... ## historgams that deifned new binning  scheme  
rebin1   = original.rebinNumbers  ( template ) ## compare it!  
rebin2   = original.rebinFunction ( template ) ## compare it!
````
Note that  there are _two_ methods for rebin 
`rebinNumbers` and `rebinFunction` -  they depends on the treatment of the histogram.
{% challenge "Challenge" %}
Choose some initial histogram with non-uniform biuning, choose _template_ historam  with non-uniform binning
and compare two methods: `rebinNumbers` and `rebinFunction`. 
{% endchallenge %}

###  _Integrals_ 
There are several_integral_-like methods for (1D)histograms 
 - `accumulate` : useful for _numbers_-like histograms, only bin-content inn used for summation (unless the bin is effectively split in case of low/high summation edge does not coinside with bin edges)
```python
s = histo.accumulate ()
s = histo.accumulate ( cut = lambda s :  0.4<=s[1].value()<0.5 ) 
s = histo.accumulate ( low  = 1    , high = 14 ) ## accumulate over    1<= ibin <14
s = histo.accumulate ( xmin = 0.14 , xmax = 14 ) ## accumulate over xmin<= x    <xmax
```
 - `integrate` : useful for _function_-like histograms, perform integration taking into account bin-width.
```python
s = histo.integrate ()
s = histo.integrate ( cut  = lambda s :  0.4<=s[1].value()<0.5 ) 
s = histo.integrate ( lowx = 1    , highx = 14   ) ## integrate over    1<= xbin <14
s = histo.integrate ( xmin = 0.14 , xmax  = 21.1 ) ## integrate over xmin<= x    <xmax
```
 - `integral` it transform the histogram into `ROOT.TF1` object and invokes `ROOT.TF1.Integral`

### _Running sums_
 and the efficiencies of cuts_ 
```python
h1 = histo.sumv ()        ## increasing order: sum(first,x) 
h2 = histo.sumv ( False ) ## decreasing order: sum(x,last ) 
```

#### _Efficiency of the cut_ 
Such functionality immediately allows to calculate efficiency historgrams using `effic` method:
```python
h1 = histo.effic ()        ## efficiency of var<x cut 
h2 = histo.effic ( False ) ## efficiency of var>x cut 
```

### _Conversion to `ROOT.TF(1,2,3)`_


### _Scaling_

In additon to _trivial_ scaling operations `h *= 3` and `h /= 10` there are seevral dedicated methdo for scaling
 - `scale` it scales the historgam content to a given sum of _in-range_ bins 
```python
print histo.accumulate()
histo.scale(10)
print histo.accumulate()
```
  - `rescale_bins` : it allows the treatment of non-uniform histograms as density distributions. Essentially each bin `i` is rescaled 
according to  the rule `h[i] *= a / S` , where `a` is specified factor and `S` is _bin-area_. such type of rescaling is important for historgams 
with non-uniform binning 

#### _Density_

There is method `density` that  converts the histgram into _density_ histogram. The  density histogram (being interpreted as _function_) has unit integral. It is different  from the simple rescaling for historgams with non-uniform bins.  
```python
d = histo.density()
```

### _Statistics_

There are many _statistic_ functions 
 - `mean`
 - `rms`
 - `kurtosis`
 - `skewness`
 - `moment`
 - `centralMoment`
 - `nEff` : number of equivalent entries
 - `stat` : statistical information about bin-to-bin content: mean, rms, minmax, ... in form of `Gaudi::Math::StatEntity` class


###  _Figure-of-Merit evaluation and cut optimisation_ 

If _figure-of-merit_ is natural and equals to _sigma(S)/S_ (note that it is equal to _sqrt(S+B)/S_):
```python
signal = ...  ## distribition for signal
fom1   = signal.FoM2 () ## FoM for var<x cut 
fom2   = signal.FoM2 ( False ) ## FoM for var>x cut 
```
Note that no explicit knowledge of background is needed here - it enters indireclty via the uncertainties in signal determination.

If _figure-of-merit_ is defined as  _S/sqrt(S+alpha*B)_ 
```python
signal = ... 
background = ... 
alpha = ... 
fom1  = signal.FoM1 ( background , alpha ) ## FoM for var<x cut 
fom2  = signal.FoM1  ( background , alpha , False ) ## FoM for var>x cut 
```

### _Solve equations_
One can also _solve  equations_  `h(x) = v`
```python
value = 3 
solutions = histo.solve ( value )
for x in solutions : print x 
```

### _Conversion to  `ROOT.TF(1,2,3)_

The conversion of histogram to `ROOT.TF1` objects is straighforward 
```python
f = histo.tf1() 
```
Optionally one can specify `interpolate` flag to define the interpolation rules.  

The  obtained `TF1` object is defined with three parameters 
  1. normalization 
  2. bias
  3. scale

It can be used e.g. for visualize interpolated historgam as function or e.g. in `ROOT.TH1.Fit` method for fitting of other historgams 

###  _Efficiencies_

There are several special cases to get the efficiency-historgams 
```python
accepted = ... ## historgam with accepted sample 
rejected = ... ## historgam with rejected sample 
total    = ... ## historgam with total sample 

eff1 = accepted/total          ## value is correct, uncertainties are *NOT* correct 
eff2 = 1/(1+rejected/accepted) ## everything is correct (binomial) 
eff3 = accepted %  total       ## everything is correct (binomial)
eff4 = accepted // total       ## correct binomial, if both histograms are "natural"
```



### _Binomial efficiencies_ 

In additon to the methods described above, few more sophisticated treatments of _binomial effiiciencies_ are provided
```python  
accepted = ...
total    = ... 

eff1 = accepted.        zechEff ( total ) ## valid for all histograms, including sPlot-weighted 
eff2 = accepted.       binomEff ( total ) ## only for natural histograms
eff3 = accepted.      wilsonEff ( total ) ## only for natural histograms 
eff4 = accepted.agrestiCoullEff ( total ) ## only for natural histograms 
```
For _natural_ historgams only one can use even more [sophisticated methods](https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval), that evaluates the interval. Each method returns _graph_, and the graphs can be visuzalised for comparison: 
```python  
accepted = ...
rejected = ... 

eff1 = accepted.eff_wald                    ( rejected ) 
eff2 = accepted.eff_wilson_score            ( rejected ) 
eff3 = accepted.eff_wilson_score_continuity ( rejected ) 
eff4 = accepted.eff_arcsin                  ( rejected ) 
eff5 = accepted.eff_agresti_coull           ( rejected ) 
eff6 = accepted.eff_jeffreys                ( rejected ) 
eff7 = accepted.eff_clopper_pearson         ( rejected ) 
```
All of this  functions have an optional argument `interval` that defines the confidence interval, 
the default value is `interval=0.682689492137086` that corresponds to 1 sigma.  

### _Optimal binning?_ 

It is not a rare case when one needs to find the binbing of the histogram that ensures almost equal bin populations. This task could be solved using `eqaul_bins` method 
```python
very_fine_binned_histo = ... ## get the fine binned histograms 
edges1 = fine_binned.equal_edges ( 10 ) ## try to fing binning with 10 almost equally populated bins 
edges2 = fine_binned.equal_edges ( 10 , wmax = 5 ) ## try to fing binning with 10 almost equally populated bins, but avoid bins wider than "wmax" 
```    