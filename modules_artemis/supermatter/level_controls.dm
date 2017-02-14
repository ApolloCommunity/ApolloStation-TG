/*
	Critical failure:
*/

/datum/sm_control
	var/base_power = 0 	// The power output that the engine will stabilize at, in kW
	var/decay = 0.75 // Used to calculate power decay per tick
	var/minimum_decay = 0.5 // Minimum amount of decay per tick, in kW

	var/overcharge_heat_multiplier = 10.0 // 10x heat output when overcharged

	var/collector_range = 10 // Max range of collectors, decreaes power output as distance increases

	var/o2_release = 0.8 // Amount of o2 released if the core is at maximum damage
	var/o2_release_heat_limit = 400 // o2 release is scaled down until this temperature, when it entirely stops
	var/o2_turbo_multiplier = 0 // How much oxygen will multiply power and heat output by, per mole
	var/o2_requirement = 0 // How much oxygen is required to keep the engine from critically failing, as a percent of the total gas composition
	var/suffocation_damage = 0 // How much damage will be done if the engine doesn't have enough O2

	var/crit_fail_chance = 0 // The chance that a critical fail will happen per minute if the engine is starving for oxygen
	var/crit_fail_damage = 0 // the amount of damage done by a critical failure

	var/co2_heat_multiplier = 0 // The multiplier that CO2 increases heat production by, per mole

	var/n2o_power_loss = 0 // The rate that N2O decreases power output, per mole

	var/phoron_release = 0.5 // Amount of phoron released if the core is at maximum damage
	var/phoron_release_heat_limit = 400 // phoron release is scaled down until this temperature
	var/phoron_heal_rate = 0 // The rate that phoron heals the core, per mole

	var/emitter_factor = 1 // Determines power generation from the emitter beam
	var/dama = 0.7
	var/damb = 1.4
	var/damc = 500

	var/thermal_factor = 0 // The amount of heat released to the environment at max power
	var/heal_rate = 0 // The amount of damage the core will automatically heal
	var/heat_damage_level = 1000 // The temperature at which heat will start damaging the crystal
	var/damage_per_degree = 1 // How much damage per degree over heat_damage_level will cause

	var/explosion_size = 25 // The size of the explosion
	var/delamination_size = 25 // The size of the vorbis wave burst

	var/vacuum_damage = 0 // The amount of damage done when the SM is sitting in a vacuum
	var/consumption_rate = 10 // The amount of gas taken from the environment per tick

	var/psionic_power = 10 // The amount of hallucination that will be added if someone looks at it
	var/radiation_power = 20 // The amount of radiation released

	var/pull_time = 15 // the amount of time in seconds that the supermatter will pull in before exploding
	var/pull_range = 15 // The distance that objects will be pulled from

	var/color = ""
	var/color_name = ""

/datum/sm_control/level_1
	base_power = 500
	o2_turbo_multiplier = 1.5/CANISTER_MOLARITY
	n2o_power_loss = 500/CANISTER_MOLARITY
	phoron_heal_rate = 1000/CANISTER_MOLARITY
	color = SM_DEFAULT_COLOR
	color_name = "green"
	thermal_factor = 200
	heal_rate = 0.5

/datum/sm_control/level_2
	base_power = 800
	decay = 0.50

	o2_turbo_multiplier = 1.6/CANISTER_MOLARITY
	n2o_power_loss = 500/CANISTER_MOLARITY
	phoron_heal_rate = 800/CANISTER_MOLARITY
	color = "#00FF99"
	color_name = "cyan"
	delamination_size = 30
	vacuum_damage = 10
	emitter_factor = 2
	thermal_factor = 300
	damage_per_degree = 1.1
	psionic_power = 15
	radiation_power = 30
	heal_rate = 0.45

/datum/sm_control/level_3
	base_power = 1400
	decay = 0.45

	o2_turbo_multiplier = 1.7/CANISTER_MOLARITY
	co2_heat_multiplier = 1.1/CANISTER_MOLARITY
	n2o_power_loss = 800/CANISTER_MOLARITY
	phoron_heal_rate = 800/CANISTER_MOLARITY
	color = "#0099FF"
	color_name = "blue"
	explosion_size = 25
	delamination_size = 35
	vacuum_damage = 25
	emitter_factor = 3
	thermal_factor = 400
	damage_per_degree = 1.2
	psionic_power = 20
	radiation_power = 40
	heal_rate = 0.40

