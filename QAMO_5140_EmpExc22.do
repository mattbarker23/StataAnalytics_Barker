clear

*importing data
import excel using "/Users/mattb/Documents/School/QAMO/QAMO 5140/Empirical Exercise 2/payroll_qamo5140_20220908.xlsx" , first

*** Step 1: drop data before 2007 and after 2012 ***
*option one: manual way: create var that numbers each observation 1 to N
*gen time = _n
*drop if time < 818 | time > 901

*option two: use stata dates to extract year:

gen mdate = monthly(DATE, "YM")
format mdate %tm
drop if yofd(dofm(mdate)) <  2007
drop if yofd(dofm(mdate)) > 2013

*keep variables we need
keep mdate EMPLOY08M12 EMPLOY10M12 EMPLOY22M8

*clean up variables and create index
sort mdate
gen time = _n

*dropping all string data types, (all N/A)
order time mdate
foreach var of varlist EMPLOY08M12 EMPLOY10M12 EMPLOY22M8 {
	destring `var', replace force
	sum `var' if time == 1
	replace `var' = `var' - r(mean)
}

*make the graph
twoway line EMPLOY* time, title("The Great Recession") subtitle("Real Time vs Today") ytitle("Cumulative Change in Employment") xtitle("Months Since Jan 2007") legend(lab(1 "2008")lab(2 "2010")lab(3 "Today")) graphregion(color(white))

