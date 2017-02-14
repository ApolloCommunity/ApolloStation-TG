/*
	Defined in code/datums/mind.dm
*/

/datum/mind/transfer_to(mob/new_character, var/force_key_move = 0)
	..() // run original transfer_to

	var/obj/item/organ/neural_lace/lace = new_character.getorgan(/obj/item/organ/neural_lace)
	if(lace)									// update the mind stored within neural laces
		lace.stored_mind = src