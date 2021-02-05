
clear

cd "c:\data\KLIPS\data"
use ".\KLIPSclean_full.dta"


set matsize 5000
set more off

merge m:1 year using ".\CPI_yearly.dta"
drop if _merge == 2
drop _merge

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


egen mdsum = sum(moving), by(pid)
gen mover_dum = 1 if mdsum > 0
replace mover_dum = 0 if mdsum == 0

egen regsum = sum(reg_ch), by(pid)
gen reg_ch_dum = 1 if regsum > 0
replace reg_ch_dum = 0 if regsum == 0 

** Generate unique region id
gen unique_region = 100*region + region2


** Unexpected (cyclical component HP)
reg reg_house_price2 i.year i.unique_region i.unique_region#c.year ///
[aw = weight] if reg_house_price_exl > 0 & reg_num >= 10
predict reg_HP_cyc, residual


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


gen age2 = age * age

label variable lnw_h "Hourly wage"
label define ownership 0 "Renter" 1 "Owner"
label value house_owner ownership
label variable reg_house_price_exl "Reg.HP"
label variable age "Age"
label variable age2 "Age**2"
label variable m_inc "Income"

fvset base 1 house_owner
