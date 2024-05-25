/client/verb/export_chat()
<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	set category = "OOC"
=======
	set category = "OOC.Chat" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	set name = "Export Chatlog"
	set desc = "Allows to trigger the chat export"
	*/
	set category = "OOC"
	set name = "Сохранить историю чата"
	set desc = "Сохранить текущую историю чата на компьютер."
	// End of Bastion of Endeavor Translation

	tgui_panel.window.send_message("saveToDiskCommand")
