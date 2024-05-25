
#define MIDDLE_CLICK 0
#define ALT_CLICK 1
#define CTRL_CLICK 2
#define MAX_HARDSUIT_CLICK_MODE 2

/client
	var/hardsuit_click_mode = MIDDLE_CLICK

/client/verb/toggle_hardsuit_mode()
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Wouldn't RIG be a better word?
	set name = "Toggle Hardsuit Activation Mode"
	set desc = "Switch between hardsuit activation modes."
<<<<<<< HEAD
	*/
	set name = "Режим активации скафандра"
	set desc = "Переключить режим активации жёсткого скафандра."
	// End of Bastion of Endeavor Translation
	set category = "OOC"
=======
	set category = "OOC.Game Settings" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))

	hardsuit_click_mode++
	if(hardsuit_click_mode > MAX_HARDSUIT_CLICK_MODE)
		hardsuit_click_mode = 0

	switch(hardsuit_click_mode)
		if(MIDDLE_CLICK)
			/* Bastion of Endeavor Translation
			to_chat(src, "Hardsuit activation mode set to middle-click.")
			*/
			to_chat(src, "Активация жёсткого скафандра установлена на среднюю кнопку мыши.")
			// End of Bastion of Endeavor Translation
		if(ALT_CLICK)
			/* Bastion of Endeavor Translation
			to_chat(src, "Hardsuit activation mode set to alt-click.")
			*/
			to_chat(src, "Активация жёсткого скафандра установлена на Alt+ЛКМ.")
			// End of Bastion of Endeavor Translation
		if(CTRL_CLICK)
			/* Bastion of Endeavor Translation
			to_chat(src, "Hardsuit activation mode set to control-click.")
			*/
			to_chat(src, "Активация жёсткого скафандра установлена на Ctrl+ЛКМ.")
			// End of Bastion of Endeavor Translation
		else
			// should never get here, but just in case:
			/* Bastion of Endeavor Translation
			soft_assert(0, "Bad hardsuit click mode: [hardsuit_click_mode] - expected 0 to [MAX_HARDSUIT_CLICK_MODE]")
			to_chat(src, "Somehow you bugged the system. Setting your hardsuit mode to middle-click.")
			*/
			soft_assert(0, "Недопустимый режим активации жёсткого скафандра: [hardsuit_click_mode] – ожидалось значение от 0 до [MAX_HARDSUIT_CLICK_MODE]")
			to_chat(src, "Вы каким-то образом сломали систему. Активация жёсткого скафандра установлена на среднюю кнопку мыши.")
			// End of Bastion of Endeavor Translation
			hardsuit_click_mode = MIDDLE_CLICK

/mob/living/MiddleClickOn(atom/A)
	if(client && client.hardsuit_click_mode == MIDDLE_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/AltClickOn(atom/A)
	if(client && client.hardsuit_click_mode == ALT_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/CtrlClickOn(atom/A)
	if(client && client.hardsuit_click_mode == CTRL_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/proc/can_use_rig()
	return 0

/mob/living/carbon/human/can_use_rig()
	return 1

/mob/living/carbon/brain/can_use_rig()
	return istype(loc, /obj/item/device/mmi)

/mob/living/silicon/ai/can_use_rig()
	return carded

/mob/living/silicon/pai/can_use_rig()
	return loc == card

/mob/living/proc/HardsuitClickOn(var/atom/A, var/alert_ai = 0)
	if(!can_use_rig())
		return 0
	var/obj/item/weapon/rig/rig = get_rig()
	if(istype(rig) && !rig.offline && rig.selected_module)
		if(src != rig.wearer)
			if(rig.ai_can_move_suit(src, check_user_module = 1))
				/* Bastion of Endeavor Translation
				message_admins("[key_name_admin(src, include_name = 1)] is trying to force \the [key_name_admin(rig.wearer, include_name = 1)] to use a hardsuit module.")
				*/
				message_admins("[key_name_admin(src, include_name = 1)] [verb_ru(src, "пыта;ется;ется;ется;ются;")] принудить [key_name_admin(rig.wearer, include_name = 1)] надеть модуль ИКС.")
				// End of Bastion of Endeavor Translation
			else
				return 0
		rig.selected_module.engage(A, alert_ai)
		if(ismob(A)) // No instant mob attacking - though modules have their own cooldowns
			setClickCooldown(get_attack_speed())
		return 1
	return 0

#undef MIDDLE_CLICK
#undef ALT_CLICK
#undef CTRL_CLICK
#undef MAX_HARDSUIT_CLICK_MODE
