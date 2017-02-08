// Neural lace implant

/obj/item/organ/neural_lace
	name = "neural lace"
	desc = "A lightweight brain implant used to record and store the entirety of a person's brain."
	icon_state = "neurallace"
	throw_speed = 2
	throw_range = 4
	layer = ABOVE_MOB_LAYER
	zone = "head"
	slot = "neurallace"
	origin_tech = "biotech=6;programming=3;engineering=4"
	attack_verb = list("attacked", "slapped", "whacked")
	var/datum/mind/stored_mind = null
	var/severed = 0 // whether or not the lace is severed/broken

/obj/item/organ/neural_lace/Insert(mob/living/carbon/M, special = 0)
	..()
	if(isnull(stored_mind) && M.mind)
		stored_mind = M.mind

/obj/item/organ/neural_lace/Remove(mob/living/carbon/C, special = 0)
	..()
	C << "<span class='warning'><b>Your neural lace has been removed!</b> \
		If you are revived through neural lace transplantation \
		you can only remember events up to this point.</span>"

// Neural lace extraction/implant tool

/obj/item/weapon/lace_claw
	name = "lace claw"
	desc = "A precision instrument used to handle neural laces without breaking them. It is set to extract mode."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "lacetool"
	var/mode = 0 // 0 = extract, 1 = implant

/obj/item/weapon/lace_claw/attack_self(mob/user)
	user << "<span class='notice'>You toggle the lace claw to [mode ? "extract" : "implant"] mode.</span>"
	desc = "A precision instrument used to handle neural laces without breaking them. It is set to [mode ? "extract" : "implant"] mode."
	mode = !mode