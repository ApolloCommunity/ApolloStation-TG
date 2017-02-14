/obj/structure/chair/shuttle
	name = "shuttle chair"
	desc = "It looks uncomfortable."
	icon = 'icons/obj/shuttlechair.dmi'
	icon_state = "chair3"
	var/image/armrest = null

/obj/structure/chair/shuttle/New()
	armrest = image("icons/obj/shuttlechair.dmi", "chair3_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/chair/shuttle/post_buckle_mob()
	if(has_buckled_mobs())
		overlays += armrest
	else
		overlays -= armrest