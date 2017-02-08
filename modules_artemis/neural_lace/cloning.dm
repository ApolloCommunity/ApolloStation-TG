/*
	Defined in code/game/machinery/computer/cloning.dm
*/

// DNA scanner console
/obj/machinery/computer/cloning/scan_mob(mob/living/carbon/human/subject)
	if (!istype(subject))
		scantemp = "<font class='bad'>Unable to locate valid genetic data.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		return
	if (subject.suiciding == 1 || subject.hellbound)
		scantemp = "<font class='bad'>Subject is not responding to scanning stimuli.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		return
	if ((subject.disabilities & NOCLONE) && (src.scanner.scan_level < 2))
		scantemp = "<font class='bad'>Subject no longer contains the fundamental materials required to create a living clone.</font>"
		playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)
		return
	if (find_record("UI", subject.dna.uni_identity, records))
		scantemp = "<font class='average'>Subject DNA already in database.</font>"
		playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		return

	var/datum/data/record/R = new()
	if(subject.dna.species)
		// We store the instance rather than the path, because some
		// species (abductors, slimepeople) store state in their
		// species datums
		R.fields["mrace"] = subject.dna.species
	else
		var/datum/species/rando_race = pick(config.roundstart_races)
		R.fields["mrace"] = rando_race.type
	R.fields["name"] = subject.real_name
	R.fields["id"] = copytext(md5(subject.dna.uni_identity), 2, 6)
	R.fields["UE"] = subject.dna.unique_enzymes
	R.fields["UI"] = subject.dna.uni_identity
	R.fields["SE"] = subject.dna.struc_enzymes
	R.fields["blood_type"] = subject.dna.blood_type
	R.fields["features"] = subject.dna.features
	R.fields["factions"] = subject.faction

	//Add an implant if needed
	var/obj/item/weapon/implant/health/imp
	for(var/obj/item/weapon/implant/health/HI in subject.implants)
		imp = HI
		break
	if(!imp)
		imp = new /obj/item/weapon/implant/health(subject)
		imp.implant(subject)
	R.fields["imp"] = "\ref[imp]"

	src.records += R
	scantemp = "Subject successfully scanned."
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

