/datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

/datum/preferences/proc/set_biological_gender(var/gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]				>> pref.real_name
	S["nickname"]				>> pref.nickname
	S["name_is_always_random"]	>> pref.be_random_name
	S["gender"]					>> pref.biological_gender
	S["id_gender"]				>> pref.identifying_gender
	S["age"]					>> pref.age
	S["bday_month"]				>> pref.bday_month
	S["bday_day"]				>> pref.bday_day
	S["last_bday_note"]			>> pref.last_birthday_notification
	S["bday_announce"]			>> pref.bday_announce
	S["spawnpoint"]				>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata
	S["OOC_Notes_Likes"]		>> pref.metadata_likes
	S["OOC_Notes_Disikes"]		>> pref.metadata_dislikes
	//CHOMPEdit Start
	S["OOC_Notes_Maybes"]		>> pref.metadata_maybes
	S["OOC_Notes_Favs"]			>> pref.metadata_favs
	S["OOC_Notes_System"]		>> pref.matadata_ooc_style
	//CHOMPEdit End

	// Bastion of Endeavor Addition: Cases for names
	S["cases_ncase"]	    	>> pref.cases[NCASE]
	S["cases_gcase"]			>> pref.cases[GCASE]
	S["cases_dcase"]			>> pref.cases[DCASE]
	S["cases_acase"]			>> pref.cases[ACASE]
	S["cases_icase"]			>> pref.cases[ICASE]
	S["cases_pcase"]			>> pref.cases[PCASE]
	// End of Bastion of Endeavor Addition

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["nickname"]				<< pref.nickname
	S["name_is_always_random"]	<< pref.be_random_name
	S["gender"]					<< pref.biological_gender
	S["id_gender"]				<< pref.identifying_gender
	S["age"]					<< pref.age
	S["bday_month"]				<< pref.bday_month
	S["bday_day"]				<< pref.bday_day
	S["last_bday_note"]			<< pref.last_birthday_notification
	S["bday_announce"]			<< pref.bday_announce
	S["spawnpoint"]				<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata
	S["OOC_Notes_Likes"]		<< pref.metadata_likes
	S["OOC_Notes_Disikes"]		<< pref.metadata_dislikes
	//CHOMPEdit Start
	S["OOC_Notes_Favs"]			<< pref.metadata_favs
	S["OOC_Notes_Maybes"]		<< pref.metadata_maybes
	S["OOC_Notes_System"]		<< pref.matadata_ooc_style
	//CHOMPEdit End

	// Bastion of Endeavor Addition: Cases for names
	S["cases_ncase"]			<< pref.cases[NCASE]
	S["cases_gcase"]			<< pref.cases[GCASE]
	S["cases_dcase"]			<< pref.cases[DCASE]
	S["cases_acase"]			<< pref.cases[ACASE]
	S["cases_icase"]			<< pref.cases[ICASE]
	S["cases_pcase"]			<< pref.cases[PCASE]
	// End of Bastion of Endeavor Addition

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	pref.age                = sanitize_integer(pref.age, get_min_age(), get_max_age(), initial(pref.age))
	pref.bday_month			= sanitize_integer(pref.bday_month, 0, 12, initial(pref.bday_month))
	pref.bday_day			= sanitize_integer(pref.bday_day, 0, 31, initial(pref.bday_day))
	pref.last_birthday_notification = sanitize_integer(pref.last_birthday_notification, 0, 9999, initial(pref.last_birthday_notification))
	pref.biological_gender  = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name		= sanitize_name(pref.real_name, pref.species, is_FBP())
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)
	pref.nickname		= sanitize_name(pref.nickname)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))
	// Bastion of Endeavor Addition: Cases for names
	if(!pref.cases[NCASE]) pref.cases[NCASE] = pref.real_name
	if(!pref.cases[GCASE]) pref.cases[GCASE] = pref.real_name
	if(!pref.cases[DCASE]) pref.cases[DCASE] = pref.real_name
	if(!pref.cases[ACASE]) pref.cases[ACASE] = pref.real_name
	if(!pref.cases[ICASE]) pref.cases[ICASE] = pref.real_name
	if(!pref.cases[PCASE]) pref.cases[PCASE] = pref.real_name
	// End of Bastion of Endeavor Addition

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/basic/copy_to_mob(var/mob/living/carbon/human/character)
	if(CONFIG_GET(flag/humans_need_surnames)) // CHOMPEdit
		/* Bastion of Endeavor Unicode Edit
		var/firstspace = findtext(pref.real_name, " ")
		var/name_length = length(pref.real_name)
		*/
		var/firstspace = findtext_char(pref.real_name, " ")
		var/name_length = length_char(pref.real_name)
		// End of Bastion of Endeavor Unicode Edit
		if(!firstspace)	//we need a surname
			pref.real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			pref.real_name += "[pick(last_names)]"

	character.real_name = pref.real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.nickname = pref.nickname

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender
	character.age = pref.age
	character.bday_month = pref.bday_month
	character.bday_day = pref.bday_day
	// Bastion of Endeavor Addition: Bastion of Endeavor TODO: This will need some work after we get a proper case editor
	character.cases_ru["basic"] = list(RUGENDER = character.gender, NCASE = pref.cases[NCASE], GCASE = pref.cases[GCASE], DCASE = pref.cases[DCASE], ACASE = pref.cases[ACASE], ICASE = pref.cases[ICASE], PCASE = pref.cases[PCASE])
	character.cases_ru["real_name"] = list(RUGENDER = character.gender, NCASE = pref.cases[NCASE], GCASE = pref.cases[GCASE], DCASE = pref.cases[DCASE], ACASE = pref.cases[ACASE], ICASE = pref.cases[ICASE], PCASE = pref.cases[PCASE])
	// End of Bastion of Endeavor Addition

