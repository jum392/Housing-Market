*xtreg lab_hour c.age c.age2 i.year tot_wealth fin_debt reg_unemployment L.i.house_owner c.reg_HP_cyc#L.i.house_owner i.school_child num_fam ///
* [aw = weight] if reg_num >= 10 & year >= 2011, fe

*xtreg unemp c.age c.age2 i.year tot_wealth fin_debt L.i.house_owner i.young i.young#L.i.house_owner#c.reg_HP_cyc i.school_child num_fam ///
* [aw = weight] if reg_num >= 10 & age >= 22, fe



eststo clear
eststo:  xtreg consumption c.age c.age2 i.year tot_wealth fin_debt m_inc i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

eststo: xtreg nh_consumption c.age c.age2 i.year tot_wealth fin_debt m_inc i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

eststo: xtreg food_consumption c.age c.age2 i.year tot_wealth fin_debt m_inc i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_con.tex", replace label compress interaction(*) ///
 se ar2 wide b(4) se(4) ///
 drop(*.year 0.Lhouse_owner 0.school_child 0.young) star(* 0.1 ** 0.05 *** 0.01) booktabs title(Consumption\label{tab:regc})
eststo clear


eststo clear
eststo:  xtreg emp2 c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

 eststo:  xtreg LF c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_ext.tex", replace label compress interaction(*) ///
 se ar2 wide b(4) se(4) ///
 drop(*.year 0.Lhouse_owner 0.school_child 0.young) star(* 0.1 ** 0.05 *** 0.01) booktabs title(Employment, Labor force participation\label{tab:reglfp})
eststo clear


eststo: xtreg emp2 c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.dum_trd2#i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

eststo: xtreg LF c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.dum_trd2#i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_ext2.tex", replace label compress interaction(*) ///
 se ar2 wide b(4) se(4) ///
 drop(*.year 0.Lhouse_owner 0.school_child 0.young) star(* 0.1 ** 0.05 *** 0.01) booktabs title(Employment, Labor force participation\label{tab:reglfp2})
eststo clear

eststo clear
eststo:  xtreg lab_hour c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

 eststo:  xtreg lnw c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe


esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_int.tex", replace label compress interaction(*) ///
 se ar2 wide b(4) se(4) ///
drop(*.year 0.Lhouse_owner 0.school_child 0.young) star(* 0.1 ** 0.05 *** 0.01) booktabs title(Labor hours, Wages\label{tab:reglh})
eststo clear

eststo: xtreg lab_hour c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.dum_trd2#i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

eststo: xtreg lnw c.age c.age2 i.year tot_wealth fin_debt i.Lhouse_owner i.young i.dum_trd2#i.young#i.Lhouse_owner#c.reg_HP_cyc2 i.school_child num_fam ///
 [aw = weight] if reg_up10dum == 1 & age >= 22, fe

esttab using "C:\Users\net19\OneDrive\문서\Research\My Research\Regressions\Housing\regres_int2.tex", replace label compress interaction(*) ///
 se ar2 wide b(4) se(4) ///
 drop(*.year 0.Lhouse_owner 0.school_child 0.young) star(* 0.1 ** 0.05 *** 0.01) booktabs title(Labor hours, Wages\label{tab:reglh2})
eststo clear

// specifications from IC

xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight], fe

xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 0, fe
xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 1, fe

xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 0 & school_child == 0, fe
xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 0 & school_child == 1, fe

xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 1 & school_child == 0, fe
xtreg lab_hour i.year i.house_owner#c.reg_HP_cyc i.house_owner tot_wealth fin_debt [aw = weight] if young == 1 & school_child == 1, fe

// Questions
// restrict to head and partner only? Yes
// house_owner or Lhouse_owner: Lhouse_owner is house_owner(t-1)
// diff in reg_HP_cyc and reg_HP_cyc2? 
// cyc: residual from raw price. cyc2: residual from logprice. 
// control: part-time job, spouse's LM status, edu, etc?
// why reg_up10dum == 1?
// reg_up10dum == 1 if a specific region contains at least 10 observations for all years
// emp_stat?
