//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

// Clickable stat() button.
/obj/effect/statclick
	/* Bastion of Endeavor Translation
	name = "Initializing..."
	*/
	name = "Инициализация..."
	// End of Bastion of Endeavor Translation
	blocks_emissive = FALSE
	var/target

/obj/effect/statclick/New(loc, text, target) //Don't port this to Initialize it's too critical
	..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			/* Bastion of Endeavor Translation
			class = "subsystem"
			*/
			class = "подсистемы"
			// End of Bastion of Endeavor Translation
		else if(istype(target, /datum/controller))
			/* Bastion of Endeavor Translation
			class = "controller"
			*/
			class = "контроллера"
			// End of Bastion of Endeavor Translation
		else if(istype(target, /datum))
			/* Bastion of Endeavor Translation
			class = "datum"
			*/
			class = "датума"
			// End of Bastion of Endeavor Translation
		else
			/* Bastion of Endeavor Translation
			class = "unknown"
			*/
			class = "неизвестного типа"
			// End of Bastion of Endeavor Translation

	usr.client.debug_variables(target)
	/* Bastion of Endeavor Translation
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")
	*/
	message_admins("[key_name_admin(usr)] проводит отладку [class] [target].")
	// End of Bastion of Endeavor Translation


// Debug verbs.
/* Bastion of Endeavor Translation
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug.Dangerous" //CHOMPEdit
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"
*/
/client/proc/restart_controller(controller in list("Главный", "Проверочный"))
	set category = "Отладка"
	set name = "Перезапустить контроллер"
	set desc = "Перезапустить один из контроллеров цикла игры (будьте осторожны!)."
// End of Bastion of Endeavor Translation

	if(!holder)
		return
	switch(controller)
		/* Bastion of Endeavor Translation
		if("Master")
		*/
		if("Главный")
		// End of Bastion of Endeavor Translation
			Recreate_MC()
			feedback_add_details("admin_verb","RMC")
		/* Bastion of Endeavor Translation
		if("Failsafe")
		*/
		if("Проверочный")
		// End of Bastion of Endeavor Translation
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	/* Bastion of Endeavor Translation
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	*/
	message_admins("[key_name_admin(usr)] перезапустил [controller] контроллер.")
	// End of Bastion of Endeavor Translation

/client/proc/debug_antagonist_template(antag_type in all_antag_types)
<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	set category = "Debug"
=======
	set category = "Debug.Investigate" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."
	*/
	set category = "Отладка"
	set name = "Отладка антагониста"
	set desc = "Провести отладку шаблона антагониста."
	// End of Bastion of Endeavor Translation

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		/* Bastion of Endeavor Translation
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
		*/
		message_admins("[key_name_admin(usr)] проводит отладку шаблона роли [antag.role_text].")
		// End of Bastion of Endeavor Translation

/client/proc/debug_controller()
<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	set category = "Debug"
=======
	set category = "Debug.Investigate" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	set name = "Debug Controller"
	set desc = "Debug the various subsystems/controllers for the game (be careful!)"
	*/
	set category = "Отладка"
	set name = "Отладка контроллера"
	set desc = "Провести отладку подсистем/контроллеров игры (будьте осторожны!)"
	// End of Bastion of Endeavor Translation

	if(!holder)
		return
	var/list/options = list()
	/* Bastion of Endeavor Translation
	options["MC"] = Master
	options["Failsafe"] = Failsafe
	options["Configuration"] = config
	*/
	options["Главный контроллер"] = Master
	options["Проверочный контроллер"] = Failsafe
	options["Конфигурация"] = config
	// End of Bastion of Endeavor Translation
	for(var/datum/controller/subsystem/S as anything in Master.subsystems)
		if(!istype(S))		//Eh, we're a debug verb, let's have typechecking.
			continue
		var/strtype = "SS[get_end_section_of_type(S.type)]"
		if(options[strtype])
			var/offset = 2
			/* Bastion of Endeavor Translation
			while(istype(options["[strtype]_[offset] - DUPE ERROR"], /datum/controller/subsystem))
			*/
			while(istype(options["[strtype]_[offset] - ДУБЛИКАТ"], /datum/controller/subsystem))
			// End of Bastion of Endeavor Translation
				offset++
			/* Bastion of Endeavor Translation
			options["[strtype]_[offset] - DUPE ERROR"] = S		//Something is very, very wrong.
			*/
			options["[strtype]_[offset] - ДУБЛИКАТ"] = S
			// End of Bastion of Endeavor Translation
		else
			options[strtype] = S

	//Goon PS stuff, and other yet-to-be-subsystem things.
	/* Bastion of Endeavor Translation
	options["LEGACY: master_controller"] = master_controller
	options["LEGACY: air_master"] = air_master
	options["LEGACY: job_master"] = job_master
	options["LEGACY: radio_controller"] = radio_controller
	options["LEGACY: emergency_shuttle"] = emergency_shuttle
	options["LEGACY: paiController"] = paiController
	options["LEGACY: cameranet"] = cameranet
	options["LEGACY: transfer_controller"] = transfer_controller
	options["LEGACY: gas_data"] = gas_data

	*/
	options["УСТАРЕВШЕЕ: master_controller"] = master_controller
	options["УСТАРЕВШЕЕ: air_master"] = air_master
	options["УСТАРЕВШЕЕ: job_master"] = job_master
	options["УСТАРЕВШЕЕ: radio_controller"] = radio_controller
	options["УСТАРЕВШЕЕ: emergency_shuttle"] = emergency_shuttle
	options["УСТАРЕВШЕЕ: paiController"] = paiController
	options["УСТАРЕВШЕЕ: cameranet"] = cameranet
	options["УСТАРЕВШЕЕ: transfer_controller"] = transfer_controller
	options["УСТАРЕВШЕЕ: gas_data"] = gas_data
	// End of Bastion of Endeavor Translation
	/* Bastion of Endeavor Translation
	var/pick = input(mob, "Choose a controller to debug/view variables of.", "VV controller:") as null|anything in options // Leaving as input() due to debug tool
	*/
	var/pick = input(mob, "Выберите контроллер, переменные которого вас интересуют.", "ПП контроллера:") as null|anything in options
	// End of Bastion of Endeavor Translation
	if(!pick)
		return
	var/datum/D = options[pick]
	if(!istype(D))
		return
	feedback_add_details("admin_verb", "DebugController")
	/* Bastion of Endeavor Translation
	message_admins("Admin [key_name_admin(mob)] is debugging the [pick] controller.")
	*/
	message_admins("[key_name_admin(mob)] проводит отладку ([capitalize(pick)]).")
	// End of Bastion of Endeavor Translation
	debug_variables(D)
