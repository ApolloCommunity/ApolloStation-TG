var/list/preferences_datums = list()

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/nr_chars = 1
	var/max_save_slots = 999

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = null

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = "Midnight"
	var/hotkeys = FALSE
	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/uses_glasses_colour = 0

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we'll have a random name every round
	var/be_random_body = 0				//whether we'll have a random body every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/underwear = "Nude"				//underwear type
	var/undershirt = "Nude"				//undershirt type
	var/socks = "Nude"					//socks type
	var/backbag = DBACKPACK				//backpack type
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "000"				//Eye color
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "FFF", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs")

	var/list/custom_names = list("clown", "mime", "ai", "cyborg", "religion", "deity")
	var/prefered_security_department = SEC_DEPT_RANDOM

		//Mob preview
	var/icon/preview_icon = null

		//More jobs
	var/list/roles = new/list()
	var/department_tag = "CIV"

		//Metadata
	var/ckey = ""
	var/rounds = 0
	var/date = ""
	//Is the char locked in ?
	var/locked = 0
	//What is the employment status
	var/status = "Active"

		//Char background
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/flavor_texts_human = ""
	var/flavor_texts_robot = ""

		//Reccores
	var/med_record = "Medical records here:"
	var/sec_record = "Security records here:"
	var/gen_record = "General employment records here:"
	var/exploit_record = "Exploitable information here:"

		//phorensics (not used atm)
	var/DNA = ""
	var/fingerprints = ""
	var/unique_identifier = ""

		//Langueages
	var/additional_language = "None"


	//Is this char to be deleted on safe or load ?
	var/to_delete = 0

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = BERANDOMJOB  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0
	// 0 = char records, 1 = char prefs
	var/char_prefs = 1
	// 0 = char list, 1 = char editor
	var/select_character = 0

		// OOC Metadata:
	var/metadata = ""

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = 0

	var/parallax = PARALLAX_HIGH

	var/uplink_spawn_loc = UPLINK_PDA


/datum/preferences/New(client/C)
	parent = C
	if(!job_stats)
		job_stats = new()

	custom_names["ai"] = pick(ai_names)
	custom_names["cyborg"] = pick(ai_names)
	custom_names["clown"] = pick(clown_names)
	custom_names["mime"] = pick(mime_names)
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			if(!to_delete)
				return

	//we couldn't load character data or the character is to be deleted so just randomize the character appearance + name
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	real_name = pref_species.random_name(gender,1)

	if(!loaded_preferences_successfully)
		save_preferences()

	//Lets only save when we need to!
	//save_character()
	return


