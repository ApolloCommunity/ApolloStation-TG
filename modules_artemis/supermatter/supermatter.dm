/obj/machinery/power/supermatter_shard/supermatter
/*
	GAS EFFECTS
	PHORON: Heals the supermatter up until level 9
	N2O: Slows down power production
	O2: Acts as a turbocharger, multiplying heat and power production by a certain amount.
		Is required to keep a stable engine after level 5. If an engine is starved of O2, it will start experiencing critical failures.
	CO2: Fire suppressant, but also increases heat output by a small amount if SM level is 3 or above
*/

/obj/machinery/power/supermatter_shard/supermatter
	name = "supermatter core"
	desc = "A strangely translucent and iridescent crystal. <span class='alert'>You get headaches just from looking at it.</span>"
	icon = 'icons/obj/supermatter_artemis.dmi'
	icon_state = "supermatter"
	var/base_icon = "base"

	density = 1
	anchored = 0

	//light_range = 3
	//light_color = SM_DEFAULT_COLOR
	//light_power = 3

	color = SM_DEFAULT_COLOR
	luminosity = 4

	var/smlevel = 1

	power = 0
	var/power_percent = 0

	damage = 0
	var/damage_max = 1000
	damage_archived = 0
	emergency_point = 500

	safe_alert = ""
	var/safe_warned = 0

	emergency_issued = 0
	lastwarning = 0
	var/warning_delay = 15 // Once every 15 seconds, announce the status
	warning_point = 100

	var/last_crit_check = 0
	var/crit_delay = 60 // One minute between critical failure checks

	var/grav_pulling = 0
	var/exploded = 0

	var/debug = 0

	var/settings = null

/obj/machinery/power/supermatter_shard/supermatter/New( loc as turf, var/level = 1 )
	. = ..()

	settings = sm_levels

	if( level > MAX_SUPERMATTER_LEVEL )
		level = MAX_SUPERMATTER_LEVEL
	else if( level < MIN_SUPERMATTER_LEVEL )
		level = MIN_SUPERMATTER_LEVEL

	if( level != MIN_SUPERMATTER_LEVEL )
		smlevel = level

	spawn(0)
		update_icon()

	radio = new (src)
	radio.listening = 0

	if(countdown)
		qdel(countdown)
		countdown = null

/obj/machinery/power/supermatter_shard/supermatter/explode()
	message_admins("Supermatter exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)", "LOG:")
	log_game("Supermatter exploded at ([x],[y],[z])")
	grav_pulling = 1
	exploded = 1

	spawn( getSMVar( smlevel, "pull_time" ) * 2 )
		var/turf/epicenter = get_turf(src)

		explosion(epicenter, \
		          getSMVar( smlevel, "explosion_size" )/3, \
		          getSMVar( smlevel, "explosion_size" )/2, \
		          getSMVar( smlevel, "explosion_size" ), \
		          getSMVar( smlevel, "explosion_size" )*2, 1)

		supermatter_delamination( epicenter, getSMVar( smlevel, "delamination_size" ), smlevel, 1 )
		qdel( src )
		return

//Changes color and light_range of the light to these values if they were not already set
/obj/machinery/power/supermatter_shard/supermatter/proc/shift_light( var/clr, var/lum = luminosity)
	luminosity = lum
	SetLuminosity(lum)
	//light_color = clr
	//light_range = lum

	//color = clr

	//set_light( light_range, light_power, light_color )

/obj/machinery/power/supermatter_shard/supermatter/proc/announce_warning()
	var/integrity = calc_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if(damage > emergency_point)
		alert_msg = SM_EMERGENCY_ALERT + alert_msg
		lastwarning = world.timeofday - warning_delay * 5
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = SM_WARNING_ALERT + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = SM_SAFE_ALERT
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		radio.talk_into(src, alert_msg)

/obj/machinery/power/supermatter_shard/supermatter/proc/calc_integrity()
	var/integrity = damage / damage_max
	integrity = round( MAX_SM_INTEGRITY - ( integrity * MAX_SM_INTEGRITY))
	return integrity < 0 ? 0 : integrity

