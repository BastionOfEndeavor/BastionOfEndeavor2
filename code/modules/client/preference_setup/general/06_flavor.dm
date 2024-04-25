/datum/category_item/player_setup_item/general/flavor
	name = "Flavor"
	sort_order = 6

/datum/category_item/player_setup_item/general/flavor/load_character(var/savefile/S)
	S["flavor_texts_general"]	>> pref.flavor_texts["general"]
	S["flavor_texts_head"]		>> pref.flavor_texts["head"]
	S["flavor_texts_face"]		>> pref.flavor_texts["face"]
	S["flavor_texts_eyes"]		>> pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]		>> pref.flavor_texts["torso"]
	S["flavor_texts_arms"]		>> pref.flavor_texts["arms"]
	S["flavor_texts_hands"]		>> pref.flavor_texts["hands"]
	S["flavor_texts_legs"]		>> pref.flavor_texts["legs"]
	S["flavor_texts_feet"]		>> pref.flavor_texts["feet"]
	S["custom_link"]			>> pref.custom_link
	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> pref.flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] >> pref.flavour_texts_robot[module]

/datum/category_item/player_setup_item/general/flavor/save_character(var/savefile/S)
	S["flavor_texts_general"]	<< pref.flavor_texts["general"]
	S["flavor_texts_head"]		<< pref.flavor_texts["head"]
	S["flavor_texts_face"]		<< pref.flavor_texts["face"]
	S["flavor_texts_eyes"]		<< pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]		<< pref.flavor_texts["torso"]
	S["flavor_texts_arms"]		<< pref.flavor_texts["arms"]
	S["flavor_texts_hands"]		<< pref.flavor_texts["hands"]
	S["flavor_texts_legs"]		<< pref.flavor_texts["legs"]
	S["flavor_texts_feet"]		<< pref.flavor_texts["feet"]
	S["custom_link"]			<< pref.custom_link

	// Bastion of Endeavor TODO: Do we need to come back to this after mobs are localized?
	S["flavour_texts_robot_Default"] << pref.flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] << pref.flavour_texts_robot[module]

/datum/category_item/player_setup_item/general/flavor/sanitize_character()
	return

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/flavor/copy_to_mob(var/mob/living/carbon/human/character)
	character.flavor_texts["general"]	= pref.flavor_texts["general"]
	character.flavor_texts["head"]		= pref.flavor_texts["head"]
	character.flavor_texts["face"]		= pref.flavor_texts["face"]
	character.flavor_texts["eyes"]		= pref.flavor_texts["eyes"]
	character.flavor_texts["torso"]		= pref.flavor_texts["torso"]
	character.flavor_texts["arms"]		= pref.flavor_texts["arms"]
	character.flavor_texts["hands"]		= pref.flavor_texts["hands"]
	character.flavor_texts["legs"]		= pref.flavor_texts["legs"]
	character.flavor_texts["feet"]		= pref.flavor_texts["feet"]
	character.ooc_notes 				= pref.metadata //VOREStation Add
	character.ooc_notes_likes			= pref.metadata_likes
	character.ooc_notes_dislikes		= pref.metadata_dislikes
	//CHOMPEdit Start
	character.ooc_notes_maybes			= pref.metadata_maybes
	character.ooc_notes_favs			= pref.metadata_favs
	character.ooc_notes_style			= pref.matadata_ooc_style
	//CHOMPEdit End
	character.custom_link				= pref.custom_link

/datum/category_item/player_setup_item/general/flavor/content(var/mob/user)
	/* Bastion of Endeavor Translation
	. += "<b>Flavor:</b><br>"
	. += "<a href='?src=\ref[src];flavor_text=open'>Set Flavor Text</a><br/>"
	. += "<a href='?src=\ref[src];flavour_text_robot=open'>Set Robot Flavor Text</a><br/>"
	. += "<a href='?src=\ref[src];custom_link=1'>Set Custom Link</a><br/>"
	*/
	. += "<br><b>Описание внешности</b><br>"
	. += "<a href='?src=\ref[src];flavor_text=open'>Установить для персонажа</a><br/>"
	. += "<a href='?src=\ref[src];flavour_text_robot=open'>Установить для робота</a><br/>"
	. += "<a href='?src=\ref[src];custom_link=1'>Установить ссылку</a><br/>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/general/flavor/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["flavor_text"])
		switch(href_list["flavor_text"])
			if("open")
			if("general")
