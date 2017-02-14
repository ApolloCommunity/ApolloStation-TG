/mob
	var/mod_sound = 1 						 // Should the sounds made by this creature be modulated?
	var/list/speech_sounds                   // A list of sounds to potentially play when speaking.
	var/list/speech_chance                   // The likelihood of a speech sound playing.
	var/datum/species_sounds/voice_sounds = null

/mob/living/carbon/human
	voice_sounds = new/datum/species_sounds/human

/mob/living/carbon/monkey
	mod_sound = 0
	voice_sounds = new/datum/species_sounds/monkey

/datum/emote/living/laugh/run_emote(mob/user, params = null, type_override = null)
	..()
	var/emote_sound = user.voice_sounds.getLaugh( user.gender )
	playsound(user.loc, emote_sound, 8, user.mod_sound )

/datum/emote/living/scream/run_emote(mob/user, params = null, type_override = null)
	..()
	var/emote_sound = user.voice_sounds.getScream( user.gender )
	playsound(user.loc, emote_sound, 8, user.mod_sound )

/datum/emote/living/cough/run_emote(mob/user, params = null, type_override = null)
	..()
	var/emote_sound = user.voice_sounds.getCough( user.gender )
	playsound(user.loc, emote_sound, 8, user.mod_sound )

/datum/emote/living/gasp/run_emote(mob/user, params = null, type_override = null)
	..()
	var/emote_sound = user.voice_sounds.getGasp( user.gender )
	playsound(user.loc, emote_sound, 8, user.mod_sound )

/datum/species_sounds
	var/list/m_scream = null
	var/list/f_scream = null

	var/list/m_gasp = null
	var/list/f_gasp = null

	var/list/m_cough = null
	var/list/f_cough = null

	var/list/m_laugh = null
	var/list/f_laugh = null

/datum/species_sounds/proc/getScream( var/gender = null )
	if( gender == FEMALE && f_scream )
		return pick( f_scream )

	if( m_scream ) // male screams are default, down with the patriarchy
		return pick( m_scream )

/datum/species_sounds/proc/getGasp( var/gender = null )
	if( gender == FEMALE && f_gasp )
		return pick( f_gasp )

	if( m_gasp )
		return pick( m_gasp )

/datum/species_sounds/proc/getLaugh( var/gender = null )
	if( gender == FEMALE && f_laugh )
		return pick( f_laugh )

	if( m_laugh )
		return pick( m_laugh )

/datum/species_sounds/proc/getCough( var/gender = null )
	if( gender == FEMALE && f_cough )
		return pick( f_cough )

	if( m_cough )
		return pick( m_cough )

/datum/species_sounds/human
	m_scream = list( 'sound/voice/human/manscream1.ogg',
					 'sound/voice/human/manscream2.ogg',
					 'sound/voice/human/manscream3.ogg' )
	f_scream = list( 'sound/voice/human/womanscream.ogg' )

	m_cough = list( 'sound/voice/human/mancough1.ogg',
					'sound/voice/human/mancough2.ogg',
					'sound/voice/human/mancough3.ogg')
	f_cough = list( 'sound/voice/human/womancough1.ogg',
					'sound/voice/human/womancough2.ogg',
					'sound/voice/human/womancough3.ogg')

	m_gasp = list( 'sound/voice/human/mangasp1.ogg',
				   'sound/voice/human/mangasp2.ogg' )

	f_gasp = list( 'sound/voice/human/womangasp1.ogg',
				   'sound/voice/human/womangasp2.ogg' )

	m_laugh = list( 'sound/voice/human/manlaugh1.ogg',
				   'sound/voice/human/manlaugh2.ogg' )

	f_laugh = list( 'sound/voice/human/womanlaugh.ogg' )

/datum/species_sounds/monkey
	m_scream = list( 'sound/voice/monkey/chimpanzee_scream1.ogg' )

	m_gasp = list( 'sound/voice/monkey/chimpanzee_chimper1.ogg',
				   'sound/voice/monkey/chimpanzee_chimper2.ogg',
				   'sound/voice/monkey/chimpanzee_whimper1.ogg' )