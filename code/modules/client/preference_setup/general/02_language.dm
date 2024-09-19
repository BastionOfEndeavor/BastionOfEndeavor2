/datum/preferences
	var/extra_languages = 0
	/* Bastion of Endeavor Translation
	var/preferred_language = "common" // VOREStation Edit: Allow selecting a preferred language
	*/
	var/preferred_language = "Общий" // VOREStation Edit: Allow selecting a preferred language
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/general/language
	name = "Language"
	sort_order = 2
	var/static/list/forbidden_prefixes = list(";", ":", ".", "!", "*", "^", "-")

<<<<<<< HEAD
/datum/category_item/player_setup_item/general/language/load_character(var/savefile/S)
	S["language"]			>> pref.alternate_languages
	S["extra_languages"]	>> pref.extra_languages
	if(islist(pref.alternate_languages))			// Because aparently it may not be?
		/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Can't say I like having the english_list there but we shall see? Why does this log every save/load anyway?
		testing("LANGSANI: Loaded from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
		*/
		testing("ЯЗЫКИ: Загружен персонаж [pref.client] ([pref.real_name || "-имя не прогружено-"]): [english_list(pref.alternate_languages || list(), nothing_text = "языков нет")].")
		// End of Bastion of Endeavor Translation
	S["language_prefixes"]	>> pref.language_prefixes
	//CHOMPEdit Begin
	S["species"]			>> pref.species
	//CHOMPEdit End
	//VORE Edit Begin
	S["preflang"]			>> pref.preferred_language
	//VORE Edit End
	S["language_custom_keys"]	>> pref.language_custom_keys

/datum/category_item/player_setup_item/general/language/save_character(var/savefile/S)
	S["language"]			<< pref.alternate_languages
	S["extra_languages"]	<< pref.extra_languages
	if(islist(pref.alternate_languages))			// Because aparently it may not be?
		/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Can't say I like having the english_list there but we shall see?
		testing("LANGSANI: Loaded from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] savefile: [english_list(pref.alternate_languages || list())]")
		*/
		testing("ЯЗЫКИ: Загружен персонаж игрока [pref.client] ([pref.real_name || "имя не прогружено"]): [english_list(pref.alternate_languages || list(), nothing_text = "языков нет")].")
		// End of Bastion of Endeavor Translation
	S["language_prefixes"]	<< pref.language_prefixes
	S["language_custom_keys"]	<< pref.language_custom_keys
	S["preflang"]			<< pref.preferred_language // VOREStation Edit
=======
/datum/category_item/player_setup_item/general/language/load_character(list/save_data)
	pref.alternate_languages	= save_data["language"]
	pref.extra_languages		= save_data["extra_languages"]
	pref.language_prefixes		= save_data["language_prefixes"]
	pref.species				= save_data["species"] //CHOMPAdd
	pref.preferred_language		= save_data["preflang"]
	pref.language_custom_keys	= save_data["language_custom_keys"]

/datum/category_item/player_setup_item/general/language/save_character(list/save_data)
	save_data["language"]				= pref.alternate_languages
	save_data["extra_languages"]		= pref.extra_languages
	save_data["language_prefixes"]		= pref.language_prefixes
	save_data["language_custom_keys"]	= pref.language_custom_keys
	save_data["preflang"]				= pref.preferred_language
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))

