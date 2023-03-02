clear

use "/Users/mattb/Documents/School/QAMO/QAMO 5140/Empirical Exercise 5/dta/grades.dta"

gen nstudents=1
collapse (mean) grade (sum) nstudents [aw=coursecredits], by(course_name schy)

bys course_name (schyear): gen laspeyres_numerator = grade*nstudents[_n-1]
bys course_name (schyear): gen laspeyres_denominator = grade[_n-1]*nstudents[_n-1]

bys course_name (schyear): gen paasche_numerator = grade*nstudents
bys course_name (schyear): gen paasche_denominator = grade[_n-1]*nstudents

collapse (rawsum) laspeyres* paasche* (mean) grade [aw=nstudents], by(schyear)

gen laspeyres = laspeyres_numerator/laspeyres_denominator
gen paasche = paasche_numerator/paasche_denominator

gen fischer = sqrt(paasche*laspeyres)


foreach index in laspeyres paasche fischer {
	sum grade if schyear==1982
	gen `index'_grade = r(mean) if schyear==1982
	replace `index'_grade = `index'_grade[_n-1]*`index' if `index'_grade[_n-1]~=.
}


twoway line *_grade grade schyear