/datum/sm_control/level_4
	base_power = 2600
	decay = 0.40

	o2_turbo_multiplier = 1.8/CANISTER_MOLARITY
	co2_heat_multiplier = 1.2/CANISTER_MOLARITY
	n2o_power_loss = 1400/CANISTER_MOLARITY
	phoron_heal_rate = 700/CANISTER_MOLARITY
	color = "#6600FF"
	color_name = "purple"
	explosion_size = 25
	delamination_size = 40
	vacuum_damage = 50
	emitter_factor = 4
	thermal_factor = 500
	damage_per_degree = 1.3
	psionic_power = 25
	radiation_power = 50
	heal_rate = 0.35

/datum/sm_control/level_5
	base_power = 5200
	decay = 0.30

	o2_release_heat_limit = 100
	phoron_release_heat_limit = 100
	o2_turbo_multiplier = 1.9/CANISTER_MOLARITY
	o2_requirement = 0.10
	crit_fail_chance = 0.01
	crit_fail_damage = 100
	co2_heat_multiplier = 1.3/CANISTER_MOLARITY
	n2o_power_loss = 1400/CANISTER_MOLARITY
	phoron_heal_rate = 600/CANISTER_MOLARITY
	color = "#FF00FF"
	color_name = "pink"
	explosion_size = 45
	delamination_size = 45
	vacuum_damage = 60
	emitter_factor = 5
	thermal_factor = 600
	damage_per_degree = 1.4
	psionic_power = 30
	radiation_power = 60
	heal_rate = 0.30

/datum/sm_control/level_6
	base_power = 10400
	decay = 0.20

	o2_release_heat_limit = 100
	phoron_release_heat_limit = 100
	o2_turbo_multiplier = 2.0/CANISTER_MOLARITY
	o2_requirement = 0.15
	crit_fail_chance = 0.05
	crit_fail_damage = 500
	co2_heat_multiplier = 1.4/CANISTER_MOLARITY
	n2o_power_loss = 5200/CANISTER_MOLARITY
	phoron_heal_rate = 550/CANISTER_MOLARITY
	color = "#FF3399"
	color_name = "magenta"
	explosion_size = 45
	delamination_size = 55
	vacuum_damage = 70
	emitter_factor = 6
	thermal_factor = 700
	damage_per_degree = 1.5
	psionic_power = 50
	radiation_power = 70
	heal_rate = 0.20

/datum/sm_control/level_7
	base_power = 20800
	decay = 0.10

	o2_release_heat_limit = 100
	phoron_release_heat_limit = 100
	o2_turbo_multiplier = 2.1/CANISTER_MOLARITY
	o2_requirement = 0.20
	crit_fail_chance = 0.1
	crit_fail_damage = 1000
	co2_heat_multiplier = 1.5/CANISTER_MOLARITY
	n2o_power_loss = 5200/CANISTER_MOLARITY
	phoron_heal_rate = 500/CANISTER_MOLARITY
	color = "#FFFF00"
	color_name = "yellow"
	explosion_size = 55
	delamination_size = 65
	vacuum_damage = 80
	emitter_factor = 7
	thermal_factor = 500
	damage_per_degree = 1.6
	psionic_power = 70
	radiation_power = 80
	heal_rate = 0.10

/datum/sm_control/level_8
	base_power = 41600
	decay = 0.05

	o2_release_heat_limit = 100
	phoron_release_heat_limit = 100
	o2_turbo_multiplier = 2.2/CANISTER_MOLARITY
	o2_requirement = 0.25
	crit_fail_chance = 0.5
	crit_fail_damage = 5000
	co2_heat_multiplier = 1.6/CANISTER_MOLARITY
	n2o_power_loss = 10400/CANISTER_MOLARITY
	phoron_heal_rate = 450/CANISTER_MOLARITY
	color = "#FF6600"
	color_name = "orange"
	explosion_size = 55
	delamination_size = 75
	vacuum_damage = 90
	emitter_factor = 8
	thermal_factor = 900
	damage_per_degree = 1.7
	psionic_power = 90
	radiation_power = 90
	heal_rate = 0.02

/datum/sm_control/level_9
	base_power = 83200
	decay = 0.01

	o2_release_heat_limit = 4
	phoron_release_heat_limit = 4
	o2_turbo_multiplier = 2.3/CANISTER_MOLARITY
	o2_requirement = 0.3
	crit_fail_chance = 1.0
	crit_fail_damage = 10000
	co2_heat_multiplier = 1.7/CANISTER_MOLARITY
	n2o_power_loss = 10400/CANISTER_MOLARITY
	phoron_heal_rate = -10/CANISTER_MOLARITY
	color = "#FF0000"
	color_name = "red"
	explosion_size = 60
	delamination_size = 85
	vacuum_damage = 100
	emitter_factor = 9
	thermal_factor = 1000
	damage_per_degree = 1.8
	psionic_power = 110
	radiation_power = 100
	heal_rate = 0.0