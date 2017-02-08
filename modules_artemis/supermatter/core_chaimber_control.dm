/////////////////////////////////////////////////////////////
// SUPERMATTER CHAIMBER CONTROL
/////////////////////////////////////////////////////////////

/obj/machinery/computer/atmos_control/supermatter
	var/input_tag
	var/output_tag
	frequency = 1441
	circuit = /obj/item/weapon/circuitboard/computer/atmos_control/tank

	var/list/input_info
	var/list/output_info

// This hacky madness is the evidence of the fact that a lot of machines were never meant to be constructable, im so sorry you had to see this
/obj/machinery/computer/atmos_control/supermatter/proc/reconnect(mob/user)
	var/list/IO = list()
	var/datum/radio_frequency/freq = SSradio.return_frequency(1441)
	var/list/devices = freq.devices["_default"]
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in devices)
		var/list/text = splittext(U.id_tag, "_")
		IO |= text[1]
	for(var/obj/machinery/atmospherics/components/unary/outlet_injector/U in devices)
		var/list/text = splittext(U.id, "_")
		IO |= text[1]
	if(!IO.len)
		user << "<span class='alert'>No machinery detected.</span>"
	var/S = input("Select the device set: ", "Selection", IO[1]) as anything in IO
	if(src)
		src.input_tag = "[S]_in"
		src.output_tag = "[S]_out"
		name = "[uppertext(S)] Supply Control"
		var/list/new_devices = freq.devices["4"]
		for(var/obj/machinery/air_sensor/U in new_devices)
			var/list/text = splittext(U.id_tag, "_")
			if(text[1] == S)
				sensors = list("[S]_sensor" = "Tank")
				break

	for(var/obj/machinery/atmospherics/components/unary/outlet_injector/U in devices)
		U.broadcast_status()
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/U in devices)
		U.broadcast_status()

/obj/machinery/computer/atmos_control/supermatter/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "supermatter_control", name, 500, 305, master_ui, state)
		ui.open()

/obj/machinery/computer/atmos_control/supermatter/ui_data(mob/user)
	var/list/data = ..()
	data["tank"] = TRUE
	data["inputting"] = input_info ? input_info["power"] : FALSE
	data["inputRate"] = input_info ? input_info["volume_rate"] : 0
	data["outputting"] = output_info ? output_info["power"] : FALSE
	data["chaimberPressure"] = output_info ? output_info["external"] : 0

	return data

/obj/machinery/computer/atmos_control/supermatter/ui_act(action, params)
	if(..() || !radio_connection)
		return
	var/datum/signal/signal = new
	signal.transmission_method = 1
	signal.source = src
	signal.data = list("sigtype" = "command")
	switch(action)
		if("reconnect")
			reconnect(usr)
			. = TRUE
		if("input")
			signal.data += list("tag" = input_tag, "power_toggle" = TRUE)
			. = TRUE
		if("output")
			signal.data += list("tag" = output_tag, "power_toggle" = TRUE)
			. = TRUE
		if("pressure")
			var/target = input("New target pressure:", name, output_info["external"]) as num|null
			if(!isnull(target) && !..())
				target =  Clamp(target, 0, 50 * ONE_ATMOSPHERE)
				signal.data += list("tag" = output_tag, "set_external_pressure" = target)
				. = TRUE
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

/obj/machinery/computer/atmos_control/supermatter/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption)
		return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)