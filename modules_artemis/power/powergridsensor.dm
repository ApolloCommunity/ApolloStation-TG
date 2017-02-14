var/global/list/powergridsensors = new/list()

/obj/machinery/power/sensor
	name = "Powernet Sensor"
	desc = "Small machine which transmits data about specific powernet"
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon" // If anyone wants to make better sprite, feel free to do so without asking me.
	anchored = 1
	use_power = 0

/obj/machinery/power/sensor/Initialize()
	..()
	if(anchored)
		connect_to_network()
		if(!powergridsensors)
			powergridsensors = new/list()
		powergridsensors.Add(src)

/obj/machinery/power/sensor/Destroy()
	powergridsensors.Remove(src)
	..()