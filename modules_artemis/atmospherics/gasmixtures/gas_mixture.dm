/datum/gas_mixture/proc/add_thermal_energy(var/joules) //joules
	temperature += (joules/heat_capacity())