cd "H:\업무\자료요청\2022년\연구용\황정혜_211103\data"
set excelxlsxlargefile on

clear
set more off
import excel "03_SCREENDATA_SM_01_orgrslt.xlsx", firstrow case(preserve)
save "03_SCREENDATA_SM_01_orgrslt"

clear
set more off
import excel "03_SCREENDATA_SM_02_orgrslt.xlsx", firstrow case(preserve)
save "03_SCREENDATA_SM_02_orgrslt"

clear
set more off
use "03_SCREENDATA_SM_01_orgrslt"
append using "03_SCREENDATA_SM_02_orgrslt"
save "03_SCREENDATA_SM_orgrslt"

tab RSLT_GRP RSLT_GRP_ORG

cd "H:\업무\자료요청\2021년\DATA클리닝\PFT_210900\EXPORT_DATA\02_CONVERT"

clear
set more off
import excel "PFT_fvlfile.xlsx", firstrow case(preserve)
gen SM_YM = substr(SM_DATE,1,7)
save "PFT_fvlfile"

cd "H:\업무\자료요청\2022년\연구용\황정혜_211103\data"

clear
set more off
use PFT_fvlfile
drop fileinfo
gen CON = CDW_ID + SM_YM
gsort CON CDW_ID SM_DATE
by CON: gen SEQ=_n
tab SEQ
drop if SEQ == 2
drop SEQ
gen FVL_YN = "Y"
save "PFT_FVLlist"

clear
set more off
use 03_SCREENDATA_SM_orgrslt
gen CON = CDW_ID + SM_DATE_N
gsort CON CDW_ID SM_DATE_N GRP
by CON: gen SEQ=_n
// tab SEQ
// drop if SEQ == 2
drop SEQ
merge m:1 CON using PFT_FVLlist
drop if _merge == 2
drop SM_DATE SM_YM _merge CON
// save "03_SCREENDATA_SM_orgrslt_fvldata"
tab RSLT_GRP RSLT_GRP_ORG
export excel "03_SCREENDATA_SM_orgrslt_fvldata.xlsx", firstrow(variable)
export excel "03_SCREENDATA_SM_orgrslt_fvldata01.xlsx" if SM_DATE_N < "2013-01", firstrow(variable)
export excel "03_SCREENDATA_SM_orgrslt_fvldata02.xlsx" if SM_DATE_N > "2012-12", firstrow(variable)


/* 데이터 재편집을 생각해 보았으나, 일단 확인해 보니, 특화와 정규건진에 중복된 CASE가 있음.
clear
set more off
use "00_DATA"
keep PTNO CDW_ID SM_DATE CON GEND_CD AGE SM0101 SM0102 SM316001 SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 SM0450
order PTNO CDW_ID SM_DATE CON GEND_CD AGE SM0101 SM0102 SM316001 SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 SM0450
gen GRP = "1"
order GRP
save "00_1정규_PFT"

clear
set more off
use 02_ADD_DATA
gen GRP = "2"
order GRP
tostring AGE,replace
gen CON = PTNO + SM_DATE
order CON, after(SM_DATE)
save "00_2특화_PFT"

clear
set more off
use 00_1정규_PFT
append using 00_2특화_PFT
save "00_SM_PFT"

clear
set more off
forvalues SHEETNO = 1/8 {
clear
set more off
import excel "PFT CIS매칭시간.xls", sheet("Sheet `SHEETNO'") firstrow case(preserve)
save "PFT_CIS_INFO_`SHEETNO'"
}

clear
set more off
use PFT_CIS_INFO_1
forvalues num = 2/8{
append using "PFT_CIS_INFO_`num'"
}
save "PFT_CIS_MATCH"

clear
set more off
use "PFT_CIS_MATCH"
gen CON = PTNO+ORDR_YMD
rename ID CDW_ID
rename ORDR_YMD SM_DATE
rename DD CIS_MATCH
save "PFT_CIS_MATCH", replace

clear
set more off
use 00_SM_PFT
gsort CON GRP CDW_ID SM_DATE
by CON: gen SEQ=_n
tab SEQ
merge 1:1 CON using PFT_CIS_MATCH
*/

