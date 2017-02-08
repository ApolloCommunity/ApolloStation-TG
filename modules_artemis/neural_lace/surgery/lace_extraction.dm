/datum/surgery/lace_extraction
	name = "neural lace extraction"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/drill, /datum/surgery_step/extract_lace, /datum/surgery_step/close)
	possible_locs = list("head")

/datum/surgery/lace_extraction/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/neural_lace/lace = target.getorgan(/obj/item/organ/neural_lace)

	if(isnull(lace))
		return 0
	return 1

/datum/surgery_step/extract_lace
	name = "extract neural lace"
	implements = list(/obj/item/weapon/lace_claw = 100, /obj/item/weapon/wirecutters = 40)
	time = 24

/datum/surgery_step/extract_lace/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to extract the neural lace from [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to pull the neural lace from [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/extract_lace/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/weapon/lace_claw))
		var/obj/item/weapon/lace_claw/C = tool

		// mode = 0 is extract mode
		if(!C.mode)
			return 1
		else
			user << "<span class='notice'>The lace claw is set to implant!</span>"

	return 0

/datum/surgery_step/extract_lace/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/neural_lace/lace = target.getorgan(/obj/item/organ/neural_lace)

	lace.Remove(target)
	lace.loc = target.loc

	user << "<span class='notice'>You successfully remove the neural lace from [target]'s [parse_zone(target_zone)]!</span>"