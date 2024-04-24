/obj/item/organ/internal/intestine
	name = "intestine"
	icon_state = "intestine"
	organ_tag = O_INTESTINE
	parent_organ = BP_GROIN

/obj/item/organ/internal/intestine/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Viral Gastroenteritis
	if (. >= 1)
		if(prob(1))
			/* Bastion of Endeavor Translation
			owner.custom_pain("There's a twisting pain in your abdomen!",1)
			*/
			owner.custom_pain("Вам скрутило живот!",1)
			// End of Bastion of Endeavor Translation
			owner.vomit()
	if (. >= 2)
		if(prob(1))
			/* Bastion of Endeavor Translation
			owner.custom_pain("Your abdomen feels like it's tearing itself apart!",1)
			*/
			owner.custom_pain("Ваш живот как будто сейчас вывернет наизнанку!",1)
			// End of Bastion of Endeavor Translation
			owner.m_intent = "walk"
			owner.hud_used.move_intent.icon_state = "walking"

/obj/item/organ/internal/intestine/xeno
	color = "#555555"
