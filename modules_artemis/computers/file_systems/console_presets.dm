// ===== MEDICAL CONSOLE =====
/obj/machinery/modular_computer/console/preset/medical
	console_department = "Medical"
	desc = "A stationary computer. This one comes preloaded with medical programs."

/obj/machinery/modular_computer/console/preset/medical/install_programs()
	//var/obj/item/weapon/computer_hardware/hard_drive/hard_drive = cpu.all_components[MC_HDD]
	//hard_drive.store_file(new/datum/computer_file/program/suit_sensors())
	//hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	//hard_drive.store_file(new/datum/computer_file/data/autorun("sensormonitor"))

/obj/machinery/modular_computer/console/preset/command/main
	console_department = "Command"
	desc = "A stationary computer. This one comes preloaded with essential command programs."

// ===== SECURITY CONSOLE =====
/obj/machinery/modular_computer/console/preset/security
	console_department = "Security"
	desc = "A stationary computer. This one comes preloaded with security programs."

/obj/machinery/modular_computer/console/preset/security/install_programs()
	//var/obj/item/weapon/computer_hardware/hard_drive/hard_drive = cpu.all_components[MC_HDD]
	//hard_drive.store_file(new/datum/computer_file/program/camera_monitor())
	//hard_drive.store_file(new/datum/computer_file/data/autorun("cammon"))