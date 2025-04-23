## read data
use hersdata.dta
drop if diabetes ==1   // 731 obs deleted
drop if mi(HDL) | mi(BMI) | mi(age) | mi(drinkany) // 11 obs deleted
keep HDL BMI age drinkany

## Part A) = bootstrap "by hand"
## =============================

## Writing our own bootstrap program requires four steps.
## 
## 1) In the first step we obtain initial estimates and store the results in a matrix, 
## say observe. In addition, we must also note the number of observations used in the analysis. 
## This information will be used when we summarize the bootstrap results.
## 
## 2) Second, we write a program which we will call myboot that samples the 
## data with replacement and returns the statistic of interest. In this step, 
## we start by preserving the data with the preserve command, then take a bootstrap
## sample with bsample. bsample samples the data in memory with replacement,
## which is the essential element of the bootstrap. From the bootstrap sample 
## we run our regression model and output the statistic of interest with the return 
## scalar command. Note that when we define the program, program define myboot, 
## we specify the rclass option; without that option, we would not be able to output 
## the bootstrapped statistic. myboot concludes with the restore command, 
## which returns the data to the original state (prior to the bootstrapped sample).
## 
## 3) In the third step, we use the simulate prefix command along with myboot, 
## which collects the statistic from the bootstrapped sample. 
## We specify the seed and number of replications at this step, which coincide 
## with those from the example above.
## 
## 4) Finally, we use the bstat command to summarize the results. 
## We include the initial estimates, stored in the matrix observe, and the 
## sample size with the stat( ) and n() options, respectively.
 
 
 
## Step 1 - define model and store the coefficients via the observe command
regress HDL BMI age drinkany 

matrix observe= (_b[_cons], _b[BMI], _b[age], _b[drinkany])
matrix list observe

 
## Step 2 - program to be repeated
capture program drop myboot2
program define myboot2, rclass
 preserve 
  bsample
    regress HDL BMI age drinkany  
    ## fit model, store coeff 
	  return scalar b0 = _b[_cons]
    return scalar b1 = _b[BMI]
    return scalar b2 = _b[age]
	return scalar b3 = _b[drinkany]
 restore
end

## Step 3 - simulation = resampling the data using the program myboot2, R=1000 replicates
simulate  b0=r(b0) b1=r(b1) b2=r(b2) b3=r(b3), reps(1000) seed(12345): myboot2

## Step 4 - compute 95% CIs
bstat, stat(observe) n(2021) 
                    ## n = nb of observations --> CAUTION HERE
estat bootstrap, all

## NB: you can reduce the output of estat bootstrap by specifying 
## the option (e.g. percentile) instead of all 

estat bootstrap, percentile


## NB: you can change the number of replicates i.e. the argument of reps()
##     we need at least 1000 replicates for 95% CU
##     The seed use here is only there to replicate the simulations
##     if you don't specify a seed, a random seed will be chosen and different results
##     will be obtained each time (very similar though). The difference is due to the
##     Monte Carlo variability.



##  select the code above and run

## NB: browse the active dataset, the dimension and the columns. NO LONGER hers

desc
list if _n<20 


#  percentile CI for each coefficient & histogram
#  ------------------------------------------------

## write a one line command for the histogram and another line for the percentile CI (per coefficient)

 
##  4) boostrap  using the libary boot - use Part B below
 

# Part B) use a Stata command - SIMPLER
# ======================================

 
clear
## read the dataset again
 
use hersdata.dta
drop if diabetes ==1  
drop if mi(HDL) | mi(BMI) | mi(age) | mi(drinkany) 
keep HDL BMI age drinkany

bootstrap, reps(1000)  seed(12345): regress HDL BMI age drinkany  
estat bootstrap, all        
## all 3 types

bootstrap, reps(1000)  seed(12345): regress HDL BMI age drinkany 
estat bootstrap, percentile 
## percentile

bootstrap, reps(1000)  seed(12345): regress HDL BMI age drinkany 
estat bootstrap, normal     
## normal

## to get the BCa option alone, type this
bootstrap, bca reps(1000)  seed(12345): regress HDL BMI age drinkany  
estat bootstrap     

## again you can use more than 1000 replicates and change the seed

