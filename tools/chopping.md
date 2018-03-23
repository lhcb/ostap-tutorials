# Using _chopping_ for `TMVA` training/using 

_Chopping_ is a technique to use the limited set of data for TMVA training. In this approach  data   are _chopped_ into several categories and for  each category `i` TMV  is trained using the   remaing   `N-1` categories, and the trained `TMVA`  is applied to the events from    category  `i`.

## _Training `TMVA`-chopper_

The _trainig-with-chopping_ is fairly trivial. First one need to define the number of distinct categories and the function to classify the events into training categories.  E.g. for `TMVA` training
```python
tSignal  = ... ## signal     TTree/TChain
tBkg     = ... ## background TTree/TChain
## book TMVA trainer     
from Ostap.TMVAChopper import Trainer 
trainer = Trainer (
  N        = N                 , ## ATTENTION! N is number of categories 
  category = "137*evt+813*run" , ## ATTENTION! It is a classification function      
  chop_signal       = False    , ## chop the signal     ?  (default) 
  chop_background   = True     , ## chop the background ?  (default)
  ...
```
All other arguments of `Trainer` are the same as for [regular `TMVA` trainer](../tools/tmva.md). Arguments `chop_signal` and `chop_background` defined what sample (or both) to be _chopped_.  The    argument caterory described _the integer-valued function_, used for classification of events.  Actually _trainer_ construct classification  function as `category%N`. 

{% discussion "How to choose chopping parameters?" %}
For efficient usage of events number of   categroeis shoudl be   rather large `N>>2`. For the given number of categories `N`, the   fraction of events used for `TMVA` training is `(N-1)/N`. Therefore with large `N` events are used more  efficiently.  From other side, for large `N` the traing time is proportional to `N`, while the  traing results shodul be more or less independent on `N`. It makes senseless  usage of `N>100`. Therefore one gets `2<<N<100`. In practice it is convinient to  choose `10<N<20`. 

The ideal classification function *must* be independent on the properties of  signal and or background. It should be `pseudorandom` and provide almost uniform population of categories. It is very easy to  achive using the following  expression  `(Na*a+Nb*b+Nc*c+...+Nz*z+)%N`, where `a`, `b`, ... , `z` are some integer-valued variables from the input `TTree`/`TChain` (event  number, run-number, GPS time in nanoseconds, number of  tracks in  event. number of hits in SPD, etc...), and `Na`, `Nb`, ..., `Nz` are prime numbers, that are large enough (`Na>>N`, `Nb>>N`, ... , `Nz>>N`).  With such construction, choosing`N` to be  also a prime number, one almost   guaranteed that  events are _randomly_  distributed into `N`-categories.

The category population can be  checked using setof  control historgams: 
```python
bc =  trainer.background_categories 
sc =  trainer.signal_categories 
bc[0].Draw() ## show popultion of background categroies
bc[1].Draw() ## the same with  different binning

sc[0].Draw() ## show popultion of signal categroies
sc[1].Draw() ## the same with  different binning
```
{% enddiscussion %}


## _Using `TMVA`-chopper_


Again one needs to define the classification function for input data. Clealry this function should match  the one used in training
```python
category = lambda s :  int ( s.evt*137 + 813*s.run ) % N ## the  classification function  
from Ostap.TMVAChopper import Reader   ## ATTENTION
reader = Reader(
    N             = N         , ##  number of   categories
    categoryfunc  = category  , ## category 
    ...
```
All other arguments of `Reader` are the same as for [regular `TMVA` reader](../tools/tmva.md).  The    created _reader_ is used exactly in the same way as for _no-chopping_-case: 
```python
tree = ... ##  the tree 
mlp  = reader['MLP']                     ## get  one method
for i in tree :                          ## loop over the entries 
    print 'MLP value is %s'  % mlp ( i ) ## get the  value 
```
{% discussion "For tests and debug" %}
For test and  debug purposes one can use it also  as a function:
```python
v1,  v2,  v3 = .... 
mlp  = reader['MLP']    ## get  one method 
for i in range ( N ) :  ## loop over   categories 
    print 'MLP value for  categroy %s is %s'  % ( i , mlp ( i , v1 , v2 ,  v3 ) )
```
And even get the difference between responces for different   categories. Clearly the spread of values should be small enough
```python 
v1,  v2,  v3 = .... 
mean = mlp.mean ( v1 , v2 , v3 ) ## get a mean-value over  different  categories 
stat = mlp.stat ( v1 , v2 , v3 ) ## get a statistics  (mean,rms, min/max,...) of  responces
```
{% enddiscussion %}
