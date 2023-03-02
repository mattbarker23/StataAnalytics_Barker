clear

import excel using "/Users/mattb/Documents/School/QAMO/QAMO 5140/Empirical Exercise 4/fred_pce_gdp.xlsx" , first

merge 1:1 year using "/Users/mattb/Documents/School/QAMO/QAMO 5140/Empirical Exercise 4/bernanke_olson_inputs.dta", keep(match) nogen

*generate variables

*% of time in leisure
gen leisure = 1-(hours*employment/pop)/(365*16)

gen value_leisure= -1*14.17275/2 * (1-leisure)^2

*consumption gdp
gen log_consumption = ln(pce/pop)
gen log_gdp = ln(gdp/pop)

*inequality
gen half_var_consumption = -1*((sqrt(2)*invnormal((1+gini)/2))^2)/2

* flow of utility
gen utility = log_consumption+value_leisure+half_var_consumption+5.2325

*construct indexes
sum expectancy if year==1979
gen index_expectancy = (expectancy/r(mean)-1)

foreach var of varlist log_consumption value_leisure half_var_consumption log_gdp{
	sum `var' if year==1979
	gen index_`var' = `var' - r(mean)	
}

egen log_lambda = rsum(index_expectancy index_log_consumption index_value index_half_var)

twoway line log_lambda log_gdp year
// twoway line index_log_consumption year

// graph bar index* if year==2021
