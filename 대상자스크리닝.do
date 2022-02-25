cd "H:\업무\자료요청\2021년\연구용\황정혜_2111xx"
set excelxlsxlargefile on

clear
import excel "COPD-연구-스크리닝-정규건진.xlsx", firstrow case(preserve)
rename 처방코드5 ORDR_CD
rename 처방일자6 ORDR_YMD
gen SM_DATE = string(ORDR_YMD, "%tcCCYY-NN-DD") /* 기존의 숫자로 된 날짜 값을 string으로 변경 */
gen SM_DATE01 = substr(SM_DATE,1,7)
gen DD_CHK = "-91" if substr(SM_DATE,9,2) < "11"
replace DD_CHK = "-92" if "10" < substr(SM_DATE,9,2) // < "21"
replace DD_CHK = "-93" if "20" < substr(SM_DATE,9,2) 
gen CON1 = 환자번호1+SM_DATE01
gen CON2 = 환자번호1+SM_DATE01+DD_CHK
save "PFT"

clear
use "PFT"
gsort CON1 SM_DATE
by CON1: gen SEQ1=_n
gsort CON2 SM_DATE
by CON2: gen SEQ2=_n
tab SEQ1
tab SEQ2

clear
set more off
import excel "COPD-연구-PFT-최정근식-보정값-확인_CHECK.xlsx", firstrow case(preserve)
gen SM_DATE = string(건진일자2, "%tdCCYY-NN-DD") /* 기존의 숫자로 된 날짜 값을 string으로 변경 */
order SM_DATE, after(CDW_ID)
drop 건진일자2
drop if SM0401 == ""
save "PFT_CORR"
gen YYYY = substr(SM_DATE,1,4)
order YYYY
gen SM_DATE01 = substr(SM_DATE,1,7)
gen CON1 = CDW_ID+SM_DATE01
gsort CON1 SM_DATE
by CON1: gen SEQ1=_n
tab SEQ1
drop if SEQ1 != 1
save "PFT_CORR", replace
