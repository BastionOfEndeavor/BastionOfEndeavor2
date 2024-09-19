// Define a place to save in character setup
/datum/preferences
	var/persistence_settings = PERSIST_DEFAULT	// Control what if anything is persisted for this character between rounds.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/persistence
	name = "Persistence"
	sort_order = 5

/datum/category_item/player_setup_item/vore/persistence/load_character(list/save_data)
	pref.persistence_settings = save_data["persistence_settings"]
	sanitize_character() // Don't let new characters start off with nulls

/datum/category_item/player_setup_item/vore/persistence/save_character(list/save_data)
	save_data["persistence_settings"] = pref.persistence_settings

/datum/category_item/player_setup_item/vore/persistence/sanitize_character()
	pref.persistence_settings		= sanitize_integer(pref.persistence_settings, 0, (1<<(PERSIST_COUNT+1)-1), initial(pref.persistence_settings))

/datum/category_item/player_setup_item/vore/persistence/content(var/mob/user)
	. = list()
	/* Bastion of Endeavor Translation
	. += "<b>Round-to-Round Persistence</b><br>"
	*/
	. += "<b>Сохранение между сменами</b><br>"
	// End of Bastion of Endeavor Translation
	. += "<table>"

	/* Bastion of Endeavor Translation
	. += "<tr><td title=\"Set spawn location based on where you cryo'd out.\">Save Spawn Location: </td>"
	*/
	. += "<tr><td title=\"Сохранять точку появления с прошлого ухода.\">Сохранить точку появления: </td>"
	// End of Bastion of Endeavor Translation
	. += make_yesno(PERSIST_SPAWN)
	. += "</tr>"

	/* Bastion of Endeavor Translation
	. += "<tr><td title=\"Save your character's weight until next round.\">Save Weight: </td>"
	*/
	. += "<tr><td title=\"Сохранять вес персонажа на следующую смену.\">Сохранять вес: </td>"
	// End of Bastion of Endeavor Translation
	. += make_yesno(PERSIST_WEIGHT)
	. += "</tr>"

	/* Bastion of Endeavor Translation
	. += "<tr><td title=\"Update organ preferences (normal/amputated/robotic/etc) and model (for robotic) based on what you have at round end.\">Save Organs: </td>"
	*/
	. += "<tr><td title=\"Сохранять состояние конечностей (нормальное/ампутированное/протез) и модель (если применимо).\">Сохранять конечности: </td>"
	// End of Bastion of Endeavor Translation
	. += make_yesno(PERSIST_ORGANS)
	. += "</tr>"

	/* Bastion of Endeavor Translation
	. += "<tr><td title=\"Update marking preferences (type and color) based on what you have at round end.\">Save Markings: </td>"
	*/
	. += "<tr><td title=\"Запоминать особенности тела персонажа на момент конца смены.\">Сохранять особенности тела: </td>"
	// End of Bastion of Endeavor Translation
	. += make_yesno(PERSIST_MARKINGS)
	. += "</tr>"

	/* Bastion of Endeavor Translation
	. += "<tr><td title=\"Update character scale based on what you were at round end.\">Save Scale: </td>"
	*/
	. += "<tr><td title=\"Запоминать размер персонажа на момент конца смены.\">Сохранять размер: </td>"
	// End of Bastion of Endeavor Translation
	. += make_yesno(PERSIST_SIZE)
	. += "</tr>"

	. += "</table>"
	return jointext(., "")

/datum/category_item/player_setup_item/vore/persistence/proc/make_yesno(var/bit)
	if(pref.persistence_settings & bit)
		/* Bastion of Endeavor Translation
		return "<td><span class='linkOn'><b>Yes</b></span></td> <td><a href='?src=\ref[src];toggle_off=[bit]'>No</a></td>"
	else
		return "<td><a href='?src=\ref[src];toggle_on=[bit]'>Yes</a></td> <td><span class='linkOn'><b>No</b></span></td>"
		*/
		return "<td><span class='linkOn'><b>Да</b></span></td> <td><a href='?src=\ref[src];toggle_off=[bit]'>Нет</a></td>"
	else
		return "<td><a href='?src=\ref[src];toggle_on=[bit]'>Да</a></td> <td><span class='linkOn'><b>Нет</b></span></td>"
		// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/vore/persistence/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_on"])
		var/bit = text2num(href_list["toggle_on"])
		pref.persistence_settings |= bit
		return TOPIC_REFRESH
	else if(href_list["toggle_off"])
		var/bit = text2num(href_list["toggle_off"])
		pref.persistence_settings &= ~bit
		return TOPIC_REFRESH
	return ..()