/datum/category_item/player_setup_item/general/language/sanitize_character()
	if(!islist(pref.alternate_languages))	pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(!istype(S))
			return
		if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
			/* Bastion of Endeavor Translation
			testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
			*/
			testing("ЯЗЫКИ: Обрезаем список языков персонажа игрока [pref.client] ([pref.real_name || "имя не прогружено"]) из-за чрезмерной длины (было: [pref.alternate_languages.len], макс.: [S.num_alternate_languages])")
			// End of Bastion of Endeavor Translation
			pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length

		// VOREStation Edit Start
		if((!(pref.preferred_language in pref.alternate_languages) && !(pref.preferred_language == LANGUAGE_GALCOM) && !(pref.preferred_language == S.language)) || !pref.preferred_language) // Safety handling for if our preferred language is ever somehow removed from the character's list of langauges, or they don't have one set
			pref.preferred_language = S.language // Reset to default, for safety
		// VOREStation Edit end

		// Sanitize illegal languages
		for(var/language in pref.alternate_languages)
			var/datum/language/L = GLOB.all_languages[language]
			if(!istype(L) || (L.flags & RESTRICTED) || (!(language in S.secondary_langs) && pref.client && !is_lang_whitelisted(pref.client, L)))
				/* Bastion of Endeavor Translation
				testing("LANGSANI: Removed [L?.name || "lang not found"] from [pref.client]'s character [pref.real_name || "-name not yet loaded-"] because it failed allowed checks")
				*/
				testing("ЯЗЫКИ: Удалён [L?.name || "неизвестный язык"] из персонажа игрока [pref.client] ([pref.real_name || "имя не прогружено"]) в связи с провалом проверки.")
				// End of Bastion of Endeavor Translation
				pref.alternate_languages -= language

	if(isnull(pref.language_prefixes) || !pref.language_prefixes.len)
		var/list/prefixes = CONFIG_GET(str_list/language_prefixes) // CHOMPEdit
		pref.language_prefixes = prefixes.Copy() // CHOMPEdit
	for(var/prefix in pref.language_prefixes)
		if(prefix in forbidden_prefixes)
			pref.language_prefixes -= prefix
	if(isnull(pref.language_custom_keys))
		pref.language_custom_keys = list()
	var/datum/species/S = GLOB.all_species[pref.species]
	for(var/key in pref.language_custom_keys)
		if(!pref.language_custom_keys[key])
			pref.language_custom_keys.Remove(key)
		if(!((pref.language_custom_keys[key] == S.language) || (pref.language_custom_keys[key] == S.default_language && S.default_language != S.language) || (pref.language_custom_keys[key] in pref.alternate_languages)))
			pref.language_custom_keys.Remove(key)

