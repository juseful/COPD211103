cd "H:\업무\자료요청\2022년\연구용\황정혜_211103\data"
set excelxlsxlargefile on

/* DRH 항목 검사결과 */
clear
set more off
forvalues year = 2005/2021 {
import excel "CL_RSLT_`year'.xls", firstrow case(preserve) allstring clear
tostring *, replace
save "CL_RSLT_`year'"
}

clear
set more off
use "CL_RSLT_2005"
forvalues year = 2006/2021 {
append using "CL_RSLT_`year'"
}
/* 배치db에서 추출한 문진 때문에 이렇게 함. */
gen CON = PTNO + SM_DATE
save "CL_RSLT"
// /* data distribution */
// gen YYYY = substr(SM_DATE,1,4)
// tab YYYY
// gsort CON PTNO SM_DATE
// by CON: gen SEQ =_n
// tab SEQ

/* 기타 항목 검사결과 */
clear
set more off
forvalues year = 2001/2020 {
import excel "UC_RSLT_`year'.xls", firstrow case(preserve) allstring clear
tostring *, replace
save "UC_RSLT_`year'"
}

clear
set more off
use "UC_RSLT_2001"
forvalues year = 2002/2020 {
append using "UC_RSLT_`year'"
}
/* 배치db에서 추출한 문진 때문에 이렇게 함. */
gen CON = PTNO + SM_DATE
save "UC_RSLT"

// /* data distribution */
// gen YYYY = substr(SM_DATE,1,4)
// tab YYYY
// gsort CON PTNO SM_DATE
// by CON: gen SEQ =_n
// tab SEQ

/* 문진결과 */
clear
set more off
forvalues year = 2001/2016 {
import excel "QUESAT_`year'.xls", firstrow case(preserve) allstring clear
tostring *, replace
save "QUESAT_`year'"
}

clear
set more off
import excel "QUESAT_2017.xlsx", firstrow case(preserve) allstring clear
tostring *, replace
save "QUESAT_2017"

clear
set more off
use "QUESAT_2001"
forvalues year = 2002/2017 {
append using "QUESAT_`year'"
}
/* 배치db에서 추출한 문진 때문에 이렇게 함. */
gen CON = PTNO + SM_DATE
save "QUESAT"

// /* data distribution */
// gen YYYY = substr(SM_DATE,1,4)
// tab YYYY
// gsort CON PTNO SM_DATE
// by CON: gen SEQ =_n
// tab SEQ

clear
set more off
import excel "lung_cancer.xlsx", firstrow case(preserve) allstring clear
keep PTNO ORDR_YMD AFI_RTUR_VL	HLSC_CTRL_CHRC_VL2	EXMN_CD	CLNC_PTHL_ORDR_SHRT_NM	SPCC_DISS_RSLT_CD	RSLT_CD_NM	FNSH_YN	CMNT_CTN	AFI_MNVT_CTN	AFI_MNVT_CTN1	AFI_MNVT_CTN2	FLUP_YMD	FLUP_CNFR_YN
gen CON = PTNO + ORDR_YMD
// gsort CON PTNO ORDR_YMD
// by CON: gen SEQ =_n
// tab SEQ
drop if PTNO == "03300625" & EXMN_CD =="BL3712"
drop if PTNO == "04783515" & EXMN_CD =="RG010P"
save "SM_CANCER", replace

clear
use "cal_data"
drop index GENDER AGE SM0101 SM0102 SM316001 SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 FVC__DIFF
save "CAL_DATA_FIN"

clear
set more off
import excel "외래폐암진단이력.xlsx", firstrow case(preserve) allstring clear
save "MED_CANCER"

clear
set more off
import excel "행안부사망확인명단_deID.xlsx", firstrow case(preserve) allstring clear
rename 사망신고일 DEATHYMD_MOIS
rename 행안부확인일 DEATHYMD_MOIS_VER
save "MOIS_D"