/obj/machinery/computer/cloning/interact(mob/user)
	user.set_machine(src)
	add_fingerprint(user)
	ui_interact(user)

	updatemodules(TRUE)

	var/dat = ""
	dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a>"

	if(scanner && HasEfficientPod() && scanner.scan_level > 2)
		if(!autoprocess)
			dat += "<a href='byond://?src=\ref[src];task=autoprocess'>Autoprocess</a>"
		else
			dat += "<a href='byond://?src=\ref[src];task=stopautoprocess'>Stop autoprocess</a>"
	else
		dat += "<span class='linkOff'>Autoprocess</span>"

	dat += "<h3>Cloning Pod Status</h3>"
	dat += "<div class='statusDisplay'>[temp]&nbsp;</div>"

	switch(src.menu)
		if(1)
			// Modules
			if (isnull(src.scanner) || !pods.len)
				dat += "<h3>Modules</h3>"
				//dat += "<a href='byond://?src=\ref[src];relmodules=1'>Reload Modules</a>"
				if (isnull(src.scanner))
					dat += "<font class='bad'>ERROR: No Scanner detected!</font><br>"
				if (!pods.len)
					dat += "<font class='bad'>ERROR: No Pod detected</font><br>"

			// Scanner
			if (!isnull(src.scanner))
				dat += "<h3>Scanner Functions</h3>"

				dat += "<div class='statusDisplay'>"
				if (!src.scanner.occupant)
					dat += "Scanner Unoccupied"
				else if(loading)
					dat += "[src.scanner.occupant] => Scanning..."
				else if(scantemp)
					dat += "[src.scanner.occupant] => [scantemp]"
					spawn(20)
						scantemp = null
						src.updateUsrDialog()
				else
					dat += "[src.scanner.occupant] => Ready to Scan"
				dat += "</div>"

				if (src.scanner.occupant)
					dat += "<a href='byond://?src=\ref[src];scan=1'>Start Scan</a>"
					dat += "<br><a href='byond://?src=\ref[src];lock=1'>[src.scanner.locked ? "Unlock Scanner" : "Lock Scanner"]</a>"
				else
					dat += "<span class='linkOff'>Start Scan</span>"

			// Database
			dat += "<h3>Database Functions</h3>"
			if (src.records.len && src.records.len > 0)
				dat += "<a href='byond://?src=\ref[src];menu=2'>View Records ([src.records.len])</a><br>"
			else
				dat += "<span class='linkOff'>View Records (0)</span><br>"
			if (src.diskette)
				dat += "<a href='byond://?src=\ref[src];disk=eject'>Eject Disk</a><br>"

		if(2)
			dat += "<h3>Current records</h3>"
			dat += "<a href='byond://?src=\ref[src];menu=1'><< Back</a><br><br>"
			// not very pretty. refactor?
			var/list/name_records = list()
			for(var/datum/data/record/R in records)
				if(name_records[R.fields["name"]])
					name_records[R.fields["name"]] += R
				else
					name_records[R.fields["name"]] = list(R)
			
			for(var/name in name_records)
				dat += "<h4>[name]</h4>"
				for(var/datum/data/record/R in name_records[name])
					dat += "Scan ID [R.fields["id"]] <a href='byond://?src=\ref[src];view_rec=[R.fields["id"]]'>View Record</a>"
		if(3)
			dat += "<h3>Selected Record</h3>"
			dat += "<a href='byond://?src=\ref[src];menu=2'><< Back</a><br>"

			if (!src.active_record)
				dat += "<font class='bad'>Record not found.</font>"
			else
				dat += "<h4>[src.active_record.fields["name"]]</h4>"
				dat += "Scan ID [src.active_record.fields["id"]] <a href='byond://?src=\ref[src];clone=[active_record.fields["id"]]'>Clone</a><br>"

				var/obj/item/weapon/implant/health/H = locate(src.active_record.fields["imp"])

				if ((H) && (istype(H)))
					dat += "<b>Health Implant Data:</b><br />[H.sensehealth()]<br><br />"
				else
					dat += "<font class='bad'>Unable to locate Health Implant.</font><br /><br />"

				dat += "<b>Unique Identifier:</b><br /><span class='highlight'>[src.active_record.fields["UI"]]</span><br>"
				dat += "<b>Structural Enzymes:</b><br /><span class='highlight'>[src.active_record.fields["SE"]]</span><br>"

				if(diskette && diskette.fields)
					dat += "<div class='block'>"
					dat += "<h4>Inserted Disk</h4>"
					dat += "<b>Contents:</b> "
					var/list/L = list()
					if(diskette.fields["UI"])
						L += "Unique Identifier"
					if(diskette.fields["UE"] && diskette.fields["name"] && diskette.fields["blood_type"])
						L += "Unique Enzymes"
					if(diskette.fields["SE"])
						L += "Structural Enzymes"
					dat += english_list(L, "Empty", " + ", " + ")
					dat += "<br /><a href='byond://?src=\ref[src];disk=load'>Load from Disk</a>"

					dat += "<br /><a href='byond://?src=\ref[src];disk=save'>Save to Disk</a>"
					dat += "</div>"

				dat += "<font size=1><a href='byond://?src=\ref[src];del_rec=1'>Delete Record</a></font>"

		if(4)
			if (!src.active_record)
				src.menu = 2
			dat = "[src.temp]<br>"
			dat += "<h3>Confirm Record Deletion</h3>"

			dat += "<b><a href='byond://?src=\ref[src];del_rec=1'>Scan card to confirm.</a></b><br>"
			dat += "<b><a href='byond://?src=\ref[src];menu=3'>Cancel</a></b>"


	var/datum/browser/popup = new(user, "cloning", "Cloning System Control")
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/computer/cloning/Topic(href, href_list)
/*  Calling ..() in an overriding proc calls the original proc, don't do that as it'll destroy records when we try to access them
	The drawback is that we have to copy over the "actual" ..() code here. boo :(

	if(..())
		return
*/

	// obj/machinery/Topic
	if(!is_interactable())
		return 1
	if(!usr.canUseTopic(src))
		return 1
	add_fingerprint(usr)

	if(loading)
		return

	if(href_list["task"])
		switch(href_list["task"])
			if("autoprocess")
				autoprocess = 1
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
			if("stopautoprocess")
				autoprocess = 0
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)

	else if ((href_list["scan"]) && !isnull(scanner) && scanner.is_operational())
		scantemp = ""

		loading = 1
		src.updateUsrDialog()
		playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
		say("Initiating scan...")

		spawn(20)
			src.scan_mob(scanner.occupant)

			loading = 0
			src.updateUsrDialog()
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

		//No locking an open scanner.
	else if ((href_list["lock"]) && !isnull(scanner) && scanner.is_operational())
		if ((!scanner.locked) && (scanner.occupant))
			scanner.locked = 1
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
		else
			scanner.locked = 0
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

	else if(href_list["view_rec"])
		playsound(src, "terminal_type", 25, 0)
		src.active_record = find_record("id", href_list["view_rec"], records)
		if(active_record)
			src.menu = 3
		else
			src.temp = "Record missing."

	else if (href_list["del_rec"])
		if ((!src.active_record) || (src.menu < 3))
			return
		if (src.menu == 3) //If we are viewing a record, confirm deletion
			src.temp = "Delete record?"
			src.menu = 4
			playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)

		else if (src.menu == 4)
			var/obj/item/weapon/card/id/C = usr.get_active_held_item()
			if (istype(C)||istype(C, /obj/item/device/pda))
				if(src.check_access(C))
					src.temp = "[src.active_record.fields["name"]] => Record deleted."
					src.records.Remove(active_record)
					active_record = null
					playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
					src.menu = 2
				else
					src.temp = "<font class='bad'>Access Denied.</font>"
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)

	else if (href_list["disk"]) //Load or eject.
		switch(href_list["disk"])
			if("load")
				if (!diskette || !istype(diskette.fields) || !diskette.fields["name"] || !diskette.fields)
					src.temp = "<font class='bad'>Load error.</font>"
					src.updateUsrDialog()
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
					return
				if (!src.active_record)
					src.temp = "<font class='bad'>Record error.</font>"
					src.menu = 1
					src.updateUsrDialog()
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
					return

				for(var/key in diskette.fields)
					src.active_record.fields[key] = diskette.fields[key]
				src.temp = "Load successful."
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

			if("eject")
				if(src.diskette)
					src.diskette.loc = src.loc
					src.diskette = null
					playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, 0)
			if("save")
				if(!diskette || diskette.read_only || !active_record || !active_record.fields)
					src.temp = "<font class='bad'>Save error.</font>"
					src.updateUsrDialog()
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
					return

				diskette.fields = active_record.fields.Copy()
				diskette.name = "data disk - '[src.diskette.fields["name"]]'"
				src.temp = "Save successful."
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)

	else if (href_list["refresh"])
		src.updateUsrDialog()
		playsound(src, "terminal_type", 25, 0)

	else if (href_list["clone"])
		var/datum/data/record/C = find_record("id", href_list["clone"], records)
		//Look for that player!
		if(C)
			var/obj/machinery/clonepod/pod = GetAvailablePod()
			//Can't clone without someone to clone.  Or a pod.  Or if the pod is busy. Or full of gibs.
			if(!pods.len)
				temp = "<font class='bad'>No Clonepods detected.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			else if(pod.occupant)
				temp = "<font class='bad'>Cloning cycle already in progress.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			else if(!pod)
				temp = "<font class='bad'>No Clonepods available.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			else if(!config.revival_cloning)
				temp = "<font class='bad'>Unable to initiate cloning cycle.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			else if(pod.occupant)
				temp = "<font class='bad'>Cloning cycle already in progress.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)
			else if(pod.growclone(C.fields["name"], C.fields["UI"], C.fields["SE"], C.fields["mrace"], C.fields["features"], C.fields["factions"]))
				temp = "[C.fields["name"]] => <font class='good'>Cloning cycle in progress...</font>"
				playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
				menu = 1
			else
				temp = "[C.fields["name"]] => <font class='bad'>Initialisation failure.</font>"
				playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)

		else
			temp = "<font class='bad'>Data corruption.</font>"
			playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, 0)

	else if (href_list["menu"])
		src.menu = text2num(href_list["menu"])
		playsound(src, "terminal_type", 25, 0)

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/*
	Defined in code/game/machinery/cloning.dm
*/