/obj/machinery/power/supermatter_shard/supermatter/process()
	power_percent = power/getSMVar( smlevel, "base_power" )

	// SUPERMATTER LOCATION CHECK
	if( turfCheck() )
		return

	// SUPERMATTER ALERT CHECK
	alertCheck()

	if(grav_pulling)
		supermatter_pull()

	// SUPERMATTER GAS INTERACTIONS
	hanldeEnvironment()

	// SUPERMATTER PSIONIC SHIT
	psionicBurst()

	// SUPERMATTER RADIATION
	radiate()

	// SUPERMATTER DECAY
	decay()

	// UPDATE DESC
	updateDesc()
	return 1

/obj/machinery/power/supermatter_shard/supermatter/proc/updateDesc()
	desc = initial(desc)
	if(damage > 200)
		desc += "<span class='alert'>You can see tiny cracks in the crystal.</span>"

	else if(damage > 400)
		desc += "<span class='alert'>A web of cracks span the crystal.</span>"

	else if(damage > 600)
		desc += "<span class='alert'>A web of deep cracks span the crystal.</span>"

	else if(damage > 800)
		desc += "<span class='alert'>A deep fissure of cracks span the crystal a pulsing glow is emanating from them.</span>"

/obj/machinery/power/supermatter_shard/supermatter/proc/turfCheck()
	var/turf/L = loc
	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL
	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return 1 //Yeah just stop.

	//TODO: Resonant chaimber!
	//if(istype( loc, /obj/machinery/phoron_desublimer/resonant_chamber ))
	//	return 1 // Resonant chambers are similar to bluespace beakers, they halt reactions within them

/obj/machinery/power/supermatter_shard/supermatter/proc/alertCheck()
	var/turf/L = loc
	if( damage > damage_max )
		if( !exploded )
			if( !istype( L, /turf/open/space ))
				announce_warning()
			explode()
	else if( damage > warning_point && ( world.timeofday - lastwarning ) >= warning_delay*10 ) // while the core is still damaged and it's still worth noting its status
		if( !istype( L, /turf/open/space ))
			announce_warning()

