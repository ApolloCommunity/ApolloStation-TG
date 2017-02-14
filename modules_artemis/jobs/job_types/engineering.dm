/*
Chief Engineer
*/
/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	department_head = list("Captain")
	department_flag = ENG
	head_announce = list("Engineering")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffeeaa"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/ce

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_minisat,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_mineral_storeroom, access_fax, access_desubber)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors, access_minisat,
			            access_ce, access_RC_announce, access_keycard_auth, access_mineral_storeroom, access_fax, access_desubber)

	rank_succession_level = COMMAND_SUCCESSION_LEVEL

/datum/outfit/job/ce
	name = "Chief Engineer"
	jobtype = /datum/job/chief_engineer

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/weapon/storage/belt/utility/chief/full
	l_pocket = /obj/item/device/pda/heads/ce
	ears = /obj/item/device/radio/headset/heads/ce
	uniform = /obj/item/clothing/under/rank/chief_engineer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/color/black/ce
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1,/obj/item/device/modular_computer/tablet/preset/advanced=1)

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store

/datum/outfit/job/ce/rig
	name = "Chief Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine/elite
	shoes = /obj/item/clothing/shoes/magboots/advance
	suit_store = /obj/item/weapon/tank/internals/oxygen
	gloves = /obj/item/clothing/gloves/color/yellow
	head = null
	internals_slot = slot_s_store

/*
Senior Engineer
*/

/datum/job/seniorengineer
	title = "Senior Engineer"
	alt_titles = list("Atmospherics Specialist", "Engine Specialist")
	flag = SENIORENGINEER
	department_head = list("Chief Engineer")
	department_flag = ENG
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	outfit = /datum/outfit/job/engineer

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics, access_desubber)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics, access_desubber)

	rank_succession_level = SENIOR_SUCCESSION_LEVEL

/datum/job/seniorengineer/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE)
	if(!H)
		return 0

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(H.job == "Atmpsherics Specialist")
		H.equipOutfit(/datum/outfit/job/atmos, visualsOnly)
	else
		H.equipOutfit(/datum/outfit/job/engineer, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/*
Station Engineer
*/
/datum/job/engineer
	title = "Station Engineer"
	flag = ENGINEER
	department_head = list("Chief Engineer")
	department_flag = ENG
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "senior engineers and the chief engineer"
	selection_color = "#fff5cc"

	outfit = /datum/outfit/job/engineer

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics, access_desubber)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction)

	rank_succession_level = INDUCTEE_SUCCESSION_LEVEL

/datum/outfit/job/engineer
	name = "Station Engineer"
	jobtype = /datum/job/engineer

	belt = /obj/item/weapon/storage/belt/utility/full
	l_pocket = /obj/item/device/pda/engineering
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/hardhat
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/device/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/engineer/rig
	name = "Station Engineer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/engine
	suit_store = /obj/item/weapon/tank/internals/oxygen
	gloves = /obj/item/clothing/gloves/color/yellow
	head = null
	internals_slot = slot_s_store


/*
Atmospheric Specialist outfit
*/
/datum/outfit/job/atmos
	name = "Atmospheric Technician"
	jobtype = /datum/job/engineer

	belt = /obj/item/weapon/storage/belt/utility/atmostech
	l_pocket = /obj/item/device/pda/atmos
	ears = /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	r_pocket = /obj/item/device/analyzer

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel/eng
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/engineering
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/device/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/atmos/rig
	name = "Atmospheric Technician (Hardsuit)"

	mask = /obj/item/clothing/mask/gas
	suit = /obj/item/clothing/suit/space/hardsuit/engine/atmos
	suit_store = /obj/item/weapon/tank/internals/oxygen
	internals_slot = slot_s_store