<<<<<<< HEAD
				/* Bastion of Endeavor Translation
				var/msg = strip_html_simple(tgui_input_text(usr,"Give a general description of your character. This will be shown regardless of clothings. Put in a single space to make blank.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE))	//VOREStation Edit: separating out OOC notes
				*/
				var/msg = strip_html_simple(tgui_input_text(usr,"Введите общее описание внешности вашего персонажа. Оно будет отображаться независимо от одежды.","Описание внешности",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE))
				// End of Bastion of Endeavor Translation
				if(CanUseTopic(user) && msg)
					pref.flavor_texts[href_list["flavor_text"]] = msg
			else
				/* Bastion of Endeavor Translation
				var/msg = strip_html_simple(tgui_input_text(usr,"Set the flavor text for your [href_list["flavor_text"]]. Put in a single space to make blank.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE))
				*/
				var/msg = strip_html_simple(tgui_input_text(usr, "Введите описание [href_list["flavor_text"]] персонажа или пробел, чтобы удалить имеющееся.","Описание внешности",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE))
				// End of Bastion of Endeavor Translation
=======
				var/msg = strip_html_simple(tgui_input_text(user,"Give a general description of your character. This will be shown regardless of clothings. Put in a single space to make blank.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE))	//VOREStation Edit: separating out OOC notes //ChompEDIT - usr removal
				if(CanUseTopic(user) && msg)
					pref.flavor_texts[href_list["flavor_text"]] = msg
			else
				var/msg = strip_html_simple(tgui_input_text(user,"Set the flavor text for your [href_list["flavor_text"]]. Put in a single space to make blank.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
				if(CanUseTopic(user) && msg)
					pref.flavor_texts[href_list["flavor_text"]] = msg
		SetFlavorText(user)
		return TOPIC_HANDLED

	else if(href_list["flavour_text_robot"])
		switch(href_list["flavour_text_robot"])
			if("open")
			/* Bastion of Endeavor Translation: Will leave the module untranslated until borgs are localized
			if("Default")
<<<<<<< HEAD
				var/msg = strip_html_simple(tgui_input_text(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting. Put in a single space to make blank.","Flavour Text",html_decode(pref.flavour_texts_robot["Default"]), multiline = TRUE, prevent_enter = TRUE))
			*/
			if("Default")
				var/msg = strip_html_simple(tgui_input_text(usr,"Введите общее описание внешности вашего робота. Оно будет использоваться для каждого модуля, не имеющего отдельного описания.","Описание внешности",html_decode(pref.flavour_texts_robot["Default"]), multiline = TRUE, prevent_enter = TRUE))
			// End of Bastion of Endeavor Translation
				if(CanUseTopic(user) && msg)
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
			else
				/* Bastion of Endeavor Translation
				var/msg = strip_html_simple(tgui_input_text(usr,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this blank, default flavour text will be used for this module. Put in a single space to make blank.","Flavour Text",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]]), multiline = TRUE, prevent_enter = TRUE))
				*/
				var/msg = strip_html_simple(tgui_input_text(usr,"Введите описание внешности вашего робота при модуле '[href_list["flavour_text_robot"]]'. Введите пробел, чтобы оставить поле пустым и использовать описание по умолчанию.","Описание внешности",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]]), multiline = TRUE, prevent_enter = TRUE))
				// End of Bastion of Endeavor Translation
=======
				var/msg = strip_html_simple(tgui_input_text(user,"Set the default flavour text for your robot. It will be used for any module without individual setting. Put in a single space to make blank.","Flavour Text",html_decode(pref.flavour_texts_robot["Default"]), multiline = TRUE, prevent_enter = TRUE)) //ChompEDIT - usr removal
				if(CanUseTopic(user) && msg)
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
			else
				var/msg = strip_html_simple(tgui_input_text(user,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this blank, default flavour text will be used for this module. Put in a single space to make blank.","Flavour Text",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]]), multiline = TRUE, prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
				if(CanUseTopic(user) && msg)
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
		SetFlavourTextRobot(user)
		return TOPIC_HANDLED
	else if(href_list["custom_link"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/new_link = strip_html_simple(tgui_input_text(usr, "Enter a link to add on to your examine text! This should be a related image link/gallery, or things like your F-list. This is not the place for memes.", "Custom Link" , html_decode(pref.custom_link), max_length = 100, encode = TRUE,  prevent_enter = TRUE))
		*/
		var/new_link = strip_html_simple(tgui_input_text(usr, "Введите ссылку, которая будет отображаться при осмотре вашего персонажа. Ссылка может иметь изображение/галерею с вашим персонажем, или вещи наподобие F-List. Сюда не положено загружать мемы.", "Ссылка" , html_decode(pref.custom_link), max_length = 100, encode = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
		if(new_link && CanUseTopic(usr))
			if(length(new_link) > 100)
				/* Bastion of Endeavor Translation
				to_chat(usr, "<span class = 'warning'>Your entry is too long, it must be 100 characters or less.</span>")
				*/
				to_chat(usr, "<span class = 'warning'>Вы ввели слишком длинную ссылку. Длина не может превышать 100 символов.</span>")
				// End of Bastion of Endeavor Translation
				return
			pref.custom_link = new_link
			/* Bastion of Endeavor Translation
			log_admin("[usr]/[usr.ckey] set their custom link to [pref.custom_link]")
			*/
			log_admin("[usr]/[usr.ckey] установил для своего персонажа ссылку [pref.custom_link].")
			// End of Bastion of Endeavor Translation
=======
		var/new_link = strip_html_simple(tgui_input_text(user, "Enter a link to add on to your examine text! This should be a related image link/gallery, or things like your F-list. This is not the place for memes.", "Custom Link" , html_decode(pref.custom_link), max_length = 100, encode = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
		if(new_link && CanUseTopic(user)) //ChompEDIT - usr removal
			if(length(new_link) > 100)
				to_chat(user, "<span class = 'warning'>Your entry is too long, it must be 100 characters or less.</span>") //ChompEDIT - usr removal
				return
			pref.custom_link = new_link
			log_admin("[user]/[user.ckey] set their custom link to [pref.custom_link]") //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))

	return ..()

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavorText(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	/* Bastion of Endeavor Translation
	HTML += "<b>Set Flavor Text</b> <hr />"
	HTML += "Note: This is not *literal* flavor of your character. This is visual description of what they look like. <hr />"
	*/
	HTML += "<meta charset='utf-8'>"
	HTML += "<b>Описание внешности</b> <hr />"
	HTML += "Введите описание внешности вашего персонажа. Скрытые одеждой части тела не будут отображать описание при осмотре вашего персонажа. Общее описание показывается вне зависимости от одежды. <hr />"
	// End of Bastion of Endeavor Translation
	HTML += "<br></center>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=general'>General:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=general'>Общее:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["general"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=head'>Head:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=головы'>Голова:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["head"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=face'>Face:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=лица'>Лицо:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["face"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=eyes'>Eyes:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=глаз'>Глаза:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["eyes"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=torso'>Body:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=торса'>Тело:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["torso"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=arms'>Arms:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=рук'>Руки:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["arms"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=hands'>Hands:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=ладоней'>Ладони:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["hands"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=legs'>Legs:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=ног'>Ноги:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["legs"])
	HTML += "<br>"
	/* Bastion of Endeavor Translation
	HTML += "<a href='?src=\ref[src];flavor_text=feet'>Feet:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavor_text=ступней'>Ступни:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavor_text;size=430x300")
	return

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	/* Bastion of Endeavor Translation
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	*/
	HTML += "<meta charset='utf-8'>"
	HTML += "<b>Описание внешности робота</b> <hr />"
	// End of Bastion of Endeavor Translation
	HTML += "<br></center>"
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Leaving the rest untranslated until borgs get localization
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>Default:</a> "
	*/
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>По умолчанию:</a> "
	// End of Bastion of Endeavor Translation
	HTML += TextPreview(pref.flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in robot_module_types)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(pref.flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return
