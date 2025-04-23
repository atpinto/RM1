import delimited "https://raw.githubusercontent.com/atpinto/RM1/main/Data/triceps.csv"
gen age2 = age^2
gen age3 = age^3
regress logthick age age2 age3
quiet predict pred
twoway  scatter logthick age || line pred age, sort 
test age2 age3  
## compare cubic polynomial fit to linear fit
import delimited "https://raw.githubusercontent.com/atpinto/RM1/main/Data/triceps.csv"
mkspline age_spl = age, cubic nknots(4)
regress logthick  age_spl* 
## Figure 7.2, default knots, and fit
import delimited "https://raw.githubusercontent.com/atpinto/RM1/main/Data/triceps.csv"
mkspline age_spl = age, cubic nknots(4) displayknots
regress logthick  age_spl*
predict pred
twoway scatter logthick age, xline(1.243  8.1865  17.469 42.72) || line pred age, sort clstyle(solid) 

# Testing whether the additional splines terms are necessary
test age_spl2 age_spl3

## Figure 7.3, knots at 10, 20, 35 and 45, and fit

drop pred age_spl*
mkspline age_spl = age, cubic knots(10 20 35 45)
matrix list r(knots)
regress logthick  age_spl*
predict pred
twoway scatter logthick age, xline(10 20 35 45) || line pred age, sort clstyle(solid) 

# Testing whether the additional splines terms are necessary
test age_spl2 age_spl3
import delimited "https://raw.githubusercontent.com/atpinto/RM1/main/Data/triceps.csv"
mkspline2 age_spl = age, cubic nknots(4)
regress logthick  age_spl*
mfxrcspline, gen(delta lower upper)
sort age

## --------------------------------------------------
## this additional command allows you to browse (only) 
## the new variables created. Deactivated here.
## You can also browse the data manually
## ---------------------------------

## br age delta lower upper 
