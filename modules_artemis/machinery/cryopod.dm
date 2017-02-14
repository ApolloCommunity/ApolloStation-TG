/*
 * Cryogenic refrigeration unit. Basically a despawner.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_despawned ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */


//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/cryopod.dmi'
	icon_state = "cellconsole"
	circuit = "/obj/item/weapon/circuitboard/cryopodcontrol"
	density = 0
	interact_offline = 1

	var/mode = null

	//Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	var/list/frozen_items = list()

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = 1

/obj/machinery/computer/cryopod/attack_ai()
	src.attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	src.add_fingerprint(usr)

	var/dat

	if (!( ticker ))
		return

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=\ref[src];log=1'>View storage log</a>.<br>"
	if(allow_items)
		dat += "<a href='?src=\ref[src];view=1'>View objects</a>.<br>"
		dat += "<a href='?src=\ref[src];item=1'>Recover object</a>.<br>"
		dat += "<a href='?src=\ref[src];allitems=1'>Recover all objects</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)

	if(..())
		return

	var/mob/user = usr

	src.add_fingerprint(user)

	if(href_list["log"])

		var/dat = "<b>Recently stored [storage_type]</b><br/><hr/><br/>"
		for(var/person in frozen_crew)
			dat += "[person]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryolog")

	if(href_list["view"])
		if(!allow_items) return

		var/dat = "<b>Recently stored objects</b><br/><hr/><br/>"
		for(var/obj/item/I in frozen_items)
			dat += "[I.name]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryoitems")

	else if(href_list["item"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			user << "<span class='notice'>There is nothing to recover from storage.</span>"
			return

		var/obj/item/I = input(usr, "Please choose which object to retrieve.","Object recovery",null) as null|anything in frozen_items
		if(!I)
			return

		if(!(I in frozen_items))
			user << "<span class='notice'>\The [I] is no longer in storage.</span>"
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges \the [I].</span>", 3)

		I.loc = get_turf(src)
		frozen_items -= I

	else if(href_list["allitems"])
		if(!allow_items) return

		if(frozen_items.len == 0)
			user << "<span class='notice'>There is nothing to recover from storage.</span>"
			return

		visible_message("<span class='notice'>The console beeps happily as it disgorges the desired objects.</span>", 3)

		for(var/obj/item/I in frozen_items)
			I.loc = get_turf(src)
			frozen_items -= I

	src.updateUsrDialog()
	return

/obj/item/weapon/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = "/obj/machinery/computer/cryopod"
	origin_tech = "programming=3"

//Decorative structures to go alongside cryopods.
/obj/structure/cryofeed

	name = "cryogenic feed"
	desc = "A bewildering tangle of machinery and pipes."
	icon = 'icons/obj/cryopod.dmi'
	icon_state = "cryo_rear"
	anchored = 1
	density = 1

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "A man-sized pod for entering suspended animation."
	icon = 'icons/obj/cryopod.dmi'
	icon_state = "body_scanner"
	density = 0
	anchored = 1

	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"
	var/on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/time_till_despawn = 3000
	var/time_entered = 0          // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0
	var/obj/item/device/radio/headset/radio

	state_open = 1

	// These items are preserved when the process() despawn proc occurs.
	var/list/preserve_items = list(
		/obj/item/weapon/hand_tele,
		/obj/item/weapon/card/id/captains_spare,
		/obj/item/device/aicard,
		/obj/item/device/mmi,
		/obj/item/device/paicard,
		/obj/item/weapon/gun,
		/obj/item/weapon/pinpointer,
		/obj/item/clothing/suit,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/head/helmet/space,
		/obj/item/weapon/storage/internal
	)

/obj/machinery/cryopod/New()
	..()
	radio = new /obj/item/device/radio/headset(src)
	find_control_computer()
	icon_state = "body_scanner"
	update_icon()

/obj/machinery/cryopod/Destroy()
	if(occupant)
		occupant.loc = loc
		occupant.resting = 1
	..()

/obj/machinery/cryopod/proc/find_control_computer(urgent=0)
	// Workaround for http://www.byond.com/forum/?post=2007448
	for(var/obj/machinery/computer/cryopod/C in src.loc.loc)
		control_computer = C
		break
	//control_computer = locate(/obj/machinery/computer/cryopod) in src.loc.loc

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [src.loc.loc] could not find control computer!")
		message_admins("Cryopod in [src.loc.loc] could not find control computer!", "DEBUG:")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

//Lifted from Unity stasis.dm and refactored. ~Zuhayr
/obj/machinery/cryopod/process()
	if(occupant)
		//Allow a ten minute gap between entering the pod and actually despawning.
		if(world.time - time_entered < time_till_despawn)
			return

		if(!occupant.client && occupant.stat<2) //Occupant is living and has no client.
			if(!control_computer)
				if(!find_control_computer(urgent=1))
					return

			despawn_occupant()

// This function can not be undone; do not call this unless you are sure
// Also make sure there is a valid control computer
/obj/machinery/cryopod/proc/despawn_occupant()
	var/mob/living/carbon/human/H = occupant
	if( istype( occupant, /mob/living/carbon/human ))
		if( H.character )
			if( H.character.locked ) // If they've been saved to the database previously
				H.character.save_character()

	//Drop all items into the pod.
	for(var/obj/item/W in occupant)
		occupant.transferItemToLoc(W,src.loc)

		if(W.contents.len) //Make sure we catch anything not handled by qdel() on the items.
			for(var/obj/item/O in W.contents)
				if(istype(O,/obj/item/weapon/storage/internal)) //Stop eating pockets, you fuck!
					continue
				O.loc = src

	//Delete all items not on the preservation list.
	var/list/items = src.contents
	items -= occupant // Don't delete the occupant
	items -= radio // or the autosay radio.

	for(var/obj/item/W in items)

		var/preserve = null
		for(var/T in preserve_items)
			if(istype(W,T))
				preserve = 1
				break

		if(!preserve)
			qdel(W)
		else
			if(control_computer && control_computer.allow_items)
				control_computer.frozen_items += W
				W.loc = null
			else
				W.loc = src.loc

	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in objectives_list)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target && istype(O.target,/datum/mind))
			if(O.target == occupant.mind)
				if(O.owner && O.owner.current)
					O.owner.current << "<span class='warning'>You get the feeling your target is no longer within your reach. Time for Plan [pick(list("A","B","C","D","X","Y","Z"))]...</span>"
				O.target = null
				spawn(1) //This should ideally fire after the occupant is deleted.
					if(!O)
						return
					O.find_target()
					if(!(O.target))
						objectives_list -= O
						O.owner.objectives -= O
						qdel(O)

	//Handle job slot/tater cleanup.
	var/edit_job_target = H.job
	var/list/opened_positions = list();

	opened_positions[edit_job_target]++

	if(occupant.mind.objectives.len)
		qdel(occupant.mind.objectives)
		occupant.mind.special_role = null

	// Delete them from datacore.

	for(var/datum/data/record/t in sortRecord(data_core.general))
		if(t.fields["name"] == H.real_name)
			data_core.general -= t
	for(var/datum/data/record/R in data_core.medical)
		if ((R.fields["name"] == occupant.real_name))
			qdel(R)
	for(var/datum/data/record/T in data_core.security)
		if ((T.fields["name"] == occupant.real_name))
			qdel(T)
	for(var/datum/data/record/G in data_core.general)
		if ((G.fields["name"] == occupant.real_name))
			qdel(G)

	//TODO: Check objectives/mode, update new targets if this mob is the target, spawn new antags?

	//This should guarantee that ghosts don't spawn.
	occupant.ckey = null

	//Make an announcement and log the person entering storage.
	control_computer.frozen_crew += "[occupant.real_name]"

	radio.talk_into(src, "[occupant.real_name] [on_store_message]", "[on_store_name]", null, list(SPAN_ROBOT))
	visible_message("<span class='notice'>\The [src] hums and hisses as it moves [occupant.real_name] into storage.</span>", 3)

	// Delete the mob.
	qdel(occupant)
	occupant = null
	name = initial(name)

