GLOBAL_LIST_EMPTY(job_whitelist) // CHOMPEdit - Managed Globals

/hook/startup/proc/loadJobWhitelist()
	if(CONFIG_GET(flag/use_jobwhitelist)) // CHOMPedit
		load_jobwhitelist() // CHOMPedit
	return 1

/proc/load_jobwhitelist()
	var/text = file2text("config/jobwhitelist.txt")
	if (!text)
		/* Bastion of Endeavor Translation
		log_misc("Failed to load config/jobwhitelist.txt")
		*/
		log_misc("Не удалось загрузить config/jobwhitelist.txt")
		// End of Bastion of Endeavor Translation
	else
		GLOB.job_whitelist = splittext(text, "\n") // CHOMPEdit - Managed Globals

/proc/is_job_whitelisted(mob/M, var/rank)
	if(!CONFIG_GET(flag/use_jobwhitelist)) // CHOMPedit
		return 1 // CHOMPedit
	var/datum/job/job = job_master.GetJob(rank)
	if(!job.whitelist_only)
		return 1
	if(rank == JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant
		return 1
	if(check_rights(R_ADMIN, 0) || check_rights(R_DEBUG, 0) || check_rights(R_EVENT, 0)) // CHOMPedit
		return 1
	if(!GLOB.job_whitelist) // CHOMPEdit - Managed Globals
		return 0
	if(M && rank)
		for (var/s in GLOB.job_whitelist) // CHOMPEdit - Managed Globals
			/* Bastion of Endeavor Unicode Edit
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
			*/
			if(findtext_char(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
			// End of Bastion of Endeavor Unicode Edit
				return 1
			/* Bastion of Endeavor Translation
			if(findtext(s,"[M.ckey] - All"))
			*/
			if(findtext_char(s,"[M.ckey] - Все"))
			// End of Bastion of Endeavor Translation
				return 1
	return 0

//ChompEDIT START - admin reload buttons
/client/proc/reload_jobwhitelist()
	/* Bastion of Endeavor Translation
	set category = "Server.Config"
	set name = "Reload Job whitelist"
	*/
	set category = "Сервер.Конфигурация"
	set name = "Перезагрузить вайтлист работ"
	// End of Bastion of Endeavor Translation

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	load_jobwhitelist()
	/* Bastion of Endeavor Translation
	log_and_message_admins("reloaded the job whitelist")
	*/
	log_and_message_admins("Вайтлист работ перезагружен.")
	// End of Bastion of Endeavor Translation
//ChompEDIT End
