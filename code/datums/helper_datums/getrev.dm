//GLOBAL_DATUM(revdata, /datum/getrev) // CHOMPEdit

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo
	var/list/testmerge = list()

/datum/getrev/New()
	if(world.TgsAvailable()) // Try TGS maybe
		testmerge = world.TgsTestMerges()
		var/datum/tgs_revision_information/REV = world.TgsRevision()
		if(REV)
			revision = REV.origin_commit || REV.commit
			/* Bastion of Endeavor Translation
			branch = "-Using TGS-" // TGS doesn't provide branch info yet
			date = "-Using TGS-" // Or date
			*/
			branch = "-Используется TGS-" // TGS doesn't provide branch info yet
			date = "-Используется TGS-" // Or date
			// End of Bastion of Endeavor Translation

	if(!revision) // File parse method
		var/list/head_branch = file2list(".git/HEAD", "\n")
		if(head_branch.len)
			branch = copytext(head_branch[1], 17)

		var/list/head_log = file2list(".git/logs/HEAD", "\n")
		for(var/line=head_log.len, line>=1, line--)
			if(head_log[line])
				var/list/last_entry = splittext(head_log[line], " ")
				if(last_entry.len < 2)	continue
				revision = last_entry[2]
				// Get date/time
				if(last_entry.len >= 5)
					var/unix_time = text2num(last_entry[5])
					if(unix_time)
						date = unix2date(unix_time)
				break

	/* Bastion of Endeavor Translation
	to_world_log("-Revision Info-")
	to_world_log("Branch: [branch]")
	to_world_log("Date: [date]")
	to_world_log("Revision: [revision]")
	*/
	to_world_log("-Информация о ревизии-")
	to_world_log("Ветвь: [branch]")
	to_world_log("Дата: [date]")
	to_world_log("Коммит: [revision]")
	// End of Bastion of Endeavor Translation

/datum/getrev/proc/GetTestMergeInfo(header = TRUE)
	. = list()
	if(!testmerge.len)
		return
	if(header)
		/* Bastion of Endeavor Translation
		. += "The following pull requests are currently test merged:"
		*/
		. += "Следующие пулл-реквесты замержены в тестовом режиме:"
		// End of Bastion of Endeavor Translation
	for(var/datum/tgs_revision_information/test_merge/tm as anything in testmerge)
		var/cm = tm.head_commit		//CHOMPStation Edit TGS4
		/* Bastion of Endeavor Translation
		var/details = ": '" + html_encode(tm.title) + "' by " + html_encode(tm.author) + " at commit " + html_encode(copytext_char(cm, 1, 11))
		*/
		var/details = ": '" + html_encode(tm.title) + "' от " + html_encode(tm.author) + " в коммите " + html_encode(copytext_char(cm, 1, 11))
		// End of Bastion of Endeavor Translation
		if(details && findtext(details, "\[s\]") && (!usr || !usr.client.holder))
			continue
		. += "<a href=\"[CONFIG_GET(string/githuburl)]/pull/[tm.number]\">#[tm.number][details]</a>" // CHOMPEdit

/client/verb/showrevinfo()
<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	set category = "OOC"
=======
	set category = "OOC.Game" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"
	*/
	set category = "OOC"
	set name = "Версия сервера"
	set desc = "Проверить актуальную ревизию сервера"
	// End of Bastion of Endeavor Translation

	if(!GLOB.revdata)
		/* Bastion of Endeavor Translation
		to_chat(src, "<span class='warning'>Please wait until server initializations are complete.</span>")
		*/
		to_chat(src, "<span class='warning'>Пожалуйста, сперва дождитесь окончания инициализации.</span>")
		// End of Bastion of Endeavor Translation
		return

	var/list/msg = list()

	if(GLOB.revdata.revision)
		/* Bastion of Endeavor Translation
		msg += "<b>Server revision:</b> B:[GLOB.revdata.branch] D:[GLOB.revdata.date]"
		if(CONFIG_GET(string/githuburl)) // CHOMPEdit
			msg += "<b>Commit:</b> <a href='[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.revision]'>[GLOB.revdata.revision]</a>" // CHOMPEdit
		else
			msg += "<b>Commit:</b> [GLOB.revdata.revision]" // CHOMPEdit - Actually SHOW the revision
		*/
		msg += "<b>Ревизия сервера:</b> Ветвь:[GLOB.revdata.branch] Дата:[GLOB.revdata.date]"
		if(CONFIG_GET(string/githuburl)) // CHOMPEdit
			msg += "<b>Коммит:</b> <a href='[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.revision]'>[GLOB.revdata.revision]</a>" // CHOMPEdit
		else
			msg += "<b>Коммит:</b> [GLOB.revdata.revision]" // CHOMPEdit - Actually SHOW the revision
		// End of Bastion of Endeavor Translation
	else
		/* Bastion of Endeavor Translation
		msg += "<b>Server revision:</b> Unknown"
		*/
		msg += "<b>Ревизия сервера:</b> Неизвестна"
		// End of Bastion of Endeavor Translation

	if(world.TgsAvailable())
		var/datum/tgs_version/version = world.TgsVersion()
		/* Bastion of Endeavor Translation
		msg += "<b>TGS version:</b> [version.raw_parameter]"
		*/
		msg += "<b>Версия TGS:</b> [version.raw_parameter]"
		// End of Bastion of Endeavor Translation
		var/datum/tgs_version/api_version = world.TgsApiVersion()
		/* Bastion of Endeavor Translation
		msg += "<b>DMAPI version:</b> [api_version.raw_parameter]"
		*/
		msg += "<b>Версия DMAPI:</b> [api_version.raw_parameter]"
		// End of Bastion of Endeavor Translation

	if(GLOB.revdata.testmerge.len)
		msg += GLOB.revdata.GetTestMergeInfo()

	to_chat(src, msg.Join("<br>"))