/obj/machinery/power/supermatter_shard/supermatter/proc/hanldeEnvironment()
	var/turf/L = loc

	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	// Getting the environment gas
	if(!istype(L, /turf/open/space))
		env = L.return_air()
		env.assert_gases("o2","n2","co2","n2o","plasma")
		removed = env.remove( max( env.total_moles()/10, min( smlevel * getSMVar( smlevel, "consumption_rate" ), env.total_moles() )))

	// If we're in a vacuum, heat can't escape the core, so we'll get damaged
	if(!env || !removed || !removed.total_moles())
		damage = max( 0, damage+( power_percent*getSMVar( smlevel, "vacuum_damage" )))
		return

	damage_archived = damage

	var/heat = getSMVar( smlevel, "thermal_factor" ) // the amount of heat we release

	// Awan suggested causing the SM to have different reactions to different gasses. So Let's try this.
	// Store these variables for reactions.
	var/oxygen = removed.gases["o2"][MOLES]
	var/phoron = removed.gases["plasma"][MOLES]
	var/carbon = removed.gases["co2"][MOLES]
	var/sleepy = removed.gases["n2o"][MOLES]

	// N2O handling
	if(sleepy)
		power = max( 0, power-( sleepy*getSMVar( smlevel, "n2o_power_loss" )))

	sleepy = 0

	// Oxygen handling
	if(oxygen >= getSMVar( smlevel, "o2_requirement" ))
		power = max( 0, power+( power*( oxygen*getSMVar( smlevel, "o2_turbo_multiplier" ))))
	else
		if( prob( getSMVar( smlevel, "crit_fail_chance" )) && delayPassed( crit_delay, last_crit_check ))
			critFail()
			spark()
		last_crit_check = world.timeofday
		damage = max( 0, damage+getSMVar( smlevel, "suffocation_damage" ))

	oxygen = 0

	// CO2 handling
	if(carbon)
		heat = max( 0, heat+( heat*( carbon*getSMVar( smlevel, "co2_heat_multiplier" )))) // Carbon reacts violently with supermatter, creating heat and leaving O2
		oxygen += carbon

	carbon = 0

	// Temperature & phoron handling
	if (removed.temperature < getSMVar( smlevel, "heat_damage_level" ))
		if(phoron)
			damage = max( 0, damage-( phoron*getSMVar( smlevel, "phoron_heal_rate" )))
	else
		var/delta_temp = removed.temperature-getSMVar( smlevel, "heat_damage_level" )
		damage = max( 0, ( delta_temp*getSMVar( smlevel, "damage_per_degree" )))

	if( power_percent > OVERCHARGE_LEVEL ) // If we're more than 120%
		heat = max( 0, heat+( heat*getSMVar( smlevel, "overcharge_heat_multiplier" )))
		if( prob( getSMVar( smlevel, "crit_fail_chance" )))
			spark()

	phoron = 0

	// Releasing phoron & oxygenm
	var/phoron_temp_percent = 1-( removed.temperature/getSMVar( smlevel, "phoron_release_heat_limit" )) // Needs to be taken from 1, so that 0K is max gas production
	if( phoron_temp_percent )
		phoron = max( 0, phoron_temp_percent*getSMVar( smlevel, "phoron_release" ))
	else
		phoron = 0

	var/o2_temp_percent = 1-( removed.temperature/getSMVar( smlevel, "o2_release_heat_limit" ))
	if( o2_temp_percent )
		oxygen = max( 0, o2_temp_percent*getSMVar( smlevel, "o2_release" ))
	else
		oxygen = 0

	//Release reaction gasses
	removed.gases["plasma"][MOLES] = phoron
	removed.gases["o2"][MOLES] = oxygen
	removed.gases["n2o"][MOLES] = sleepy
	removed.gases["co2"][MOLES] = carbon

	removed.add_thermal_energy( power*heat*( power_percent**2 ))
	env.merge(removed)

	// Healing
	damage = max( 0, damage-getSMVar( smlevel, "heal_rate" ))

/obj/machinery/power/supermatter_shard/supermatter/proc/psionicBurst()
	for(var/mob/living/carbon/human/l in oview(src, 7)) // If they can see it without mesons on.  Bad on them.
		if(!istype(l.glasses, /obj/item/clothing/glasses/meson))
		//TODO handle nucleation hallucinations!
			//if(!isnucleation(l))
				//l.hallucination = max(0, getSMVar( smlevel, "psionic_power" ) * sqrt(1 / max(1,get_dist(l, src))))
			//else // Nucleations get less hallucinatoins
			l.hallucination = max(0, getSMVar( smlevel, "psionic_power" )/5 * sqrt(1 / max(1,get_dist(l, src))))

// should probably be replaced with something more intricate sometime
/obj/machinery/power/supermatter_shard/supermatter/proc/radiate()
	// 0.83 * (power/733) + 1.28 comes from regression analysis on wanted values for the radiation range
	var/rad_range = round( 0.83 * (power/733) + 1.28 )
	radiation_pulse(get_turf(src), rad_range/2, rad_range, 100, log=0)
	transfer_energy()

/obj/machinery/power/supermatter_shard/supermatter/proc/decay()
	var/decay = max( getSMVar( smlevel, "minimum_decay" ), (power-getSMVar( smlevel, "base_power" ))*getSMVar( smlevel, "decay" ))
	power = max(0, power-decay)

/obj/machinery/power/supermatter_shard/supermatter/proc/critFail()
	var/crit_damage = rand( 0, getSMVar( smlevel, "crit_fail_damage" ))

	damage += crit_damage

	// A wave burst during a critical failure
	supermatter_delamination( get_turf( src ), smlevel*1.5, smlevel, 0, 0 )

	var/integrity = calc_integrity()
	radio.talk_into(src, "CRITICAL STRUCTURE FAILURE: [MAX_SM_INTEGRITY-integrity]% Integrity Lost!")
	announce_warning()

