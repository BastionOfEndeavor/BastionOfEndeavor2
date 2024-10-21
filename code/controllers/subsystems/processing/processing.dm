//Used to process objects. Fires once every second.

SUBSYSTEM_DEF(processing)
	/* Bastion of Endeavor Translation
	name = "Processing"
	*/
	name = "Обработка"
	// End of Bastion of Endeavor Translation
	priority = FIRE_PRIORITY_PROCESS
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 10

	/* Bastion of Endeavor Translation
	var/stat_tag = "P" //Used for logging
	*/
	var/stat_tag = "| Обрабатывается"
	// End of Bastion of Endeavor Translation
	var/list/processing = list()
	var/list/currentrun = list()
	var/process_proc = /datum/proc/process

	var/debug_last_thing
	var/debug_original_process_proc // initial() does not work with procs
	var/datum/current_thing

/datum/controller/subsystem/processing/Recover()
	/* Bastion of Endeavor Translation
	log_debug("[name] subsystem Recover().")
	*/
	log_debug("Вызван Recover() подсистемы '[name]'.")
	// End of Bastion of Endeavor Translation
	if(SSprocessing.current_thing)
		/* Bastion of Endeavor Translation
		log_debug("current_thing was: (\ref[SSprocessing.current_thing])[SSprocessing.current_thing]([SSprocessing.current_thing.type]) - currentrun: [SSprocessing.currentrun.len] vs total: [SSprocessing.processing.len]")
		*/
		log_debug("current_thing было: (\ref[SSprocessing.current_thing])[SSprocessing.current_thing]([SSprocessing.current_thing.type]) - currentrun: [SSprocessing.currentrun.len] при [SSprocessing.processing.len] в общей сложности.")
		// End of Bastion of Endeavor Translation
	var/list/old_processing = SSprocessing.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D

/datum/controller/subsystem/processing/stat_entry(msg)
	/* Bastion of Endeavor Translation: Yeah
	msg = "[stat_tag]:[processing.len]"
	*/
	msg = "[stat_tag]: [processing.len]"
	// End of Bastion of Endeavor Translation
	return ..()

/datum/controller/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		current_thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(current_thing))
			processing -= current_thing
		else if(current_thing.process(wait) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, current_thing)
		if (MC_TICK_CHECK)
			current_thing = null
			return

	current_thing = null

/datum/controller/subsystem/processing/proc/toggle_debug()
	if(!check_rights(R_DEBUG))
		return

	if(debug_original_process_proc)
		process_proc = debug_original_process_proc
		debug_original_process_proc = null
	else
		debug_original_process_proc	= process_proc
		process_proc = /datum/proc/DebugSubsystemProcess

	/* Bastion of Endeavor Translation
	to_chat(usr, "[name] - Debug mode [debug_original_process_proc ? "en" : "dis"]abled")
	*/
	to_chat(usr, "[name] - Режим отладки [debug_original_process_proc ? "включён" : "выключен"].")
	// End of Bastion of Endeavor Translation

