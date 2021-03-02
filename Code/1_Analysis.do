
clear

local user = 1 // 1 = JM, 2 = IC

if `user' == 1 {
  cd "c:\data\KLIPS\data"
  use ".\KLIPSclean_full.dta", clear
}
if `user' == 2 {
  use "../Temp/KLIPSclean_full.dta", clear
}


set matsize 5000
set more off

/*
(if `user' == 1) merge m:1 year using ".\CPI_yearly.dta"
(if `user' == 2) merge m:1 year using "../Data/CPI_yearly.dta"
drop if _merge == 2
drop _merge
*/

** Generate unique region id
gen unique_region = 100*region + region2


** Unexpected (cyclical component HP)
if (`user' == 1) merge m:1 unique_region year using "RegionalReg.dta", keepusing(reg_HP_cyc reg_HP_cyc2 reg_HP_cyc3 reg_HP_trd)
if (`user' == 2) merge m:1 unique_region year using "../Temp/RegionalReg.dta", keepusing(reg_HP_cyc reg_HP_cyc2 reg_HP_cyc3 reg_HP_trd)


gen lnw = ln(wage)


** Drop unnecessary sample
drop if edu <0
drop if house_own < 0
drop if region2 < 0


** Only focus on age 18 ~ 70
drop if age > 70
drop if age < 18
drop if ind < 0
drop if occ < 0
drop if lab_hour < 0
drop if moving < 0

xtset pid year
gen dlnw = lnw - L.lnw
gen lnhour = ln(lab_hour)
bysort pid: egen weight = mean(weight_l)

gen employ = 1 if unemp == 0
replace employ = 0 if unemp == 1 | OLF == 1


** Generate house owner state
gen house_owner = 1 if house_own == 1
replace house_owner = 0 if house_own != 1
egen house_owner_year = sum(house_owner), by(pid)
gen house_own_ever = 1 if house_owner_year > 0
replace house_own_ever = 0 if house_owner_year == 0




replace house_price = . if house_price < 0
egen reg_house_price = wtmean(house_price), weight(weight_c) by(region year)
egen reg_house_price2 = wtmean(house_price), weight(weight_c) by(region region2 year)
egen reg_ownership = wtmean(house_owner), weight(weight_c) by(region region2 year)
egen reg_unemployment = wtmean(unemp), weight(weight_c) by(region region2 year)
gen dum = 1
egen reg_num = sum(dum), by(region region2 year)
drop dum
gen reg_up10 = 1 if reg_num >= 10
replace reg_up10 = 0 if reg_num < 10
egen reg_up10dum = mean(reg_up10), by(region region2)


egen all_house_price = wtmean(house_price), weight(weight_c) by(year)
egen all_ownership = wtmean(house_owner), weight(weight_c) by(year)


** Generate regional average price excluding own price
gen whp = house_price * weight_c
replace whp = 0 if missing(house_price)
gen weight_dum = weight_c
replace weight_dum = 0 if missing(house_price)
egen weight_sum = sum(weight_dum), by(region region2 year)
egen reg_house_sum = sum(whp), by(region region2 year)
gen reg_house_price_exl = reg_house_sum / weight_sum if whp == 0
replace reg_house_price_exl = (reg_house_sum - whp)/(weight_sum - weight_c) if whp != 0
replace reg_house_price_exl = reg_house_price_exl




gen dum_young = 1 if age <= 40
replace dum_young = 0 if age > 40

gen ln_wealth = ln(fin_wealth)
gen ln_debt = ln(fin_debt)
replace m_inc = m_inc

gen house_purchase = 1 if house_owner == 1 & L.house_owner == 0
replace house_purchase = 0 if missing(house_purchase)

gen unit_wage = wage / (lab_hour * (7/30))
gen lnw_h = ln(unit_wage)

replace house_wealth = 0 if house_owner == 0 & missing(house_wealth)
gen tot_wealth = fin_wealth + house_wealth
replace tot_wealth = tot_wealth + house_col if house_owner == 0
gen net_wealth = tot_wealth - fin_debt


** Moving dummy
replace moving = 0 if moving == 2


** Generate region change dummy
gen reg_ch = 1 if region != L.region
replace reg_ch = 1 if region == L.region & region2 != L.region2
replace reg_ch = 0 if region == L.region & region2 == L.region2
replace reg_ch = 0 if year == 1999

gen metro = 1 if region == 1 | region == 8
replace metro = 0 if missing(metro)

gen Lmetro = L.metro
gen young = 1 if age <= 40
replace young = 0 if age > 40

egen mdsum = sum(moving), by(pid)
gen mover_dum = 1 if mdsum > 0
replace mover_dum = 0 if mdsum == 0

egen regsum = sum(reg_ch), by(pid)
gen reg_ch_dum = 1 if regsum > 0
replace reg_ch_dum = 0 if regsum == 0

** Build tradable sectors
gen ind1 = 1 if ind >= 100 & ind < 350
replace ind1 = 0 if missing(ind1) & !missing(ind)
gen ind2 = 1 if ind >= 580 & ind < 680
replace ind2 = 0 if missing(ind2) & !missing(ind)
gen ind3 = 1 if ind >= 700 & ind < 740
replace ind3 = 0 if missing(ind3) & !missing(ind)
gen ind4 = 1 if ind < 100
replace ind4 = 0 if missing(ind4) & !missing(ind)

by pid: gen numob = _n
gen trd = 1 if (ind1 == 1 | ind2 == 1 | ind3 == 1 | ind4 == 1) & numob == 1
replace trd = 0 if missing(trd) & !missing(ind) & numob == 1
replace trd = 1 if (ind1 == 1 | ind2 == 1 | ind3 == 1 | ind4 ==1) & numob == 2 & (L.OLF == 1 | L.unemp == 1)
replace trd = 0 if missing(trd) & numob == 2 & (L.OLF == 1 | L.unemp == 1)

egen dum_trd = sum(trd), by(pid)

gen trd2 = 1 if (ind1 == 1 | ind2 == 1 | ind3 == 1) & numob == 1
replace trd2 = 0 if missing(trd2) & !missing(ind) & numob == 1 & ind4 == 0
replace trd2 = 1 if (ind1 == 1 | ind2 == 1 | ind3 == 1) & numob == 2 & (L.OLF == 1 | L.unemp == 1)
replace trd2 = 0 if missing(trd2) & numob == 2 & (L.OLF == 1 | L.unemp == 1) & ind4 == 0
replace trd2 = -1 if ind4 == 1 & numob == 1
replace trd2 = -1 if missing(L.trd2) & ind4 == 1 & numob == 2

egen dum_trd2 = sum(trd2), by(pid)
replace dum_trd2 = . if dum_trd2 < 0

gen dum_trd3 = 1 if (L.ind1 == 1 | L.ind2 == 1 | L.ind3 == 1 )
replace dum_trd3 = 0 if L.ind1 == 0 & L.ind2 == 0 & L.ind3 == 0

gen fam = 1 if emp_stat == 3
replace fam = 0 if missing(fam)
egen dum_fam = sum(fam), by(pid)

gen age2 = age * age

gen emp2 = 1 if unemp == 0
replace emp2 = 0 if unemp == 1

gen LF = 1 if OLF == 0
replace LF = 0 if OLF == 1

gen Lhouse_owner = 1 if L.house_owner == 1
replace Lhouse_owner = 0 if L.house_owner == 0

* Unit change
replace reg_HP_cyc = reg_HP_cyc / 10000
replace tot_wealth = tot_wealth / 10000
replace fin_debt = fin_debt / 10000


label variable lnw_h "Hourly wage"
label define ownership 0 "Renter" 1 "Owner"
label value house_owner ownership
label value Lhouse_owner ownership
label variable reg_house_price_exl "Reg.HP"
label variable age "Age"
label variable age2 "Age**2"
label variable m_inc "Income"
label define young2 0 "Old" 1 "Young"
label value young young2
label define trd 0 "Services" 1 "Tradable"
label value dum_trd trd
label value dum_trd2 trd
label variable reg_HP_cyc "Reg.HP.Cyc"
label variable reg_HP_cyc2 "Reg.HP.Cyc"

label variable num_fam "Num. of Family"
label define child 0 "Child:None" 1 "Have children"
label value school_child child
label variable tot_wealth "Wealth"
label variable fin_debt "Fin.Debt"
label variable consumption "Consumption"
label variable nh_consumption "Consumption(Non-housing)"
label variable food_consumption "Food consumption"

fvset base 1 house_owner
if (`user' == 2) save "../Output/klips_final.dta", replace
