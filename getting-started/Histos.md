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
Note that the result in both cases is of type `VE`, _val+/-err_, and the interpolation is involved in the second case. The interpolation can be controlled using `interpolation` argument 
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

#### _Transformations_ 
```python
h1 = histo.transform ( lambda x,y : y    ) ## identical transformation (copy) 
h2 = histo.transform ( lambda x,y : y**3 ) ## get the third power of the histogram content 
h3 = histo.transform ( lambda x,y : y/x  ) ## less trivial functional transformation 
```

####  _Efficiencies_

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

####  _Math functions_

The standard math-functions can be applied to the histoigram (bin-by-bin):
```python
from LHCbMath.math_ve import *
h1 = sin ( histo ) 
h2 = exp ( histo ) 
h3 = exp ( abs ( histo ) ) 
...
```
####  _Sampling_
There is an easy way to sample the histograms according to their content, e.g. for toy-experiments:
```python
h1 = histo.sample() ## make a random histogram with content sampled according to bin+-error in original histo
h2 = histo.sample( accept = lambda s : s > 0 ) ##sample but require that sampled values are positive 
```