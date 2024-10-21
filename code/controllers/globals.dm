GLOBAL_REAL(GLOB, /datum/controller/global_vars)

/datum/controller/global_vars
	/* Bastion of Endeavor Translation
	name = "Global Variables"
	*/
	name = "Глобальные переменные"
	// End of Bastion of Endeavor Translation

	var/list/gvars_datum_protected_varlist
	var/list/gvars_datum_in_built_vars
	var/list/gvars_datum_init_order

/datum/controller/global_vars/New()
	if(GLOB)
		/* Bastion of Endeavor Translation
		CRASH("Multiple instances of global variable controller created")
		*/
		CRASH("Создано несколько инстанций контроллера глобальных переменных.")
		// End of Bastion of Endeavor Translation
	GLOB = src

	var/datum/controller/exclude_these = new
	gvars_datum_in_built_vars = exclude_these.vars + list("gvars_datum_protected_varlist", "gvars_datum_in_built_vars", "gvars_datum_init_order")

	/* Bastion of Endeavor Translation
	log_world("[vars.len - gvars_datum_in_built_vars.len] global variables")
	*/
	log_world("[count_ru((vars.len - gvars_datum_in_built_vars.len), ";глобальная переменная;глобальных переменных;глобальных переменных")].")
	// End of Bastion of Endeavor Translation

	Initialize(exclude_these)

/datum/controller/global_vars/Destroy(force)
	/* Bastion of Endeavor Translation
	stack_trace("There was an attempt to qdel the global vars holder!")
	*/
	stack_trace("Попытка qdel'нуть холдер глобальных переменных!")
	// End of Bastion of Endeavor Translation
	if(!force)
		return QDEL_HINT_LETMELIVE

	QDEL_NULL(statclick)
	gvars_datum_protected_varlist.Cut()
	gvars_datum_in_built_vars.Cut()

	GLOB = null

	return ..()

/datum/controller/global_vars/stat_entry(msg)
	if(!statclick)
		/* Bastion of Endeavor Translation
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)
		*/
		statclick = new/obj/effect/statclick/debug(null, "Инициализация...", src)
		// End of Bastion of Endeavor Translation

<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	msg = "GLOB: [statclick.update("Edit")]" //CHOMPEdit
	*/
	msg = "[statclick.update("Редактировать")]" //CHOMPEdit
	// End of Bastion of Endeavor Translation
	return msg //CHOMPEdit
=======
	msg = "GLOB: [statclick.update("Edit")]"
	return msg
>>>>>>> 4d9879937f ([MIRROR] Port tg statpanel (#9242))

/datum/controller/global_vars/vv_edit_var(var_name, var_value)
	if(gvars_datum_protected_varlist[var_name])
		return FALSE
	return ..()

/datum/controller/global_vars/Initialize()
	gvars_datum_init_order = list()
	gvars_datum_protected_varlist = list(NAMEOF(src, gvars_datum_protected_varlist) = TRUE)
	var/list/global_procs = typesof(/datum/controller/global_vars/proc)
	var/expected_len = vars.len - gvars_datum_in_built_vars.len
	if(global_procs.len != expected_len)
		/* Bastion of Endeavor Translation
		warning("Unable to detect all global initialization procs! Expected [expected_len] got [global_procs.len]!")
		*/
		warning("Не удалось обнаружить все проки глобальной инициализации! Ожидалось [expected_len], получено [global_procs.len]!")
		// End of Bastion of Endeavor Translation
		if(global_procs.len)
			var/list/expected_global_procs = vars - gvars_datum_in_built_vars
			for(var/I in global_procs)
				/* Bastion of Endeavor Unicode Edit: Unsure about this, but whatever.
				expected_global_procs -= replacetext("[I]", "InitGlobal", "")
				*/
				expected_global_procs -= replacetext_char("[I]", "InitGlobal", "")
				// End of Bastion of Endeavor Unicode Edit
			var/english_missing = expected_global_procs.Join(", ")
			/* Bastion of Endeavor Translation
			log_world("Missing procs: [english_missing]")
			*/
			log_world("Недостающие проки: [english_missing]")
			// End of Bastion of Endeavor Translation
	for(var/I in global_procs)
		var/start_tick = world.time
		call(src, I)()
		var/end_tick = world.time
		if(end_tick - start_tick)
			/* Bastion of Endeavor Translation
			warning("Global [replacetext("[I]", "InitGlobal", "")] slept during initialization!")
			*/
			warning("Глобальная переменная [replacetext_char("[I]", "InitGlobal", "")] спала во время инициализации!")
			// End of Bastion of Endeavor Translation
	// Bastion of Endeavor Addition: A bit annoying to have to put it here but this must run before anything loads
	populate_case_repository_ru()
	// End of Bastion Of Endeavor Addition.

	//populate_legacy_globals()
