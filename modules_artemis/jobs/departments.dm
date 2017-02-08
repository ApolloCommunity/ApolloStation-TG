var/list/departments

/datum/department
	var/name
	var/list/positions = list()
	var/list/starting_positions = list()
	var/department_id
	var/color = "#FFFFFF"
	var/background_color = "#FFFFFF"
	var/font_color = "#000000"
	var/faction = "Station"
	var/region_access = list()

/datum/department/New()
	for( var/datum/job/job in allJobDatums)
		if( job.department_flag == department_id )
			positions += job
	departments[department_id] = src

	..()

/datum/department/proc/getPromotablePositionNames()
	var/list/names = list()

	for( var/datum/job/position in positions )
		if( position.rank_succession_level < COMMAND_SUCCESSION_LEVEL && position.rank_succession_level > INDUCTEE_SUCCESSION_LEVEL )
			names.Add( position.title )

	return names

/datum/department/proc/getAllPositionNames()
	var/list/names = list()

	for( var/datum/job/position in positions )
		names.Add( position.title )

	return names

/datum/department/proc/getAllPositionNamesWithPriority()
	var/list/names = getAllPositionNames()

	for( var/name in names )
		names[name] = "None"

	return names

/datum/department/proc/getLowestPosition()
	var/list/roles = list()

	for( var/datum/job/position in positions )
		if( position.rank_succession_level <= INDUCTEE_SUCCESSION_LEVEL )
			roles.Add( position )

	return pick( roles )

/datum/department/civilian
	name = "Civilian"
	department_id = CIVILIAN
	background_color = "#dddddd"
	starting_positions = list( "Assistant" = "Low", "Bartender" = "None", "Chaplain" = "None", "Chef" = "None", "Janitor" = "None", "Librarian" = "None")

/datum/department/engineering
	name = "Engineering"
	department_id = ENG
	background_color = "#ffeeaa"
	starting_positions = list( "Station Engineer" = "High" )

/datum/department/supply
	name = "Supply"
	department_id = CARGO
	background_color = "#FFF3D8"
	starting_positions = list( "Cargo Technician" = "High" , "Shaft Miner" = "None")

/datum/department/medical
	name = "Medical"
	department_id = MED
	background_color = "#EEFFEE"
	starting_positions = list( "Medical Doctor" = "High" )

/datum/department/science
	name = "Research"
	department_id = SCI
	background_color = "#ffeeff"
	starting_positions = list( "Scientist" = "High" )

/datum/department/security
	name = "Security"
	department_id = SEC
	background_color = "#ffeeee"
	starting_positions = list( "Security Officer" = "High" )