/*
	Defined in code/modules/mob/living/carbon/life.dm
*/

/mob/living/carbon/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)
		return

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	if(..()) //not dead
		handle_blood()

	if(stat != DEAD)
		for(var/V in internal_organs)
			var/obj/item/organ/O = V
			O.on_life()

	//Updates the number of stored chemicals for powers
	handle_changeling()

	// handle pain-related events from fractures
	handle_fractures()

	if(stat != DEAD)
		return 1