/obj/machinery/power/supermatter_shard/supermatter/proc/spark()
	// Light up some sparks
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(1, 3, src)
	sparks.start()
	return

/obj/machinery/power/supermatter_shard/supermatter/proc/smLevelChange( var/level_increase = 1 )
	smlevel += level_increase

	update_icon()

//Hitting the core with anything, this includes power and damage calculations from the emitter.
/obj/machinery/power/supermatter_shard/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0		// This stops people from being able to really power up the supermatter
						// Then bring it inside to explode instantly upon landing on a valid turf.

	if(Proj.flag != "bullet")
		var/factor = getSMVar( smlevel, "emitter_factor" )
		power += ( 0.16 * ( 1.69 ** factor )) * ( Proj.damage*config_bullet_energy) // regression
		if(smlevel > 1)
			//If above level 1
			//Dam calc with a exponential factor (simular as above).
			//Dam vars can be adjusted in utils.dm in the supermatter folder.
			var/dama = getSMVar( smlevel, "dama")
			var/damb = getSMVar( smlevel, "damb")
			var/damc = getSMVar( smlevel, "damc")
			damage += ((dama*(damb ** factor)) * Proj.damage)/damc * 50
	else
		damage += Proj.damage
	return 0

/obj/machinery/power/supermatter_shard/supermatter/proc/arc_act(energy)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0		// This stops people from being able to really power up the supermatter
						// Then bring it inside to explode instantly upon landing on a valid turf.
	var/factor = getSMVar( smlevel, "emitter_factor" )
	power += ( 0.16 * ( 1.69 ** factor )) * ( energy / ( ARC_EMITTER_POWER_MAX * 0.6667)) *50 // regression, times 50 to make up for arc emitter fire rate.
	if(smlevel > 1)
		//If above level 1
		//Dam calc with a exponential factor (simular as above).
		//Dam vars can be adjusted in /datum/sm_control
		var/dama = getSMVar( smlevel, "dama")
		var/damb = getSMVar( smlevel, "damb")
		var/damc = getSMVar( smlevel, "damc")
		damage += ((dama*(damb ** factor)) * energy)/damc * 50 //Times 50 to make up for arc emitter fire rate.

/obj/machinery/power/supermatter_shard/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"
	return

/obj/machinery/power/supermatter_shard/supermatter/attack_ai(mob/user as mob)
	user << "<span class = \"warning\">You attempt to interface with the control circuits but find they are not connected to your network.  Maybe in a future firmware update.</span>"

/obj/machinery/power/supermatter_shard/supermatter/attack_hand(mob/user as mob)
//TODO: NUCLEATIONS!
/*
	if( isnucleation( user )) // Nucleation's can touch it to heal!
		var/mob/living/L = user
		user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src], inducing a resonance... \his body starts to glow before they calmly pull away from it.</span>",\
		"<span class='notice'>You reach out and touch \the [src]. Everything seems to go quiet and slow down as you feel your crystal structures mending.\"</span></span>", \
		"<span class=\"danger\">Everything suddenly goes silent.\"</span>")
		L.revive(full_heal = 1, admin_revive = 0)
		L.sleeping = max(L.sleeping+2, 10)
		return
		*/


	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src], inducing a resonance... \his body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")

	Consume(user)

/obj/machinery/power/supermatter_shard/supermatter/transfer_energy()
	for(var/obj/machinery/power/rad_collector/R in rad_collectors)
		var/distance = get_dist(R, src)
		if(distance && distance <= getSMVar( smlevel, "collector_range" ))		//sanity for 1/0
			//stop their being a massive benifit to moving the rad collectors closer
			if(distance < 3)	distance = 2.67			// between 25 - 50k benifit 	(level 1)
			//for collectors using standard phoron tanks at 1013 kPa, the actual power generated will be this power*0.3*20*29 = power*174
			R.receive_pulse(power*(0.7/distance))			// mod = 0.65 : 0.325 : 0.211 ..... 0.065    outputs - ~400 - 435kW with default setup (tested via mapping > setup supermatter)
	return

