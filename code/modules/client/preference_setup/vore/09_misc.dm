/datum/category_item/player_setup_item/vore/misc
	name = "Misc Settings"
	sort_order = 9

/datum/category_item/player_setup_item/vore/misc/load_character(list/save_data)
	pref.show_in_directory		= save_data["show_in_directory"]
	pref.directory_tag			= save_data["directory_tag"]
	//CHOMPAdd Start
	pref.directory_gendertag	= save_data["directory_gendertag"]
	pref.directory_sexualitytag	= save_data["directory_sexualitytag"]
	//CHOMPAdd End
	pref.directory_erptag		= save_data["directory_erptag"]
	pref.directory_ad			= save_data["directory_ad"]
	pref.sensorpref				= save_data["sensorpref"]
	pref.capture_crystal		= save_data["capture_crystal"]
	pref.auto_backup_implant	= save_data["auto_backup_implant"]
	pref.borg_petting			= save_data["borg_petting"]
	pref.stomach_vision			= save_data["stomach_vision"]

/datum/category_item/player_setup_item/vore/misc/save_character(list/save_data)
	save_data["show_in_directory"]		= pref.show_in_directory
	save_data["directory_tag"]			= pref.directory_tag
	//CHOMPAdd Start
	save_data["directory_gendertag"]	= pref.directory_gendertag
	save_data["directory_sexualitytag"]	= pref.directory_sexualitytag
	//CHOMPAdd End
	save_data["directory_erptag"]		= pref.directory_erptag
	save_data["directory_ad"]			= pref.directory_ad
	save_data["sensorpref"]				= pref.sensorpref
	save_data["capture_crystal"]		= pref.capture_crystal
	save_data["auto_backup_implant"]	= pref.auto_backup_implant
	save_data["borg_petting"]			= pref.borg_petting
	save_data["stomach_vision"]			= pref.stomach_vision

/datum/category_item/player_setup_item/vore/misc/copy_to_mob(var/mob/living/carbon/human/character)
	if(pref.sensorpref > 5 || pref.sensorpref < 1)
		pref.sensorpref = 5
	character.sensorpref = pref.sensorpref
	character.capture_crystal = pref.capture_crystal
	//Vore Stomach Sprite Preference
	character.stomach_vision = pref.stomach_vision
	character.recalculate_vis()

/datum/category_item/player_setup_item/vore/misc/sanitize_character()
	pref.show_in_directory		= sanitize_integer(pref.show_in_directory, 0, 1, initial(pref.show_in_directory))
	pref.directory_tag			= sanitize_inlist(pref.directory_tag, GLOB.char_directory_tags, initial(pref.directory_tag))
	pref.directory_gendertag	= sanitize_inlist(pref.directory_gendertag, GLOB.char_directory_gendertags, initial(pref.directory_gendertag)) // CHOMPStation Edit: Character Directory Update
	pref.directory_sexualitytag	= sanitize_inlist(pref.directory_sexualitytag, GLOB.char_directory_sexualitytags, initial(pref.directory_sexualitytag)) // CHOMPStation Edit: Character Directory Update
	pref.directory_erptag		= sanitize_inlist(pref.directory_erptag, GLOB.char_directory_erptags, initial(pref.directory_erptag))
	pref.sensorpref				= sanitize_integer(pref.sensorpref, 1, sensorpreflist.len, initial(pref.sensorpref))
	pref.capture_crystal		= sanitize_integer(pref.capture_crystal, 0, 1, initial(pref.capture_crystal))
	pref.auto_backup_implant	= sanitize_integer(pref.auto_backup_implant, 0, 1, initial(pref.auto_backup_implant))
	pref.borg_petting			= sanitize_integer(pref.borg_petting, 0, 1, initial(pref.borg_petting))
	pref.stomach_vision			= sanitize_integer(pref.stomach_vision, 0, 1, initial(pref.stomach_vision))

