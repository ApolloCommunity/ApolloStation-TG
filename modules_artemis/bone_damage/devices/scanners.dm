/*
	Defined in code/game/objects/items/devices/scanners.dm

	Since you can't override global procs (like /proc/healthscan) we have to resort to this ugly method :(
*/

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)

	// Clumsiness/brain damage check
	if ((user.disabilities & CLUMSY || user.getBrainLoss() >= 60) && prob(50))
		user.visible_message("<span class='warning'>[user] has analyzed [get_turf(M)]'s vitals!</span>",
			"<span class='notice'>You stupidly try to analyze [get_turf(M)]'s vitals!</span>")

		user << "<span class='info'>Analyzing results for [get_turf(M)]:\n\tOverall status: <b>Healthy</b>"
		user << "<span class='info'>Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FF8000'>Burn</font>/<font color='red'>Brute</font></span>"
		user << "<span class='info'>\tDamage specifics: <font color='blue'>0</font>-<font color='green'>0</font>-<font color='#FF8000'>0</font>-<font color='red'>0</font></span>"
		user << "<span class='info'>Body temperature: ???</span>"
		return

	user.visible_message("<span class='notice'>[user] has analyzed [M]'s vitals.</span>")

	if(scanmode == 0)
		new_healthscan(user, M, mode)
	else if(scanmode == 1)
		chemscan(user, M)

	add_fingerprint(user)

/*
	Defined in code/game/objects/items/devices/PDA/PDA.dm
*/

/obj/item/device/pda/attack(mob/living/carbon/C, mob/living/user)
	if(istype(C))
		switch(scanmode)
			if(1)
				C.visible_message("<span class='alert'>[user] has analyzed [C]'s vitals!</span>")
				new_healthscan(user, C, 1)
				add_fingerprint(user)

			if(4)
				C.visible_message("<span class='warning'>[user] has analyzed [C]'s radiation levels!</span>")

				user.show_message("<span class='notice'>Analyzing Results for [C]:</span>")
				if(C.radiation)
					user.show_message("\green Radiation Level: \black [C.radiation]")
				else
					user.show_message("<span class='notice'>No radiation detected.</span>")