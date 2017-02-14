var/global/datum/subsystem/cell_auto/cell_auto_manager
var/global/datum/cell_auto_handler/v_wave_handler = new(2)
var/global/datum/cell_auto_handler/sm_crystal_handler = new(600)
var/global/datum/cell_auto_handler/explosion_handler = new(1)

//previously, this would have been named 'process()' but that name is used everywhere for different things!
//fire() seems more suitable. This is the procedure that gets called every 'wait' deciseconds.
//fire(), and the procs it calls, SHOULD NOT HAVE ANY SLEEP OPERATIONS in them!
//YE BE WARNED!
/datum/subsystem/cell_auto/fire()


/datum/subsystem/cell_auto
	name = "Cell Auto"
	init_order = 12
	priority = 40

	var/list/datum/cell_auto_handler/handlers = list()

	var/initialized = FALSE
	var/old_initialized

/datum/subsystem/cell_auto/New()
	NEW_SS_GLOBAL(cell_auto_manager)

/datum/subsystem/cell_auto/Initialize(timeofdayl)
	handlers = list( v_wave_handler, sm_crystal_handler)//,explosion_handler)
	initialized = TRUE
	. = ..()

/datum/subsystem/cell_auto/stat_entry()
	..("C:[handlers.len]")


/datum/subsystem/cell_auto/fire(resumed = 0)
	//world << "FIRING Cell Auto"
	if( !handlers )
		return

	for( var/datum/cell_auto_handler/handler in handlers )
		if( handler.shouldProcess() )
			handler.process()
		if (MC_TICK_CHECK)
			return

/datum/subsystem/cell_auto/Recover()
	initialized = cell_auto_manager.initialized
	old_initialized = cell_auto_manager.old_initialized