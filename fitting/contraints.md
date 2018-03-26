# Using _Constraints_ in the fit

Often oen  can  add _soft Gaussian constraint_ for  soem   fit parameters, e.g. one   can constraing the rsignal resolution:
```python
sigma_MC       = VE( 0.015 , 0.001**2 ) ## 
sigma_cnt      = model.sigma.constrainTo ( sigma_MC , 'sigma_constraint')
my_constraints = ROOT.RooFit.ExternalConstraints ( ROOT.RooArgSet ( sigma_cnt  ) ) 
dataset         = ...
model.fitTo ( dataset , ... , constraints = my_constraints , ....  ) 
```
Clearly several constraints can be combined togather 
```python
sigma_cnt  = model.sigma.constrainTo ( sigma_MC           , 'sigma_constraint')
peak_cnt   = model.mean .constrainTo ( VE(3.096,0.001**2) , 'mass_constraint' )
my_constraints = ROOT.RooFit.ExternalConstraints ( ROOT.RooArgSet ( sigma_cnt , peak_cnt ) ) 
```
For the next version of ostap,  one will be able to avoid the explicit creation of
` ROOT.RooFit.ExternalConstraint` and `ROOT.RooArgSet`
```python
sigma_cnt  = model.sigma.constrainTo ( sigma_MC           , 'sigma_constraint')
peak_cnt   = model.mean .constrainTo ( VE(3.096,0.001**2) , 'mass_constraint' )
model.fitTo ( dataset , ... , constraints = ( sigma_cnt , peak_cnt ) , ....  ) 
```