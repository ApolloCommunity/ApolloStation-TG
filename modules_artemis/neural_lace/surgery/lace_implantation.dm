/datum/surgery/lace_implant
	name = "neural lace implantation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/drill, /datum/surgery_step/implant_lace, /datum/surgery_step/close)
	possible_locs = list("head")

/datum/surgery/lace_implant/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/neural_lace/lace = target.getorgan(/obj/item/organ/neural_lace)

	if(isnull(lace))
		return 1
	return 0

/datum/surgery_step/implant_lace
	name = "implant neural lace"
	implements = list(/obj/item/weapon/lace_claw = 100, /obj/item/weapon/wirecutters = 40)
	time = 24

/datum/surgery_step/implant_lace/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to attach the neural lace to [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to attach the neural lace to [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(istype(tool, /obj/item/weapon/lace_claw))
		var/obj/item/weapon/lace_claw/C = tool

		// mode = 1 is implant mode
		if(C.mode)
			return 1
		else
			user << "<span class='notice'>The lace claw is set to extract!</span>"

	return 0

/datum/surgery_step/implant_lace/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/neural_lace/lace = user.get_inactive_held_item()

	if(!istype(lace))
		user << "<span class='notice'>You revv up the lace claw but realize you don't actually have a neural lace in your offhand.</span>"
		return

	user.temporarilyRemoveItemFromInventory(lace)
	lace.Insert(target)

	user << "<span class='notice'>You successfully attach the neural lace to [target]'s [parse_zone(target_zone)]!</span>"

	// mind transfer bit

	if(isnull(lace.stored_mind))
		return
	if(lace.stored_mind.current && lace.stored_mind.current.stat != DEAD) // you have to be at least dead for a transfer
		return
	if(target.mind && target.mind.active) // is the body already occupied by some other mind?
		target.visible_message("<span class='danger'>\The [target] spasms violently!</span>")
		if(prob(75))
			target << "<span class='danger'>You manage to fight off the mind creeping over your own!</span>"
			return
		else
			target << "<span class='danger'>You slip out of consciousness as a different mind takes over.</span>"

	lace.stored_mind.transfer_to(target)

	if(lace.stored_mind.current.get_ghost())
		lace.stored_mind.current << "<span class='notice'>Your mind has been uploaded to a new body through your neural lace! \
									You can now reenter your new body.</span>"