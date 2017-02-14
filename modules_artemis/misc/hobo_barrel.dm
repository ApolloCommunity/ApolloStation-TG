/obj/structure/hobo_barrel
	name = "hobo barrel"
	icon = 'icons/obj/hobo_barrel.dmi'
	icon_state = "off"
	desc = "A cold piece of cylindrical metal."
	var/obj/structure/hobo_barrel/lit = 0
	anchored = 1
	density = 1
	var/brightness_on = 3
	var/max_fuel = 10
	var/fuel = 0
	var/isRigged = 0

/obj/item/weapon/reagent_containers/food/snacks/ratrod
	name = "roasted ratrod"
	desc = "A rodent with a metal rod stuck through it. It's been cooked."
	icon_state = "ratrod"
	trash = /obj/item/stack/rods
	bitesize = 2
	list_reagents = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/ratrod/raw
	name = "raw ratrod"
	desc = "A rodent with a metal rod stuck through it."
	icon_state = "ratrod_raw"
	list_reagents = list("nutriment" = 1, "toxin" = 3)

/obj/item/weapon/reagent_containers/food/snacks/ratrod/raw/On_Consume(var/mob/M)
	M << "You feel unwell."
	..()
	return

/obj/structure/hobo_barrel/New()
	..()

/obj/structure/hobo_barrel/attackby(var/obj/item/I,var/mob/user)
	if(istype(I,/obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = I
		if(C.lit == 1 && fuel == max_fuel)
			icon_state = "hobo_barrel"
			user << "You throw the lit [I.name] into the barrel, and the paper inside lights up in flames!"
			desc = "A hot piece of cylindrical metal."

			SetLuminosity(brightness_on)
		else
			user << "You throw the [I.name] into the barrel."
		qdel(C)
	else if(istype(I,/obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = I
		if(fuel < max_fuel)
			fuel++
			user << "You throw the [P.name] into the barrel."
			qdel(P)
		else
			user << "The barrel is full."
	else if(istype(I,/obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/W = I
		if(fuel < max_fuel)
			if(W.amount > (max_fuel - fuel))
				W.amount -= (max_fuel - fuel)
				fuel = max_fuel
				user << "You fill the barrel to the brim with [I.name]"
			else
				fuel += W.amount
				qdel(W)
				user << "You throw the [I.name] into the barrel."
		else
			user << "The barrel is full."
	else if(istype(I,/obj/item/weapon/reagent_containers/food/snacks/ratrod/raw))
		if(icon_state == "hobo_barrel")
			user << "<span class='notice'>You begin roasting the ratrod over the barrel fire.</span>"
			if(do_after(user, 100))
				user << "<span class='notice'>The rat gets a nice, brown color. You pull the ratrod away from the fire.</span>"
				qdel(I)
				var/obj/item/weapon/reagent_containers/food/snacks/ratrod/ratrod = new()
				ratrod.loc = get_turf(user)
				user.put_in_hands(ratrod)
		else
			user << "<span class='notice'>You hold the ratrod over the barrel for no apparent reason.</span>"
