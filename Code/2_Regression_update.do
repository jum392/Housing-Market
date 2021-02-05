xtreg lab_hour c.age c.age2 i.year tot_wealth fin_debt reg_unemployment L.i.house_owner c.reg_HP_cyc#L.i.house_owner i.school_child num_fam ///
 [aw = weight] if reg_num >= 10 & year >= 2011, fe
