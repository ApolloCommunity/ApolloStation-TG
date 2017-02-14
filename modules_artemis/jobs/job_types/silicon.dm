/*
AI
*/
/datum/job/ai
	title = "AI"
	flag = AI
	department_flag = SILICON
	faction = "Station"
	total_positions = 0
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = 1
	minimal_player_age = 30

	rank_succession_level = BORG_SUCCESSION_LEVEL

/datum/job/ai/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

/datum/job/ai/config_check()
	if(config && config.allow_ai)
		return 1
	return 0

/*
Cyborg
*/
/datum/job/cyborg
	title = "Cyborg"
	flag = CYBORG
	department_flag = SILICON
	faction = "Station"
	total_positions = 0
	spawn_positions = 1
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"
	minimal_player_age = 21

	rank_succession_level = BORG_SUCCESSION_LEVEL

/datum/job/cyborg/equip(mob/living/carbon/human/H)
	if(!H)
		return 0
	return H.Robotize()
