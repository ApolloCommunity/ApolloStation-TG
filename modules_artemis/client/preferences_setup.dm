
//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	undershirt = random_undershirt(gender)
	socks = random_socks()
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(config.roundstart_races)
		pref_species = new rando_race()
	backbag = 1
	features = random_features()
	age = rand(AGE_MIN,AGE_MAX)

	home_system = "Unset"           //System of birth.
	citizenship = "None"            //Current home system.
	flavor_texts_human = ""
	flavor_texts_robot = ""

		//Reccores
	med_record = "Medical records here:"
	sec_record = "Security records here:"
	gen_record = "General employment records here:"
	exploit_record = "Exploitable information here:"

		//phorensics (not used atm)
	DNA = ""
	fingerprints = ""
	unique_identifier = ""

		//Langueages
	additional_language = "None"

	//Is this char to be deleted on safe or load ?
	to_delete = 0
	locked = 0
	generate_init_roles()


/datum/preferences/proc/update_preview_icon()
	// Silicons only need a very basic preview since there is no customization for them.
	var/high_ranked = "Assistant"
	for(var/x in roles)
		if(roles[x] == "HIGH")
			high_ranked = x
			if(x == "AI")
				preview_icon = icon('icons/mob/AI.dmi', "AI", SOUTH)
				preview_icon.Scale(64, 64)
				return
			if(x == "Cyborg")
				preview_icon = icon('icons/mob/robots.dmi', "robot", SOUTH)
				preview_icon.Scale(64, 64)
				return

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = new()
	//Copy to mannequin, we want to update the icon and we donnot want a random char.
	copy_to(mannequin, 1, 0)

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob

	previewJob = SSjob.GetJob(high_ranked)

	if(previewJob)
		mannequin.job = previewJob.title
		previewJob.equip(mannequin, TRUE)
	CHECK_TICK
	preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)
	CHECK_TICK
	mannequin.setDir(NORTH)

	var/icon/stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)
	CHECK_TICK
	mannequin.setDir(WEST)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)
	CHECK_TICK
	mannequin.setDir(SOUTH)
	stamp = getFlatIcon(mannequin)
	CHECK_TICK
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)
	CHECK_TICK
	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
	CHECK_TICK
	qdel(mannequin)
