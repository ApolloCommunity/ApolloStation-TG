// mend bones
/datum/surgery/fix_bone
	name = "fractured bone mending"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/set_bone, /datum/surgery_step/glue_bone, /datum/surgery_step/close)
	possible_locs = list("chest", "head", "l_arm", "r_arm", "l_leg", "r_leg")

/datum/surgery/fix_bone/can_start(mob/user, mob/living/carbon/target)
	var/target_zone = check_zone(user.zone_selected)

	var/obj/item/bodypart/B = target.get_bodypart(target_zone)
	if(!B.broken)
		return 0
	return 1

// break bones
/datum/surgery/break_bone
	name = "bone fracturing"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/break_bone, /datum/surgery_step/close)
	possible_locs = list("chest", "head", "l_arm", "r_arm", "l_leg", "r_leg")

/datum/surgery/break_bone/can_start(mob/user, mob/living/carbon/target)
	var/target_zone = check_zone(user.zone_selected)

	var/obj/item/bodypart/B = target.get_bodypart(target_zone)
	if(B.broken)
		return 0
	return 1

// set bones back into place
/datum/surgery_step/set_bone
	name = "set bone"
	implements = list(/obj/item/weapon/bonesetter = 100, /obj/item/weapon/wrench = 75)
	time = 24

/datum/surgery_step/set_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to set the bone in [target]'s [parse_zone(target_zone)].",
		"<span class='notice'>You begin to set the bone in [target]'s [parse_zone(target_zone)]...</span>")

// glue bones together
/datum/surgery_step/glue_bone
	name = "glue bone"
	implements = list(/obj/item/weapon/bonegel = 100, /obj/item/stack/packageWrap = 35, /obj/item/stack/cable_coil = 15)
	time = 24

/datum/surgery_step/glue_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("[user] begins to glue the bone fragments in [target]'s [parse_zone(target_zone)] together.",
		"<span class='notice'>You begin to glue the bone fragments in [target]'s [parse_zone(target_zone)] together...</span>")

/datum/surgery_step/glue_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/B = target.get_bodypart(target_zone)
	B.heal_fracture()

	return ..()

// violently smash bones
/datum/surgery_step/break_bone
	name = "break bone"
	implements = list(/obj/item/weapon/crowbar = 100, /obj/item/weapon/wrench = 100,
		/obj/item/weapon/storage/toolbox = 100, /obj/item/weapon/tank = 100, /obj/item/weapon/kitchen/rollingpin = 100,
		/obj/item/weapon/weldingtool = 100)
	time = 24

/datum/surgery_step/break_bone/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='danger'>[user] begins to smash the bone in [target]'s [parse_zone(target_zone)]!</span>",
		"<span class='danger'>You begin to smash through the bone in [target]'s [parse_zone(target_zone)]...</span>")

/datum/surgery_step/break_bone/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target.apply_damage(20, "brute", "[target_zone]")

	var/obj/item/bodypart/B = target.get_bodypart(target_zone)
	B.fracture()

	user.visible_message("<span class='danger'>[user] shatters the bones [target]'s [parse_zone(target_zone)] into pieces!</span>",
		"<span class='danger'>You shatter the bones [target]'s [parse_zone(target_zone)] into pieces.</span>")
	return 1