clear
set more off
use "CL_RSLT"
merge 1:1 CON using "UC_RSLT"
drop if _merge!=3
// count if SM0401 ==""
// count if SM040101 ==""
// count if SM0402 ==""
// count if SM040201 ==""
// count if SM0403 ==""
// count if SM0404 ==""
// count if SM040401 ==""
// count if SM0405 ==""
// count if SM040501 ==""
// count if SM0450==""
drop if SM040101 == ""
drop _merge
merge 1:1 CON using "QUESAT"
drop if _merge == 2
drop _merge
merge 1:1 CON using "SM_CANCER"
drop if _merge == 2
gen SM_DATE_N = substr(SM_DATE,1,7)
order SM_DATE_N, after(SM_DATE)
drop _merge
merge 1:1 CON using "CAL_DATA_FIN"
drop if _merge == 2
order pred_fvc pred_FEV1 pred_FEV1_FVC cal_fvc_ cal_FEV1_ RSLT_GRP SEVERITY, after(SM0450)
drop _merge
merge m:1 CDW_ID using "MED_CANCER"
drop if _merge == 2
drop _merge
merge m:1 CDW_ID using "MOIS_D"
drop if _merge == 2
drop _merge ORDR_YMD
rename pred_fvc	PRED_SM0401
rename pred_FEV1 PRED_SM0402
rename pred_FEV1_FVC PRED_SM0403
rename cal_fvc_ CAL_SM040101
rename cal_FEV1_ CAL_SM040201
save "00_DATA", replace

clear
set more off
use "00_DATA"
drop PTNO CON SM_DATE SM0101 SM0102
// forvalues year = 2001/2020 {
// export excel "DATA_`year'.xlsx" if substr(SM_DATE_N,1,4) == "`year'", firstrow(variable)
// }
//
// /* temp work */
export excel "DATA_SAMPLE.xlsx" if substr(SM_DATE_N,1,4) == "2020", firstrow(variable)
rename GEND_CD GENDER
keep PTNO SM_DATE CON GENDER AGE SM0101 SM0102 SM316001 SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 SM0450
order PTNO SM_DATE CON GENDER AGE SM0101 SM0102 SM316001 SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 SM0450
save "cal_data_org", replace
tab AGE

/* data screening */
clear
set more off
use "00_DATA"
gen yyyy = substr(SM_DATE_N,1,4)
keep CDW_ID SM_DATE_N GEND_CD AGE yyyy SM0401 SM040101 SM0402 SM040201 SM0403 SM0404 SM040401 SM0405 SM040501 SM0450 PRED_SM0401 PRED_SM0402 PRED_SM0403 CAL_SM040101 CAL_SM040201 RSLT_GRP SEVERITY
save "01_SCREENDATA"
// tab RSLT_GRP SEVERITY
export excel "DATA_SCREEN.xlsx", firstrow(variable)

clear
set more off
use 01_SCREENDATA
gsort CDW_ID SM_DATE_N
by CDW_ID: gen SEQ=_n
drop if SEQ != 1
tab yyyy GEND_CD
export excel "01_SCREENDATA.xlsx", firstrow(variable)

table category, c(sum total)

collapse (count) cell = RSLT_GRP, by(GEND_CD yyyy)
reshape wide cell, i(time) j(X2) string
rename cell* *

clear
set more off
use 01_SCREENDATA
keep if CDW_ID == "2D8F02F9BA87" || CDW_ID == "06B59866AE7B" || CDW_ID == "9B53A05BDB75" || CDW_ID == "FB96857E4F39"
export excel "09_SAMPLE.xlsx", firstrow(variable)

clear
set more off
import excel "cal_data_add_lca.xlsx", firstrow case(preserve)
gen SM_DATE_N = substr(SM_DATE,1,7)
order SM_DATE_N, after(SM_DATE)
gen yyyy = substr(SM_DATE_N,1,4)
drop PTNO  SM_DATE SM0101 SM0102
tostring AGE - SM040501, replace
gen GRP = "02.특화"
save "02_SCREENDATA_특화"

clear
set more off
import excel "외래폐기능 검사결과_수정.xlsx", firstrow case(preserve)
tostring AGE, replace
gen SM_DATE = string(SM_DATE_1ST, "%tdCCYY-NN-DD") /* 기존의 숫자로 된 날짜 값을 string으로 변경 */
gen FVC_ENFR_DT = string(O_FVC_ENFR_DT, "%tcCCYY-NN-DD_HH:MM:SS") /* 기존의 숫자로 된 날짜 값을 string으로 변경 */
order SM_DATE, after(CDW_ID)
order FVC_ENFR_DT, after(GEND_CD)
drop SM_DATE_1ST O_FVC_ENFR_DT
tostring *, replace
/* tosting으로 null 값이 "."로 replace된 값 제거 */
foreach var of varlist * {
	replace `var' = "" if `var' == "."
}
save "03_SCREENDATA_외래"

