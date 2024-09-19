/* Bastion of Endeavor Edit: Very bold move but I'm repathing this to show up in the antagonist tab
/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3
*/
/datum/category_item/player_setup_item/antagonism/pai
	name = "pAI"
	sort_order = 2
// End of Bastion of Endeavor Edit

	var/datum/paiCandidate/candidate

<<<<<<< HEAD
/* Bastion of Endeavor Edit
/datum/category_item/player_setup_item/player_global/pai/load_preferences(var/savefile/S)
*/
/datum/category_item/player_setup_item/antagonism/pai/load_preferences(var/savefile/S)
// End of Bastion of Endeavor Edit
=======
/datum/category_item/player_setup_item/player_global/pai/load_preferences(datum/json_savefile/savefile)
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))
	if(!candidate)
		candidate = new()
	var/preference_mob = preference_mob()
	if(!preference_mob)// No preference mob - this happens when we're called from client/New() before it calls ..()  (via datum/preferences/New())
		spawn()
			preference_mob = preference_mob()
			if(!preference_mob)
				return
			candidate.savefile_load(preference_mob)
		return

	candidate.savefile_load(preference_mob)

<<<<<<< HEAD
/* Bastion of Endeavor Edit
/datum/category_item/player_setup_item/player_global/pai/save_preferences(var/savefile/S)
*/
/datum/category_item/player_setup_item/antagonism/pai/save_preferences(var/savefile/S)
// End of Bastion of Endeavor Edit
=======
/datum/category_item/player_setup_item/player_global/pai/save_preferences(datum/json_savefile/savefile)
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/* Bastion of Endeavor Edit
/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
*/
/datum/category_item/player_setup_item/antagonism/pai/content(var/mob/user)
// End of Bastion of Endeavor Edit
	/* Bastion of Endeavor Translation
	. += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .
	. += "Name: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"
	*/
	. += "<b>Персональный ИИ</b><br>"
	if(!candidate)
		log_debug("Переменная candidate в настройках ПИИ [gcase_ru(user)] оказалась null.")
		return .
	// Bastion of Endeavor TODO: get the case editor here as well
	. += "Имя: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "Не установлено"]</a><br>"
	. += "Описание: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "Не установлено"]</a><br>"
	. += "Роль: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "Не установлена"]</a><br>"
	. += "Примечания OOC: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "Не установлены"]</a><br>"
	// End of Bastion of Endeavor Translation

/* Bastion of Endeavor Edit
/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
*/
/datum/category_item/player_setup_item/antagonism/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
// End of Bastion of Endeavor Edit
	if(href_list["option"])
		var/t
		switch(href_list["option"])
			if("name")
				/* Bastion of Endeavor Translation
				t = sanitizeName(tgui_input_text(user, "Enter a name for your pAI", "Global Preference", candidate.name, MAX_NAME_LEN), MAX_NAME_LEN, 1)
				*/
				t = sanitizeName(tgui_input_text(user, "Введите своё имя в качестве персонального ИИ:", "Имя ПИИ", candidate.name, MAX_NAME_LEN), MAX_NAME_LEN, 1)
				// End of Bastion of Endeavor Translation
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				/* Bastion of Endeavor Translation
				t = tgui_input_text(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description), multiline = TRUE, prevent_enter = TRUE)
				*/
				t = tgui_input_text(user, "Введите своё описание в качестве персонального ИИ:", "Описание ПИИ", html_decode(candidate.description), multiline = TRUE, prevent_enter = TRUE)
				// End of Bastion of Endeavor Translation
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				/* Bastion of Endeavor Translation
				t = tgui_input_text(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role))
				*/
				t = tgui_input_text(user, "Опишите свою роль в качестве персонального ИИ:", "Роль ПИИ", html_decode(candidate.role))
				// End of Bastion of Endeavor Translation
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				/* Bastion of Endeavor Translation
				t = tgui_input_text(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments), multiline = TRUE, prevent_enter = TRUE)
				*/
				t = tgui_input_text(user, "Введите свои примечания ООС в качестве персонального ИИ:", "Примечания ООС ПИИ", html_decode(candidate.comments), multiline = TRUE, prevent_enter = TRUE)
				// End of Bastion of Endeavor Translation
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
		return TOPIC_REFRESH

	return ..()
