*** Regression


eststo clear
eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region net_wealth ///
m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0 & region == 1, fe

esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_up.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region 1.house_owner) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Labor Hours\label{tab:reglh})
eststo clear



eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region net_wealth m_inc ///
i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0 & region == 1, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres2_up.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region 1.house_owner) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Wages\label{tab:regwage})
eststo clear


eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region net_wealth ///
m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0, fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt m_inc i.house_owner c.reg_house_price_exl#ibn.house_owner [aw = weight] ///
 if age<=40 & reg_house_price_exl > 0 & region == 1, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_u_up.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region 1.house_owner) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Unemployment\label{tab:regunemp})
eststo clear
