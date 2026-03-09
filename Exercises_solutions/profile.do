/* Part a */
import delimited "https://www.dropbox.com/s/t0ml83xesaaazd0/hers_subset.csv?dl=1", clear

reg dbp bmi
/* Part b*/
gen bmi5 = bmi / 5
reg dbp bmi5
/*Compute*/
  disp tprob(274,2.2)
