/////////////////////////////////////////////
//Lighting bolt between scourse and target
/////////////////////////////////////////////

/datum/effect/effect/system/lightning_bolt

/datum/effect/effect/system/lightning_bolt/New()
	..()

/datum/effect/effect/system/lightning_bolt/proc/start(atom/scourse, atom/target, size = 2, sx_offset = 0, sy_offset = 0, dx_offset = 0, dy_offset = 0)
	var/vector/start = new (scourse.x * world.icon_size + world.icon_size/2 + sx_offset, scourse.y * world.icon_size + world.icon_size/2 + sy_offset)
	var/vector/dest  = new (target.x * world.icon_size + world.icon_size/2 + dx_offset, target.y * world.icon_size + world.icon_size/2 + dy_offset)
	var/bolt/b = new(start, dest, 50)
	b.Draw(scourse.z, color = "#ffffff", thickness = size, split = 1)
