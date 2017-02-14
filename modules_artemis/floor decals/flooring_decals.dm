/obj/effect/turf_decal/Initialize(mapload)
	var/turf/T = loc
	var/image/I = src.get_decal()
	if(!istype(T)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	I.color = src.color
	I.alpha = src.alpha
	T.add_decal(I,group)
	qdel(src)

/obj/effect/turf_decal/corner
	icon_state = "corner_white"
	alpha = 229

/obj/effect/turf_decal/corner/black
	name = "black corner"
	color = "#333333"

/obj/effect/turf_decal/corner/black/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/black/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/blue
	name = "blue corner"
	color = COLOR_BLUE_GRAY

/obj/effect/turf_decal/corner/blue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/blue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/paleblue
	name = "pale blue corner"
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/turf_decal/corner/paleblue/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/paleblue/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/green
	name = "green corner"
	color = COLOR_GREEN_GRAY

/obj/effect/turf_decal/corner/green/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/green/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/lime
	name = "lime corner"
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/turf_decal/corner/lime/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/lime/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/yellow
	name = "yellow corner"
	color = COLOR_BROWN

/obj/effect/turf_decal/corner/yellow/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/yellow/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/yellow/full
	icon_state = "corner_white_full"

/obj/effect/turf_decal/corner/beige
	name = "beige corner"
	color = COLOR_BEIGE

/obj/effect/turf_decal/corner/beige/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/beige/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/red
	name = "red corner"
	color = COLOR_RED_GRAY

/obj/effect/turf_decal/corner/red/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/red/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/red/full
	icon_state = "corner_white_full"

/obj/effect/turf_decal/corner/pink
	name = "pink corner"
	color = COLOR_PALE_RED_GRAY

/obj/effect/turf_decal/corner/pink/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/pink/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/purple
	name = "purple corner"
	color = COLOR_PURPLE_GRAY

/obj/effect/turf_decal/corner/purple/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/purple/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/mauve
	name = "mauve corner"
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/turf_decal/corner/mauve/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/mauve/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/orange
	name = "orange corner"
	color = COLOR_DARK_ORANGE

/obj/effect/turf_decal/corner/orange/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/orange/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/brown
	name = "brown corner"
	color = COLOR_DARK_BROWN

/obj/effect/turf_decal/corner/brown/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/brown/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/white
	name = "white corner"
	icon_state = "corner_white"

/obj/effect/turf_decal/corner/white/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/white/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/corner/grey
	name = "grey corner"
	color = "#8D8C8C"

/obj/effect/turf_decal/corner/grey/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/turf_decal/corner/grey/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/turf_decal/spline/plain
	name = "spline - plain"
	icon_state = "spline_plain"

/obj/effect/turf_decal/spline/fancy
	name = "spline - fancy"
	icon_state = "spline_fancy"

/obj/effect/turf_decal/spline/fancy/wood
	name = "spline - wood"
	color = "#CB9E04"

/obj/effect/turf_decal/spline/fancy/wood/corner
	icon_state = "spline_fancy_corner"

/obj/effect/turf_decal/spline/fancy/wood/cee
	icon_state = "spline_fancy_cee"

/obj/effect/turf_decal/spline/fancy/wood/three_quarters
	icon_state = "spline_fancy_full"

/obj/effect/turf_decal/stripes/full
	icon_state = "warningfull"

/obj/effect/turf_decal/delivery
	color = "#CFCF55"
	color = "#CFCF55"

/obj/effect/turf_decal/delivery/white
	name = "hatched marking"
	icon_state = "delivery"
	alpha = 229

/obj/effect/turf_decal/bot
	name = "yellow outline"
	color = "#CFCF55"

/obj/effect/turf_decal/bot/white
	name = "white outline"
	icon_state = "outline"
	alpha = 229

/obj/effect/turf_decal/bot/blue
	name = "blue outline"
	color = "#00B8B2"

/obj/effect/turf_decal/bot/grey
	name = "grey outline"
	color = "#808080"

/obj/effect/turf_decal/loading_area
	name = "loading area"
	icon_state = "loadingarea"
	alpha = 229

/obj/effect/turf_decal/plaque
	name = "plaque"
	icon_state = "plaque"

/obj/effect/turf_decal/carpet
	name = "carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet_edges"

/obj/effect/turf_decal/carpet/blue
	name = "carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "bcarpet_edges"

/obj/effect/turf_decal/carpet/corners
	name = "carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet_corners"

/obj/effect/turf_decal/asteroid
	name = "random asteroid rubble"
	icon_state = "asteroid0"

/obj/effect/turf_decal/asteroid/New()
	icon_state = "asteroid[rand(0,9)]"
	..()

/obj/effect/turf_decal/chapel
	name = "chapel"
	icon_state = "chapel"

/obj/effect/turf_decal/ss13/l1
	name = "L1"
	icon_state = "L1"

/obj/effect/turf_decal/ss13/l2
	name = "L2"
	icon_state = "L2"

/obj/effect/turf_decal/ss13/l3
	name = "L3"
	icon_state = "L3"

/obj/effect/turf_decal/ss13/l4
	name = "L4"
	icon_state = "L4"

/obj/effect/turf_decal/ss13/l5
	name = "L5"
	icon_state = "L5"

/obj/effect/turf_decal/ss13/l6
	name = "L6"
	icon_state = "L6"

/obj/effect/turf_decal/ss13/l7
	name = "L7"
	icon_state = "L7"

/obj/effect/turf_decal/ss13/l8
	name = "L8"
	icon_state = "L8"

/obj/effect/turf_decal/ss13/l9
	name = "L9"
	icon_state = "L9"

/obj/effect/turf_decal/ss13/l10
	name = "L10"
	icon_state = "L10"

/obj/effect/turf_decal/ss13/l11
	name = "L11"
	icon_state = "L11"

/obj/effect/turf_decal/ss13/l12
	name = "L12"
	icon_state = "L12"

/obj/effect/turf_decal/ss13/l13
	name = "L13"
	icon_state = "L13"

/obj/effect/turf_decal/ss13/l14
	name = "L14"
	icon_state = "L14"

/obj/effect/turf_decal/ss13/l15
	name = "L15"
	icon_state = "L15"

/obj/effect/turf_decal/ss13/l16
	name = "L16"
	icon_state = "L16"

/obj/effect/turf_decal/sign
	name = "floor sign"
	icon_state = "white_1"

/obj/effect/turf_decal/sign/two
	icon_state = "white_2"

/obj/effect/turf_decal/sign/a
	icon_state = "white_a"

/obj/effect/turf_decal/sign/b
	icon_state = "white_b"

/obj/effect/turf_decal/sign/c
	icon_state = "white_c"

/obj/effect/turf_decal/sign/d
	icon_state = "white_d"

/obj/effect/turf_decal/sign/ex
	icon_state = "white_ex"

/obj/effect/turf_decal/sign/m
	icon_state = "white_m"

/obj/effect/turf_decal/sign/cmo
	icon_state = "white_cmo"

/obj/effect/turf_decal/sign/v
	icon_state = "white_v"

/obj/effect/turf_decal/sign/p
	icon_state = "white_p"

/obj/effect/turf_decal/solarpanel
	icon_state = "solarpanel"

/obj/effect/turf_decal/snow
	icon = 'icons/turf/overlays.dmi'
	icon_state = "snowfloor"

//artemis Logo

/obj/effect/turf_decal/artemis/l1
	name = "A1"
	icon_state = "A1"

/obj/effect/turf_decal/artemis/l2
	name = "A2"
	icon_state = "A2"

/obj/effect/turf_decal/artemis/l3
	name = "A3"
	icon_state = "A3"

/obj/effect/turf_decal/artemis/l4
	name = "A4"
	icon_state = "A4"

/obj/effect/turf_decal/artemis/l5
	name = "A5"
	icon_state = "A5"

/obj/effect/turf_decal/artemis/l6
	name = "A6"
	icon_state = "A6"

/obj/effect/turf_decal/artemis/l7
	name = "A7"
	icon_state = "A7"

/obj/effect/turf_decal/artemis/l8
	name = "A8"
	icon_state = "A8"

/obj/effect/turf_decal/artemis/l9
	name = "A9"
	icon_state = "A9"

/obj/effect/turf_decal/artemis/l10
	name = "A10"
	icon_state = "A10"

/obj/effect/turf_decal/artemis/l11
	name = "A11"
	icon_state = "A11"

/obj/effect/turf_decal/artemis/l12
	name = "A12"
	icon_state = "A12"

/obj/effect/turf_decal/artemis/l13
	name = "A13"
	icon_state = "A13"

/obj/effect/turf_decal/artemis/l14
	name = "A14"
	icon_state = "A14"

//Road decals
/obj/effect/turf_decal/road/edge
	name = "road edge"
	icon_state = "road_E"

/obj/effect/turf_decal/road/edge/cee
	name = "road edge"
	icon_state = "road_U"

/obj/effect/turf_decal/road/edge/corner
	name = "road edge"
	icon_state = "road_L"

/obj/effect/turf_decal/road/edge/inner
	name = "road edge"
	icon_state = "road_C"

/obj/effect/turf_decal/road/loading
	name = "road loading"
	icon_state = "road_loading"

/obj/effect/turf_decal/road/dropoff
	name = "road dropoff"
	icon_state = "road_drop"

/obj/effect/turf_decal/road/turn
	name = "road turn"
	icon_state = "road_turn"

/obj/effect/turf_decal/road/turn/inverted
	name = "road turn"
	icon_state = "road_Iturn"

/obj/effect/turf_decal/road/fullturn
	name = "road turn"
	icon_state = "road_dturn"