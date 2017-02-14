/*
	Defined in code/game/machinery/Sleeper.dm
*/

/obj/machinery/sleeper/ui_data()
	var/list/data = list()
	data["occupied"] = occupant ? 1 : 0
	data["open"] = state_open

	data["chems"] = list()
	for(var/chem in available_chems)
		var/datum/reagent/R = chemical_reagents_list[chem]
		data["chems"] += list(list("name" = R.name, "id" = R.id, "allowed" = chem_allowed(chem)))

	data["occupant"] = list()
	if(occupant)
		data["occupant"]["name"] = occupant.name
		data["occupant"]["stat"] = occupant.stat
		data["occupant"]["health"] = occupant.health
		data["occupant"]["maxHealth"] = occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = occupant.getBruteLoss()
		data["occupant"]["oxyLoss"] = occupant.getOxyLoss()
		data["occupant"]["toxLoss"] = occupant.getToxLoss()
		data["occupant"]["fireLoss"] = occupant.getFireLoss()
		data["occupant"]["cloneLoss"] = occupant.getCloneLoss()
		data["occupant"]["brainLoss"] = occupant.getBrainLoss()
		
		data["occupant"]["boneFractures"] = list()
		if(iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			for(var/X in C.get_fractures())
				var/obj/item/bodypart/B = X
				data["occupant"]["boneFractures"] += list(list("name" = B.name))

		data["occupant"]["reagents"] = list()
		if(occupant.reagents.reagent_list.len)
			for(var/datum/reagent/R in occupant.reagents.reagent_list)
				data["occupant"]["reagents"] += list(list("name" = R.name, "volume" = R.volume))
	return data