clear
set more off
use "02_SCREENDATA_특화"
order GRP
foreach var of varlist SM0401-SM040501 {
	replace `var' = "" if `var' == "."
}
rename pred_fvc	PRED_SM0401
rename pred_FEV1 PRED_SM0402
rename pred_FEV1FVC PRED_SM0403
rename cal_fvc CAL_SM040101
rename cal_FEV1 CAL_SM040201
rename GENDER GEND_CD
drop FVC_DIFF
save "02_SCREENDATA_특화", replace

clear
set more off
use "01_SCREENDATA"
gen GRP = "01.정규"
order GRP
append using "02_SCREENDATA_특화"
save "03_SCREENDATA_SM"

clear
set more off
use "03_SCREENDATA_SM"
export excel "03_SCREENDATA_SM.xlsx", firstrow(variable)
tab yyyy
// export excel "03_SCREENDATA_SM.xlsx", firstrow(variable)
drop yyyy
export excel "03_SCREENDATA_SM_01.xlsx" if SM_DATE_N < "2013-01" , firstrow(variable)
export excel "03_SCREENDATA_SM_02.xlsx" if SM_DATE_N > "2012-12" , firstrow(variable)
// export delimited "03_SCREENDATA_SM.csv"

clear
set more off
use "03_SCREENDATA_외래"
export excel "03_SCREENDATA_외래.xlsx", firstrow(variable)
export delimited "03_SCREENDATA_외래.csv"

/* 20220210 최종 반출 대상자 확정 후 */
/* 특화 LCA DATA 정리 */
clear
set more off
use 02_ADD_DATA
gen CON = CDW_ID + SM_DATE
gsort CON
by CON: gen SEQ=_n
tab SEQ
drop if SEQ == 2
drop CON SEQ
save 02_ADD_DATA, replace

clear
set more off
import excel "lca_cal_data.xlsx", firstrow case(preserve)
gen CON = CDW_ID + SM_DATE
drop SM0101-SM0450
save 02_ADD_DATA_LCA, replace

clear
set more off
use 02_ADD_DATA
gen CON = CDW_ID + SM_DATE
merge 1:1 CON using 02_ADD_DATA_LCA
rename pred_fvc	PRED_SM0401
rename pred_FEV1 PRED_SM0402
rename pred_FEV1FVC PRED_SM0403
rename cal_fvc CAL_SM040101
rename cal_FEV1 CAL_SM040201
drop _merge
tostring AGE, replace
drop CON
gen CON = PTNO + SM_DATE
gen SM_DATE_N = substr(SM_DATE,1,7)
order SM_DATE_N, after(SM_DATE)
drop GENDER FVC_DIFF
save 02_ADD_DATA_CALCULATED, replace

/* LCA DATA APPEND */
clear
set more off
use 00_DATA
append using 02_ADD_DATA_CALCULATED
gsort CON -BL2011 // 데이터 추출시 멀티 패키지 CASE 제외를 못했음. 정규건진인 DATA만 남겨두기 위함.
by CON: gen SEQ=_n
tab SEQ
drop if SEQ ==2
drop SEQ
gen CON2 = CDW_ID + SM_DATE_N
save 00_DATA_220215, replace

clear
set more off
use 00_DATA_220215
gsort CON2 SM_DATE // 데이터 추출시 멀티 패키지 CASE 제외를 못했음. 정규건진인 DATA만 남겨두기 위함.
by CON2: gen SEQ=_n
tab SEQ
drop SEQ

/* 최종대상자 데이터와 merge */
clear
set more off
import delimited using abnormal_with_sm_fvl, varnames(1)
tab fvl_yn

clear
set more off
import delimited using normal_with_sm_fvl, varnames(1)
tab fvl_yn