/datum/category_item/player_setup_item/general/language/content()
	/* Bastion of Endeavor Translation
	. += "<b>Languages</b><br>"
	*/
	. += "<b>Языки</b><br>"
	// End of Bastion of Endeavor Translation
	var/datum/species/S = GLOB.all_species[pref.species]
	if(pref.alternate_languages.len > (S.num_alternate_languages + pref.extra_languages))
		/* Bastion of Endeavor Translation
		testing("LANGSANI: Truncated [pref.client]'s character [pref.real_name || "-name not yet loaded-"] language list because it was too long (len: [pref.alternate_languages.len], allowed: [S.num_alternate_languages])")
		*/
		testing("ЯЗЫКИ: Обрезаем список языков персонажа игрока [pref.client] ([pref.real_name || "имя не прогружено"]) из-за чрезмерной длины (было: [pref.alternate_languages.len], макс.: [S.num_alternate_languages]).")
		// End of Bastion of Endeavor Translation
		pref.alternate_languages.len = (S.num_alternate_languages + pref.extra_languages) // Truncate to allowed length
	if(S.language)
		/* Bastion of Endeavor Translation
		. += "- [S.language] - <a href='?src=\ref[src];set_custom_key=[S.language]'>Set Custom Key</a><br>"
		*/
		. += "- [S.language] – <a href='?src=\ref[src];set_custom_key=[S.language]'>Назначить клавишу</a><br>"
		// End of Bastion of Endeavor Translation
	if(S.default_language && S.default_language != S.language)
		/* Bastion of Endeavor Translation
		. += "- [S.default_language] - <a href='?src=\ref[src];set_custom_key=[S.default_language]'>Set Custom Key</a><br>"
		*/
		. += "- [S.default_language] – <a href='?src=\ref[src];set_custom_key=[S.default_language]'>Назначить клавишу</a><br>"
		// End of Bastion of Endeavor Translation
	if(S.num_alternate_languages + pref.extra_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				/* Bastion of Endeavor Translation
				. += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a> - <a href='?src=\ref[src];set_custom_key=[lang]'>Set Custom Key</a><br>"
				*/
				. += "- [lang] – <a href='?src=\ref[src];remove_language=[i]'>Удалить</a> – <a href='?src=\ref[src];set_custom_key=[lang]'>Назначить клавишу</a><br>"
				// End of Bastion of Endeavor Translation

		if(pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
			/* Bastion of Endeavor Translation
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([(S.num_alternate_languages + pref.extra_languages) - pref.alternate_languages.len] remaining)<br>"
			*/
			. += "- <a href='?src=\ref[src];add_language=1'>Добавить</a> (осталось ещё [(S.num_alternate_languages + pref.extra_languages) - pref.alternate_languages.len])<br>"
			// End of Bastion of Endeavor Translation
	else
		/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: MOB Localization - add more clarity here
		. += "- [pref.species] cannot choose secondary languages.<br>"
		*/
		. += "- Ваша раса не может владеть вторым языком.<br>"
		// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	. += "<b>Language Keys</b><br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Change</a> <a href='?src=\ref[src];reset_prefix=1'>Reset</a><br>"
	. += "<b>Preferred Language</b> <a href='?src=\ref[src];pref_lang=1'>[pref.preferred_language]</a><br>" // VOREStation Add
	*/
	. += "<b>Клавиши языков</b><br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Изменить</a> <a href='?src=\ref[src];reset_prefix=1'>Сбросить</a><br>"
	. += "<b>Предпочитаемый язык:</b> <a href='?src=\ref[src];pref_lang=1'>[pref.preferred_language]</a><br>" // VOREStation Add
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/general/language/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH
	else if(href_list["add_language"])
		var/datum/species/S = GLOB.all_species[pref.species]
		if(pref.alternate_languages.len >= (S.num_alternate_languages + pref.extra_languages))
			/* Bastion of Endeavor Translation
			tgui_alert_async(user, "You have already selected the maximum number of alternate languages for this species!")
			*/
			tgui_alert_async(user, "У вас уже максимум дополнительных языков!")
			// End of Bastion of Endeavor Translation
		else
			var/list/available_languages = S.secondary_langs.Copy()
			for(var/L in GLOB.all_languages)
				var/datum/language/lang = GLOB.all_languages[L]
				if(!(lang.flags & RESTRICTED) && (is_lang_whitelisted(user, lang)))
					available_languages |= L

			// make sure we don't let them waste slots on the default languages
			available_languages -= S.language
			available_languages -= S.default_language
			available_languages -= pref.alternate_languages

			if(!available_languages.len)
				/* Bastion of Endeavor Translation
				tgui_alert_async(user, "There are no additional languages available to select.")
				*/
				tgui_alert_async(user, "Больше не осталось доступных для выбора языков.")
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				var/new_lang = tgui_input_list(user, "Select an additional language", "Character Generation", available_languages)
				*/
				var/new_lang = tgui_input_list(user, "Выберите дополнительный язык:", "Дополнительные языки", available_languages)
				// End of Bastion of Endeavor Translation
				if(new_lang && pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
					var/datum/language/chosen_lang = GLOB.all_languages[new_lang]
					if(istype(chosen_lang))
						/* Bastion of Endeavor Translation
						var/choice = tgui_alert(user, "[chosen_lang.desc]",chosen_lang.name, list("Take","Cancel")) //ChompEDIT - usr removal
						if(choice != "Cancel" && pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
						*/
						var/choice = tgui_alert(user, "[chosen_lang.desc]",chosen_lang.name, list("Взять","Отмена"))
						if(choice != "Отмена" && pref.alternate_languages.len < (S.num_alternate_languages + pref.extra_languages))
						// End of Bastion of Endeavor Translation
							pref.alternate_languages |= new_lang
					return TOPIC_REFRESH

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			/* Bastion of Endeavor Translation
			char = tgui_input_text(user, "Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining") //ChompEDIT - usr removal
			*/
			char = tgui_input_text(user, "Введите один особый символ. Можно использовать один символ несколько раз. Символы, уже используемые для рации: ; : . Символы, уже используемые для глагола Сказать: ! * ^", "Клавиша языка – осталось ещё [3 - keys.len]")
			// End of Bastion of Endeavor Translation
			if(char)
				/* Bastion of Endeavor Translation
				if(length(char) > 1)
					tgui_alert_async(user, "Only single characters allowed.", "Error")
				*/
				if(length_char(char) > 1)
					tgui_alert_async(user, "Разрешён только один символ.", "Ошибка")
				// End of Bastion of Endeavor Translation
				else if(char in list(";", ":", "."))
					/* Bastion of Endeavor Translation
					tgui_alert_async(user, "Radio character. Rejected.", "Error")
					*/
					tgui_alert_async(user, "Символ уже используется для рации.", "Ошибка")
					// End of Bastion of Endeavor Translation
				else if(char in list("!","*","^","-"))
					/* Bastion of Endeavor Translation
					tgui_alert_async(user, "Say character. Rejected.", "Error")
					*/
					tgui_alert_async(user, "Символ уже используется для глагола Сказать.", "Ошибка")
					// End of Bastion of Endeavor Translation
				else if(contains_az09(char))
					/* Bastion of Endeavor Translation
					tgui_alert_async(user, "Non-special character. Rejected.", "Error")
					*/
					tgui_alert_async(user, "Нельзя использовать буквы алфавита.", "Ошибка")
					// End of Bastion of Endeavor Translation
				else
					keys.Add(char)
		while(char && keys.len < 3)

		if(keys.len == 3)
			pref.language_prefixes = keys
			return TOPIC_REFRESH
	else if(href_list["reset_prefix"])
		var/list/prefixes = CONFIG_GET(str_list/language_prefixes) // CHOMPEdit
		pref.language_prefixes = prefixes.Copy() // CHOMPEdit
		return TOPIC_REFRESH

	else if(href_list["set_custom_key"])
		var/lang = href_list["set_custom_key"]
		if(!(lang in GLOB.all_languages))
			return TOPIC_REFRESH

		var/oldkey = ""
		for(var/key in pref.language_custom_keys)
			if(pref.language_custom_keys[key] == lang)
				oldkey = key
				break

		/* Bastion of Endeavor Translation
		var/char = tgui_input_text(user, "Input a language key for [lang]. Input a single space to reset.", "Language Custom Key", oldkey)
		if(length(char) != 1)
		*/
		var/char = tgui_input_text(user, "Введите клавишу для языка или пробел для сброса.", "[lang] – Клавиша языка", oldkey)
		if(length_char(char) != 1)
		// End of Bastion of Endeavor Translation
			return TOPIC_REFRESH
		else if(char == " ")
			for(var/key in pref.language_custom_keys)
				if(pref.language_custom_keys[key] == lang)
					pref.language_custom_keys -= key
					break
		else if(contains_az09(char))
			if(!(char in pref.language_custom_keys))
				pref.language_custom_keys += char
			pref.language_custom_keys[char] = lang
		else
			/* Bastion of Endeavor Translation
			tgui_alert_async(user, "Improper language key. Rejected.", "Error")
			*/
			tgui_alert_async(user, "Недопустимая клавиша языка.", "Ошибка")
			// End of Bastion of Endeavor Translation

		return TOPIC_REFRESH

	// VOREStation Add: Preferred Language
	else if(href_list["pref_lang"])
		if(pref.species) // Safety to prevent a null runtime here
			var/datum/species/S = GLOB.all_species[pref.species]
			var/list/lang_opts = list(S.language) + pref.alternate_languages + LANGUAGE_GALCOM
			/* Bastion of Endeavor Translation: Removing the alert because it's pointless clutter, nothing in the chargen uses this
			var/selection = tgui_input_list(user, "Choose your preferred spoken language:", "Preferred Spoken Language", lang_opts, pref.preferred_language)
			if(!selection) // Set our preferred to default, just in case.
				tgui_alert_async(user, "Preferred Language not modified.", "Selection Canceled")
			*/
			var/selection = tgui_input_list(user, "Выберите предпочитаемый язык вашего персонажа (по умолчанию – [S.language]):", "Предпочтительный язык", lang_opts, pref.preferred_language)
			// End of Bastion of Endeavor Translation
			if(selection)
				pref.preferred_language = selection
				/* Bastion of Endeavor Removal: Same as above, I don't think we really want this to pop up? It stands out in the whole chargen window when everything else uses refresh
				if(selection == "common" || selection == S.language)
					tgui_alert_async(user, "You will now speak your standard default language, [S.language ? S.language : "common"], if you do not specify a language when speaking.", "Preferred Set to Default")
				else // Did they set anything else?
					tgui_alert_async(user, "You will now speak [pref.preferred_language] if you do not specify a language when speaking.", "Preferred Language Set")
				*/
				// End of Bastion of Endeavor Removal
			return TOPIC_REFRESH
	// VOREStation Add End


	return ..()
