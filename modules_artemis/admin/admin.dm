//Jury rigged version of freeze from other servers ~rj
/client/proc/cmd_admin_restrain(mob/living/M in mob_list)
	set category = "Admin"
	set name = "Restrain"

	if(!holder)
		src << "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>"
		return
	if(!M || !ismob(M))
		usr << "You seem to be selecting a mob that doesn't exist anymore or has never existed."
		return

	if(istype(M, /mob/living/carbon) || istype(M, /mob/living/silicon))
		if(M.captured == 1)
			M.captured = 0
			M.canmove = 1
			M.stunned = 0
			message_admins("[key_name_admin(src)] has lifted [key_name(M)]'s restraining order.")
			log_admin("[key_name_admin(usr)] has lifted [key_name(M)]'s restraining order.")
		else
			M.captured = 1
			M.canmove = 0
			M.stunned = 900000
			message_admins("[key_name_admin(src)] has restrained [key_name(M)].")
			log_admin("[key_name_admin(src)] has restrained [key_name(M)].")

/mob/living
	var/captured = 0