/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	update_preview_icon()
	user << browse_rsc(preview_icon, "previewicon.png")
	var/dat = "<center>"

	dat += "<a href='?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Character Settings</a> "
	dat += "<a href='?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>Game Preferences</a>"

	if(!path)
		dat += "<div class='notice'>Please create an account to save your preferences</div>"

	dat += "</center>"

	dat += "<HR>"

	switch(current_tab)
		if (0) // Character Settings#
			dat += "<center>LOCK YOUR CHARACTER OR YOU WILL BE ASSIGNED A RANDOM ONE!</center>"
			dat += "<a href='?_src_=prefs;preference=select_character;select_character=0' [select_character == 0 ? "class='linkOn'" : ""]>Character List</a> "
			dat += "<a href='?_src_=prefs;preference=select_character;select_character=1' [select_character == 1 ? "class='linkOn'" : ""]>Edit Character</a>"
			switch(select_character)
				if(0)//Char list
					dat += "<center><h2>Character List</h2><br><br>"
					dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=add_char;add_char=1'>New Character</a><br><br>"
					if(path)
						var/savefile/S = new /savefile(path)
						if(S)
							var/name
							var/status
							dat += "<table><tr><th>Character</th><th>Status</th></tr>"
							for(var/i=1, i<= nr_chars, i++)
								S.cd = "/character[i]"
								S["real_name"] >> name
								S["status"] >> status
								if(!status)
									status = "Active"
								if(!name)
									name = "Character[i]"

								dat += "<tr valign='top' width='20%'>"
								if(status == "KIA" || status == "Terminated")
									dat += "<td><a style='white-space:nowrap'>[name]</a></td><td>[status]</td>"
								else
									dat += "<td><a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a></td><td>[status]</td>"
								dat += "</tr>"
							dat += "</table>"
				if(1)//Char editor
					dat += "<br>"
					dat += "<a href='?_src_=prefs;preference=char_prefs;char_prefs=1' [char_prefs == 1 ? "class='linkOn'" : ""]>Identity/Occupation</a>"
					dat += "<a href='?_src_=prefs;preference=char_prefs;char_prefs=0' [char_prefs == 0 ? "class='linkOn'" : ""]>Records</a>"
					switch(char_prefs)
						if(0)
							dat += character_records()
						if(1)
							dat += occupation_choices()
					dat += "</tr></table>"


		if (1) // Game Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>General Settings</h2>"
			dat += "<b>UI Style:</b> <a href='?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
			dat += "<b>Keybindings:</b> <a href='?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Default"]</a><br>"
			dat += "<b>tgui Style:</b> <a href='?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy" : "No Frills"]</a><br>"
			dat += "<b>tgui Monitors:</b> <a href='?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary" : "All"]</a><br>"
			dat += "<b>Play admin midis:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</a><br>"
			dat += "<b>Play lobby music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</a><br>"
			dat += "<b>Ghost ears:</b> <a href='?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost sight:</b> <a href='?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost whispers:</b> <a href='?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost radio:</b> <a href='?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "Yes" : "No"]</a><br>"
			dat += "<b>Ghost pda:</b> <a href='?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"
			dat += "<b>Pull requests:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "Yes" : "No"]</a><br>"
			dat += "<b>Midround Antagonist:</b> <a href='?_src_=prefs;preference=allow_midround_antag'>[(toggles & MIDROUND_ANTAG) ? "Yes" : "No"]</a><br>"
			if(config.allow_Metadata)
				dat += "<b>OOC Notes:</b> <a href='?_src_=prefs;preference=metadata;task=input'>Edit </a><br>"

			if(user.client)
				if(user.client.holder)
					dat += "<b>Adminhelp Sound:</b> <a href='?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"On":"Off"]</a><br>"
					dat += "<b>Announce Login:</b> <a href='?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"On":"Off"]</a><br>"

				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"

				if(unlock_content)
					dat += "<b>BYOND Membership Publicity:</b> <a href='?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "Public" : "Hidden"]</a><br>"
					dat += "<b>Ghost Form:</b> <a href='?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
					dat += "<B>Ghost Orbit: </B> <a href='?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"

			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += "<b>Ghost Accessories:</b> <a href='?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"

			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += "<b>Ghosts of Others:</b> <a href='?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"

			if (SERVERTOOLS && config.maprotation)
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.friendlyname])"
				else
					if (p_map in config.maplist)
						var/datum/votablemap/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.friendlyname
					else
						p_map += " (No longer exists)"
				dat += "<b>Preferred Map:</b> <a href='?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"

			dat += "<b>FPS:</b> <a href='?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"

			dat += "<b>Parallax (Fancy Space):</b> <a href='?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=\"?_src_=prefs;preference=parallaxup\";return false;'>"
			switch (parallax)
				if (PARALLAX_LOW)
					dat += "Low"
				if (PARALLAX_MED)
					dat += "Medium"
				if (PARALLAX_INSANE)
					dat += "Insane"
				if (PARALLAX_DISABLE)
					dat += "Disabled"
				else
					dat += "High"
			dat += "</a><br>"

			dat += "</td><td width='300px' height='300px' valign='top'>"

			dat += "<h2>Special Role Settings</h2>"

			if(jobban_isbanned(user, "Syndicate"))
				dat += "<font color=red><b>You are banned from antagonist roles.</b></font>"
				src.be_special = list()


			for (var/i in special_roles)
				if(jobban_isbanned(user, i))
					dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;jobbancheck=[i]'>BANNED</a><br>"
				else
					var/days_remaining = null
					if(config.use_age_restriction_for_jobs && ispath(special_roles[i])) //If it's a game mode antag, check if the player meets the minimum age
						var/mode_path = special_roles[i]
						var/datum/game_mode/temp_mode = new mode_path
						days_remaining = temp_mode.get_remaining_days(user.client)

					if(days_remaining)
						dat += "<b>Be [capitalize(i)]:</b> <font color=red> \[IN [days_remaining] DAYS]</font><br>"
					else
						dat += "<b>Be [capitalize(i)]:</b> <a href='?_src_=prefs;preference=be_special;be_special_type=[i]'>[(i in be_special) ? "Yes" : "No"]</a><br>"

			dat += "</td></tr></table>"

	dat += "<hr><center>"

	if(!IsGuestKey(user.key))
		if(!locked)
			dat += "<a href='?_src_=prefs;preference=load'>Undo</a> "
		dat += "<a href='?_src_=prefs;preference=save'>Save and Lock Setup</a> "

	if(!locked)
		dat += "<a href='?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</center>"

	var/datum/browser/popup = new(user, "preferences", "<div align='center'>Character Setup</div>", 640, 770)
	popup.set_content(dat)
	popup.open(0)

