# Using _Weighted fits_

Often one needs to fit _weighted dataset_, etg.  _backrgonud-subtracted_  
or _efficiency_corrected_. It is purely trivial in Ostap:
```python
dataset = ...
dsw     = dataset.makeWeighted( 'S_sw/eff' ) ## 
model   = ...
model.fitTo ( dsw , .... , sumw2 = True , ... ) ## <--- HERE
```
 
