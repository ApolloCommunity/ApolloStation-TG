/datum/computer_file/program/card_mod/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if (!ui)

		var/datum/asset/assets = get_asset_datum(/datum/asset/simple/headers)
		assets.send(user)

		ui = new(user, src, ui_key, "identification_computer", "ID card modification program", 600, 700, state = state)
		ui.open()
		ui.set_autoupdate(state = 1)


/datum/computer_file/program/card_mod/format_jobs(list/jobs)
	var/obj/item/weapon/computer_hardware/card_slot/card_slot = computer.all_components[MC_CARD]
	var/obj/item/weapon/card/id/id_card = card_slot.stored_card
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"display_name" = replacetext(job, "&nbsp", " "),
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/computer_file/program/card_mod/ui_act(action, params)
	if(..())
		return 1

	var/obj/item/weapon/computer_hardware/card_slot/card_slot
	var/obj/item/weapon/computer_hardware/printer/printer
	if(computer)
		card_slot = computer.all_components[MC_CARD]
		printer = computer.all_components[MC_PRINT]
		if(!card_slot)
			return

	var/obj/item/weapon/card/id/user_id_card = null
	var/mob/user = usr

	var/obj/item/weapon/card/id/id_card = card_slot.stored_card
	var/obj/item/weapon/card/id/auth_card = card_slot.stored_card2

	if(auth_card)
		user_id_card = auth_card
	else
		if(ishuman(user))
			var/mob/living/carbon/human/h = user
			user_id_card = h.get_idcard()

	switch(action)
		if("PRG_switchm")
			if(params["target"] == "mod")
				mod_mode = 1
			else if (params["target"] == "manifest")
				mod_mode = 0
			else if (params["target"] == "manage")
				mod_mode = 2
		if("PRG_togglea")
			if(show_assignments)
				show_assignments = 0
			else
				show_assignments = 1
		if("PRG_print")
			if(computer && printer) //This option should never be called if there is no printer
				if(mod_mode)
					if(authorized())
						var/contents = {"<h4>Access Report</h4>
									<u>Prepared By:</u> [user_id_card && user_id_card.registered_name ? user_id_card.registered_name : "Unknown"]<br>
									<u>For:</u> [id_card.registered_name ? id_card.registered_name : "Unregistered"]<br>
									<hr>
									<u>Assignment:</u> [id_card.assignment]<br>
									<u>Access:</u><br>
								"}

						var/known_access_rights = get_all_accesses()
						for(var/A in id_card.access)
							if(A in known_access_rights)
								contents += "  [get_access_desc(A)]"

						if(!printer.print_text(contents,"access report"))
							usr << "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>"
							return
						else
							computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
				else
					var/contents = {"<h4>Crew Manifest</h4>
									<br>
									[data_core ? data_core.get_manifest(0) : ""]
									"}
					if(!printer.print_text(contents,text("crew manifest ([])", worldtime2text())))
						usr << "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>"
						return
					else
						computer.visible_message("<span class='notice'>\The [computer] prints out paper.</span>")
		if("PRG_eject")
			if(computer && card_slot)
				var/select = params["target"]
				switch(select)
					if("id")
						if(id_card)
							data_core.manifest_modify(id_card.registered_name, id_card.assignment)
							card_slot.try_eject(1, user)
						else
							var/obj/item/I = usr.get_active_held_item()
							if (istype(I, /obj/item/weapon/card/id))
								if(!usr.drop_item())
									return
								I.forceMove(computer)
								card_slot.stored_card = I
					if("auth")
						if(auth_card)
							if(id_card)
								data_core.manifest_modify(id_card.registered_name, id_card.assignment)
							head_subordinates = null
							region_access = null
							authenticated = 0
							minor = 0
							card_slot.try_eject(2, user)
						else
							var/obj/item/I = usr.get_active_held_item()
							if (istype(I, /obj/item/weapon/card/id))
								if(!usr.drop_item())
									return
								I.forceMove(computer)
								card_slot.stored_card2 = I
		if("PRG_terminate")
			if(computer && ((id_card.assignment in head_subordinates) || id_card.assignment == "Assistant"))
				id_card.assignment = "Unassigned"
				remove_nt_access(id_card)

		if("PRG_edit")
			if(computer && authorized())
				if(params["name"])
					var/temp_name = reject_bad_name(input("Enter name.", "Name", id_card.registered_name),1)
					if(temp_name)
						id_card.registered_name = temp_name
					else
						computer.visible_message("<span class='notice'>[computer] buzzes rudely.</span>")
				//else if(params["account"])
				//	var/account_num = text2num(input("Enter account number.", "Account", id_card.associated_account_number))
				//	id_card.associated_account_number = account_num
		if("PRG_assign")
			if(computer && authorized() && id_card)
				var/t1 = params["assign_target"]
				if(t1 == "Custom")
					var/temp_t = reject_bad_text(input("Enter a custom job assignment.","Assignment", id_card.assignment), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J = new jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							usr << "<span class='warning'>No log exists for this job: [t1]</span>"
							return

						access = jobdatum.get_access()

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1

		if("PRG_access")
			if(params["allowed"] && computer && authorized())
				var/access_type = text2num(params["access_target"])
				var/access_allowed = text2num(params["allowed"])
				if(access_type in (is_centcom ? get_all_centcom_access() : get_all_accesses()))
					id_card.access -= access_type
					if(!access_allowed)
						id_card.access += access_type
		if("PRG_open_job")
			var/edit_job_target = params["target"]
			var/datum/job/j = SSjob.GetJob(edit_job_target)
			if(!j)
				return 0
			if(can_open_job(j) != 1)
				return 0
			if(opened_positions[edit_job_target] >= 0)
				time_last_changed_position = world.time / 10
			j.total_positions++
			opened_positions[edit_job_target]++
		if("PRG_close_job")
			var/edit_job_target = params["target"]
			var/datum/job/j = SSjob.GetJob(edit_job_target)
			if(!j)
				return 0
			if(can_close_job(j) != 1)
				return 0
			//Allow instant closing without cooldown if a position has been opened before
			if(opened_positions[edit_job_target] <= 0)
				time_last_changed_position = world.time / 10
			j.total_positions--
			opened_positions[edit_job_target]--
		if("PRG_regsel")
			if(!reg_ids)
				reg_ids = list()
			var/regsel = text2num(params["region"])
			if(regsel in reg_ids)
				reg_ids -= regsel
			else
				reg_ids += regsel

	if(id_card)
		id_card.name = text("[id_card.registered_name]'s ID Card ([id_card.assignment])")

	return 1

/datum/computer_file/program/card_mod/remove_nt_access(obj/item/weapon/card/id/id_card)
	id_card.access -= get_all_accesses()
	id_card.access -= get_all_centcom_access()

/datum/computer_file/program/card_mod/apply_access(obj/item/weapon/card/id/id_card, list/accesses)
	id_card.access |= accesses

/datum/computer_file/program/card_mod/ui_data(mob/user)

	var/list/data = get_header_data()

	var/obj/item/weapon/computer_hardware/card_slot/card_slot
	var/obj/item/weapon/computer_hardware/printer/printer

	if(computer)
		card_slot = computer.all_components[MC_CARD]
		printer = computer.all_components[MC_PRINT]

	data["mmode"] = mod_mode

	var/authed = 0
	if(computer)
		if(card_slot)
			var/obj/item/weapon/card/id/auth_card = card_slot.stored_card2
			data["auth_name"] = auth_card ? strip_html_simple(auth_card.name) : "-----"
			authed = authorized()


	if(mod_mode == 2)
		data["slots"] = list()
		var/list/pos = list()
		for(var/datum/job/job in SSjob.occupations)
			if(job.title in blacklisted)
				continue

			var/list/status_open = build_manage(job,1)
			var/list/status_close = build_manage(job,0)

			pos.Add(list(list(
				"title" = job.title,
				"current" = job.current_positions,
				"total" = job.total_positions,
				"status_open" = (authed && !minor) ? status_open["enable"]: 0,
				"status_close" = (authed && !minor) ? status_close["enable"] : 0,
				"desc_open" = status_open["desc"],
				"desc_close" = status_close["desc"])))
		data["slots"] = pos

	data["src"] = "\ref[src]"
	data["station_name"] = station_name()


	if(!mod_mode)
		data["manifest"] = list()
		var/list/crew = list()
		for(var/datum/data/record/t in sortRecord(data_core.general))
			crew.Add(list(list(
				"name" = t.fields["name"],
				"rank" = t.fields["rank"])))

		data["manifest"] = crew
	data["assignments"] = show_assignments
	if(computer)
		data["have_id_slot"] = !!card_slot
		data["have_printer"] = !!printer
		if(!card_slot && mod_mode == 1)
			mod_mode = 0 //We can't modify IDs when there is no card reader
	else
		data["have_id_slot"] = 0
		data["have_printer"] = 0

	data["centcom_access"] = is_centcom


	data["authenticated"] = authed


	if(mod_mode == 1 && computer)
		if(card_slot)
			var/obj/item/weapon/card/id/id_card = card_slot.stored_card

			data["has_id"] = !!id_card
			data["id_rank"] = id_card && id_card.assignment ? html_encode(id_card.assignment) : "Unassigned"
			data["id_owner"] = id_card && id_card.registered_name ? html_encode(id_card.registered_name) : "-----"
			data["id_name"] = id_card ? strip_html_simple(id_card.name) : "-----"

			if(show_assignments)
				data["engineering_jobs"] = format_jobs(engineering_positions)
				data["medical_jobs"] = format_jobs(medical_positions)
				data["science_jobs"] = format_jobs(science_positions)
				data["security_jobs"] = format_jobs(security_positions)
				data["cargo_jobs"] = format_jobs(supply_positions)
				data["civilian_jobs"] = format_jobs(civilian_positions)
				data["centcom_jobs"] = format_jobs(get_all_centcom_jobs())


		if(card_slot.stored_card)
			var/obj/item/weapon/card/id/id_card = card_slot.stored_card
			if(is_centcom)
				var/list/all_centcom_access = list()
				for(var/access in get_all_centcom_access())
					all_centcom_access.Add(list(list(
						"desc" = replacetext(get_centcom_access_desc(access), "&nbsp", " "),
						"ref" = access,
						"allowed" = (access in id_card.access) ? 1 : 0)))
				data["all_centcom_access"] = all_centcom_access
			else
				var/list/regions = list()
				for(var/i = 1; i <= 7; i++)
					if((minor || target_dept) && !(i in region_access))
						continue

					var/list/accesses = list()
					if(i in reg_ids)
						for(var/access in get_region_accesses(i))
							if (get_access_desc(access))
								accesses.Add(list(list(
								"desc" = replacetext(get_access_desc(access), "&nbsp", " "),
								"ref" = access,
								"allowed" = (access in id_card.access) ? 1 : 0)))

					regions.Add(list(list(
						"name" = get_region_accesses_name(i),
						"regid" = i,
						"selected" = (i in reg_ids) ? 1 : null,
						"accesses" = accesses)))
				data["regions"] = regions

	data["minor"] = target_dept || minor ? 1 : 0


	return data

/datum/computer_file/program/card_mod/authorized()
	if(!authenticated && computer)
		var/obj/item/weapon/computer_hardware/card_slot/card_slot = computer.all_components[MC_CARD]
		if(card_slot)
			var/obj/item/weapon/card/id/auth_card = card_slot.stored_card2
			if(auth_card)
				region_access = list()
				if(transfer_access in auth_card.GetAccess())
					minor = 0
					authenticated = 1
					return 1
				else
					if((access_hop in auth_card.access) && ((target_dept==1) || !target_dept))
						region_access |= 1
						region_access |= 6
						get_subordinates("Head of Personnel")
					if((access_hos in auth_card.access) && ((target_dept==2) || !target_dept))
						region_access |= 2
						get_subordinates("Head of Security")
					if((access_cmo in auth_card.access) && ((target_dept==3) || !target_dept))
						region_access |= 3
						get_subordinates("Chief Medical Officer")
					if((access_rd in auth_card.access) && ((target_dept==4) || !target_dept))
						region_access |= 4
						get_subordinates("Research Director")
					if((access_ce in auth_card.access) && ((target_dept==5) || !target_dept))
						region_access |= 5
						get_subordinates("Chief Engineer")
					if((access_ce in auth_card.access) && ((target_dept==6) || !target_dept))
						region_access |= 6
						get_subordinates("Quartermaster")
					if(region_access.len)
						minor = 1
						authenticated = 1
						return 1
	else
		return authenticated

/datum/computer_file/program/card_mod/get_subordinates(rank)
	head_subordinates = list()
	for(var/datum/job/job in SSjob.occupations)
		if(rank in job.department_head)
			head_subordinates += job.title
