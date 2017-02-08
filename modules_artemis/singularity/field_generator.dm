/obj/machinery/field/generator/proc/arc_act(energy)
	power = min(power + energy, field_generator_max_power)
	check_power_level()
	update_icon()
	return 0