/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Engineer"), widthPerColumn = 295, height = 620)
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "The job ticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Choose occupation chances</b><br>"

		if(!locked)
			HTML += "<center><a href='?_src_=prefs;preference=job;task=department'>Choose Department</a></center><br>"
		else
			HTML += "<center>[department_tag]</center><br>"

		HTML += "<div align='center'>Left-click to raise an occupation preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		for(var/datum/job/job in SSjob.occupations)

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			lastJob = job
			//world << "[parent]'s processing: [rank]"
			if(!has_role(rank))
				HTML += "<font color=black>[rank]</font></td><td><a href='?_src_=has_role;has_role=[rank]'> LOCKED</a></td></tr>"
				continue
			//world << "[parent] has role"

			if(jobban_isbanned(user, rank))
				HTML += "<font color=red>[rank]</font></td><td><a href='?_src_=prefs;jobbancheck=[rank]'> BANNED</a></td></tr>"
				continue
			//world << "[parent] is not jobbanned from role"

			if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=red>[rank]</font></td><td><font color=red> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			//world << "[parent] is not has old enough client"

			if(config.enforce_human_authority && !user.client.prefs.pref_species.qualifies_for_rank(rank, user.client.prefs.features))
				if(user.client.prefs.pref_species.id == "human")
					HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[MUTANT\]</b></font></td></tr>"
				else
					HTML += "<font color=red>[rank]</font></td><td><font color=red><b> \[NON-HUMAN\]</b></font></td></tr>"
				continue
			//world << "[parent]'s species can do role"


			if((rank in command_positions) || (rank == "AI"))//Bold head jobs
				HTML += "<b><span class='dark'>[rank]</span></b>"
			else
				HTML += "<span class='dark'>[rank]</span>"

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			if(roles[rank] == "HIGH")
				prefLevelLabel = "High"
				prefLevelColor = "slateblue"
				prefUpperLevel = 4
				prefLowerLevel = 2
			else if(roles[rank] == "MEDIUM")
				prefLevelLabel = "Medium"
				prefLevelColor = "green"
				prefUpperLevel = 1
				prefLowerLevel = 3
			else if(roles[rank] == "LOW")
				prefLevelLabel = "Low"
				prefLevelColor = "orange"
				prefUpperLevel = 2
				prefLowerLevel = 4
			else
				prefLevelLabel = "NEVER"
				prefLevelColor = "red"
				prefUpperLevel = 3
				prefLowerLevel = 1

			HTML += "<a class='white' href='?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"
			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Be an Assistant if preferences unavailable"
		if(joblessrole == BERANDOMJOB)
			message = "Get random job if preferences unavailable"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Return to lobby if preferences unavailable"
		HTML += "<center><br><a href='?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='?_src_=prefs;preference=job;task=reset'>Reset Preferences</a></center>"

	user << browse(null, "window=preferences")
	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(0)
	return

//FUCK BITFLAGS AND SHIFTS AND ALL THAT BS! ~rj
/datum/preferences/proc/SetJobPreferenceLevel(var/job, level)
	//world << "Setting job prefs, job: [job], level: [level]"
	var/priority = "NEVER"
	switch(level)
		if(1)
			priority = "HIGH"
		if(2)
			priority = "MEDIUM"
		if(3)
			priority = "LOW"
		if(4)
			priority = "NEVER"

	if (!job)
		return 0

	if (level == 1) // to high
		//remove any other job(s) set to high
		//world << "Setting to high."
		for(var/x in roles)
			if(roles[x] == "HIGH")
				roles[x] = "MEDIUM"

	for(var/x in roles)
		if(x == job)
			//world << "Setting job role job: [job], to: [priority]"
			roles[x] = priority
			return 1

	return 0

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	//world << "[parent] updating job level job: [role], level: [desiredLvl]"
	if(!SSjob || SSjob.occupations.len <= 0)
		//world << "No job subsystem or SSjob occupations list is empty"
		return
	var/datum/job/job = SSjob.GetJob(role)
	//world << "[parent] getting job datum for [role]"

	if(!job)
		//world << "[parent] no job datum found."
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		//world << "[parent] desired level: [desiredLvl] is not a number"
		user << "<span class='danger'>UpdateJobPreference - desired level was not a number. Please notify coders!</span>"
		ShowChoices(user)
		return

	//world << "[parent] setting preferenses."
	SetJobPreferenceLevel(role, desiredLvl)
	SetChoices(user)

	return 1

//Check if the player has this job on the given level
/datum/preferences/proc/GetJobDepartment(var/datum/job/j, var/level)
	var/priority = "NEVER"
	switch(level)
		if(1)
			priority = "HIGH"
		if(2)
			priority = "MEDIUM"
		if(3)
			priority = "LOW"
		if(4)
			priority = "NEVER"


	var/title = j.title
	for(var/x in roles)
		if(x == title)
			if(roles[x] == priority)
				return 1
	return 0


