# sPlot

Using [sPlot](http://dx.doi.org/10.1016/j.nima.2005.08.106) is   rather  trivial in Ostap:
```python
dataset = ...
model   = Fit1D ( signal = ... , backgrund = ... ) 
model.fitTo ( dataset )
print datatset   
model.sPlot ( dataset )  ## <--- HERE 
print datatset           ## <--- note appearence of new variables 
```