/obj/machinery/cryopod/open_machine()
	if(!state_open && !panel_open)
		..()
		name = initial(name)
		//Eject any items that aren't meant to be in the pod.
		var/list/items = src.contents
		if(occupant)
			items -= occupant
		if(radio)
			items -= radio

		for(var/obj/item/W in items)
			W.loc = get_turf(src)
		density = 0


/obj/machinery/cryopod/close_machine(mob/user)
	var/willing = 0 //We don't want to allow people to be forced into despawning.
	if(isnull(user) || !istype(user))
		return
	if(!(get_turf(user) == get_turf(src)))
		..(user)
		return
	if(state_open)
		..(user)
		if(user.client)
			if(alert(user,"Would you like to enter long-term storage?",,"Yes","No") == "Yes")
				if(!user)
					return
				willing = 1
		else
			willing = 1
		if(occupant && willing)
			occupant << "<span class='notice'><b>[on_enter_occupant_message]</b></span>"
			occupant << "<span class='notice'>If you ghost, log out or close your client now, your character will be permanently removed from the round</b></span>"
			log_admin("[key_name_admin(user)] has entered a stasis pod.")
			time_entered = world.time
			name = "[name] ([usr.name])"
			density = 0

/obj/machinery/cryopod/emp_act(severity)
	if(is_operational() && occupant)
		open_machine()
	..(severity)

/*
/obj/machinery/cryopod/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !user.IsAdvancedToolUser())
		return
	close_machine(target)
*/

/obj/machinery/cryopod/proc/toggle_open(mob/user)
	if(state_open)
		close_machine(user)
		return

	open_machine()

/obj/machinery/cryopod/attack_hand(mob/user)
	if(..(user,1,0)) //don't set the machine, since there's no dialog
		return

	toggle_open(user)

/obj/machinery/cryopod/update_icon()
	icon_state = initial(icon_state)
	if(!state_open)
		icon_state += "-open"

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.
