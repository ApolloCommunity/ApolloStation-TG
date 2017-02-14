/*
Chief Medical Officer
*/
/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	department_head = list("Captain")
	department_flag = MED
	head_announce = list("Medical")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	req_admin_notify = 1
	minimal_player_age = 7

	outfit = /datum/outfit/job/cmo

	access = list(access_medical, access_morgue, access_genetics, access_cloning, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_fax)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_cloning, access_heads, access_mineral_storeroom,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_maint_tunnels, access_fax)

	rank_succession_level = COMMAND_SUCCESSION_LEVEL

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	id = /obj/item/weapon/card/id/silver
	belt = /obj/item/device/pda/heads/cmo
	ears = /obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1)

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel/med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/*
Medical Doctor
*/
/datum/job/seniordoctor
	title = "Senior Medical Doctor"
	alt_titles = list("Virologist")
	flag = SENIORDOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = MED
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_cloning, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_cloning, access_chemistry, access_virology)

	rank_succession_level = SENIOR_SUCCESSION_LEVEL

/datum/job/senirodoctor/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE)
	if(!H)
		return 0

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(H.job == "Virologist")
		H.equipOutfit(/datum/outfit/job/virologist, visualsOnly)
	else
		H.equipOutfit(/datum/outfit/job/doctor, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/*
Medical Doctor
*/
/datum/job/doctor
	title = "Medical Doctor"
	alt_titles = list("Pharmacist","Surgeon","Psychiatrist")
	flag = DOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = MED
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_cloning, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_cloning, access_chemistry)

	rank_succession_level = INDUCTEE_SUCCESSION_LEVEL

/datum/job/doctor/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE)
	if(!H)
		return 0

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)

	if(H.job == "Pharmacist")
		H.equipOutfit(/datum/outfit/job/pharmacist, visualsOnly)
	else
		H.equipOutfit(/datum/outfit/job/doctor, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/datum/outfit/job/doctor
	name = "Medical Doctor"
	jobtype = /datum/job/doctor

	belt = /obj/item/device/pda/medical
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel/med
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/datum/outfit/job/pharmacist
	name = "Pharmacist"
	jobtype = /datum/job/doctor

	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/device/pda/chemist
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist

	backpack = /obj/item/weapon/storage/backpack/chemistry
	satchel = /obj/item/weapon/storage/backpack/satchel/chem
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med

/datum/outfit/job/virologist
	name = "Virologist"
	jobtype = /datum/job/doctor

	belt = /obj/item/device/pda/viro
	ears = /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/virologist
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/virology
	satchel = /obj/item/weapon/storage/backpack/satchel/vir
	dufflebag = /obj/item/weapon/storage/backpack/dufflebag/med
