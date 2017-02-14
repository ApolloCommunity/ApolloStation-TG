/datum/species/human/gravworlder
	name = "Grav-Adapted Human"
	id = "gravadapted"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,RADIMMUNE,)

	stunmod = 0.9
	brutemod = 0.85
	speedmod = 0.8
	say_mod = "grunts"

/datum/species/human/spacer
	name = "Space-Adapted Human"
	id = "spaceadapted"
	eyes = "spaceeyes"
	damage_overlay_type = "spaceadapted"
	species_traits = list(LIPS,RESISTPRESSURE,NOBREATH,EASYDISMEMBER)
	stunmod = 1.5
	brutemod = 1.5
	heatmod =  1.5

/datum/species/human/vatgrown
	name = "Vat-Grown Human"
	id = "vatgrown"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,VIRUSIMMUNE)

	stunmod = 1.2
	coldmod = 0.8
	heatmod = 1.2

/datum/species/human/vatgrown/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_vatgrown_name()

	var/randname = vatgrown_name(gender)

	randname += "-[rand(1,99)]"

	return randname

/datum/species/monkey