clear
set more off
import delimited using normal_with_sm_fvl, varnames(1)
rename cdw_id CDW_ID
rename sm_date_n SM_DATE_N
gen CON2 = CDW_ID + SM_DATE_N
merge 1:m CON2 using 00_DATA_220215
// drop if _merge != 1
drop if _merge != 3
// drop if _merge == 2
drop _merge CON2 CON
order PTNO SM_DATE_N
save 00_01_NORMAL_220223_SM

// clear
// set more off
// import delimited using normal_only_first, varnames(1)
// rename cdw_id CDW_ID
// rename sm_date_n SM_DATE_N
// gen CON2 = CDW_ID + SM_DATE_N
// merge 1:m CON2 using 00_DATA_220215
// // drop if _merge != 1
// drop if _merge != 3
// // drop if _merge == 2
// drop _merge CDW_ID CON2 SM_DATE CON
// order PTNO SM_DATE_N
// save 00_01_NORMAL_220221

clear
set more off
import delimited using abnormal_with_sm_fvl, varnames(1)
rename cdw_id CDW_ID
rename sm_date_n SM_DATE_N
gen CON2 = CDW_ID + SM_DATE_N
gsort CON2 SM_DATE_N
by CON2: gen SEQ=_n
tab SEQ
// drop if SEQ == 2
drop SEQ
merge 1:m CON2 using 00_DATA_220215
// drop if _merge != 1
drop if _merge != 3
// drop if _merge == 2
drop _merge CON2 CON
order PTNO SM_DATE_N
save 00_02_ABNORMAL_220223_SM

clear
set more off
use 03_SCREENDATA_외래
gen CON = CDW_ID + FVC_ENFR_DT
save 03_SCREENDATA_외래, replace

clear
set more off
import delimited using abnormal_with_sm_fvl, varnames(1)
rename cdw_id CDW_ID
rename sm_date_n SM_DATE_N
drop if fvc_enfr_dt == ""
gen CON = CDW_ID + fvc_enfr_dt
// gen CON2 = CDW_ID + SM_DATE_N
gsort CON fvc_enfr_dt
by CON: gen SEQ=_n
tab SEQ
// drop if SEQ == 2
drop SEQ
merge 1:1 CON using 03_SCREENDATA_외래
drop if _merge != 3
drop _merge SM_DATE FVC_ENFR_DT CON
save 00_02_ABNORMAL_220223_OUT
tab fvl_yn

// clear
// set more off
// import delimited using abnormal, varnames(1)
// rename cdw_id CDW_ID
// rename sm_date_n SM_DATE_N
// gen CON2 = CDW_ID + SM_DATE_N
// gsort CON2 SM_DATE_N
// by CON2: gen SEQ=_n
// tab SEQ
// drop if SEQ == 2
// drop SEQ
// merge 1:m CON2 using 00_DATA_220215
// // drop if _merge != 1
// drop if _merge != 3
// // drop if _merge == 2
// drop _merge CDW_ID CON2 SM_DATE CON
// order PTNO SM_DATE_N
// save 00_02_ABNORMAL_220221

/* DATA EXPORT */
// clear
// set more off
// use 00_01_NORMAL_220221
// export excel "DATA_01_NORMAL.xlsx", firstrow(variables)
clear
set more off
use 00_01_NORMAL_220223_SM
export excel "DATA_01_NORMAL.xlsx", firstrow(variables)
//
// clear
// set more off
// use 00_02_ABNORMAL_220221
// export excel "DATA_02_ABNORMAL.xlsx", firstrow(variables)
clear
set more off
use 00_02_ABNORMAL_220223_SM
export excel "DATA_02_ABNORMAL.xlsx", firstrow(variables)

clear
set more off
use 00_02_ABNORMAL_220223_OUT
export excel "DATA_03_ABNORMAL_외래.xlsx", firstrow(variables)

/* fvl file extract */
clear
set more off
import excel "DATA_04_FVL_EXPORT_SAMPLE.xlsx", firstrow case(preserve)
save DATA_04_FVL_EXPORT_SAMPLE

clear
set more off
import excel "DATA_04_FVL_EXPORT.xlsx", firstrow case(preserve)
save DATA_04_FVL_EXPORT

// 누락자 재정리
clear
set more off
import excel "DATA_04_FVL_EXPORT_ADD.xlsx", firstrow case(preserve)
save DATA_04_FVL_EXPORT_ADD

clear
set more off
use PFT_fvlfile

