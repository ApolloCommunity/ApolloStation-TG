/datum/subsystem/ticker/New()
	NEW_SS_GLOBAL(ticker)

	login_music = pickweight(list('sound/ambience/space_asshole.ogg' =10, 'sound/ambience/title3.ogg' =15, 'sound/ambience/title4.ogg' =15, 'sound/misc/i_did_not_grief_them.ogg' =15, 'sound/ambience/fire_fire.ogg' = 15, 'sound/ambience/space_oddity.ogg' = 15, 'sound/ambience/mining_song2.ogg' = 15, 'sound/ambience/mining_song3.ogg' = 15)) // choose title music!
	if(SSevent.holidays && SSevent.holidays[APRIL_FOOLS])
		login_music = 'sound/ambience/clown.ogg'