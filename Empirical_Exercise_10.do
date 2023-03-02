clear 

use "/Users/mattb/Documents/School/QAMO/QAMO 5140/Empirical Exercise 10/dta/oaxaca_data.dta"

keep if age>24 & age<55

gen female=sex==2

gen married=mars==1
gen college=educ>100
gen young_child=nchlt5>0

gen lfpr=lab==2

tabstat college young_child married lfpr [aw=asecwt], by(female)

reg lfpr college young_child married female [aw=asecwt]

reg lfpr college young_child married if female==0 [aw=asecwt]

reg lfpr college young_child married if female==1 [aw=asecwt]
