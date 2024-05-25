/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/client/var/datum/tgui_panel/tgui_panel

/**
 * tgui panel / chat troubleshooting verb
 */
/client/verb/fix_tgui_panel()
	/* Bastion of Endeavor Translation
	set name = "Fix chat"
<<<<<<< HEAD
	*/
	set name = "Починить чат"
	// End of Bastion of Endeavor Translation
	set category = "OOC"
=======
	set category = "OOC.Debug" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	var/action
	/* Bastion of Endeavor Translation
	log_tgui(src, "Started fixing.", context = "verb/fix_tgui_panel")
	*/
	log_tgui(src, "Начинаем починку.", context = "verb/fix_tgui_panel")
	// End of Bastion of Endeavor Translation

	nuke_chat()

	// Failed to fix, using tgalert as fallback
	/* Bastion of Endeavor Translation
	action = tgalert(src, "Did that work?", "", "Yes", "No, switch to old ui")
	if (action == "No, switch to old ui")
	*/
	action = tgalert(src, "Чат отображается?", "", "Да", "Нет, отключить TGChat")
	if (action == "Нет, отключить TGChat")
	// End of Bastion of Endeavor Translation
		winset(src, "output", "on-show=&is-disabled=0&is-visible=1")
		winset(src, "browseroutput", "is-disabled=1;is-visible=0")
		/* Bastion of Endeavor Translation
		log_tgui(src, "Failed to fix.", context = "verb/fix_tgui_panel")
		*/
		log_tgui(src, "Не удалось починить.", context = "verb/fix_tgui_panel")
		// End of Bastion of Endeavor Translation

/client/proc/nuke_chat()
	// Catch all solution (kick the whole thing in the pants)
	winset(src, "output", "on-show=&is-disabled=0&is-visible=1")
	winset(src, "browseroutput", "is-disabled=1;is-visible=0")
	if(!tgui_panel || !istype(tgui_panel))
		/* Bastion of Endeavor Translation
		log_tgui(src, "tgui_panel datum is missing",
		*/
		log_tgui(src, "Пропал датум tgui_panel.",
		// End of Bastion of Endeavor Translation
			context = "verb/fix_tgui_panel")
		tgui_panel = new(src)
	tgui_panel.initialize(force = TRUE)
	// Force show the panel to see if there are any errors
	winset(src, "output", "is-disabled=1&is-visible=0")
	winset(src, "browseroutput", "is-disabled=0;is-visible=1")

/client/verb/refresh_tgui()
	/* Bastion of Endeavor Translation
	set name = "Refresh TGUI"
<<<<<<< HEAD
	set category = "OOC"
	*/
	set name = "Обновить окна TGUI"
	set category = "OOC"
	// End of Bastion of Endeavor Translation
=======
	set category = "OOC.Debug" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))

	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()