/datum/preferences/proc/ResetJobs()
	for(var/x in roles)
		roles[x] = "NEVER"

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["jobbancheck"])
		var/job = sanitizeSQL(href_list["jobbancheck"])
		var/sql_ckey = sanitizeSQL(user.ckey)
		var/DBQuery/query_get_jobban = dbcon.NewQuery("SELECT reason, bantime, duration, expiration_time, a_ckey FROM [format_table_name("ban")] WHERE ckey = '[sql_ckey]' AND job = '[job]' AND (bantype = 'JOB_PERMABAN'  OR (bantype = 'JOB_TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")
		if(!query_get_jobban.Execute())
			var/err = query_get_jobban.ErrorMsg()
			log_game("SQL ERROR obtaining reason from ban table. Error : \[[err]\]\n")
			return
		if(query_get_jobban.NextRow())
			var/reason = query_get_jobban.item[1]
			var/bantime = query_get_jobban.item[2]
			var/duration = query_get_jobban.item[3]
			var/expiration_time = query_get_jobban.item[4]
			var/a_ckey = query_get_jobban.item[5]
			var/text
			text = "<span class='redtext'>You, or another user of this computer, ([user.ckey]) is banned from playing [job]. The ban reason is:<br>[reason]<br>This ban was applied by [a_ckey] on [bantime]"
			if(text2num(duration) > 0)
				text += ". The ban is for [duration] minutes and expires on [expiration_time] (server time)"
			text += ".</span>"
			user << text
		return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				if(locked)
					save_character()
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(jobban_isbanned(user, "Assistant"))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEASSISTANT
					if(BEASSISTANT)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)

			if("department")
				generate_init_roles()
				var/list/departments = list("Civilian" = "CIV", "Cargo" = "CAR", "Medical" = "MED", "Science" = "SCI", "Engineering" = "ENG", "Security" = "SEC", "Silicon" = "SIL")
				var/tmp/choises = list("Civilian","Cargo","Medical","Science","Engineering","Security","Silicon")
				var/chosen = input(user, "Choose your department:","Choose Department",null) as null|anything in choises
				department_tag = departments[chosen]
				if(!department_tag || isnull(department_tag) || department_tag == "")
					department_tag = "CIV"
				prune_roles()
				SetChoices(user)

			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					hair_color = random_short_color()
				if("hair_style")
					hair_style = random_hair_style(gender)
				if("facial")
					facial_hair_color = random_short_color()
				if("facial_hair_style")
					facial_hair_style = random_facial_hair_style(gender)
				if("underwear")
					underwear = random_underwear(gender)
				if("undershirt")
					undershirt = random_undershirt(gender)
				if("socks")
					socks = random_socks()
				if("eyes")
					eye_color = random_eye_color()
				if("s_tone")
					skin_tone = random_skin_tone()
				if("bag")
					backbag = pick(backbaglist)
				if("all")
					random_character()

		if("input")
			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = input(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",null) as null|anything in ghost_forms
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = input(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND", null) as null|anything in ghost_orbits
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("name")
					var/new_name = reject_bad_name( input(user, "Choose your character's name:", "Character Preference")  as text|null )
					if(new_name)
						real_name = new_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("gen_rec")
					var/rec = input(user, "Fill in your characters general employment record", "Character Preference")  as text|null
					if(rec)
						gen_record = rec
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("sec_rec")
					var/rec = input(user, "Fill in your characters security record", "Character Preference")  as text|null
					if(rec)
						sec_record = rec
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("med_rec")
					var/rec = input(user, "Fill in your characters medical record", "Character Preference")  as text|null
					if(rec)
						med_record = rec
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("exp_rec")
					var/rec = input(user, "Fill in your characters general employment reccord", "Character Preference")  as text|null
					if(rec)
						exploit_record = rec
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
					if(new_age)
						age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , metadata)  as message|null
					if(new_metadata)
						metadata = sanitize(copytext(new_metadata,1,MAX_MESSAGE_LEN))

				if("hair")
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as null|color
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair)


				if("hair_style")
					var/new_hair_style
					if(gender == MALE)
						new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in hair_styles_male_list
					else
						new_hair_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in hair_styles_female_list
					if(new_hair_style)
						hair_style = new_hair_style

				if("next_hair_style")
					if (gender == MALE)
						hair_style = next_list_item(hair_style, hair_styles_male_list)
					else
						hair_style = next_list_item(hair_style, hair_styles_female_list)

				if("previous_hair_style")
					if (gender == MALE)
						hair_style = previous_list_item(hair_style, hair_styles_male_list)
					else
						hair_style = previous_list_item(hair_style, hair_styles_female_list)

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as null|color
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial)

				if("facial_hair_style")
					var/new_facial_hair_style
					if(gender == MALE)
						new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in facial_hair_styles_male_list
					else
						new_facial_hair_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in facial_hair_styles_female_list
					if(new_facial_hair_style)
						facial_hair_style = new_facial_hair_style

				if("next_facehair_style")
					if (gender == MALE)
						facial_hair_style = next_list_item(facial_hair_style, facial_hair_styles_male_list)
					else
						facial_hair_style = next_list_item(facial_hair_style, facial_hair_styles_female_list)

				if("previous_facehair_style")
					if (gender == MALE)
						facial_hair_style = previous_list_item(facial_hair_style, facial_hair_styles_male_list)
					else
						facial_hair_style = previous_list_item(facial_hair_style, facial_hair_styles_female_list)

				if("underwear")
					var/new_underwear
					if(gender == MALE)
						new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_m
					else
						new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_f
					if(new_underwear)
						underwear = new_underwear

				if("undershirt")
					var/new_undershirt
					if(gender == MALE)
						new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in undershirt_m
					else
						new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference") as null|anything in undershirt_f
					if(new_undershirt)
						undershirt = new_undershirt

				if("socks")
					var/new_socks
					new_socks = input(user, "Choose your character's socks:", "Character Preference") as null|anything in socks_list
					if(new_socks)
						socks = new_socks

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
					if(new_eyes)
						eye_color = sanitize_hexcolor(new_eyes)

				if("species")

					var/result = input(user, "Select a species", "Species Selection") as null|anything in roundstart_species

					if(result)
						var/newtype = roundstart_species[result]
						pref_species = new newtype()
						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#7F7F7F")[3]))
							features["mcolor"] = pref_species.default_color

				if("mutant_color")
					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Character Preference") as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						else
							user << "<span class='danger'>Invalid color. Your color is not bright enough.</span>"

				if("tail_lizard")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in tails_list_lizard
					if(new_tail)
						features["tail_lizard"] = new_tail

				if("tail_human")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in tails_list_human
					if(new_tail)
						features["tail_human"] = new_tail

				if("snout")
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in snouts_list
					if(new_snout)
						features["snout"] = new_snout

				if("horns")
					var/new_horns
					new_horns = input(user, "Choose your character's horns:", "Character Preference") as null|anything in horns_list
					if(new_horns)
						features["horns"] = new_horns

				if("tentacles")
					var/new_tentacles
					new_tentacles = input(user, "Choose your character's tentacles:", "Character Preference") as anything in tentacles_list
					if(new_tentacles)
						features["tentacles"] = new_tentacles

				if("ears")
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in ears_list
					if(new_ears)
						features["ears"] = new_ears

				if("wings")
					var/new_wings
					new_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in r_wings_list
					if(new_wings)
						features["wings"] = new_wings

				if("frills")
					var/new_frills
					new_frills = input(user, "Choose your character's frills:", "Character Preference") as null|anything in frills_list
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = input(user, "Choose your character's spines:", "Character Preference") as null|anything in spines_list
					if(new_spines)
						features["spines"] = new_spines

				if("body_markings")
					var/new_body_markings
					new_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in body_markings_list
					if(new_body_markings)
						features["body_markings"] = new_body_markings

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in legs_list
					if(new_legs)
						features["legs"] = new_legs

				if("s_tone")
					var/new_s_tone = input(user, "Choose your character's skin-tone:", "Character Preference")  as null|anything in skin_tones
					if(new_s_tone)
						skin_tone = new_s_tone

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
					if(new_backbag)
						backbag = new_backbag

				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("clown_name")
					var/new_clown_name = reject_bad_name( input(user, "Choose your character's clown name:", "Character Preference")  as text|null )
					if(new_clown_name)
						custom_names["clown"] = new_clown_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("mime_name")
					var/new_mime_name = reject_bad_name( input(user, "Choose your character's mime name:", "Character Preference")  as text|null )
					if(new_mime_name)
						custom_names["mime"] = new_mime_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("ai_name")
					var/new_ai_name = reject_bad_name( input(user, "Choose your character's AI name:", "Character Preference")  as text|null, 1 )
					if(new_ai_name)
						custom_names["ai"] = new_ai_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, 0-9, -, ' and .</font>"

				if("cyborg_name")
					var/new_cyborg_name = reject_bad_name( input(user, "Choose your character's cyborg name:", "Character Preference")  as text|null, 1 )
					if(new_cyborg_name)
						custom_names["cyborg"] = new_cyborg_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, 0-9, -, ' and .</font>"

				if("religion_name")
					var/new_religion_name = reject_bad_name( input(user, "Choose your character's religion:", "Character Preference")  as text|null )
					if(new_religion_name)
						custom_names["religion"] = new_religion_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("deity_name")
					var/new_deity_name = reject_bad_name( input(user, "Choose your character's deity:", "Character Preference")  as text|null )
					if(new_deity_name)
						custom_names["deity"] = new_deity_name
					else
						user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

				if("sec_dept")
					var/department = input(user, "Choose your prefered security department:", "Security Departments") as null|anything in security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.friendlyname])"
					for (var/M in config.maplist)
						var/datum/votablemap/VM = config.maplist[M]
						var/friendlyname = "[VM.friendlyname] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.name
					maplist[default] = null
					var/pickedmap = input(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference")  as null|anything in maplist
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/version_message
					if (user.client && user.client.byond_version < 511)
						version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [user.client.byond_version] is too low"
					if (world.byond_version < 511)
						version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
					var/desiredfps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = desiredfps
						if (world.byond_version >= 511 && user.client && user.client.byond_version >= 511)
							user.client.vars["fps"] = clientfps
				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference")  as null|anything in list("Midnight", "Plasmafire", "Retro", "Slimecore", "Operative", "Clockwork")
					if(pickedui)
						UI_style = pickedui

		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE
					underwear = random_underwear(gender)
					undershirt = random_undershirt(gender)
					socks = random_socks()
					facial_hair_style = random_facial_hair_style(gender)
					hair_style = random_hair_style(gender)

				if("hotkeys")
					hotkeys = !hotkeys

				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_lock")
					tgui_lock = !tgui_lock

				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP
				if("announce_login")
					toggles ^= ANNOUNCE_LOGIN

				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("name")
					be_random_name = !be_random_name

				if("all")
					be_random_body = !be_random_body

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if(toggles & SOUND_LOBBY)
						user << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
					else
						user.stopLobbySound()

				if("ghost_ears")
					chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")
					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = Wrap(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref()

				if("parallaxdown")
					parallax = Wrap(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent && parent.mob && parent.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref()

				if("save")
					//Safe and lock in the character.
					locked = 1
					prune_roles()
					save_preferences()
					save_character()

				if("load")
					load_preferences()
					load_character()

				if("changeslot")
					if(!load_character(text2num(href_list["num"])))
						random_character()
						real_name = random_unique_name(gender)

				if("add_char")
					save_preferences()
					default_slot += 1
					random_character()
					real_name = random_unique_name(gender)
					nr_chars += 1

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])

				if("char_prefs")
					if(href_list["char_prefs"])
						char_prefs = text2num(href_list["char_prefs"])

				if("select_character")
					if(href_list["select_character"])
						select_character = text2num(href_list["select_character"])

	ShowChoices(user)
	return 1

/datum/preferences/proc/character_records()
	var/dat = ""
	dat += "<br>"

	dat += "<b>General:</b> "
	dat += "<a href='?_src_=prefs;preference=gen_rec;task=input'>[gen_record]</a><BR>"

	dat += "<b>Medical:</b> "
	dat += "<a href='?_src_=prefs;preference=med_rec;task=input'>[med_record]</a><BR>"

	dat += "<b>Security:</b> "
	dat += "<a href='?_src_=prefs;preference=sec_rec;task=input'>[sec_record]</a><BR>"

	dat += "<b>Exploitable Information:</b> "
	dat += "<a href='?_src_=prefs;preference=exp_rec;task=input'>[exploit_record]</a><BR>"

	return dat

/datum/preferences/proc/occupation_choices()
	var/dat = ""
	dat += "<center><h2>Occupation Choices</h2>"
	dat += "<a href='?_src_=prefs;preference=job;task=menu'>Set Occupation Preferences</a><br></center>"

	dat += "<h2>Identity</h2>"
	if(!locked)
		dat += "<table width='100%'><tr><td width='75%' valign='top'>"
		if(jobban_isbanned(usr, "appearance"))
			dat += "<b>You are banned from using custom names and appearances. You can continue to adjust your characters, but you will be randomised once you join the game.</b><br>"
		dat += "<a href='?_src_=prefs;preference=name;task=random'>Random Name</A> "
		dat += "<a href='?_src_=prefs;preference=name'>Always Random Name: [be_random_name ? "Yes" : "No"]</a><BR>"

		dat += "<b>Name:</b> "
		dat += "<a href='?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"

		dat += "<b>Gender:</b> <a href='?_src_=prefs;preference=gender'>[gender == MALE ? "Male" : "Female"]</a><BR>"
		dat += "<b>Age:</b> <a href='?_src_=prefs;preference=age;task=input'>[age]</a><BR>"

		dat += "<b>Special Names:</b><BR>"
		dat += "<a href ='?_src_=prefs;preference=clown_name;task=input'><b>Clown:</b> [custom_names["clown"]]</a> "
		dat += "<a href ='?_src_=prefs;preference=mime_name;task=input'><b>Mime:</b>[custom_names["mime"]]</a><BR>"
		dat += "<a href ='?_src_=prefs;preference=ai_name;task=input'><b>AI:</b> [custom_names["ai"]]</a> "
		dat += "<a href ='?_src_=prefs;preference=cyborg_name;task=input'><b>Cyborg:</b> [custom_names["cyborg"]]</a><BR>"
		dat += "<a href ='?_src_=prefs;preference=religion_name;task=input'><b>Chaplain religion:</b> [custom_names["religion"]] </a>"
		dat += "<a href ='?_src_=prefs;preference=deity_name;task=input'><b>Chaplain deity:</b> [custom_names["deity"]]</a><BR>"

		dat += "<b>Custom job preferences:</b><BR>"
		dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Prefered security department:</b> [prefered_security_department]</a><BR></td>"

		dat += "<td valign='center'>"

		dat += "<div class='statusDisplay'><center><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></center></div>"

		dat += "</td></tr></table>"

		dat += "<h2>Body</h2>"
		dat += "<a href='?_src_=prefs;preference=all;task=random'>Random Body</A> "
		dat += "<a href='?_src_=prefs;preference=all'>Always Random Body: [be_random_body ? "Yes" : "No"]</A><br>"

		dat += "<table width='100%'><tr><td width='24%' valign='top'>"

		if(config.mutant_races)
			dat += "<b>Species:</b><BR><a href='?_src_=prefs;preference=species;task=input'>[pref_species.name]</a><BR>"
		else
			dat += "<b>Species:</b> Human<BR>"

		dat += "<b>Underwear:</b><BR><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a><BR>"
		dat += "<b>Undershirt:</b><BR><a href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a><BR>"
		dat += "<b>Socks:</b><BR><a href ='?_src_=prefs;preference=socks;task=input'>[socks]</a><BR>"
		dat += "<b>Backpack:</b><BR><a href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a><BR>"
		dat += "<b>Uplink Spawn Location:</b><BR><a href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a><BR></td>"

		if(pref_species.use_skintones)

			dat += "<td valign='top' width='21%'>"

			dat += "<h3>Skin Tone</h3>"

			dat += "<a href='?_src_=prefs;preference=s_tone;task=input'>[skin_tone]</a><BR>"

			dat += "</td>"

		if(HAIR in pref_species.species_traits)

			dat += "<td valign='top' width='21%'>"

			dat += "<h3>Hair Style</h3>"

			dat += "<a href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=previous_hair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_hair_style;task=input'>&gt;</a><BR>"
			dat += "<span style='border:1px solid #161616; background-color: #[hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"


			dat += "</td><td valign='top' width='21%'>"

			dat += "<h3>Facial Hair Style</h3>"

			dat += "<a href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=previous_facehair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_facehair_style;task=input'>&gt;</a><BR>"
			dat += "<span style='border: 1px solid #161616; background-color: #[facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"

			dat += "</td>"

		if(EYECOLOR in pref_species.species_traits)

			dat += "<td valign='top' width='21%'>"

			dat += "<h3>Eye Color</h3>"

			dat += "<span style='border: 1px solid #161616; background-color: #[eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a><BR>"

			dat += "</td>"

		if(config.mutant_races) //We don't allow mutant bodyparts for humans either unless this is true.

			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))

				dat += "<td valign='top' width='14%'>"

				dat += "<h3>Mutant Color</h3>"

				dat += "<span style='border: 1px solid #161616; background-color: #[features["mcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"

				dat += "</td>"

			if("tail_lizard" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Tail</h3>"

				dat += "<a href='?_src_=prefs;preference=tail_lizard;task=input'>[features["tail_lizard"]]</a><BR>"

				dat += "</td>"

			if("snout" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Snout</h3>"

				dat += "<a href='?_src_=prefs;preference=snout;task=input'>[features["snout"]]</a><BR>"

				dat += "</td>"

			if("horns" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Horns</h3>"

				dat += "<a href='?_src_=prefs;preference=horns;task=input'>[features["horns"]]</a><BR>"

				dat += "</td>"

			if("tentacles" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Tentacles</h3>"

				dat += "<a href='?_src_=prefs;preference=tentacles;task=input'>[features["tentacles"]]</a><BR>"

				dat += "</td>"

			if("frills" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Frills</h3>"

				dat += "<a href='?_src_=prefs;preference=frills;task=input'>[features["frills"]]</a><BR>"

				dat += "</td>"

			if("spines" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Spines</h3>"

				dat += "<a href='?_src_=prefs;preference=spines;task=input'>[features["spines"]]</a><BR>"

				dat += "</td>"

			if("body_markings" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Body Markings</h3>"

				dat += "<a href='?_src_=prefs;preference=body_markings;task=input'>[features["body_markings"]]</a><BR>"

				dat += "</td>"
			if("legs" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Legs</h3>"

				dat += "<a href='?_src_=prefs;preference=legs;task=input'>[features["legs"]]</a><BR>"

				dat += "</td>"
		if(config.mutant_humans)

			if("tail_human" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Tail</h3>"

				dat += "<a href='?_src_=prefs;preference=tail_human;task=input'>[features["tail_human"]]</a><BR>"

				dat += "</td>"

			if("ears" in pref_species.mutant_bodyparts)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Ears</h3>"

				dat += "<a href='?_src_=prefs;preference=ears;task=input'>[features["ears"]]</a><BR>"

				dat += "</td>"

			if("wings" in pref_species.mutant_bodyparts && r_wings_list.len >1)
				dat += "<td valign='top' width='7%'>"

				dat += "<h3>Wings</h3>"

				dat += "<a href='?_src_=prefs;preference=wings;task=input'>[features["wings"]]</a><BR>"

				dat += "</td>"
	else
		dat += "<table width='100%'><tr><td width='75%' valign='top'>"

		dat += "<b>Name:</b> [real_name]<BR>"

		dat += "<b>Gender:</b> [gender == MALE ? "Male" : "Female"]<BR>"
		dat += "<b>Age:</b> [age]<BR>"

		dat += "<b>Special Names:</b><BR>"
		dat += "<a href ='?_src_=prefs;preference=clown_name;task=input'><b>Clown:</b> [custom_names["clown"]]</a> "
		dat += "<a href ='?_src_=prefs;preference=mime_name;task=input'><b>Mime:</b>[custom_names["mime"]]</a><BR>"
		dat += "<a href ='?_src_=prefs;preference=ai_name;task=input'><b>AI:</b> [custom_names["ai"]]</a> "
		dat += "<a href ='?_src_=prefs;preference=cyborg_name;task=input'><b>Cyborg:</b> [custom_names["cyborg"]]</a><BR>"
		dat += "<a href ='?_src_=prefs;preference=religion_name;task=input'><b>Chaplain religion:</b> [custom_names["religion"]] </a>"
		dat += "<a href ='?_src_=prefs;preference=deity_name;task=input'><b>Chaplain deity:</b> [custom_names["deity"]]</a><BR>"

		dat += "<b>Custom job preferences:</b><BR>"
		dat += "<a href='?_src_=prefs;preference=sec_dept;task=input'><b>Prefered security department:</b> [prefered_security_department]</a><BR></td>"

		dat += "<td valign='center'>"

		dat += "<div class='statusDisplay'><center><img src=previewicon.png width=[preview_icon.Width()] height=[preview_icon.Height()]></center></div>"

		dat += "</td></tr></table>"

		dat += "<h2>Body</h2>"
		dat += "<table width='100%'><tr><td width='24%' valign='top'>"

		if(config.mutant_races)
			dat += "<b>Species:</b> [pref_species.name]<BR>"
		else
			dat += "<b>Species:</b> Human<BR>"

		dat += "<b>Underwear:</b><BR><a href ='?_src_=prefs;preference=underwear;task=input'>[underwear]</a><BR>"
		dat += "<b>Undershirt:</b><BR><a href ='?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a><BR>"
		dat += "<b>Socks:</b><BR><a href ='?_src_=prefs;preference=socks;task=input'>[socks]</a><BR>"
		dat += "<b>Backpack:</b><BR><a href ='?_src_=prefs;preference=bag;task=input'>[backbag]</a><BR>"
		dat += "<b>Uplink Spawn Location:</b><BR><a href ='?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a><BR></td>"

		if(HAIR in pref_species.species_traits)

			dat += "<td valign='top' width='21%'>"

			dat += "<h3>Hair Style</h3>"

			dat += "<a href='?_src_=prefs;preference=hair_style;task=input'>[hair_style]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=previous_hair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_hair_style;task=input'>&gt;</a><BR>"
			dat += "<span style='border:1px solid #161616; background-color: #[hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=hair;task=input'>Change</a><BR>"


			dat += "</td><td valign='top' width='21%'>"

			dat += "<h3>Facial Hair Style</h3>"

			dat += "<a href='?_src_=prefs;preference=facial_hair_style;task=input'>[facial_hair_style]</a><BR>"
			dat += "<a href='?_src_=prefs;preference=previous_facehair_style;task=input'>&lt;</a> <a href='?_src_=prefs;preference=next_facehair_style;task=input'>&gt;</a><BR>"
			dat += "<span style='border: 1px solid #161616; background-color: #[facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=facial;task=input'>Change</a><BR>"

			dat += "</td>"

		if(EYECOLOR in pref_species.species_traits)

			dat += "<td valign='top' width='21%'>"

			dat += "<h3>Eye Color</h3>"

			dat += "<span style='border: 1px solid #161616; background-color: #[eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='?_src_=prefs;preference=eyes;task=input'>Change</a><BR>"

			dat += "</td>"

	return dat

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, random = 1)
	//If the char is not locked give the user a random char for this round.
	if(!locked && random)
		real_name = pref_species.random_name(gender)
		random_character(gender)

	if(be_random_name)
		real_name = pref_species.random_name(gender)

	if(be_random_body)
		random_character(gender)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.name = character.real_name

	character.gender = gender
	character.age = age

	character.eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color

	character.skin_tone = skin_tone
	character.hair_style = hair_style
	character.facial_hair_style = facial_hair_style
	character.underwear = underwear
	character.undershirt = undershirt
	character.socks = socks

	character.backbag = backbag

	character.dna.features = features.Copy()
	character.dna.real_name = character.real_name
	var/datum/species/chosen_species
	if(pref_species != /datum/species/human && config.mutant_races)
		chosen_species = pref_species.type
	else
		chosen_species = /datum/species/human
	character.set_species(chosen_species, icon_update=0)

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts()

	character.character = src


/datum/preferences/proc/has_role(var/role)
	//world << "prefs/has_role, [role]"
	for(var/unlocked in roles)
		if(lowertext(unlocked) == lowertext(role))
			//world << "prefs/has_role/ret1, [unlocked], [role]"
			return 1
	//world << "prefs/has_role/ret0, [role]"
	return 0

/datum/preferences/proc/prune_roles()
	var/list/new_roles = new/list()
	for(var/J in job_stats.department_jobs[department_tag])
		for(var/role in roles)
			if(role == J)
				new_roles[role] = roles[role]

	for(var/J in job_stats.department_jobs["CIV"])
		new_roles[J] = "NEVER"
	roles = new_roles

/datum/preferences/proc/generate_init_roles()
	if(NO_INDUCTEE == 1)
		for(var/role in job_stats.all_jobs)
			roles[role] = "NEVER"
	else
		for(var/role in job_stats.inductee_roles)
			roles[role] = "NEVER"
	department_tag = "CIV"

/datum/preferences/proc/get_all_jobs()
	return job_stats.all_jobs

/mob/living
	var/datum/preferences/character = null