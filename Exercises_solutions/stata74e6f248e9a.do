## Stata code

clear
import delimited "https://www.dropbox.com/scl/fi/9dtsid3cpziubhhuw9hhy/hers_subset.csv?rlkey=vainwt6vtbbo2kuqidv0e24v9&st=k5r7e42w&dl=1"
encode  exercise, gen(exercise_r)
encode drinkany , gen(drinkany_r)

drop if diabetes == "yes"

regress glucose i.exercise_r age i.drinkany_r bmi 

