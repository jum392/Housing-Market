
** After runnign Analysis.do

collapse unique_region reg_house_price2 weight_c reg_num, ///
by(region region2 year)

xtset unique_region year
gen Lphr = L.reg_house_price2
gen wgt = weight_c * reg_num
bysort:unqiue_region: egen weight = mean(wgt)

xtreg reg_house_price2 i.year L.reg_house_price2 [aw = weight], fe
predict reg_HP_cyc, residual

save ".\RegionalReg.dta", replace
