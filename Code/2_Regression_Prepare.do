*** Regression



eststo clear
eststo: xtreg lab_hour lnw_h c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight], fe

eststo: xtreg lab_hour lnw_h c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40, fe

eststo: xtreg lab_hour lnw_h c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40 & region == 1, fe

eststo: xtreg lab_hour lnw_h c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if ind >= 100 & ind <= 400, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Labor Hours\label{tab:reglh})
eststo clear



eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight], fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40, fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40 & region == 1, fe

eststo: xtreg lab_hour c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if ind >= 100 & ind <= 400, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_m.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Labor Hours\label{tab:reglh2})
eststo clear


eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight], fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40, fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40 & region == 1, fe

eststo: xtreg unemp c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if ind >= 100 & ind <= 400, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_u.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Unemployment\label{tab:regunemp})
eststo clear



eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if moving == 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40 & moving == 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if age <= 40 & region == 1 & moving == 0, fe

eststo: xtreg lnw c.age c.age2 i.year i.unique_region tot_wealth ///
fin_debt c.reg_house_price_exl#ibn.house_owner [aw = weight] if ind >= 100 & ind <= 400 & moving == 0, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres2.tex", replace label nobaselevels compress noconstant interaction(*) ///
 se ar2 ///
 drop(*.year *.unique_region) star(* 0.1 ** 0.05 *** 0.01) booktabs noconstant title(Wages\label{tab:regwage})
eststo clear
