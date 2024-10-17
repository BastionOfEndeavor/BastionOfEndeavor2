/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5
/datum/category_item/player_setup_item/general/background/load_character(list/save_data)
	pref.med_record			= save_data["med_record"]
	pref.sec_record			= save_data["sec_record"]
	pref.gen_record			= save_data["gen_record"]
	pref.home_system		= save_data["home_system"]
	pref.birthplace			= save_data["birthplace"]
	pref.citizenship		= save_data["citizenship"]
	pref.faction			= save_data["faction"]
	pref.religion			= save_data["religion"]
	pref.economic_status	= save_data["economic_status"]

/datum/category_item/player_setup_item/general/background/save_character(list/save_data)
	save_data["med_record"]			= pref.med_record
	save_data["sec_record"]			= pref.sec_record
	save_data["gen_record"]			= pref.gen_record
	save_data["home_system"]		= pref.home_system
	save_data["birthplace"]			= pref.birthplace
	save_data["citizenship"]		= pref.citizenship
	save_data["faction"]			= pref.faction
	save_data["religion"]			= pref.religion
	save_data["economic_status"]	= pref.economic_status

/datum/category_item/player_setup_item/general/background/sanitize_character()
	/* Bastion of Endeavor Translation
	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.birthplace)  pref.birthplace =  "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"
	*/
	if(!pref.home_system) pref.home_system = "Не указано"
	if(!pref.birthplace)  pref.birthplace =  "Не указано"
	if(!pref.citizenship) pref.citizenship = "Нет"
	if(!pref.faction)     pref.faction =     "Нет"
	if(!pref.religion)    pref.religion =    "Нет"
	// End of Bastion of Endeavor Translation

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_CLASS, initial(pref.economic_status))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/background/copy_to_mob(var/mob/living/carbon/human/character)
	character.med_record		= pref.med_record
	character.sec_record		= pref.sec_record
	character.gen_record		= pref.gen_record
	character.home_system		= pref.home_system
	character.birthplace		= pref.birthplace
	character.citizenship		= pref.citizenship
	character.personal_faction	= pref.faction
	character.religion			= pref.religion

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Job bans
	. += "<b>Background Information</b><br>"
	. += "Economic Status: <a href='?src=\ref[src];econ_status=1'>[pref.economic_status]</a><br/>"
	. += "Home: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"
	. += "Birthplace: <a href='?src=\ref[src];birthplace=1'>[pref.birthplace]</a><br/>"
	. += "Citizenship: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	. += "Faction: <a href='?src=\ref[src];faction=1'>[pref.faction]</a><br/>"
	. += "Religion: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"

	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br>"
		. += " (<a href='?src=\ref[src];reset_medrecord=1'>Reset</A>)<br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br>"
		. += "(<a href='?src=\ref[src];reset_emprecord=1'>Reset</A>)<br><br>"
		. += "Security Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"
		. += "(<a href='?src=\ref[src];reset_secrecord=1'>Reset</A>)"
	*/
	. += "<b>Происхождение персонажа</b><br>"
	. += "Финансовое положение: <a href='?src=\ref[src];econ_status=1'>[pref.economic_status]</a><br/>"
	. += "Место жительства: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"
	. += "Место рождения: <a href='?src=\ref[src];birthplace=1'>[pref.birthplace]</a><br/>"
	. += "Гражданство: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	. += "Фракция: <a href='?src=\ref[src];faction=1'>[pref.faction]</a><br/>"
	. += "Вероисповедание: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"
	. += "<br/><b>Записи</b><br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>Вам запрещено использовать записи персонажа.</span><br>"
	else
		. += "Медицинские записи:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br>"
		. += "<a href='?src=\ref[src];reset_medrecord=1'>Удалить</A><br><br>"
		. += "Записи о трудоустройстве:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br>"
		. += "<a href='?src=\ref[src];reset_emprecord=1'>Удалить</A><br><br>"
		. += "Записи службы безопасности:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"
		. += "<a href='?src=\ref[src];reset_secrecord=1'>Удалить</A>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["econ_status"])
		/* Bastion of Endeavor Translation
		var/new_class = tgui_input_list(user, "Choose your economic status. This will affect the amount of money you will start with.", "Character Preference", ECONOMIC_CLASS, pref.economic_status)
		*/
		var/new_class = tgui_input_list(user, "Укажите финансовое положение персонажа. Это влияет на его начальное количество денег.", "Финансовое положение", ECONOMIC_CLASS, pref.economic_status)
		// End of Bastion of Endeavor Translation
		if(new_class && CanUseTopic(user))
			pref.economic_status = new_class
			return TOPIC_REFRESH

	else if(href_list["home_system"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Please choose your home planet and/or system. This should be your current primary residence. Select \"Other\" to specify manually.", "Character Preference", home_system_choices + list("Unset","Other"), pref.home_system)
		*/
		var/choice = tgui_input_list(user, "Укажите планету и/или систему, где живёт ваш персонаж на данный момент. Выберите \"Другое\", чтобы вписать вручную.", "Место жительства", home_system_choices + list("Не указано","Другое"), pref.home_system)
		// End of Bastion of Endeavor Translation
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		if(choice == "Other")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a home system.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		if(choice == "Другое")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Укажите планету и/или систему, где живёт ваш персонаж на данный момент.", "Место жительства", null, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

	else if(href_list["birthplace"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Please choose the planet and/or system or other appropriate location that you were born/created. Select \"Other\" to specify manually.", "Character Preference", home_system_choices + list("Unset","Other"), pref.birthplace)
		*/
		var/choice = tgui_input_list(user, "Укажите планету и/или систему, где был рождён или создан ваш персонаж. Выберите \"Другое\", чтобы вписать вручную.", "Место рождения", home_system_choices + list("Не указано","Другое"), pref.birthplace)
		// End of Bastion of Endeavor Translation
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		if(choice == "Other")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a birthplace.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		if(choice == "Другое")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Укажите планету и/или систему, где был рождён или создан ваш персонаж.", "Место рождения", null, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
			if(raw_choice && CanUseTopic(user))
				pref.birthplace = raw_choice
		else
			pref.birthplace = choice
		return TOPIC_REFRESH

	else if(href_list["citizenship"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Please select the faction or political entity with which you currently hold citizenship. Select \"Other\" to specify manually.", "Character Preference", citizenship_choices + list("None","Other"), pref.citizenship)
		*/
		var/choice = tgui_input_list(user, "Укажите фракцию или политическое объединение, к которому принадлежит гражданство вашего персонажа. Выберите \"Другое\", чтобы вписать вручную.", "Гражданство", citizenship_choices + list("Нет","Другое"), pref.citizenship)
		// End of Bastion of Endeavor Translation
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		if(choice == "Other")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter your current citizenship.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		if(choice == "Другое")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Укажите гражданство вашего персонажа.", "Гражданство", null, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
			if(raw_choice && CanUseTopic(user))
				pref.citizenship = raw_choice
		else
			pref.citizenship = choice
		return TOPIC_REFRESH

	else if(href_list["faction"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Please choose the faction you primarily work for, if you are not under the direct employ of NanoTrasen. Select \"Other\" to specify manually.", "Character Preference", faction_choices + list("None","Other"), pref.faction)
		*/
		var/choice = tgui_input_list(user, "Укажите фракцию или компанию, на которую работает ваш персонаж. Выберите \"Другое\", чтобы вписать вручную.", "Фракция", faction_choices + list("Нет","Другое"), pref.faction)
		// End of Bastion of Endeavor Translation
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		if(choice == "Other")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a faction.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		if(choice == "Другое")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Укажите фракцию или компанию, на которую работает ваш персонаж.", "Фракция", null, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
			if(raw_choice)
				pref.faction = raw_choice
		else
			pref.faction = choice
		return TOPIC_REFRESH

	else if(href_list["religion"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Please choose a religion. Select \"Other\" to specify manually.", "Character Preference", religion_choices + list("None","Other"), pref.religion)
		*/
		var/choice = tgui_input_list(user, "Укажите религию вашего персонажа. Выберите \"Другое\", чтобы вписать вручную.", "Вероисповедание", religion_choices + list("Нет","Другое"), pref.religion)
		// End of Bastion of Endeavor Translation
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		if(choice == "Other")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Please enter a religon.", "Character Preference", null, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		if(choice == "Другое")
			var/raw_choice = strip_html_simple(tgui_input_text(user, "Укажите религию вашего персонажа.", "Вероисповедание", null, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
			if(raw_choice)
				pref.religion = sanitize(raw_choice)
		else
			pref.religion = choice
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		/* Bastion of Endeavor Translation
		var/new_medical = strip_html_simple(tgui_input_text(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		*/
		var/new_medical = strip_html_simple(tgui_input_text(user,"Введите медицинские записи вашего персонажа.","Медицинские записи", html_decode(pref.med_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		// End of Bastion of Endeavor Translation
		if(new_medical && !jobban_isbanned(user, JOB_RECORDS) && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		/* Bastion of Endeavor Translation
		var/new_general = strip_html_simple(tgui_input_text(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		*/
		var/new_general = strip_html_simple(tgui_input_text(user,"Введите записи о трудоустройстве вашего персонажа.","Записи о трудоустройстве", html_decode(pref.gen_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		// End of Bastion of Endeavor Translation
		if(new_general && !jobban_isbanned(user, JOB_RECORDS) && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		/* Bastion of Endeavor Translation
		var/sec_medical = strip_html_simple(tgui_input_text(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		*/
		var/sec_medical = strip_html_simple(tgui_input_text(user,"Введите записи службы безопасности о вашем персонаже.","Записи службы безопасности", html_decode(pref.sec_record), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
		// End of Bastion of Endeavor Translation
		if(sec_medical && !jobban_isbanned(user, JOB_RECORDS) && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["reset_medrecord"])
		/* Bastion of Endeavor Translation
		var/resetmed_choice = tgui_alert(user, "Wipe your Medical Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No")) //ChompEDIT - usr removal
		if(resetmed_choice == "Yes")
		*/
		var/resetmed_choice = tgui_alert(user, "Удалить медицинские записи вашего персонажа? Это действие невозможно отменить, если вы предварительно не сохранили персонажа! Сделайте запасную копию.","Удалить записи",list("Да","Нет"))
		if(resetmed_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.med_record = null
		return TOPIC_REFRESH

	else if(href_list["reset_emprecord"])
		/* Bastion of Endeavor Translation
		var/resetemp_choice = tgui_alert(user, "Wipe your Employment Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No")) //ChompEDIT - usr removal
		if(resetemp_choice == "Yes")
		*/
		var/resetemp_choice = tgui_alert(user, "Удалить записи о трудоустройстве вашего персонажа? Это действие невозможно отменить, если вы предварительно не сохранили персонажа! Сделайте запасную копию.","Удалить записи",list("Да","Нет"))
		if(resetemp_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.gen_record = null
		return TOPIC_REFRESH

	else if(href_list["reset_secrecord"])
		/* Bastion of Endeavor Translation
		var/resetsec_choice = tgui_alert(user, "Wipe your Security Records? This cannot be reverted if you have not saved your character recently! You may wish to make a backup first.","Reset Records",list("Yes","No")) //ChompEDIT - usr removal
		if(resetsec_choice == "Yes")
		*/
		var/resetsec_choice = tgui_alert(user, "Удалить записи службы безопасности о вашем персонаже? Это действие невозможно отменить, если вы предварительно не сохранили персонажа! Сделайте запасную копию.","Удалить записи",list("Да","Нет"))
		if(resetsec_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.sec_record = null
		return TOPIC_REFRESH

	return ..()