#define CLONE_INITIAL_DAMAGE 190

// Cloning pod
/obj/machinery/clonepod/growclone(clonename, ui, se, datum/species/mrace, list/features, factions)
	if(panel_open)
		return FALSE
	if(mess || attempting)
		return FALSE

	attempting = TRUE //One at a time!!
	locked = TRUE
	countdown.start()

	eject_wait = TRUE
	addtimer(CALLBACK(src, .proc/wait_complete), 30)

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)

	H.hardset_dna(ui, se, H.real_name, null, mrace, features)

	if(efficiency > 2)
		var/list/unclean_mutations = (not_good_mutations|bad_mutations)
		H.dna.remove_mutation_group(unclean_mutations)
	if(efficiency > 5 && prob(20))
		H.randmutvg()
	if(efficiency < 3 && prob(50))
		var/mob/M = H.randmutb()
		if(ismob(M))
			H = M

	H.silent = 20 //Prevents an extreme edge case where clones could speak if they said something at exactly the right moment.
	occupant = H

	if(!clonename)	//to prevent null names
		clonename = "clone ([rand(0,999)])"
	H.real_name = clonename

	// clones shouldn't have a lace
	var/obj/item/organ/neural_lace/lace = H.getorgan(/obj/item/organ/neural_lace)
	lace.Remove(H)
	qdel(lace)

	icon_state = "pod_1"
	//Get the clone body ready
	H.setCloneLoss(CLONE_INITIAL_DAMAGE)     //Yeah, clones start with very low health, not with random, because why would they start with random health
	H.setBrainLoss(CLONE_INITIAL_DAMAGE)
	H.Paralyse(4)

	if(H)
		H.faction |= factions

		H.set_cloned_appearance()

		H.suiciding = FALSE
	attempting = FALSE
	return TRUE

/obj/machinery/clonepod/go_out()
	if (locked)
		return
	countdown.stop()

	if (mess) //Clean that mess and dump those gibs!
		mess = FALSE
		new /obj/effect/gibspawner/generic(loc)
		audible_message("<span class='italics'>You hear a splat.</span>")
		icon_state = "pod_0"
		return

	if (!occupant)
		return

	var/turf/T = get_turf(src)
	occupant.forceMove(T)
	icon_state = "pod_0"
	eject_wait = FALSE //If it's still set somehow.
	occupant.domutcheck(1) //Waiting until they're out before possible monkeyizing. The 1 argument forces powers to manifest.
	occupant = null

#undef CLONE_INITIAL_DAMAGE