/datum/controller/subsystem/processing/proc/log_recent()
	/* Bastion of Endeavor Translation
	var/msg = "Debug output from the [name] subsystem:\n"
	msg += "- Process subsystems are processed tail-first -\n"
	*/
	var/msg = "Результаты отладки подсистемы '[name]':\n"
	msg += "- Обрабатывающие подсистемы начинаются с хвоста -\n"
	// End of Bastion of Endeavor Translation
	if(!currentrun || !processing)
		/* Bastion of Endeavor Translation
		msg += "ERROR: A critical list [currentrun ? "processing" : "currentrun"] is gone!"
		*/
		msg += "ОШИБКА: Пропал критически важный список [currentrun ? "processing" : "currentrun"]!"
		// End of Bastion of Endeavor Translation
		log_game(msg)
		log_world(msg)
		return
	/* Bastion of Endeavor Translation
	msg += "Lists: current_run: [currentrun.len], processing: [processing.len]\n"
	*/
	msg += "Списки: current_run: [currentrun.len], processing: [processing.len]\n"
	// End of Bastion of Endeavor Translation

	if(!currentrun.len)
		/* Bastion of Endeavor Translation
		msg += "!!The subsystem just finished the processing list, and currentrun is empty (or has never run).\n"
		msg += "!!The info below is the tail of processing instead of currentrun.\n"
		*/
		msg += "!!Подсистема только что завершила список processing, и currentrun пуст (либо не запускался).\n"
		msg += "!!Информация внизу – хвост списка processing вместо currentrun.\n"
		// End of Bastion of Endeavor Translation

	var/datum/D = currentrun.len ? currentrun[currentrun.len] : processing[processing.len]
	/* Bastion of Endeavor Translation
	msg += "Tail entry: [describeThis(D)] (this is likely the item AFTER the problem item)\n"
	*/
	msg += "Запись хвоста: [describeThis(D)] (вероятнее всего, это предмет ПОСЛЕ проблемного)\n"
	// End of Bastion of Endeavor Translation

	var/position = processing.Find(D)
	if(!position)
		/* Bastion of Endeavor Translation
		msg += "Unable to find context of tail entry in processing list.\n"
		*/
		msg += "Не удалось найти контекст к записи хвоста в списке processing.\n"
		// End of Bastion of Endeavor Translation
	else
		if(position != processing.len)
			var/additional = processing.Find(D, position+1)
			if(additional)
				/* Bastion of Endeavor Translation
				msg += "WARNING: Tail entry found more than once in processing list! Context is for the first found.\n"
				*/
				msg += "ВНИМАНИЕ: Запись хвоста найдена в списке processing больше одного раза! Контекст принадлежит первой найденной.\n"
				// End of Bastion of Endeavor Translation
		var/start = clamp(position-2,1,processing.len)
		var/end = clamp(position+2,1,processing.len)
		/* Bastion of Endeavor Translation
		msg += "2 previous elements, then tail, then 2 next elements of processing list for context:\n"
		*/
		msg += "2 предыдущих элемента, хвост и 2 следующих элемента списка processing для контекста:\n"
		// End of Bastion of Endeavor Translation
		msg += "---\n"
		for(var/i in start to end)
			/* Bastion of Endeavor Translation
			msg += "[describeThis(processing[i])][i == position ? " << TAIL" : ""]\n"
			*/
			msg += "[describeThis(processing[i])][i == position ? " << ХВОСТ" : ""]\n"
			// End of Bastion of Endeavor Translation
		msg += "---\n"
	log_game(msg)
	log_world(msg)

/datum/controller/subsystem/processing/fail()
	..()
	log_recent()

/datum/controller/subsystem/processing/critfail()
	..()
	log_recent()

/datum/proc/DebugSubsystemProcess(var/wait, var/times_fired, var/datum/controller/subsystem/processing/subsystem)
	subsystem.debug_last_thing = src
	var/start_tick = world.time
	var/start_tick_usage = world.tick_usage
	. = call(src, subsystem.debug_original_process_proc)(wait, times_fired)

	var/tick_time = world.time - start_tick
	var/tick_use_limit = world.tick_usage - start_tick_usage - 100 // Current tick use - starting tick use - 100% (a full tick excess)
	if(tick_time > 0)
		/* Bastion of Endeavor Translation
		stack_trace("[log_info_line(subsystem.debug_last_thing)] slept during processing. Spent [tick_time] tick\s.")
		*/
		stack_trace("[log_info_line(subsystem.debug_last_thing)] [verb_ru(subsystem.debug_last_thing, "спал")] во время обработки. [count_ru(tick_time, "Затрачен;;о;о", TRUE)] [count_ru(tick_time, "тик;;а;ов")].")
		// End of Bastion of Endeavor Translation
	if(tick_use_limit > 0)
		/* Bastion of Endeavor Translation
		stack_trace("[log_info_line(subsystem.debug_last_thing)] took longer than a tick to process. Exceeded with [tick_use_limit]%")
		*/
		stack_trace("[log_info_line(subsystem.debug_last_thing)] занял(-а) больше тика на обработку. Время превышено на [tick_use_limit]%.")
		// End of Bastion of Endeavor Translation

/datum/proc/process()
	set waitfor = 0
	return PROCESS_KILL