/obj/machinery/power/supermatter_shard/supermatter/attackby(obj/item/W, mob/living/user, params)

	if(!istype(W) || (W.flags & ABSTRACT) || !istype(user))
		return

	if(istype(W, /obj/item/weapon/shard/supermatter))
		src.damage += W.force
		user.visible_message("<span class=\"warning\">\The [user] slashes at \the [src] with a [W] with a horrendous clash!</span>",\
		"<span class=\"danger\">You slash at \the [src] with \the [src] with a horrendous clash!\"</span>",\
		"<span class=\"warning\">A horrendous clash fills your ears.</span>")
		return

	if(user.drop_item(W))
		Consume(W)
		user.visible_message("<span class='danger'>As [user] touches \the [src] with \a [W], silence fills the room...</span>",\
			"<span class='userdanger'>You touch \the [src] with \the [W], and everything suddenly goes silent.</span>\n<span class='notice'>\The [W] flashes into dust as you flinch away from \the [src].</span>",\
			"<span class='italics'>Everything suddenly goes silent.</span>")
		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 50, 1)
		radiation_pulse(get_turf(src), 1, 1, 150, 1)

/obj/machinery/power/supermatter_shard/supermatter/ex_act()
	return

/obj/machinery/power/supermatter_shard/supermatter/Bumped( atom/AM as mob|obj )
	//we dont wanna cut out the arc emitter segments!
	if(istype(AM, /obj/segment))
		return

	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		if( !M.smVaporize()) // Nucleation's biology doesn't react to this
			return
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	Consume(AM)

/obj/machinery/power/supermatter_shard/supermatter/Consume(var/mob/living/user)
	if(istype(user))
		if( user.smVaporize() )
			power += getSMVar( smlevel, "base_power" )/8
	else
		qdel( user )
		return

	update_icon()

	power += getSMVar( smlevel, "base_power" )/8

		//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(src, sqrt(((power/getSMVar( smlevel, "base_power" ))*7) / 5)))
		if(l in view())
			l.show_message("<span class=\"warning\">As \the [src] slowly stops resonating, you find your skin covered in new radiation burns.</span>", 1,\
				"<span class=\"warning\">The unearthly ringing subsides and you notice you have new radiation burns.</span>", 2)
		else
			l.show_message("<span class=\"warning\">You hear an uneartly ringing and notice your skin is covered in fresh radiation burns.</span>", 2)

	var/rad_range = round(sqrt(((power/getSMVar( smlevel, "base_power" ))*7) / 5))
	radiation_pulse(get_turf(src), rad_range/2, rad_range, 200, 0)

/obj/machinery/power/supermatter_shard/supermatter/update_icon()
	color = getSMVar( smlevel, "color" )
	name = getSMVar( smlevel, "color_name" ) + " " + initial(name)

	shift_light( color )

/obj/machinery/power/supermatter_shard/supermatter/proc/supermatter_pull()

	// Let's just make this one loop.
	for(var/atom/X in orange( getSMVar( smlevel, "pull_radius" ), src ))
		X.singularity_pull(src, STAGE_FIVE)
	return

/obj/machinery/power/supermatter_shard/supermatter/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	spawn(0)
		over.MouseDrop_T(src,usr)
	return

// Returns whether or not time since start is greater than delay or less than 0
/proc/delayPassed( var/delay, var/start )
	if((( world.timeofday - start) > delay ) || (( world.timeofday - start ) < 0))
		return 1
	return 0

//LINDA! Don't touch the supermatter. ~rj
/obj/machinery/power/supermatter_shard/supermatter/experience_pressure_difference(pressure_difference, direction, pressure_resistance_prob_delta = 0)
	return 0