/*
	Defined in code/modules/mob/living/carbon/human/human_movement.dm
*/

/*
	Movement slowdown
	Defined in code/modules/surgery/bodyparts/bodyparts.dm
*/

/mob/living/carbon/human/Move()
	. = ..()
	if(!.)
		return 0

	for(var/X in bodyparts)
		var/obj/item/bodypart/B = X
		B.on_mob_move()

/obj/item/bodypart/proc/movement_delay()
	return 0

// dupe code but thats what happens when it ain't /leg/r and /leg/l
// i cba to fix that
/obj/item/bodypart/l_leg/movement_delay()
	. = brute_dam / 50
	if(broken)
		if(splinted)
			. += 2
		else
			. += 5

/obj/item/bodypart/l_leg/on_mob_move()
	if(splinted)
		return

	if(broken && prob(2))
		rattle_bones()
		owner.Weaken(2)

/obj/item/bodypart/r_leg/movement_delay()
	. = brute_dam / 50
	if(broken)
		if(splinted)
			. += 2
		else
			. += 5

/obj/item/bodypart/r_leg/on_mob_move()
	if(splinted)
		return

	if(broken && prob(2))
		rattle_bones()
		owner.Weaken(2)

// arm stuff
#define HAND_L 1
#define HAND_R 2

/obj/item/bodypart/l_arm/fracture()
	..()

	var/obj/item/held_item = owner.get_item_for_held_index(HAND_L)
	if(held_item)
		owner.dropItemToGround(held_item)
		owner.visible_message("<span class='danger'>[src] drops the [held_item]!</span>",
				"<span class='danger'>Your left arm hurts badly!</span>")
		owner.emote("scream")

/obj/item/bodypart/r_arm/fracture()
	..()

	var/obj/item/held_item = owner.get_item_for_held_index(HAND_R)
	if(held_item)
		owner.dropItemToGround(held_item)
		owner.visible_message("<span class='danger'>[src] drops the [held_item]!</span>",
				"<span class='danger'>Your right arm hurts badly!</span>")
		owner.emote("scream")

#undef HAND_L
#undef HAND_R