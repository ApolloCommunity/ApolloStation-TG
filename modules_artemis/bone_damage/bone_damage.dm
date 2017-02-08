/*
	Bone breaking & rattling
	Defined in code/modules/surgery/bodyparts/bodyparts.dm
*/

/obj/item/bodypart
	var/can_break = 1 // can this bodypart be fractured?
	// NB! v must be >= 9. the receive_damage override is reliant on update_bodypart_damage_state() returning 1, which happens every 9 damage
	var/break_damage = 15 // must deal at least this much damage in one hit to guarantee a fracture
	var/broken = 0 // broken bones?
	var/splinted = 0 // is the limb splinted

/obj/item/bodypart/head
	break_damage = 20

/obj/item/bodypart/chest
	break_damage = 20

/obj/item/bodypart/proc/rattle_bones()
	if(!broken)
		return

	owner << "<span class='danger'>The bones in your [name] move around painfully!</span>"
	owner.emote("scream")
	owner.staminaloss += 10

/obj/item/bodypart/proc/fracture()
	if(!can_break || broken)
		return

	broken = 1
	owner.visible_message( // ty for the messages bay
		"<span class='danger'>You hear a loud cracking sound coming from \the [owner].</span>",
		"<span class='danger'>Something feels like it shattered in your [name]!</span>",
		"<span class='danger'>You hear a sickening crack.</span>")
	// overriding get_sfx didn't work :(
	var/fracture_sfx = pick('sound/effects/bonebreak1.ogg',
						'sound/effects/bonebreak2.ogg',
						'sound/effects/bonebreak3.ogg',
						'sound/effects/bonebreak4.ogg')
	playsound(owner.loc, fracture_sfx, 100)
	owner.emote("scream")

/obj/item/bodypart/proc/heal_fracture()
	if(!can_break || !broken)
		return

	broken = 0
	splinted = 0

/obj/item/bodypart/receive_damage(brute, burn, updating_health = 1)
	. = ..()
	if(!.)
		return 0
	if(broken)
		return

	if(brute >= break_damage)
		fracture()

// chest pain is pretty fuckin shit. make it give some extra staminaloss
/obj/item/bodypart/chest/rattle_bones()
	..()
	owner.staminaloss += 15