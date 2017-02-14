/obj/item/weapon/bonesetter
	name = "bone setter"
	desc = "Put naughty bones in their place."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	materials = list(MAT_METAL=5000, MAT_GLASS=2500)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked", "pinched")

/obj/item/weapon/bonegel
	name = "bone gel"
	desc = "Keeps bones together."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	materials = list(MAT_METAL=5000, MAT_GLASS=2500)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked")