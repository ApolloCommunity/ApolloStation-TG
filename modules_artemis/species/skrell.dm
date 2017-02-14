/datum/species/skrell
	//Squid humanoids that come from an aquatic homeworld
	name = "Skrell"
	id = "skrell"
	say_mod = "warbles"
	eyes = "skrelleyes"
	damage_overlay_type = "skrell"
	default_color = "64BAA0"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS)
	mutant_bodyparts = list("ears", "wings", "tentacles")
	default_features = list("mcolor" = "48F", "ears" = "None", "wings" = "None", "tentacles" = "short")
	meat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skrell
	skinned_type = /obj/item/stack/sheet/animalhide/skrell
	exotic_blood = "skrellblood"
	exotic_bloodtype = "S"
	brutemod = 2 //Weak against firearms
	burnmod = 1.5 //Weak against lasers

/datum/species/skrell/qualifies_for_rank()
	return 1

/datum/species/skrell/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_skrell_name()

	var/randname = skrell_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/skrell/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id == "protein")
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/obj/item/stack/sheet/animalhide/skrell
	name = "skrell skin"
	desc = "very rubbery"
	singular_name = "skrell skin piece"
	icon_state = "sheet-skrell"

/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/skrell
	icon_state = "skrellmeat"
	desc = "Almost sushi"
	filling_color = "#0066CC"

/datum/reagent/blood/skrell
	name = "Skrell Blood"
	id = "skrellblood"
	color = "#0066cc"

/datum/sprite_accessory/tentacles
	icon = 'icons/mob/mutant_bodyparts.dmi'

/datum/sprite_accessory/tentacles/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/tentacles/long
	name = "Long"
	icon_state = "long"