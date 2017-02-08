#define HAND_L 1
#define HAND_R 2

/obj/item/stack/medical/splint
	name = "medical splint"
	singular_name = "medical splint"
	desc = "For supporting and keeping limbs with bone fractures still, preventing further injury."
	icon_state = "splint"
	amount = 5
	max_amount = 5

/obj/item/stack/medical/splint/attack(mob/living/M, mob/user)
	if(M.stat == DEAD)
		var/t_him = "it"
		if(M.gender == MALE)
			t_him = "him"
		else if(M.gender == FEMALE)
			t_him = "her"
		user << "<span class='danger'>\The [M] is dead, you cannot help [t_him]!</span>"
		return

	if(!iscarbon(M))
		user << "<span class='danger'>You don't know how to apply the splint to [M]!</span>"
		return 1

	var/mob/living/carbon/C = M
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))

	if(!affecting) //Missing limb?
		user << "<span class='warning'>[M] doesn't have \a [parse_zone(user.zone_selected)]!</span>"
		return
	if(!affecting.broken)
		user << "<span class='warning'>[M]'s [affecting.name] isn't broken!</span>"
		return
	if(affecting.splinted)
		user << "<span class='warning'>[M]'s [affecting.name] is already splinted!</span>"
		return

	var/limb = affecting.name
	if(M == user)
		if((user.active_hand_index == HAND_L && istype(affecting, /obj/item/bodypart/l_arm)) || \
			(user.active_hand_index == HAND_R && istype(affecting, /obj/item/bodypart/r_arm)))
			user << "<span class='danger'>You cannot apply a splint to the arm you're using!</span>"
			return
		user.visible_message("<span class='danger'>[user] starts to apply the splint to their [limb].</span>",
			"<span class='danger'>You start to apply the splint to your [limb].</span>",
			"<span class='danger'>You hear something being wrapped.</span>")
	else
		user.visible_message("<span class='danger'>[user] starts to apply the splint to [M]'s [limb].</span>",
		"<span class='danger'>You start to apply the splint to [M]'s [limb].</span>",
		"<span class='danger'>You hear something being wrapped.</span>")
		

	if(do_after(user, self_delay, target = M))
		if(M == user && prob(75))
			user.visible_message("<span class='danger'>[user] fumbles with the splint.</span>",
				"<span class='danger'>You fumble with the splint.</span>",
				"<span class='danger'>You hear something being wrapped.</span>")
			return

		use(1)
		affecting.splinted = 1
		if(M == user)
			user.visible_message("<span class='notice'>[user] successfully applies a splint to their [limb].</span>",
				"<span class='notice'>You successfully apply a splint to your [limb].</span>",
				"<span class='notice'>You hear something being wrapped.</span>")
		else
			user.visible_message("<span class='notice'>[user] successfully applies a splint to [M]'s [limb].</span>",
				"<span class='notice'>You successfully apply a splint to [M]'s [limb].</span>",
				"<span class='notice'>You hear something being wrapped.</span>")
		return

	user.visible_message("<span class='danger'>[user] fails to apply a splint to [M]'s [limb]!</span>",
		"<span class='danger'>You fail to apply a splint to [M]'s [limb]!</span>",
		"<span class='danger'>You hear something being wrapped.</span>")

#undef HAND_L
#undef HAND_R