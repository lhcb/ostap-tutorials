#  _Decorations_

Ostap  _decorates_ many `ROOT.RooFit` classes, adding more convinient methods to them.  

##  `RooArgList` and `RooArgSet` 

All these classes have got set of additional python-like  methods for iteration, extension, addition, elemtn access checking the content etc...
Also several methods to provide more coherent interfaces (e.g. `add` vs `Add`) are added. 
<script src="https://gist.github.com/VanyaBelyaev/69cdf870f0db8261f044cf6a29e91117.js"/></script>

## _RooAbsData and RooDataSet_

These methods also have got the extended interface with many useful methods  and operators, like 
e.g. concatenation of datasets `a+b` and merging them `a*c`. 

`RooDataSet` class also has go many methods, that are similar to those of `ROOT.TTree`, in particular  `project` and `draw`:
```python
dataset = ... 
dataset.draw('mass','pt>1')  
histo   = ...
dataset.project ( histo , 'mass', 'pt>1' ) 
```
Many other methonds like `statVar`, `sumVar` , `statCov` , `vminmax` are  also the  same as for `ROOT.TTree`,  see [above](../getting-started/Trees.md).
```python
s1    = dataset.statVar ('eff') 
s2    = dataset.sumVar  ('eff') 
r     = dataset.statCov ('eff','pt') 
mn,mx = dataset.vminmax ('eff') 
```

## _RooFitResult_

The class `RooFitResult` get many decorations that allow to access fit results
```python
result = ...
par1 = result.params()  ## get all floating parameters 
par2 = result.params( float_only = False ) ## all parameters 
a,v  = result.param ( 'a' )      ## par by name 
a,v  = result.param (  a  )      ## par by RooFit object itself 
p    = result.a                 ## par as attribute 
for par in result :   print par                ## iteration 
for name,par in result.iteritems() : print par ## iteration
print result.cov  ( 'a' , 'b' )   ## get the covariance submatrix  
print result.corr ( 'a' , 'b'  )  ## get the correlation coefficient 
```
Also the simple math with fiting parameters is supported 
```python
result = ...
s = result.sum       ('S','B' ) ## S+B
d = result.divide    ('S','B' ) ## S/B
s = result.subtract  ('B','B1') ## B-B1
m = result.multiply  ('A','B' ) ## A*B 
f = result.fraction  ('S','B' ) ## S/(S+B) 
```

##  _RooRealVar & friends_

Few simple operations are added to simplify the calculations  with `RooRealVar` objects:
```python
x = ROOT.RooRealVar( ... )
x + 10 
x - 10 
x * 10 
x / 10 
10 + x 
10 - x 
10 * x 
10 / x
x += 2 
x -= 2 
x *= 2 
x /= 2 
x ** 3 
```


