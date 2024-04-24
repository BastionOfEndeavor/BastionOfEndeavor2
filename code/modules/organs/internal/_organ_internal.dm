#define PROCESS_ACCURACY 10

/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/robotize()
	..()
	/* Bastion of Endeavor Translation
	name = "prosthetic [initial(name)]"
	*/
	update_blueprint_ru(left = "механическ;adj3aX~", separator_left = " ")
	name = cap_ru(src)
	// End of Bastion of Endeavor Translation
	icon_state = "[initial(icon_state)]_prosthetic"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_prosthetic"

/obj/item/organ/internal/mechassist()
	..()
	/* Bastion of Endeavor Translation
	name = "assisted [initial(name)]"
	*/
	update_blueprint_ru(left = "полумеханическ;adj3aX~", separator_left = " ")
	name = cap_ru(src)
	// End of Bastion of Endeavor Translation
	icon_state = "[initial(icon_state)]_assisted"
	if(dead_icon)
		dead_icon = "[initial(dead_icon)]_assisted"

// Brain is defined in brain.dm
/obj/item/organ/internal/handle_germ_effects()
	. = ..() //Should be an interger value for infection level
	if(!.) return

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if(. >= 2 && antibiotics < ANTIBIO_NORM) //INFECTION_LEVEL_TWO
		if (prob(3))
			take_damage(1,silent=prob(30))

	if(. >= 3 && antibiotics < ANTIBIO_OD)	//INFECTION_LEVEL_THREE
		if (prob(50))
			take_damage(1,silent=prob(15))