/datum/category_item/player_setup_item/general/basic/content()
	. = list()
	/* Bastion of Endeavor Translation: Added the cases setup
	. += "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a><br>"
	. += "<b>Nickname:</b> "
	. += "<a href='?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a>"
	. += "(<a href='?src=\ref[src];reset_nickname=1'>Clear</A>)"
	. += "<br>"
	. += "<b>Biological Sex:</b> <a href='?src=\ref[src];bio_gender=1'><b>[gender2text(pref.biological_gender)]</b></a><br>"
	. += "<b>Pronouns:</b> <a href='?src=\ref[src];id_gender=1'><b>[gender2text(pref.identifying_gender)]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a> <b>Birthday:</b> <a href='?src=\ref[src];bday_month=1'>[pref.bday_month]</a><b>/</b><a href='?src=\ref[src];bday_day=1'>[pref.bday_day]</a> - <b>Announce?:</b> <a href='?src=\ref[src];bday_announce=1'>[pref.bday_announce ? "Yes" : "Disabled"]</a><br>" //ChompEDIT - DISABLE the announcement
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(CONFIG_GET(flag/allow_metadata)) // CHOMPEdit
		//CHOMPEdit Start
		. += "<b>OOC Notes: <a href='?src=\ref[src];edit_ooc_notes=1'>Edit</a><a href='?src=\ref[src];edit_ooc_note_favs=1'>Favs</a><a href='?src=\ref[src];edit_ooc_note_likes=1'>Likes</a><a href='?src=\ref[src];edit_ooc_note_maybes=1'>Maybes</a><a href='?src=\ref[src];edit_ooc_note_dislikes=1'>Dislikes</a></b><br>"
		. += "Detailed field or short list system? <a href='?src=\ref[src];edit_ooc_note_style=1'>[pref.matadata_ooc_style ? "Lists" : "Fields"]</a><br><br>"
		//CHOMPEdit End
	*/
	. += "<b>Имя:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a>"
	. += "<a href='?src=\ref[src];random_name=1'>Сгенерировать имя</A>"
	. += "<a href='?src=\ref[src];cases_window=open'>Установить склонение имени</a><br>"
	// . += "<a href='?src=\ref[src];always_random_name=1'>Каждый раз случайное: [pref.be_random_name ? "Да" : "Нет"]</a><br>" // I don't see any reason for us to have this
	. += "<b>Прозвище:</b> "
	. += "<a href='?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a>"
	. += " <a href='?src=\ref[src];reset_nickname=1'>Сбросить</A>"
	. += "<br>"
	. += "<b>Биологический пол:</b> <a href='?src=\ref[src];bio_gender=1'>[get_key_by_value(all_genders_define_list_ru, pref.biological_gender)]</a><br>"
	. += "<b>Местоимения:</b> <a href='?src=\ref[src];id_gender=1'>[get_key_by_value(all_id_genders_define_list_ru, pref.identifying_gender)]</a><br>"
	. += "<b>Возраст:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><b>, дата рождения:</b> <a href='?src=\ref[src];bday_day=1'>[pref.bday_day]</a><b>.</b><a href='?src=\ref[src];bday_month=1'>[pref.bday_month]</a><br>"
	. += "<b>Точка прибытия</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(CONFIG_GET(flag/allow_metadata)) // CHOMPEdit
		//CHOMPEdit Start
		. += "<b>Примечания OOC: <a href='?src=\ref[src];edit_ooc_notes=1'>Изменить</a><a href='?src=\ref[src];edit_ooc_note_favs=1'>Любимое</a><a href='?src=\ref[src];edit_ooc_note_likes=1'>Нравится</a><a href='?src=\ref[src];edit_ooc_note_maybes=1'>Неоднозначно</a><a href='?src=\ref[src];edit_ooc_note_dislikes=1'>Не нравится</a></b><br>"
		. += "Примечания в формате <a href='?src=\ref[src];edit_ooc_note_style=1'>[pref.matadata_ooc_style ? "столбцов" : "вертикальных граф"]</a>.<br><br>"
		//CHOMPEdit End
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		/* Bastion of Endeavor Translation
		var/raw_name = tgui_input_text(user, "Choose your character's name:", "Character Name")
		*/
		var/raw_name = tgui_input_text(user, "Введите имя вашего персонажа:", "Имя персонажа")
		// End of Bastion of Endeavor Translation
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species, is_FBP())
			if(new_name)
				pref.real_name = new_name
				// Bastion of Endeavor Addition: Sort of an ugly temporary measure until we get a proper case editor
				pref.cases[NCASE] = pref.real_name
				pref.cases[GCASE] = pref.real_name
				pref.cases[DCASE] = pref.real_name
				pref.cases[ACASE] = pref.real_name
				pref.cases[ICASE] = pref.real_name
				pref.cases[PCASE] = pref.real_name
				// End of Bastion of Endeavor Addition
				return TOPIC_REFRESH
			else
				/* Bastion of Endeavor Translation
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				*/
				to_chat(user, "<span class='warning'>Недопустимое имя. В имени должно быть от 2 до [count_ru(MAX_NAME_LEN, "символ;а;ов;ов")]. Оно может содержать только буквы от А-Я, а-я, -, ', и .</span>")
				// End of Bastion of Endeavor Translation
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.identifying_gender, pref.species)
		// Bastion of Endeavor Addition: Sort of an ugly temporary measure until we get a proper case editor
		pref.cases[NCASE] = pref.real_name
		pref.cases[GCASE] = pref.real_name
		pref.cases[DCASE] = pref.real_name
		pref.cases[ACASE] = pref.real_name
		pref.cases[ICASE] = pref.real_name
		pref.cases[PCASE] = pref.real_name
		// End of Bastion of Endeavor Addition
		return TOPIC_REFRESH

	// Bastion of Endeavor Addition: Cases for names
	else if(href_list["cases_window"])
		set_pref_cases_ru(user)
		return TOPIC_HANDLED

	else if (href_list["cases"])
		var/msg = sanitize(tgui_input_text(usr,"Установите склонение имени в этом падеже.","Склонение имени",html_decode(pref.cases[href_list["cases"]]), MAX_NAME_LEN))
		if(CanUseTopic(user))
			pref.cases[href_list["cases"]] = msg
		set_pref_cases_ru(user)
		return TOPIC_HANDLED
	// End of Bastion of Endeavor Addition

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["nickname"])
		/* Bastion of Endeavor Translation
		var/raw_nickname = tgui_input_text(user, "Choose your character's nickname:", "Character Nickname", pref.nickname)
		*/
		var/raw_nickname = tgui_input_text(user, "Укажите прозвище вашего персонажа:", "Прозвище персонажа", pref.nickname)
		// End of Bastion of Endeavor Translation
		if (!isnull(raw_nickname) && CanUseTopic(user))
			var/new_nickname = sanitize_name(raw_nickname, pref.species, is_FBP())
			if(new_nickname)
				pref.nickname = new_nickname
				return TOPIC_REFRESH
			else
				/* Bastion of Endeavor Translation
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				*/
				to_chat(user, "<span class='warning'>Недопустимое имя. В имени должно быть от 2 до [MAX_NAME_LEN] символов. Оно может содержать только буквы от А-Я, а-я, -, ', и .</span>")
				// End of Bastion of Endeavor Translation
				return TOPIC_NOACTION

	else if(href_list["reset_nickname"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/nick_choice = tgui_alert(usr, "Wipe your Nickname? This will completely remove any chosen nickname(s).","Wipe Nickname",list("Yes","No"))
=======
		var/nick_choice = tgui_alert(user, "Wipe your Nickname? This will completely remove any chosen nickname(s).","Wipe Nickname",list("Yes","No"))  //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(nick_choice == "Yes")
		*/
		var/nick_choice = tgui_alert(usr, "Вы действительно хотите сбросить своё прозвище?","Сбросить прозвище",list("Да","Нет"))
		if(nick_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.nickname = null
		return TOPIC_REFRESH

	else if(href_list["bio_gender"])
		/* Bastion of Endeavor Translation
		var/new_gender = tgui_input_list(user, "Choose your character's biological sex:", "Character Preference", get_genders(), pref.biological_gender)
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(new_gender)
		*/
		var/new_gender = tgui_input_list(user, "Укажите биологический пол вашего персонажа:", "Биологический пол", get_genders_ru(get_genders()), get_key_by_value(all_genders_define_list_ru, pref.biological_gender))
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(all_genders_define_list_ru[new_gender])
		// End of Bastion of Endeavor Translation
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["id_gender"])
		/* Bastion of Endeavor Translation
		var/new_gender = tgui_input_list(user, "Choose your character's pronouns:", "Character Preference", all_genders_define_list, pref.identifying_gender)
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = new_gender
		*/
		var/new_gender = tgui_input_list(user, "Укажите местоимения вашего персонажа:", "Местоимения персонажа", all_id_genders_define_list_ru, get_key_by_value(all_id_genders_define_list_ru, pref.identifying_gender))
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = all_id_genders_define_list_ru[new_gender]
		// End of Bastion of Endeavor Translation
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/min_age = get_min_age()
		var/max_age = get_max_age()
		/* Bastion of Endeavor Translation
		var/new_age = tgui_input_number(user, "Choose your character's age:\n([min_age]-[max_age])", "Character Preference", pref.age, max_age, min_age)
		*/
		var/new_age = tgui_input_number(user, "Укажите возраст персонажа: ([min_age]-[max_age])", "Возраст персонажа", pref.age, max_age, min_age)
		// End of Bastion of Endeavor Translation
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), max_age), min_age)
			return TOPIC_REFRESH

	else if(href_list["bday_month"])
		/* Bastion of Endeavor Translation
		var/new_month = tgui_input_number(user, "Choose your character's birth month (number)", "Birthday Month", pref.bday_month, 12, 0)
		*/
		var/new_month = tgui_input_number(user, "Укажите цифру месяца рождения вашего персонажа.", "Месяц рождения", pref.bday_month, 12, 0)
		// End of Bastion of Endeavor Translation
		if(new_month && CanUseTopic(user))
			pref.bday_month = new_month
		/* Bastion of Endeavor Translation
		else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes") && CanUseTopic(user))
		*/
		else if((tgui_alert(user, "Сбросить дату рождения вашего персонажа?","Сбросить?",list("Нет","Да")) == "Да") && CanUseTopic(user))
		// End of Bastion of Endeavor Translation
			pref.bday_month = 0
			pref.bday_day = 0
		return TOPIC_REFRESH

	else if(href_list["bday_day"])
		if(!pref.bday_month)
			/* Bastion of Endeavor Translation
			tgui_alert(user,"You must set a birth month before you can set a day.", "Error", list("Okay"))
			*/
			tgui_alert(user,"Чтобы указать день, нужно сперва указать месяц.", "Ошибка", list("ОК"))
			// End of Bastion of Endeavor Translation
			return
		var/max_days
		switch(pref.bday_month)
			if(1)
				max_days = 31
			if(2)
				max_days = 29
			if(3)
				max_days = 31
			if(4)
				max_days = 30
			if(5)
				max_days = 31
			if(6)
				max_days = 30
			if(7)
				max_days = 31
			if(8)
				max_days = 31
			if(9)
				max_days = 30
			if(10)
				max_days = 31
			if(11)
				max_days = 30
			if(12)
				max_days = 31

		/* Bastion of Endeavor Translation
		var/new_day = tgui_input_number(user, "Choose your character's birth day (number, 1-[max_days])", "Birthday Day", pref.bday_day, max_days, 0)
		*/
		var/new_day = tgui_input_number(user, "Укажите число, в которое родился ваш персонаж (от 1 до [max_days]).", "Дата рождения", pref.bday_day, max_days, 0)
		// End of Bastion of Endeavor Translation
		if(new_day && CanUseTopic(user))
			pref.bday_day = new_day
		/* Bastion of Endeavor Translation
		else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes") && CanUseTopic(user))
		*/
		else if((tgui_alert(user, "Сбросить дату рождения вашего персонажа?","Сбросить?",list("Нет","Да")) == "Да") && CanUseTopic(user))
		// End of Bastion of Endeavor Translation
			pref.bday_month = 0
			pref.bday_day = 0
		return TOPIC_REFRESH

	else if(href_list["bday_announce"])
		pref.bday_announce = 0 //ChompEDIT - Disable this
		return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(user, "Where would you like to spawn when late-joining?", "Late-Join Choice", spawnkeys)
		*/
		var/choice = tgui_input_list(user, "В какой точке вы хотели бы появиться?", "Точка появления", spawnkeys)
		// End of Bastion of Endeavor Translation
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["edit_ooc_notes"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see, such as Roleplay-preferences. This will not be saved permanently unless you click save in the Character Setup panel!", "Game Preference" , html_decode(pref.metadata), multiline = TRUE,  prevent_enter = TRUE))
		*/
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Укажите здесь любую внеигровую информацию относительно ваших пожеланий в отыгрыше, которую хотите сообщить остальным.", "Примечания OOC" , html_decode(pref.metadata), multiline = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
		if(new_metadata && CanUseTopic(user))
			pref.metadata = new_metadata
	else if(href_list["edit_ooc_note_likes"])
		/* Bastion of Endeavor Translation
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your LIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_likes), multiline = TRUE,  prevent_enter = TRUE))
		*/
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Укажите здесь любую внеигровую информацию относительно того, что вам НРАВИТСЯ в отыгрыше, которую хотите сообщить остальным. Введите !очистить, чтобы очистить поле.", "Примечания OOC" , html_decode(pref.metadata), multiline = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
=======
		var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see, such as Roleplay-preferences. This will not be saved permanently unless you click save in the Character Setup panel!", "Game Preference" , html_decode(pref.metadata), multiline = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
		if(new_metadata && CanUseTopic(user))
			pref.metadata = new_metadata
	else if(href_list["edit_ooc_note_likes"])
		var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your LIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_likes), multiline = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(new_metadata && CanUseTopic(user))
			/* Bastion of Endeavor Translation
			if(new_metadata == "!clear")
			*/
			if(new_metadata == "!очистить")
			// End of Bastion of Endeavor Translation
				new_metadata = ""
			pref.metadata_likes = new_metadata
	else if(href_list["edit_ooc_note_dislikes"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your DISLIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_dislikes), multiline = TRUE,  prevent_enter = TRUE))
		*/
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Укажите здесь любую внеигровую информацию относительно того, что вам НЕ НРАВИТСЯ в отыгрыше, которую хотите сообщить остальным. Введите !очистить, чтобы очистить поле.", "Примечания OOC" , html_decode(pref.metadata), multiline = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
=======
		var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your DISLIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_dislikes), multiline = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(new_metadata && CanUseTopic(user))
			/* Bastion of Endeavor Translation
			if(new_metadata == "!clear")
			*/
			if(new_metadata == "!очистить")
			// End of Bastion of Endeavor Translation
				new_metadata = ""
			pref.metadata_dislikes = new_metadata
	//CHOMPEdit Start
	else if(href_list["edit_ooc_note_favs"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your FAVOURITE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_favs), multiline = TRUE,  prevent_enter = TRUE))
		*/
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Укажите здесь любую внеигровую информацию относительно того, что вы ОБОЖАЕТЕ в отыгрыше, которую хотите сообщить остальным. Введите !очистить, чтобы очистить поле.", "Примечания OOC", html_decode(pref.metadata_favs), multiline = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
=======
		var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your FAVOURITE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_favs), multiline = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(new_metadata && CanUseTopic(user))
			/* Bastion of Endeavor Translation
			if(new_metadata == "!clear")
			*/
			if(new_metadata == "!очистить")
			// End of Bastion of Endeavor Translation
				new_metadata = ""
			pref.metadata_favs = new_metadata
	else if(href_list["edit_ooc_note_maybes"])
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your MAYBE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_maybes), multiline = TRUE,  prevent_enter = TRUE))
		*/
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Укажите здесь любую внеигровую информацию относительно того, какие темы в отыгрыше для вас НЕОДНОЗНАЧНЫ, которую хотите сообщить остальным. Введите !очистить, чтобы очистить поле.", "Примечания OOC", html_decode(pref.metadata_maybes), multiline = TRUE,  prevent_enter = TRUE))
		// End of Bastion of Endeavor Translation
