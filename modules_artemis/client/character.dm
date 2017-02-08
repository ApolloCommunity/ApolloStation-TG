var/list/all_characters = list() // A list of all loaded characters

//used for alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/character
	var/mob/living/carbon/human/char_mob
	var/ckey

	// Basic information
	var/real_name						//our character's name
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/blood_type = "A+"				//blood type (not-chooseable)

	// Default clothing
	var/underwear = "Nude"				//underwear type
	var/undershirt = "Nude"				//undershirt type
	var/socks = "Nude"					//socks type
	var/backbag = DBACKPACK				//backpack type
	var/prefered_security_department = SEC_DEPT_RANDOM

	// Cosmetic features
	var/hair_style = "Bald"				//Hair type
	var/hair_color = "000"				//Hair color
	var/facial_hair_style = "Shaved"	//Face hair type
	var/facial_hair_color = "000"		//Facial hair color

	var/skin_tone = "caucasian1"		//Skin color

	var/eye_color = "000"				//Eye color

	// Character species
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "FFF", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs")

	// Secondary language
	var/additional_language = "None"

	// Custom spawn gear
	var/list/gear

	// Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.

	// Job vars, these are used in the job selection screen and hiring computer
	var/datum/department/selected_department
	var/list/roles = list( "Assistant" = "Low" ) // Roles that the player has unlocked

	// Maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	// The default name of a job like "Medical Doctor"
	var/list/player_alt_titles = new()

	// Flavor texts
	var/flavor_texts_human
	var/flavor_texts_robot

	// Character records, these are written by the player
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	// Relation to NanoTrasen
	var/nanotrasen_relation = "Neutral"

	// Location of traitor uplink
	var/uplink_location = "PDA"

	var/DNA
	var/fingerprints
	var/unique_identifier

	var/list/birth_date = list()

	// A few status effects
	var/employment_status = "Active" // Is this character employed and alive or gone for good?

	var/round_number = 0 // When was this character last played?

	var/datum/browser/menu

	var/new_character = 1 // Is this a new character?
	var/temporary = 1 // Is this character only for this round?

/datum/character/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	undershirt = random_undershirt(gender)
	socks = random_socks()
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(config.roundstart_races)
		pref_species = new rando_race()
	backbag = 1
	features = random_features()
	age = rand(AGE_MIN,AGE_MAX)

/datum/character/New( var/key, var/new_char = 1, var/temp = 1 )
	ckey = ckey( key )

	blood_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

	gender = pick(MALE, FEMALE)

	gear = list()

	DNA = md5( "DNA[real_name][blood_type][gender][eye_color][time2text(world.timeofday,"hh:mm")]" )
	fingerprints = md5( DNA )
	unique_identifier = md5( fingerprints )

	new_character = new_char
	temporary = temp

	if( !selected_department )
		selected_department = departments["CIVILIAN"]
	menu = new( null, "creator", "Character Creator", 710, 610 )
	menu.window_options = "focus=0;can_close=0;"

	all_characters += src

/datum/character/Destroy()
	all_characters -= src

	..()