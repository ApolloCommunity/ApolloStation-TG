proc/toggle_hub()
	set category = "Server"
	set name = "Toggle Hub"

	world.visibility = (!world.visibility)

	log_admin("WORLD has toggled the server's hub status for the round, it is now [(world.visibility?"on":"off")] the hub. This was an automatic toggle to get us back on the hub!")
	message_admins("WORLD has toggled the server's hub status for the round, it is now [(world.visibility?"on":"off")] the hub. This was an automatic toggle to get us back on the hub!")
	if (world.visibility && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a filewall is blocking incoming connections.")

	feedback_add_details("admin_verb","HUB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
