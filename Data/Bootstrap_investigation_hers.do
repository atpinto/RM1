

* 2) bootstrap
* -------------



cd "\\ad.monash.edu\home\User051\sheritie\Desktop\RM1\data"

use "hersdata.dta"
drop if diabetes ==1   // 731 obs deleted
drop if mi(HDL) | mi(BMI) | mi(age) | mi(drinkany) // 11 obs deleted




* Part A) = bootstrap by hand
* ===========================

/* Writing our own bootstrap program requires four steps.

1) In the first step we obtain initial estimates and store the results in a matrix, 
say observe. In addition, we must also note the number of observations used in the analysis. 
This information will be used when we summarize the bootstrap results.

2) Second, we write a program which we will call myboot that samples the 
data with replacement and returns the statistic of interest. In this step, 
we start by preserving the data with the preserve command, then take a bootstrap
sample with bsample. bsample samples the data in memory with replacement,
which is the essential element of the bootstrap. From the bootstrap sample 
we run our regression model and output the statistic of interest with the return 
scalar command. Note that when we define the program, program define myboot, 
we specify the rclass option; without that option, we would not be able to output 
the bootstrapped statistic. myboot concludes with the restore command, 
which returns the data to the original state (prior to the bootstrapped sample).

3) In the third step, we use the simulate prefix command along with myboot, 
which collects the statistic from the bootstrapped sample. 
We specify the seed and number of replications at this step, which coincide 
with those from the example above.

4) Finally, we use the bstat command to summarize the results. 
We include the initial estimates, stored in the matrix observe, and the 
sample size with the stat( ) and n() options, respectively.

*/




cd "\\ad.monash.edu\home\User051\sheritie\Desktop\RM1\data"

use "hersdata.dta"
drop if diabetes ==1   // 731 obs deleted
drop if mi(HDL) | mi(BMI) | mi(age) | mi(drinkany) // 11 obs deleted



*Step 1

regress HDL BMI age drinkany 

matrix observe= (_b[_cons], _b[BMI], _b[age], _b[drinkany], _b[_cons] + 27*_b[BMI] + 65*_b[age]+ 1*_b[drinkany])
matrix list coeff

 
*Step 2
capture program drop myboot2
program define myboot2, rclass
 preserve 
  bsample
    regress HDL BMI age drinkany  // model to be fitted  and coeff - UPDATE
	return scalar b0 = _b[_cons]
    return scalar b1 = _b[BMI]
    return scalar b2 = _b[age]
	return scalar b3 = _b[drinkany]
	return scalar pred= _b[_cons] + 27*_b[BMI]+65*_b[age]+ 1*_b[drinkany]
 restore
end

*Step 3
simulate  b0=r(b0) b1=r(b1) b2=r(b2) b3=r(b3) pred=r(pred), reps(1000) seed(12345): myboot2

*Step 4
bstat, stat(observe) n(2021) // n = nb of observations !  CAUTION HERE
estat bootstrap, all

* -------------------

hist b1
centile b1, centile(2.5 97.5)
hist b2
centile b2, centile(2.5 97.5)
hist b3
centile b3, centile(2.5 97.5)




* Part B) use a Stata command
* ==========================

cd "\\ad.monash.edu\home\User051\sheritie\Desktop\RM1\data"

use "hersdata.dta"
drop if diabetes ==1   // 731 obs deleted
drop if mi(HDL) | mi(BMI) | mi(age) | mi(drinkany) // 11 obs deleted

bootstrap, reps(1000)  seed(12345): regress HDL BMI age drinkany 

/* L
Linear regression                               Number of obs     =      2,021
                                                Replications      =      1,000
                                                Wald chi2(3)      =     122.77
                                                Prob > chi2       =     0.0000
                                                R-squared         =     0.0652
                                                Adj R-squared     =     0.0638
                                                Root MSE          =    13.0608

------------------------------------------------------------------------------
             |   Observed   Bootstrap                         Normal-based
         HDL |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         BMI |  -.4036859   .0548886    -7.35   0.000    -.5112656   -.2961062
         age |   .2086808   .0430616     4.85   0.000     .1242817      .29308
    drinkany |   4.502504   .5957828     7.56   0.000     3.334792    5.670217
       _cons |   46.68225   3.455292    13.51   0.000     39.91001     53.4545
------------------------------------------------------------------------------


*/
 
bootstrap, bca reps(1000) seed(12345): regress HDL BMI age drinkany 
estat bootstrap, all  // 4 types are listed
estat bootstrap, bca  // only BCa 


/* 

. estat bootstrap, all  // 4 types are listed

Linear regression                               Number of obs     =      2,021
                                                Replications      =       1000

------------------------------------------------------------------------------
             |    Observed               Bootstrap
         HDL |       Coef.       Bias    Std. Err.  [95% Conf. Interval]
-------------+----------------------------------------------------------------
         BMI |  -.40368587  -.0038854    .0548886   -.5112656  -.2961062   (N)
             |                                      -.5188768  -.2992493   (P)
             |                                       -.507547  -.2924751  (BC)
             |                                       -.507547  -.2924751 (BCa)
         age |   .20868084  -.0009771   .04306157    .1242817     .29308   (N)
             |                                        .117856   .2910675   (P)
             |                                       .1173203   .2900742  (BC)
             |                                       .1173203   .2900742 (BCa)
    drinkany |   4.5025044   .0024019   .59578279    3.334792   5.670217   (N)
             |                                       3.368253   5.692966   (P)
             |                                       3.405528   5.748656  (BC)
             |                                        3.41334   5.748656 (BCa)
       _cons |   46.682253   .1759177   3.4552918    39.91001    53.4545   (N)
             |                                       40.42489   54.07221   (P)
             |                                       39.84275   53.29212  (BC)
             |                                       39.93469   53.47001 (BCa)
------------------------------------------------------------------------------
(N)    normal confidence interval
(P)    percentile confidence interval
(BC)   bias-corrected confidence interval
(BCa)  bias-corrected and accelerated confidence interval

*/



// Lumley's argument is ok in this situation
// -----------------------------------------

estat bootstrap, all
estat bootstrap, percentile

* ================
* BETTER example ?
* ===============
