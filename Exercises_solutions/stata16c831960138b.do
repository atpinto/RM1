import delimited "https://www.dropbox.com/s/t0ml83xesaaazd0/hers_subset.csv?dl=1"
reg dbp bmi

lincom _cons + 28*bmi

set obs 277
replace bmi = 28 in 277
predict fitDBP
predict seprDBP, stdf
gen upper = fitDBP + 1.96*seprDBP in 277
gen lower = fitDBP -1.96*seprDBP in 277

list bmi fitDBP lower upper in 277

