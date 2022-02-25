cd "H:\업무\자료요청\2022년\연구용\황정혜_211103\data_add"
set excelxlsxlargefile on

clear
set more off
forvalue yyyy = 2001/2020{
clear
set more off
import excel "특화_`yyyy'.xls", firstrow case(preserve)
tostring SM0101 - SM0450, replace
save "특화_`yyyy'"
}

clear
set more off
use 특화_2001
forvalue yyyy = 2001/2020{
append using "특화_`yyyy'"
}
foreach var of varlist SM0101 - SM0450 {
	replace `var' = "" if `var' == "."
}
save 02_ADD_DATA

clear
set more off
use 02_ADD_DATA
