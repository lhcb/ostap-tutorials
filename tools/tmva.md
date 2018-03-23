# Using `TMVA`

Ostap hosts couple of classes, that simplifies the training and using of [`TMVA`](https://root.cern.ch/tmva).

##  _Training `TMVA`_
```python
tSignal  = ... ## signal     TTree/TChain
tBkg     = ... ## background TTree/TChain
## book TMVA trainer     
from Ostap.PyTMVA import Trainer 
trainer = Trainer (
   name    = 'TestTMVA' ,   
   methods = [
   # type                   name   configuration
   ( ROOT.TMVA.Types.kMLP        , 'MLP'        , 'H:!V:EstimatorType=CE:VarTransform=N:NCycles=200:HiddenLayers=N+3:TestRate=5:!UseRegulator' ) ,
   ( ROOT.TMVA.Types.kBDT        , 'BDTG'       , 'H:!V:NTrees=100:MinNodeSize=2.5%:BoostType=Grad:Shrinkage=0.10:UseBaggedBoost:BaggedSampleFraction=0.5:nCuts=20:MaxDepth=2' ) , 
   ( ROOT.TMVA.Types.kCuts       , 'Cuts'       , 'H:!V:FitMethod=MC:EffSel:SampleSize=200000:VarProp=FSmart' ) ,
   ( ROOT.TMVA.Types.kFisher     , 'Fisher'     , 'H:!V:Fisher:VarTransform=None:CreateMVAPdfs:PDFInterpolMVAPdf=Spline2:NbinsMVAPdf=50:NsmoothMVAPdf=10' ),
   ( ROOT.TMVA.Types.kLikelihood , 'Likelihood' , 'H:!V:TransformOutput:PDFInterpol=Spline2:NSmoothSig[0]=20:NSmoothBkg[0]=20:NSmoothBkg[1]=10:NSmooth=1:NAvEvtPerBin=50' )
   ] ,
   variables  = [ 'var1' , 'var2' ,  'var3' ] , ## Variables to be used for training 
   signal     = tSignal                       , ## ``Signal'' sample 
   background = tBkg                          , ## ``Background'' sample  
   verbose    = False )
```
Optionally one can specify also `signal_cuts` and `background_cuts`.

Traing `TMVA` itself is trivial, one needs to invoke the method `train`:
```python 
weights_files = trainer.train ()
```
It  returs the list/tuple of _weight-`XML`-files_, the output of `TMVA` trainer.
Optionally one can retrieve also the list of  _`C++-class`-files,  using the proeprty `class_files` or  everything together in a form of `tar`-file using the property
`tar_file`:
```python
weight_files = trainer.weight_files ## XML weights  
class_files  = trainer.class_files  ## C++ classes 
tar_file     = trainer.tar_file     ## everything together
```

##  _Using `TMVA`_

To use trained `TMVA` one exploits _`TMVA` reader_:
```python 
from Ostap.PyTMVA import Reader
reader = Reader( 
   'MyMLP' ,
   variables     = [ ('var1' , lambda s : s.var1 )   ,
                     ('var2' , lambda s : s.var2 )   ,
                     ('var3' , lambda s : s.var3 ) ] ,
  weights_files = tar_file  )
```
{% discussion "What is `lambda s : s.var1` here?" %}
The the element of the pair is, obviously, the variable name.
The second   argument is _accessor function_. 
It will be applied for _1-argument call_ of the _method_.
E.g. in this example, one  can apply it to `TTree`/`TChain`/`RooAbsData`/`RooArgSet` and the variable 
`var1` from   this `TTree`/`TChain`/`RooAbsData`/`RooArgSet` will be used as `'var1'` for the `TMVA`.
Accessor  functions coudl be  trivial, as on this case,  but they also can be less trivial:
```python
variables     = [ ('var1' , lambda s : s.rapidity     )   , ## use another name 
                  ('var2' , lambda s : s.pt/1000      )   , ## make some rescaling
                  ('var3' , lambda s : atan2(s.y,s.x) ) ] , ## make more complicated calculations
```
If one wants to use other objects for _1-argument call_, other set of accessor  functions   need to be supplied.
E.g. if data  are expected to be supplied  as a `tuple`/`list`/`std::vector<...>`, one   can use 
```python
variables     = [ ('var1' , lambda s : s[0] )   , ## use another name 
                  ('var2' , lambda s : s[1] )   , ## make some rescaling
                  ('var3' , lambda s : a[2] ) ] , ## make more complicated calculations
```
One  can  also use just the plain list of variable names:
```python
variables     = [ 'var1' , 'var2' , 'var3' ] 
```
This list will be automatically transformed into 
```python
variables     = [ ('var1' , lambda s : getattr( s , 'var1') ) ,
                  ('var2' , lambda s : getattr( s , 'var2') ) ,
                  ('var3' , lambda s : getattr( s , 'var3') ) ]
```
{% enddiscussion %}

As `weight_files` arguments one can use either the list of _weights-files_ from _the trainer_, or, _much easier_, use the single _'tar'-file_ from _the trainer_. The methods,  available from the weight files can be checked as
```python
print reader.methods 
````
And the usage of the reader is rather trivial, e.g. one can  explicitly request the  responce for certain set of arguments:
```python
v1,  v2,  v3 = .... 
mlp  = reader['MLP']                     ## get  one method 
print 'MLP value is %s'  % mlp ( v1 , v2 ,  v3 ) 
```
In practice, one practially always uses it with `TTree`/`TChain`/`RooAbsData`/`RooArgSet`, in this  case one use _1-argument call_,  assuming then proper _accessor functions_ are supplied: 
```python
tree = ... ##  the tree 
mlp  = reader['MLP']                     ## get  one method
for i in tree :                          ## loop over the entries 
    print 'MLP value is %s'  % mlp ( i ) ## get the  value 
```

