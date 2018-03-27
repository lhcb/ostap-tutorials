# Operations with trees/chains 

## _General_

```python
tree = ...
print tree.branches() 
print tree.leaves() 
print 'Number of entries %s' % len ( tree ) 
```
{% discussion "For large number of bracnhes..." %}
For trees  with very large number of bracnhes (_feature_ of LHCb) one can improves printout:
```python
from   Ostap.Logger import multicolumn
print 'Branches: \n%s' % muhlticolumn ( tree.branches() )
```
{% enddiscussion %}



## _Statistic for the given variable/expression_


```python
st1 = tree.statVar('m')
st2 = tree.statVar('m','pt>10')
st3 = tree.statVar('m/eff','(pt>10)*trg_eff')
```
The results are in a form of `WStatEntity`, _weighted_ `StatEntity`)

```python
ncorr = tree.sumVar('S_sw/eff','pt>10')
```
Also one can get statistics and covariances for the pair of variables/expressions:
```python
s1 , s2 , cov2 = tree.statCov ( 'pt' , 'p' , 'pt>10' ) 
```
Or just simple 
```python
mn , mx = tree.minmax('1/eff')
```


##  _Explicit loops_ 

Explicit loops over the entries in tree/chain are trivial :
```python
for i in  range(len(tree)) : 
    tree.GetEntry(i)
    if tree.pt <  10 : continue 
    print tree.m 
```
But the direct looping looks a bit nicer:
```python
for entry in tree : 
    if entry.pt <  10 : continue 
    print entry.m 
```
Note that explciit loops are rather CPU-inefficient and slow. 
One  can _drastically_ improve performance by e.g embedding the cuts in iterator
```python
for entry in tree.withCuts('pt>10') : 
    print entry.m 
```
One  can also specify `first` and `last` entries and display  the progress bar 
```python
for entry in tree.withCuts('pt>10', last = 10000 , progress =  True ) : 
    print entry.m 
```

##  _Projections_ 
```python
h1 = ...
r  = tree.project ( h1 , 'mass' , 'pt>10' )
```
{% discussion "For loooong chains or huge trees..." %}
The module `Ostap.Kisa` provides nice functionality for parallell processing of large chains or huge trees for _projections_
```python
h1 = ...
long_chain =  ...
huge_tree   =  ...
import Ostap.Kisa
r1 = long_chain.pproject ( h1 , 'mass' , 'pt>10' ) 
r2 = huge_tree .pproject ( h1 , 'mass' , 'pt>10' ) 
```
For long chains it makes parallelizaion on _per-tree_ level,  and  for huge trees it split the tree into  chunks and parallelization 
is applied on _per-chunk_ level.
{% enddiscussion %}


## _Data, Data2 and DataAndLumi_ 

There is useful way to collect many ROOT files into single chains, avoiding non-existent, broken and invalid  trees 
(that is not so rare for the outptu of Ganga)
```python
from   Ostap.Data   import DataAndLumi as Data  
ganga = '/afs/cern.ch/work/i/ibelyaev/public/GANGA/workspace/ibelyaev/LocalXML'
patterns_Y = [
  ganga + '/319/*/output/CY.root' , ## 2k+11,down
  ganga + '/320/*/output/CY.root' , ## 2k+11,up
  ganga + '/321/*/output/CY.root' , ## 2k+12,down
  ganga + '/322/*/output/CY.root' , ## 2k+12,up
 ]
data_D0Y = Data ( 'YD0/CY' , patterns_Y )
print data_D0Y
chain = data_D0Y.chain 
lumi  = data_D0Y.getLumi()
```
Or they can be accumulated separately, and combined later: 
```python
from   Ostap.Data   import DataAndLumi as Data  
ganga  = '/afs/cern.ch/work/i/ibelyaev/public/GANGA/workspace/ibelyaev/LocalXML'
d2011d = Data( 'YD0/CY' ,  ganga + '/319/*/output/CY.root' ) ## 2k+11,down
d2011u = Data( 'YD0/CY' ,  ganga + '/320/*/output/CY.root' ) ## 2k+11,up
d2012d = Data( 'YD0/CY' ,  ganga + '/321/*/output/CY.root' ) ## 2k+12,down
d2012u = Data( 'YD0/CY' ,  ganga + '/322/*/output/CY.root' ) ## 2k+12,up
d2011  = d2011d + d2011u 
d2012  = d2012d + d2012u
runI   = d2011  + d2011 
```