//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	/* Bastion of Endeavor Translation
	set name = "wiki"
	set desc = "Type what you want to know about.  This will open the wiki on your web browser."
	set category = "OOC.Resources" //CHOMPEdit
	*/
	set name = "Вики сервера"
	set desc = "Ввести интересующую тему, чтобы открыть результаты поиска на вики в браузере."
	set category = "OOC.Информация"
	// End of Bastion of Endeavor Translation
	if(CONFIG_GET(string/wikiurl)) // CHOMPEdit
		if(query)
			if(CONFIG_GET(string/wikisearchurl)) // CHOMPEdit
				/* Bastion of Endeavor Unicode Edit
				var/output = replacetext(CONFIG_GET(string/wikisearchurl), "%s", url_encode(query)) // CHOMPEdit
				*/
				var/output = replacetext_char(CONFIG_GET(string/wikisearchurl), "%s", url_encode(query)) // CHOMPEdit
				// End of Bastion of Endeavor Unicode Edit
				src << link(output)
			else
				/* Bastion of Endeavor Translation
				to_chat(src, "<span class='warning'> The wiki search URL is not set in the server configuration.</span>")
				*/
				to_chat(src, "<span class='warning'>URL вики не задан в конфигурации сервера.</span>")
				// End of Bastion of Endeavor Translation
		else
			src << link(CONFIG_GET(string/wikiurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='warning'>The wiki URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>URL вики не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
		return

/client/verb/forum()
	/* Bastion of Endeavor Translation
	set name = "forum"
	set desc = "Visit the forum."
	*/
	set name = "Форум сервера"
	set desc = "Посетить форум сервера."
	// End of Bastion of Endeavor Translation
	set hidden = 1
	if(CONFIG_GET(string/forumurl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the forum in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть форум сервера в браузере. Продолжить?","Форум сервера",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/forumurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='warning'>The forum URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>URL форума не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
		return

/client/verb/rules()
	/* Bastion of Endeavor Translation
	set name = "Rules"
	set desc = "Show Server Rules."
	*/
	set name = "Правила сервера"
	set desc = "Показать правила сервера."
	// End of Bastion of Endeavor Translation
	set hidden = 1

	if(CONFIG_GET(string/rulesurl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the rules in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть правила сервера в браузере. Продолжить?","Правила сервера",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/rulesurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>URL правил сервера не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
	return

/client/verb/map()
	/* Bastion of Endeavor Translation
	set name = "Map"
	set desc = "See the map."
	*/
	set name = "Карта станции"
	set desc = "Показать карту станции."
	// End of Bastion of Endeavor Translation
	set hidden = 1

	if(CONFIG_GET(string/mapurl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the map in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть карту станции в браузере. Продолжить?","Карта станции",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/mapurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='danger'>The map URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>URL карты станции не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
	return

/client/verb/github()
	/* Bastion of Endeavor Translation
	set name = "GitHub"
	set desc = "Visit the GitHub"
	*/
	set name = "GitHub сервера"
	set desc = "Посетить GitHub сервера."
	// End of Bastion of Endeavor Translation
	set hidden = 1

	if(CONFIG_GET(string/githuburl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the GitHub in your browser. Are you sure?","Visit Website",list("Yes","No"))!="Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть GitHub сервера в браузере. Продолжить?","GitHub сервера",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/githuburl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='danger'>The GitHub URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>GitHub сервера не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
	return

/client/verb/discord()
	/* Bastion of Endeavor Translation
	set name = "Discord"
	set desc = "Visit the discord"
	*/
	set name = "Discord сервера"
	set desc = "Посетить Discord сервера."
	// End of Bastion of Endeavor Translation
	set hidden = 1

	if(CONFIG_GET(string/discordurl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the Discord in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть Discord сервера в браузере. Продолжить?","Discord сервера",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/discordurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='danger'>The Discord URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>Discord сервера не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
	return

/client/verb/patreon()
	/* Bastion of Endeavor Translation
	set name = "Patreon"
	set desc = "Visit the patreon"
	*/
	set name = "Patreon сервера"
	set desc = "Посетить Patreon сервера."
	// End of Bastion of Endeavor Translation
	set hidden = 1

	if(CONFIG_GET(string/patreonurl)) // CHOMPEdit
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "This will open the Patreon in your browser. Are you sure?","Visit Website",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "Вы собираетесь открыть Patreon сервера в браузере. Продолжить?","Patreon сервера",list("Да","Нет")) != "Yes")
		// End of Bastion of Endeavor Translation
			return
		src << link(CONFIG_GET(string/patreonurl)) // CHOMPEdit
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='danger'>The Patreon URL is not set in the server configuration.</span>")
		*/
		to_chat(src, "<span class='warning'>Patreon сервера не задан в конфигурации сервера.</span>")
		// End of Bastion of Endeavor Translation
	return

/client/verb/hotkeys_help()
	/* Bastion of Endeavor Translation
	set name = "hotkeys-help"
	set category = "OOC.Resources" //CHOMPEdit
	*/
	set name = "Показать управление"
	set category = "OOC.Информация"
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/admin = {"<font color='AD5AAD'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}
	*/
	var/admin = {"<font color='AD5AAD'>
Администрация:
\tF5 = Режим админ-призрака
\tF6 = Панель игрока
\tF7 = Личное сообщение игроку
\tF8 = Режим невидимого призрака
</font>"}
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/hotkey_mode = {"<font color='AD5AAD'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tz = activate held object (or y)
\tu = Rest
\tb = Resist
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}
	*/
	var/hotkey_mode = {"<font color='AD5AAD'>
Режим горячих клавиш (при включённых горячих клавишах):
\tTAB = Включение режима хоткеев (при запуске на английской раскладке)
\tA = Влево
\tS = Вниз
\tD = Вправо
\tW = Вверх
\tQ = Отпустить предмет
\tE = Надеть на себя
\tR = Метнуть предмет
\tT = Сказать
\tY = Шептать
\t5 = Действие
\t6 = Скрытое действие
\tX = Сменить руку
\tZ = Использовать предмет в руке (или Y)
\tU = Лечь / Встать
\tB = Сопротивляться
\tJ = Переключить режим прицеливания
\tF = Листать намерения влево
\tG = Листать намерения вправо
\t1 = Намерение 'Помочь'
\t2 = Намерение 'Обезвредить'
\t3 = Намерение 'Схватить'
\t4 = Намерение 'Навредить'
\tCtrl+ЛКМ = Потянуть
\tShift+ЛКМ = Осмотреть
\tCtrl+Shift+Стрелки = Сдвинуть персонажа на пиксель
</font>"}
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/other = {"<font color='AD5AAD'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+u = Rest
\tCtrl+b = Resist
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}
	*/
	var/other = {"<font color='AD5AAD'>
Любой режим (горячие клавиши не обязательны):
\tCtrl+A = Влево
\tCtrl+S = Вниз
\tCtrl+D = Вправо
\tCtrl+W = Вверх
\tCtrl+Q = Отпустить предмет
\tCtrl+E = Надеть на себя
\tCtrl+R = Метнуть предмет
\tCtrl+U = Лечь / Встать
\tCtrl+B = Сопротивляться
\tCtrl+X = Поменять руку
\tCtrl+Z = Использовать предмет в руке (или Ctrl+Y)
\tCtrl+F = Листать намерения влево
\tCtrl+G = Листать намерения вправо
\tCtrl+1 = Намерение 'Помочь'
\tCtrl+2 = Намерение 'Обезвредить'
\tCtrl+3 = Намерение 'Схватить'
\tCtrl+4 = Намерение 'Навредить'
\tF1 = Помощь Администатора
\tF2 = Чат ООС
\tF3 = Сказать
\tF4 = Действие
\tDELETE = Перестать тянуть
\tINSERT = Листать намерения вправо
\tHOME = Бросить
\tPAGE UP = Поменять руку
\tPAGE DOWNN = Использовать предмет в руке
\tEND = Кинуть
</font>"}
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/robot_hotkey_mode = {"<font color='AD5AAD'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module 1
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
\tCtrl+Click = pull
\tShift+Click = examine
</font>"}
	*/
	var/robot_hotkey_mode = {"<font color='AD5AAD'>
Режим горячих клавиш (при включённых горячих клавишах):
\tTAB = Включение режима горячих клавиш (при запуске на английской раскладке)
\tA = Влево
\tS = Вниз
\tD = Вправо
\tW = Вверх
\tQ = Убрать активный модуль
\tT = Сказать
\tY = Шептать
\tX = Сменить активный модуль
\tZ = Использовать предмет в руке (или Y)
\tF = Листать намерения влево
\tG = Листать намерения вправо
\t1 = Включить модуль 1
\t2 = Включить модуль 2
\t3 = Включить модуль 3
\t4 = Сменить намерение
\t5 = Действие
\t6 = Скрытое действие
\tCtrl+ЛКМ = Потянуть
\tShift+ЛКМ = Осмотреть
</font>"}
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	var/robot_other = {"<font color='AD5AAD'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = stop pulling
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}
	*/
	var/robot_other = {"<font color='AD5AAD'>
Любой режим (горячие клавиши не обязательны):
\tCtrl+A = Влево
\tCtrl+S = Вниз
\tCtrl+D = Вправо
\tCtrl+W = Вверх
\tCtrl+Q = Убрать активный модуль
\tCtrl+X = Сменить активный модуль
\tCtrl+Z = Использовать предмет в руке (или Ctrl+Y)
\tCtrl+F = Листать намерения влево
\tCtrl+G = Листать намерения вправо
\tCtrl+1 = Включить модуль 1
\tCtrl+2 = Включить модуль 2
\tCtrl+3 = Включить модуль 3
\tCtrl+4 = Сменить намерение
\tF1 = Помощь Админа
\tF2 = Чат ООС
\tF3 = Сказать
\tF4 = Эмоут
\tDELETE = Перестать тянуть
\tINSERT = Сменить намерение
\tPAGE UP = Сменить активный модуль
\tPAGE DOWN = Использовать предмет в руке
</font>"}
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Edit: Filters
	if(isrobot(src.mob))
		to_chat(src,robot_hotkey_mode)
		to_chat(src,robot_other)
	else
		to_chat(src,hotkey_mode)
		to_chat(src,other)
	if(holder)
		to_chat(src,admin)
	*/
	if(isrobot(src.mob))
	
		to_chat(src,"<span class='chatexport'>[robot_hotkey_mode]</span>")
		to_chat(src,"<span class='chatexport'>[robot_other]</span>")
	else
		to_chat(src,"<span class='chatexport'>[hotkey_mode]</span>")
		to_chat(src,"<span class='chatexport'>[other]</span>")
	if(holder)
		to_chat(src,"<span class='chatexport'>[admin]</span>")
	// End of Bastion of Endeavor Edit

// Set the DreamSeeker input macro to the type appropriate for its mob
/client/proc/set_hotkeys_macro(macro_name = "macro", hotkey_macro_name = "hotkeymode", hotkeys_enabled = null)
	// If hotkeys mode was not specified, fall back to choice of default in client preferences.
	if(isnull(hotkeys_enabled))
		hotkeys_enabled = prefs?.read_preference(/datum/preference/toggle/hotkeys_default)

	if(hotkeys_enabled)
		winset(src, null, "mainwindow.macro=[hotkey_macro_name] hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=[macro_name] hotkey_toggle.is-checked=false input.focus=true")
