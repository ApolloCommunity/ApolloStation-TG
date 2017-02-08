/obj/machinery/computer/phoron_desublimer_control
	name = "Phoron Desublimation Control"
	desc = "Controls the phoron desublimation process."
	icon = 'icons/obj/machines/phoron_desublimation.dmi'
	icon_state = "Ready"

	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	var/active = 0
	var/assembled = 0
	var/mselection = 1
	var/list/mat_presets = list(    "Steel" = 30,
									"Silver" = null,
									"Uranium" = null,
									"Gold" = null,
									"Platinum" = null,
									"Diamonds" = null,
									"Phoron" = null,
									"Osmium" = null )

	var/obj/machinery/phoron_desublimer/vessel/vessel
	var/obj/machinery/phoron_desublimer/furnace/furnace

/obj/machinery/computer/phoron_desublimer_control/New()
	..()

	spawn( 2 )
		src.check_parts()

/obj/machinery/computer/phoron_desublimer_control/proc/find_parts()
	vessel = null
	furnace = null

	var/area/main_area = get_area(src)

	for( var/obj/machinery/phoron_desublimer/PD in main_area )
		if( istype( PD, /obj/machinery/phoron_desublimer/vessel ))
			vessel = PD
		if( istype( PD, /obj/machinery/phoron_desublimer/furnace ))
			furnace = PD

	return

/obj/machinery/computer/phoron_desublimer_control/proc/check_parts()
	find_parts()

	if( !vessel )
		return 0
	if( !furnace )
		return 0

	return 1

/obj/machinery/computer/phoron_desublimer_control/proc/set_preset()
	if( !usr ) return
	var/preset = null
	preset = input( usr, "Which preset would you like set?", "Select Preset", preset ) in mat_presets
	mat_presets[preset] = furnace.neutron_flow

/obj/machinery/computer/phoron_desublimer_control/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/phoron_desublimer_control/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
										datum/tgui/master_ui = null, datum/ui_state/state = physical_state)
	if(stat & (BROKEN|NOPOWER))
		return
	if(user.stat || user.restrained())
		return

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "phoron_desublimer_control", name, 600, 385, master_ui, state)
		ui.open()

/obj/machinery/computer/phoron_desublimer_control/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("PRG_switchm")
			if(params["target"] == "vessel")
				mselection = 1
			if(params["target"] == "furnance")
				mselection = 2
			. = TRUE
		if("run_scan")
			src.check_parts()
			. = TRUE
		if("set_preset")
			src.set_preset()
			. = TRUE
		if("vessel_eject_shard")
			vessel.eject_shard()
			. = TRUE
		if("vessel_eject_tank")
			vessel.eject_tank()
			. = TRUE
		if("vessel_fill")
			vessel.fill()
			. = TRUE
		if("vessel_feed")
			vessel.crystalize()
		if("furnace_eject_shard")
			furnace.eject_shard()
			. = TRUE
		if("neutron_adj")
			var/diff = text2num(params["neutron_adj"])
			if(furnace.neutron_flow > 1)
				furnace.neutron_flow = min(furnace.max_neutron_flow, furnace.neutron_flow+diff)
			else
				furnace.neutron_flow = max(furnace.min_neutron_flow, furnace.neutron_flow+diff)
			. = TRUE
		if("set_neutron_flow")
			var/diff = text2num(params["set_neutron_flow"])
			if( diff )
				furnace.neutron_flow = diff
			. = TRUE
		if("furnace_activate")
			if( furnace.report_ready() & !furnace.active )
				furnace.produce()
			. = TRUE

	add_fingerprint(usr)
	update_icon()


/obj/machinery/computer/phoron_desublimer_control/ui_data(mob/user)
	// this is the data which will be sent to the ui
	var/list/data = list()
	data["test"] = 1
	data["test2"] = "test"
	data["mselection"] = 1
	data["presets"] = list()
	data["mselection"] = mselection

	var/list/presets = list()
	for (var/re in mat_presets )
		presets.Add(list(list("title" = re, "value" = mat_presets[re] ,"commands" = list("set_neutron_flow" = mat_presets[re]))))
	data["presets"] = presets

	if( vessel && mselection == 1 )
		data["vessel"] = vessel
		data["shard"] = vessel.loaded_shard
		data["max_shard_size"] = 100
		data["vessel_pressure"] = vessel.air_contents.return_pressure()

		if( vessel.loaded_shard )
			var/obj/item/weapon/shard/supermatter/S = vessel.loaded_shard
			data["shard_size"] = size_percent( S.size, S.max_size )
		else
			data["shard_size"] = 0

		if( vessel.loaded_tank )
			data["tank"] = vessel.loaded_tank
			data["tank_pressure"] = round(vessel.loaded_tank.air_contents.return_pressure() ? vessel.loaded_tank.air_contents.return_pressure() : 0)
		else
			data["tank_pressure"] = 0

	else if( furnace && mselection == 2 )
		data["furnace"] = furnace
		data["neutron_flow"] = furnace.neutron_flow
		data["max_neutron_flow"] = furnace.max_neutron_flow
		data["min_neutron_flow"] = furnace.min_neutron_flow
		data["shard"] = furnace.shard
		data["max_shard_size"] = 100

		if( furnace.shard )
			var/obj/item/weapon/shard/supermatter/S = furnace.shard
			data["shard_size"] = size_percent( S.size, S.max_size )
		else
			data["shard_size"] = 0

	return data