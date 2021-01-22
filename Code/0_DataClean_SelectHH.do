
* KLIPS Data cleaning
* Select only for the head of household

clear
set more off
cd "c:\data\KLIPS\data"

local year 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22

foreach y of local year{



use ".\klips`y'p.dta", replace

gen year = 20`y' - 3

* Only household head
drop if p`y'0102 != 10


* Demographics
rename p`y'0101 sex
rename p`y'0107 age
rename p`y'0110 edu



merge m:m hhid`y' using ".\klips`y'h.dta", keepusing(h`y'0141 h`y'0142 h`y'0150 ///
h`y'1406 h`y'1410 h`y'1412 h`y'1413 h`y'1414 h`y'2512 h`y'2513 ///
h`y'2562 h`y'2564 h`y'2566 h`y'2568 h`y'2570 h`y'2572 ///
h`y'2602 h`y'2605 h`y'2608 h`y'2611 h`y'2614 h`y'2617 h`y'1401)
drop if _merge == 2
drop _merge

rename h`y'0141 region
rename h`y'0142 region2
rename h`y'0150 num_fam
rename h`y'1401 moving

rename h`y'1406 house_own
rename h`y'1410 house_size
rename h`y'1412 house_price
rename h`y'1413 house_col
rename h`y'1414 house_rent

* Build housing wealth
rename h`y'2512 house_wealth
replace house_wealth = 500 if h`y'2513 == 1
replace house_wealth = 1750 if h`y'2513 == 2
replace house_wealth = 3750 if h`y'2513 == 3
replace house_wealth = 6250 if h`y'2513 == 4
replace house_wealth = 8750 if h`y'2513 == 5
replace house_wealth = 15000 if h`y'2513 == 6
replace house_wealth = 25000 if h`y'2513 == 7
replace house_wealth = 35000 if h`y'2513 == 8
replace house_wealth = 45000 if h`y'2513 == 9
replace house_wealth = 75000 if h`y'2513 == 10
replace house_wealth = 150000 if h`y'2513 == 11

* Build financial wealth
local wel_num 2562 2564 2566 2568 2570 2572
foreach qnum of local wel_num{
replace h`y'`qnum' = 0 if missing(h`y'`qnum')
}
gen fin_wealth = h`y'2562 + h`y'2564 + h`y'2566 + h`y'2568 + h`y'2570 + h`y'2572


* Build financial debt
local debt_num 2602 2605 2608 2611 2614 2617
foreach qnum2 of local debt_num{
replace h`y'`qnum2' = 0 if missing(h`y'`qnum2')
}
gen fin_debt = h`y'2602 + h`y'2605 + h`y'2608 + h`y'2611 + h`y'2614 + h`y'2614


* labor market variables
rename p`y'1642 wage
gen lab_hour = p`y'1004 if p`y'1003 == 2
replace lab_hour = p`y'1006 if p`y'1003 == 1
rename p`y'0340 ind
rename p`y'0350 occ



* About job change status
rename p`y'0301 job_st_year
gen job_ch = 1 if job_st_year == year
replace job_ch = 0 if job_st_year < year
gen tenure = year - job_st_year

* labor market status
rename p`y'0211 emp_stat
gen unemp = 1 if p`y'2801 == 1 | p`y'2802 == 1
replace unemp = 0 if !missing(jobclass)
gen OLF = 1 if missing(jobclass) & missing(unemp)
replace OLF = 0 if !missing(unemp)



* weight
rename w`y'p_l weight_l
rename w`y'p_c weight_c


keep year pid sex age edu region region2 num_fam house_own house_size house_price ///
house_col house_rent house_wealth fin_wealth fin_debt wage lab_hour tenure job_ch ///
emp_stat unemp OLF weight_l weight_c ind occ moving
 
save ".\KLIPS`y'clean.dta", replace
}




use ".\KLIPS02clean.dta"
local y2 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22

foreach z of local y2{
append using ".\KLIPS`z'clean.dta"
}
save ".\KLIPSclean_full.dta", replace