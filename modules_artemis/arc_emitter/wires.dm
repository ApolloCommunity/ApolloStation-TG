/datum/wires/arc_emitter

	holder_type = /obj/machinery/power/arc_emitter
	var/const/SABOTAGE_WIRE = 1
	var/const/TOGGLE_WIRE = 2

	/datum/wires/arc_emitter/New(atom/holder)
	wires = list(
		SABOTAGE_WIRE, TOGGLE_WIRE
	)
	..()

/datum/wires/arc_emitter/interactable(mob/user)
	var/obj/machinery/power/arc_emitter/A = holder
	if(A.panel_open)
		return TRUE

/datum/wires/arc_emitter/get_status()
	var/obj/machinery/power/arc_emitter/A = holder
	var/list/status = list()
	status += "<BR>The red light is [A.disabled ? "off" : "on"]."
	return status

/datum/wires/arc_emitter/on_cut(wire, mended)
	var/obj/machinery/power/arc_emitter/A = holder
	switch(wire)
		if(SABOTAGE_WIRE)
			A.disabled = !mended

/datum/wires/arc_emitter/on_pulse(wire)
	var/obj/machinery/power/arc_emitter/A = holder
	//if(IsIndexCut(wire))
	//	return
	switch(wire)
		if(TOGGLE_WIRE)
			A.activate(usr)