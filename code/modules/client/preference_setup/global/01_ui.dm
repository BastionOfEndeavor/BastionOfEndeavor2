/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(datum/json_savefile/savefile)
	pref.UI_style			= savefile.get_entry("UI_style")
	pref.UI_style_color		= savefile.get_entry("UI_style_color")
	pref.UI_style_alpha		= savefile.get_entry("UI_style_alpha")
	pref.ooccolor			= savefile.get_entry("ooccolor")
	pref.tooltipstyle		= savefile.get_entry("tooltipstyle")
	pref.client_fps			= savefile.get_entry("client_fps")
	pref.ambience_freq		= savefile.get_entry("ambience_freq")
	pref.ambience_chance	= savefile.get_entry("ambience_chance")
	pref.tgui_fancy			= savefile.get_entry("tgui_fancy")
	pref.tgui_lock			= savefile.get_entry("tgui_lock")
	pref.tgui_input_mode	= savefile.get_entry("tgui_input_mode")
	pref.tgui_large_buttons		= savefile.get_entry("tgui_large_buttons")
	pref.tgui_swapped_buttons	= savefile.get_entry("tgui_swapped_buttons")
	pref.obfuscate_key		= savefile.get_entry("obfuscate_key")
	pref.obfuscate_job		= savefile.get_entry("obfuscate_job")
	pref.chat_timestamp		= savefile.get_entry("chat_timestamp")

