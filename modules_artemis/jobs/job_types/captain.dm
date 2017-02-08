/*
Captain
*/
/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department_head = list("Centcom")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Nanotrasen officials and Central Command"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14

	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

	rank_succession_level = CAPTAIN_SUCCESION_LEVEL

/datum/job/captain/get_access()
	return get_all_accesses()

/datum/job/captain/announce(mob/living/carbon/human/H)
	..()
	minor_announce("Captain [H.real_name] on deck!")

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	id = /obj/item/weapon/card/id/gold
	belt = /obj/item/device/pda/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform =  /obj/item/clothing/under/rank/captain
	suit = /obj/item/clothing/suit/armor/vest/capcarapace
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/captain
	satchel = /obj/item/weapon/storage/backpack/satchel/cap
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/captain

	implants = list(/obj/item/weapon/implant/mindshield)


/*
Head of Personnel
*/
/datum/job/hop
	title = "Head of Personnel"
	flag = HOP
	department_head = list("Captain")
	department_flag = CIVILIAN
	head_announce = list("Supply", "Service")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10

	outfit = /datum/outfit/job/hop

	access = list(access_security, access_sec_doors, access_court, access_weapons,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom, access_fax)
	minimal_access = list(access_security, access_sec_doors, access_court, access_weapons,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom, access_fax)

	rank_succession_level = CAPTAIN_SUCCESION_LEVEL-1

/datum/outfit/job/hop
	name = "Head of Personnel"
	jobtype = /datum/job/hop

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/hop
	ears = /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	shoes = /obj/item/clothing/shoes/sneakers/brown
	head = /obj/item/clothing/head/hopcap
	backpack_contents = list(/obj/item/weapon/storage/box/ids=1,\
		/obj/item/weapon/melee/classic_baton/telescopic=1, /obj/item/device/modular_computer/tablet/preset/advanced = 1)

/*
Internal Affairs Agent
*/
/datum/job/iaa
	title = "Internal Affairs Agent"
	flag = IAA
	department_head = list("Centcom")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Central Command"
	selection_color = "#ddddff"

	outfit = /datum/outfit/job/iaa

	access = list(access_lawyer, access_court, access_sec_doors, access_iaa, access_heads)
	minimal_access = list(access_lawyer, access_court, access_sec_doors, access_iaa, access_heads)

	rank_succession_level = COMMAND_SUCCESSION_LEVEL

/datum/outfit/job/iaa
	name = "Internal Affairs Agent"
	jobtype = /datum/job/iaa

	belt = /obj/item/device/pda/lawyer
	ears = /obj/item/device/radio/headset/heads
	uniform = /obj/item/clothing/under/lawyer/blacksuit
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/weapon/storage/briefcase/iaa
	l_pocket = /obj/item/device/laser_pointer
	implants = list(/obj/item/weapon/implant/mindshield)

/*
SolGov Rep
*/
/datum/job/solgov
	title = "SolGov Representative"
	flag = SOLGOVAGENT
	department_head = list("Captain")
	department_flag = SOLGOV
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Sol Government"
	selection_color = "#ffeeee"

	outfit = /datum/outfit/job/solgov

	access = list(access_lawyer, access_court, access_sec_doors)
	minimal_access = list(access_lawyer, access_court, access_sec_doors)

/datum/outfit/job/solgov
	name = "SolGov Representative"
	jobtype = /datum/job/solgov

	belt = /obj/item/device/pda/lawyer
	ears = /obj/item/device/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/lawyer/bluesuit
	suit = /obj/item/clothing/suit/toggle/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/weapon/storage/briefcase/lawyer
	l_pocket = /obj/item/device/laser_pointer
	r_pocket = /obj/item/clothing/tie/lawyers_badge
	implants = list(/obj/item/weapon/implant/mindshield)