=======
		var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your MAYBE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.metadata_maybes), multiline = TRUE,  prevent_enter = TRUE)) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(new_metadata && CanUseTopic(user))
			/* Bastion of Endeavor Translation
			if(new_metadata == "!clear")
			*/
			if(new_metadata == "!очистить")
			// End of Bastion of Endeavor Translation
				new_metadata = ""
			pref.metadata_maybes = new_metadata
	else if(href_list["edit_ooc_note_style"])
		pref.matadata_ooc_style = !pref.matadata_ooc_style
		return TOPIC_REFRESH
	//CHOMPEdit End
	return ..()

/datum/category_item/player_setup_item/general/basic/proc/get_genders()
	var/datum/species/S
	if(pref.species)
		S = GLOB.all_species[pref.species]
	else
		S = GLOB.all_species[SPECIES_HUMAN]
	var/list/possible_genders = S.genders
	if(!pref.organ_data || pref.organ_data[BP_TORSO] != "cyborg")
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders

// Bastion of Endeavor Addition: Cases for names
/datum/category_item/player_setup_item/general/basic/proc/set_pref_cases_ru(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><meta charset=\"utf-8\"><center>"
	HTML += "<b>Установите склонение имени персонажа</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];cases=ncase'>Именительный:</a> "
	HTML += TextPreview(pref.cases[NCASE])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];cases=gcase'>Родительный:</a> "
	HTML += TextPreview(pref.cases[GCASE])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];cases=dcase'>Дательный:</a> "
	HTML += TextPreview(pref.cases[DCASE])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];cases=acase'>Винительный:</a> "
	HTML += TextPreview(pref.cases[ACASE])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];cases=icase'>Творительный:</a> "
	HTML += TextPreview(pref.cases[ICASE])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];cases=pcase'>Предложный:</a> "
	HTML += TextPreview(pref.cases[PCASE])
	HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=cases;size=430x300")
	return
// End of Bastion of Endeavor Addition