/datum/category_item/player_setup_item/player_global/ui/save_preferences(datum/json_savefile/savefile)
	savefile.set_entry("UI_style",			pref.UI_style)
	savefile.set_entry("UI_style_color",	pref.UI_style_color)
	savefile.set_entry("UI_style_alpha",	pref.UI_style_alpha)
	savefile.set_entry("ooccolor",			pref.ooccolor)
	savefile.set_entry("tooltipstyle",		pref.tooltipstyle)
	savefile.set_entry("client_fps",		pref.client_fps)
	savefile.set_entry("ambience_freq",		pref.ambience_freq)
	savefile.set_entry("ambience_chance",	pref.ambience_chance)
	savefile.set_entry("tgui_fancy",		pref.tgui_fancy)
	savefile.set_entry("tgui_lock",			pref.tgui_lock)
	savefile.set_entry("tgui_input_mode",	pref.tgui_input_mode)
	savefile.set_entry("tgui_large_buttons",	pref.tgui_large_buttons)
	savefile.set_entry("tgui_swapped_buttons",	pref.tgui_swapped_buttons)
	savefile.set_entry("obfuscate_key",		pref.obfuscate_key)
	savefile.set_entry("obfuscate_job",		pref.obfuscate_job)
	savefile.set_entry("chat_timestamp",	pref.chat_timestamp)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style			= sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color		= sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha		= sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor			= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.tooltipstyle		= sanitize_inlist(pref.tooltipstyle, all_tooltip_styles, initial(pref.tooltipstyle))
	pref.client_fps			= sanitize_integer(pref.client_fps, 0, MAX_CLIENT_FPS, initial(pref.client_fps))
	pref.ambience_freq		= sanitize_integer(pref.ambience_freq, 0, 60, initial(pref.ambience_freq)) // No more than once per hour.
	pref.ambience_chance 	= sanitize_integer(pref.ambience_chance, 0, 100, initial(pref.ambience_chance)) // 0-100 range.
	pref.tgui_fancy			= sanitize_integer(pref.tgui_fancy, 0, 1, initial(pref.tgui_fancy))
	pref.tgui_lock			= sanitize_integer(pref.tgui_lock, 0, 1, initial(pref.tgui_lock))
	pref.tgui_input_mode	= sanitize_integer(pref.tgui_input_mode, 0, 1, initial(pref.tgui_input_mode))
	pref.tgui_large_buttons	= sanitize_integer(pref.tgui_large_buttons, 0, 1, initial(pref.tgui_large_buttons))
	pref.tgui_swapped_buttons	= sanitize_integer(pref.tgui_swapped_buttons, 0, 1, initial(pref.tgui_swapped_buttons))
	pref.obfuscate_key		= sanitize_integer(pref.obfuscate_key, 0, 1, initial(pref.obfuscate_key))
	pref.obfuscate_job		= sanitize_integer(pref.obfuscate_job, 0, 1, initial(pref.obfuscate_job))
	pref.chat_timestamp		= sanitize_integer(pref.chat_timestamp, 0, 1, initial(pref.chat_timestamp))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	/* Bastion of Endeavor Translation
	. = "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Custom UI</b> (recommended for White UI):<br>"
	. += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> [color_square(hex = pref.UI_style_color)] <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	. += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	. += "<b>Tooltip Style:</b> <a href='?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltipstyle]</b></a><br>"
	. += "<b>Client FPS:</b> <a href='?src=\ref[src];select_client_fps=1'><b>[pref.client_fps]</b></a><br>"
	. += "<b>Random Ambience Frequency:</b> <a href='?src=\ref[src];select_ambience_freq=1'><b>[pref.ambience_freq]</b></a><br>"
	. += "<b>Ambience Chance:</b> <a href='?src=\ref[src];select_ambience_chance=1'><b>[pref.ambience_chance]</b></a><br>"
	. += "<b>tgui Window Mode:</b> <a href='?src=\ref[src];tgui_fancy=1'><b>[(pref.tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</b></a><br>"
	. += "<b>tgui Window Placement:</b> <a href='?src=\ref[src];tgui_lock=1'><b>[(pref.tgui_lock) ? "Primary Monitor" : "Free (default)"]</b></a><br>"
	. += "<b>TGUI Input Framework:</b> <a href='?src=\ref[src];tgui_input_mode=1'><b>[(pref.tgui_input_mode) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	. += "<b>TGUI Large Buttons:</b> <a href='?src=\ref[src];tgui_large_buttons=1'><b>[(pref.tgui_large_buttons) ? "Enabled (default)" : "Disabled"]</b></a><br>"
	. += "<b>TGUI Swapped Buttons:</b> <a href='?src=\ref[src];tgui_swapped_buttons=1'><b>[(pref.tgui_swapped_buttons) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	. += "<b>Obfuscate Ckey:</b> <a href='?src=\ref[src];obfuscate_key=1'><b>[(pref.obfuscate_key) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	. += "<b>Obfuscate Job:</b> <a href='?src=\ref[src];obfuscate_job=1'><b>[(pref.obfuscate_job) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	. += "<b>Chat Timestamps:</b> <a href='?src=\ref[src];chat_timestamps=1'><b>[(pref.chat_timestamp) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	if(can_select_ooc_color(user))
		. += "<b>OOC Color:</b>"
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> [color_square(hex = pref.ooccolor)]<a href='?src=\ref[src];reset=ooc'>reset</a><br>"
	*/
	. = "<b>Стиль интерфейса:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Персонализация</b> (рекомендуется использовать Белый стиль):<br>"
	. += "- Цвет: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> [color_square(hex = pref.UI_style_color)] <a href='?src=\ref[src];reset=ui'>Сбросить</a><br>"
	. += "- Альфа (прозрачность): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> <a href='?src=\ref[src];reset=alpha'>Сбросить</a><br>"
	. += "<b>Стиль всплывающих подсказок:</b> <a href='?src=\ref[src];select_tooltip_style=1'><b>[get_key_by_value(all_tooltip_styles_ru, pref.tooltipstyle)]</b></a><br>"
	. += "<b>FPS клиента:</b> <a href='?src=\ref[src];select_client_fps=1'><b>[pref.client_fps]</b></a><br>"
	. += "<b>Частота звуков окружения:</b> <a href='?src=\ref[src];select_ambience_freq=1'><b>[pref.ambience_freq]</b></a><br>"
	. += "<b>Вероятность звуков окружения:</b> <a href='?src=\ref[src];select_ambience_chance=1'><b>[pref.ambience_chance]</b></a><br>"
	. += "<b>Режим окон TGUI:</b> <a href='?src=\ref[src];tgui_fancy=1'><b>[(pref.tgui_fancy) ? "Красивый (по умолчанию)" : "Совместимость (медленнее)"]</b></a><br>"
	. += "<b>Размещение окон TGUI:</b> <a href='?src=\ref[src];tgui_lock=1'><b>[(pref.tgui_lock) ? "Главный монитор" : "Свободное (по умолчанию)"]</b></a><br>"
	. += "<b>Система ввода TGUI:</b> <a href='?src=\ref[src];tgui_input_mode=1'><b>[(pref.tgui_input_mode) ? "Включена (по умолчанию)" : "Выключена"]</b></a><br>" // doesn't match the original string because we flipped the default preference
	. += "<b>Крупные кнопки TGUI:</b> <a href='?src=\ref[src];tgui_large_buttons=1'><b>[(pref.tgui_large_buttons) ? "Включены (по умолчанию)" : "Выключены"]</b></a><br>"
	. += "<b>Смена мест кнопок TGUI:</b> <a href='?src=\ref[src];tgui_swapped_buttons=1'><b>[(pref.tgui_swapped_buttons) ? "Включена" : "Выключена (по умолчанию)"]</b></a><br>"
	. += "<b>Скрывать Ckey в лобби:</b> <a href='?src=\ref[src];obfuscate_key=1'><b>[(pref.obfuscate_key) ? "Включено" : "Отключено (по умолчанию)"]</b></a><br>"
	. += "<b>Скрывать должность в лобби:</b> <a href='?src=\ref[src];obfuscate_job=1'><b>[(pref.obfuscate_job) ? "Включено" : "Отключено (по умолчанию)"]</b></a><br>"
	. += "<b>Отметки времени:</b> <a href='?src=\ref[src];chat_timestamps=1'><b>[(pref.chat_timestamp) ? "Включены" : "Отключены (по умолчанию)"]</b></a><br>"
	if(can_select_ooc_color(user))
		. += "<b>Цвет в чате OOC: </b>"
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>По умолчанию</b></a><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> [color_square(hex = pref.ooccolor)] <a href='?src=\ref[src];reset=ooc'>Сбросить</a><br>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		/* Bastion of Endeavor Translation
		var/UI_style_new = tgui_input_list(user, "Choose UI style.", "Character Preference", all_ui_styles, pref.UI_style)
		*/
		var/UI_style_new = tgui_input_list(user, "Выберите стиль интерфейса. Для персонализации рекомендуется выбрать Белый:", "Стиль интерфейса", all_ui_styles, pref.UI_style)
		// End of Bastion of Endeavor Translation
		if(!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		/* Bastion of Endeavor Translation
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		*/
		var/UI_style_color_new = input(user, "Выберите цвет интерфейса (тёмные цвета не рекомендуются!):", "Цвет интерфейса", pref.UI_style_color) as color|null
		// End of Bastion of Endeavor Translation
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		/* Bastion of Endeavor Translation
		var/UI_style_alpha_new = tgui_input_number(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha, 255, 50)
		*/
		var/UI_style_alpha_new = tgui_input_number(user, "Укажите значение альфа (непрозрачность) интерфейса от 50 до 255:", "Непрозрачность интерфейса", pref.UI_style_alpha, 255, 50)
		// End of Bastion of Endeavor Translation
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		/* Bastion of Endeavor Translation
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		*/
		var/new_ooccolor = input(user, "Укажите цвет своих сообщений в чате OOC:", "Цвет сообщений OOC") as color|null
		// End of Bastion of Endeavor Translation
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_tooltip_style"])
		/* Bastion of Endeavor Translation
		var/tooltip_style_new = tgui_input_list(user, "Choose tooltip style.", "Global Preference", all_tooltip_styles, pref.tooltipstyle)
		if(!tooltip_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.tooltipstyle = tooltip_style_new
		*/
		var/tooltip_style_new = tgui_input_list(user, "Выберите стиль всплывающих подсказок.", "Стиль всплывающих подсказок", all_tooltip_styles_ru, get_key_by_value(all_tooltip_styles_ru, pref.tooltipstyle))
		if(!tooltip_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.tooltipstyle = all_tooltip_styles_ru[tooltip_style_new]
		// End of Bastion of Endeavor Translation
		return TOPIC_REFRESH

	else if(href_list["select_client_fps"])
		/* Bastion of Endeavor Translation
		var/fps_new = tgui_input_number(user, "Input Client FPS (1-200, 0 uses server FPS)", "Global Preference", pref.client_fps, 200, 0)
		*/
		var/fps_new = tgui_input_number(user, "Введите значение FPS (1-200 либо 0 для FPS сервера)", "FPS клиента", pref.client_fps, 200, 0)
		// End of Bastion of Endeavor Translation
		if(isnull(fps_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		if(fps_new < 0 || fps_new > MAX_CLIENT_FPS) return TOPIC_NOACTION
		pref.client_fps = fps_new
		if(pref.client)
			pref.client.fps = fps_new
		return TOPIC_REFRESH

	else if(href_list["select_ambience_freq"])
		/* Bastion of Endeavor Translation
		var/ambience_new = tgui_input_number(user, "Input how often you wish to hear ambience repeated! (1-60 MINUTES, 0 for disabled)", "Global Preference", pref.ambience_freq, 60, 0)
		*/
		var/ambience_new = tgui_input_number(user, "Укажите, насколько часто вы хотели бы слышать звуки окружения (Раз в 1-60 минут либо 0 для отключения)", "Частота звуков окружения", pref.ambience_freq, 60, 0)
		// End of Bastion of Endeavor Translation
		if(isnull(ambience_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		if(ambience_new < 0 || ambience_new > 60) return TOPIC_NOACTION
		pref.ambience_freq = ambience_new
		return TOPIC_REFRESH

	else if(href_list["select_ambience_chance"])
		/* Bastion of Endeavor Translation
		var/ambience_chance_new = tgui_input_number(user, "Input the chance you'd like to hear ambience played to you (On area change, or by random ambience). 35 means a 35% chance to play ambience. This is a range from 0-100. 0 disables ambience playing entirely. This is also affected by Ambience Frequency.", "Global Preference", pref.ambience_freq, 100, 0)
		*/
		var/ambience_chance_new = tgui_input_number(user, "Укажите шанс воспроизведения звуков окружения (при смене помещения или случайно) от 0 до 100. 0 отключает звуки окружения полностью. Эта настройка идёт вкупе с частотой.", "Шанс звуков окружения", pref.ambience_freq, 100, 0)
		// End of Bastion of Endeavor Translation
		if(isnull(ambience_chance_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		if(ambience_chance_new < 0 || ambience_chance_new > 100) return TOPIC_NOACTION
		pref.ambience_chance = ambience_chance_new
		return TOPIC_REFRESH

	else if(href_list["tgui_fancy"])
		pref.tgui_fancy = !pref.tgui_fancy
		return TOPIC_REFRESH

	else if(href_list["tgui_lock"])
		pref.tgui_lock = !pref.tgui_lock
		return TOPIC_REFRESH

	else if(href_list["tgui_input_mode"])
		pref.tgui_input_mode = !pref.tgui_input_mode
		return TOPIC_REFRESH

	else if(href_list["tgui_large_buttons"])
		pref.tgui_large_buttons = !pref.tgui_large_buttons
		return TOPIC_REFRESH

	else if(href_list["tgui_swapped_buttons"])
		pref.tgui_swapped_buttons = !pref.tgui_swapped_buttons
		return TOPIC_REFRESH

	else if(href_list["obfuscate_key"])
		pref.obfuscate_key = !pref.obfuscate_key
		return TOPIC_REFRESH

	else if(href_list["obfuscate_job"])
		pref.obfuscate_job = !pref.obfuscate_job
		return TOPIC_REFRESH

	else if(href_list["chat_timestamps"])
		pref.chat_timestamp = !pref.chat_timestamp
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return CONFIG_GET(flag/allow_admin_ooccolor) && check_rights(R_ADMIN|R_EVENT|R_FUN, 0, user) // CHOMPEdit
