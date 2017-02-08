/*
	Defined in code/modules/mob/living/carbon/carbon.dm
*/

/mob/living/carbon/fully_heal(admin_revive = 0)
	for(var/X in get_fractures())
		var/obj/item/bodypart/B = X
		B.heal_fracture()
	..()

// fracture-related procs
/mob/living/carbon/proc/get_fractures()
	. = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/B = X
		if(B.broken)
			. += B

/mob/living/carbon/proc/handle_fractures()
	var/list/obj/item/bodypart/fractures = get_fractures()
	if(!fractures.len) // no fractures
		return

	for(var/X in fractures)
		var/obj/item/bodypart/B = X
		if(!B.broken || B.splinted)
			continue
		var/r_arm = istype(B, /obj/item/bodypart/r_arm) // just throw it in a var cause we use it twice
		if(!istype(B, /obj/item/bodypart/l_arm) && !r_arm)
			continue

		var/hand = "l"
		if(r_arm)
			hand = "r"

		var/obj/item/held = get_held_items_for_side(hand)
		if(!held)
			continue

		dropItemToGround(held)
		src << "<span class='danger'>Your [B.name] hurts badly!</span>"