/proc/new_healthscan(mob/living/user, mob/living/M, mode = 1)
	if(user.incapacitated() || user.eye_blind)
		return
	//Damage specifics
	var/oxy_loss = M.getOxyLoss()
	var/tox_loss = M.getToxLoss()
	var/fire_loss = M.getFireLoss()
	var/brute_loss = M.getBruteLoss()
	var/mob_status = (M.stat > 1 ? "<span class='alert'><b>Deceased</b></span>" : "<b>[round(M.health/M.maxHealth,0.01)*100] % healthy</b>")

	if(M.status_flags & FAKEDEATH)
		mob_status = "<span class='alert'>Deceased</span>"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.heart_attack && H.stat != DEAD)
			user << "<span class='danger'>Subject suffering from heart attack: Apply defibrillator immediately!</span>"

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.has_brain_worms())
			user << "<span class='danger'>Foreign organism detected in subject's cranium. Recommended treatment: Dosage of sucrose solution and removal of object via surgery.</span>"

	user << "<span class='info'>Analyzing results for [M]:\n\tOverall status: [mob_status]</span>"

	// Damage descriptions
	if(brute_loss > 10)
		user << "\t<span class='alert'>[brute_loss > 50 ? "Severe" : "Minor"] tissue damage detected.</span>"
	if(fire_loss > 10)
		user << "\t<span class='alert'>[fire_loss > 50 ? "Severe" : "Minor"] burn damage detected.</span>"
	if(oxy_loss > 10)
		user << "\t<span class='info'><span class='alert'>[oxy_loss > 50 ? "Severe" : "Minor"] oxygen deprivation detected.</span>"
	if(tox_loss > 10)
		user << "\t<span class='alert'>[tox_loss > 50 ? "Critical" : "Dangerous"] amount of toxins detected.</span>"
	if(M.getStaminaLoss())
		user << "\t<span class='alert'>Subject appears to be suffering from fatigue.</span>"
	if (M.getCloneLoss())
		user << "\t<span class='alert'>Subject appears to have [M.getCloneLoss() > 30 ? "severe" : "minor"] cellular damage.</span>"
	if (M.reagents && M.reagents.get_reagent_amount("epinephrine"))
		user << "\t<span class='info'>Bloodstream analysis located [M.reagents:get_reagent_amount("epinephrine")] units of rejuvenation chemicals.</span>"
	if (M.getBrainLoss() >= 100 || !M.getorgan(/obj/item/organ/brain))
		user << "\t<span class='alert'>Subject brain function is non-existent.</span>"
	else if (M.getBrainLoss() >= 60)
		user << "\t<span class='alert'>Severe brain damage detected. Subject likely to have mental retardation.</span>"
	else if (M.getBrainLoss() >= 10)
		user << "\t<span class='alert'>Brain damage detected. Subject may have had a concussion.</span>"
	// Fractures
	if(iscarbon(M) && mode)
		var/mob/living/carbon/C = M
		var/list/fractures = C.get_fractures()
		if(fractures.len)
			user << "\t<span class='alert'>Fractured bones detected. Analyze in sleeper for more details.</span>"

	// Organ damage report
	if(iscarbon(M) && mode == 1)
		var/mob/living/carbon/C = M
		var/list/damaged = C.get_damaged_bodyparts(1,1)
		if(length(damaged)>0 || oxy_loss>0 || tox_loss>0 || fire_loss>0)
			user << "<span class='info'>\tDamage: <span class='info'><font color='red'>Brute</font></span>-<font color='#FF8000'>Burn</font>-<font color='green'>Toxin</font>-<font color='blue'>Suffocation</font>\n\t\tSpecifics: <font color='red'>[brute_loss]</font>-<font color='#FF8000'>[fire_loss]</font>-<font color='green'>[tox_loss]</font>-<font color='blue'>[oxy_loss]</font></span>"
			for(var/obj/item/bodypart/org in damaged)
				user << "\t\t<span class='info'>[capitalize(org.name)]: [(org.brute_dam > 0) ? "<font color='red'>[org.brute_dam]</font></span>" : "<font color='red'>0</font>"]-[(org.burn_dam > 0) ? "<font color='#FF8000'>[org.burn_dam]</font>" : "<font color='#FF8000'>0</font>"]"

	// Species and body temperature
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		user << "<span class='info'>Species: [H.dna.species.name]</span>"
	user << "<span class='info'>Body temperature: [round(M.bodytemperature-T0C,0.1)] &deg;C ([round(M.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>"

	// Time of death
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		user << "<span class='info'>Time of Death:</span> [M.tod]"
		var/tdelta = round(world.time - M.timeofdeath)
		if(tdelta < (DEFIB_TIME_LIMIT * 10))
			user << "<span class='danger'>Subject died [tdelta / 10] seconds \
				ago, defibrillation may be possible!</span>"

	for(var/datum/disease/D in M.viruses)
		if(!(D.visibility_flags & HIDDEN_SCANNER))
			user << "<span class='alert'><b>Warning: [D.form] detected</b>\nName: [D.name].\nType: [D.spread_text].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure_text]</span>"

	// Blood Level
	if(M.has_dna())
		var/mob/living/carbon/C = M
		var/blood_id = C.get_blood_id()
		if(blood_id)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				if(H.bleed_rate)
					user << "<span class='danger'>Subject is bleeding!</span>"
			var/blood_percent =  round((C.blood_volume / BLOOD_VOLUME_NORMAL)*100)
			var/blood_type = C.dna.blood_type
			if(blood_id != "blood")//special blood substance
				blood_type = blood_id
			if(C.blood_volume <= BLOOD_VOLUME_SAFE && C.blood_volume > BLOOD_VOLUME_OKAY)
				user << "<span class='danger'>LOW blood level [blood_percent] %, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>"
			else if(C.blood_volume <= BLOOD_VOLUME_OKAY)
				user << "<span class='danger'>CRITICAL blood level [blood_percent] %, [C.blood_volume] cl,</span> <span class='info'>type: [blood_type]</span>"
			else
				user << "<span class='info'>Blood level [blood_percent] %, [C.blood_volume] cl, type: [blood_type]</span>"

		var/cyberimp_detect
		for(var/obj/item/organ/cyberimp/CI in C.internal_organs)
			if(CI.status == ORGAN_ROBOTIC)
				cyberimp_detect += "[C.name] is modified with a [CI.name].<br>"
		if(cyberimp_detect)
			user << "<span class='notice'>Detected cybernetic modifications:</span>"
			user << "<span class='notice'>[cyberimp_detect]</span>"