/datum/category_item/player_setup_item/vore/misc/content(var/mob/user)
	. += "<br>"
	/* Bastion of Endeavor Translation
	. += "<b>Appear in Character Directory:</b> <a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Yes" : "No"]</b></a><br>"
	. += "<b>Character Directory Vore Tag:</b> <a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a><br>"
	. += "<b>Character Directory Gender:</b> <a href='?src=\ref[src];directory_gendertag=1'><b>[pref.directory_gendertag]</b></a><br>" // CHOMPStation Edit: Character Directory Update
	. += "<b>Character Directory Sexuality:</b> <a href='?src=\ref[src];directory_sexualitytag=1'><b>[pref.directory_sexualitytag]</b></a><br>" // CHOMPStation Edit: Character Directory Update
	. += "<b>Character Directory ERP Tag:</b> <a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a><br>"
	. += "<b>Character Directory Advertisement:</b> <a href='?src=\ref[src];directory_ad=1'><b>Set Directory Ad</b></a><br>"
	. += "<b>Suit Sensors Preference:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"
	. += "<b>Capture Crystal Preference:</b> <a [pref.capture_crystal ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_capture_crystal=1'><b>[pref.capture_crystal ? "Yes" : "No"]</b></a><br>"
	. += "<b>Spawn With Backup Implant:</b> <a [pref.auto_backup_implant ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_implant=1'><b>[pref.auto_backup_implant ? "Yes" : "No"]</b></a><br>"
	. += "<b>Allow petting as robot:</b> <a [pref.borg_petting ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_borg_petting=1'><b>[pref.borg_petting ? "Yes" : "No"]</b></a><br>"
	. += "<b>Enable Stomach Sprites:</b> <a [pref.stomach_vision ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_stomach_vision=1'><b>[pref.stomach_vision ? "Yes" : "No"]</b></a><br>"
	*/
	. += "<b>Режим датчиков одежды:</b> <a [pref.sensorpref ? "" : ""] href='?src=\ref[src];toggle_sensor_setting=1'><b>[sensorpreflist[pref.sensorpref]]</b></a><br>"
	. += "<b>Разрешить заключение в кристалл:</b> <a [pref.capture_crystal ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_capture_crystal=1'><b>[pref.capture_crystal ? "Да" : "Нет"]</b></a><br>"
	. += "<b>Имплантат резервного копирования:</b> <a [pref.auto_backup_implant ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_implant=1'><b>[pref.auto_backup_implant ? "Да" : "Нет"]</b></a><br>"
	. += "<br><b>Теги в Списке персонажей</b><br>"
	. += "<a [pref.show_in_directory ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_show_in_directory=1'><b>[pref.show_in_directory ? "Отображать в Списке персонажей" : "Отображать в Списке персонажей"]</b></a><br>"
	. += "<table><tr><td>Роль в Vore:</td><td><a href='?src=\ref[src];directory_tag=1'><b>[pref.directory_tag]</b></a></td></tr>"
	. += "<tr><td>Роль в ERP:</td><td><a href='?src=\ref[src];directory_erptag=1'><b>[pref.directory_erptag]</b></a></td></tr>"
	. += "<tr><td>Гендер:</td><td><a href='?src=\ref[src];directory_gendertag=1'><b>[pref.directory_gendertag]</b></a></td></tr>" // CHOMPStation Edit: Character Directory Update
	. += "<tr><td>Ориентация:</td><td><a href='?src=\ref[src];directory_sexualitytag=1'><b>[pref.directory_sexualitytag]</b></a></td></tr>" // CHOMPStation Edit: Character Directory Update
	. += "<tr><td>Объявление:</td><td><a href='?src=\ref[src];directory_ad=1'><b>Установить</b></a></td></tr></table><br>"
	. += "<b><a [pref.borg_petting ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_borg_petting=1'><b>[pref.borg_petting ? "Допускать" : "Не допускать"]</b></a> поглаживания, будучи роботом</b><br>"
	. += "<b><a [pref.stomach_vision ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_stomach_vision=1'><b>[pref.stomach_vision ? "Отображать" : "Не отображать"]</b></a> животы персонажей</b><br>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/vore/misc/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_show_in_directory"])
		pref.show_in_directory = pref.show_in_directory ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["directory_tag"])
		/* Bastion of Endeavor Translation
		var/new_tag = tgui_input_list(user, "Pick a new Vore tag for the character directory", "Character Vore Tag", GLOB.char_directory_tags, pref.directory_tag)
		*/
		var/new_tag = tgui_input_list(user, "Укажите роль в Vore для Списка персонажей:", "Роль в Vore", GLOB.char_directory_tags, pref.directory_tag)
		// End of Bastion of Endeavor Translation
		if(!new_tag)
			return
		pref.directory_tag = new_tag
		return TOPIC_REFRESH
	// CHOMPStation Edit Start: Directory Update
	else if(href_list["directory_gendertag"])
		/* Bastion of Endeavor Translation
		var/new_gendertag = tgui_input_list(user, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags, pref.directory_gendertag)
		*/
		var/new_gendertag = tgui_input_list(user, "Укажите гендер вашего персонажа для Списка персонажей.", "Пол персонажа", GLOB.char_directory_gendertags, pref.directory_gendertag)
		// End of Bastion of Endeavor Translation
		if(!new_gendertag)
			return
		pref.directory_gendertag = new_gendertag
		return TOPIC_REFRESH
	else if(href_list["directory_sexualitytag"])
		/* Bastion of Endeavor Translation
		var/new_sexualitytag = tgui_input_list(user, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags, pref.directory_sexualitytag)
		*/
		var/new_sexualitytag = tgui_input_list(user, "Укажите ориентацию вашего персонажа для Списка персонажей.", "Ориентация персонажа", GLOB.char_directory_sexualitytags, pref.directory_sexualitytag)
		// End of Bastion of Endeavor Translation
		if(!new_sexualitytag)
			return
		pref.directory_sexualitytag = new_sexualitytag
		return TOPIC_REFRESH
	// CHOMPStation Edit End: Directory Update
	else if(href_list["directory_erptag"])
		/* Bastion of Endeavor Translation
		var/new_erptag = tgui_input_list(user, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags, pref.directory_erptag)
		*/
		var/new_erptag = tgui_input_list(user, "Укажите роль в ERP для Списка персонажей:", "Роль в ERP", GLOB.char_directory_erptags, pref.directory_erptag)
		// End of Bastion of Endeavor Translation
		if(!new_erptag)
			return
		pref.directory_erptag = new_erptag
		return TOPIC_REFRESH
	else if(href_list["directory_ad"])
		/* Bastion of Endeavor Translation
		var/msg = sanitize(tgui_input_text(user,"Write your advertisement here!", "Flavor Text", html_decode(pref.directory_ad), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
		*/
		var/msg = sanitize(tgui_input_text(user,"Введите объявление для своего персонажа!", "Объявление", html_decode(pref.directory_ad), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
		// End of Bastion of Endeavor Translation
		if(!msg)
			return
		pref.directory_ad = msg
		return TOPIC_REFRESH
	else if(href_list["toggle_sensor_setting"])
		/* Bastion of Endeavor Translation
		var/new_sensorpref = tgui_input_list(user, "Choose your character's sensor preferences:", "Character Preferences", sensorpreflist, sensorpreflist[pref.sensorpref])
		*/
		var/new_sensorpref = tgui_input_list(user, "Укажите предпочитаемый режим датчиков одежды:", "Режим датчиков", sensorpreflist, sensorpreflist[pref.sensorpref])
		// End of Bastion of Endeavor Translation
		if (!isnull(new_sensorpref) && CanUseTopic(user))
			pref.sensorpref = sensorpreflist.Find(new_sensorpref)
			return TOPIC_REFRESH
	else if(href_list["toggle_capture_crystal"])
		pref.capture_crystal = pref.capture_crystal ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_implant"])
		pref.auto_backup_implant = pref.auto_backup_implant ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_borg_petting"])
		pref.borg_petting = pref.borg_petting ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_stomach_vision"])
		pref.stomach_vision = pref.stomach_vision ? 0 : 1;
		return TOPIC_REFRESH
	return ..();
