//
// Mobs Subsystem - Process mob.Life()
//

//VOREStation Edits - Contains temporary debugging code to diagnose extreme tick consumption.
//Revert file to Polaris version when done.

SUBSYSTEM_DEF(mobs)
	/* Bastion of Endeavor Translation
	name = "Mobs"
	*/
	name = "Существа"
	// End of Bastion of Endeavor Translation
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()

	var/slept_mobs = 0
	var/list/process_z = list()

/datum/controller/subsystem/mobs/stat_entry(msg)
	/* Bastion of Endeavor Translation
	msg = "P: [global.mob_list.len] | S: [slept_mobs]"
	*/
	msg = "| Существ: [global.mob_list.len] | Спит: [slept_mobs]"
	// End of Bastion of Endeavor Translation
	return ..()

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		src.currentrun = mob_list.Copy()
		process_z.len = GLOB.living_players_by_zlevel.len
		slept_mobs = 0
		for(var/level in 1 to process_z.len)
			process_z[level] = GLOB.living_players_by_zlevel[level].len

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(!M || QDELETED(M))
			mob_list -= M
			continue
		else if(M.low_priority && !(M.loc && get_z(M) && process_z[get_z(M)]))
			slept_mobs++
			continue
		//CHOMPEdit Start - Enable pausing mobs (For transformation, holding until reformation, etc.)
		else if(!M.enabled)
			slept_mobs++
			continue
		//CHOMPEdit End

		M.Life(times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/mobs/proc/log_recent()
	/* Bastion of Endeavor Translation
	var/msg = "Debug output from the [name] subsystem:\n"
	msg += "- This subsystem is processed tail-first -\n"
	*/
	var/msg = "Результаты отладки подсистемы '[name]':\n"
	msg += "- Эта подсистема обрабатывается с хвоста -\n"
	// End of Bastion of Endeavor Translation
	if(!currentrun || !mob_list)
		/* Bastion of Endeavor Translation
		msg += "ERROR: A critical list [currentrun ? "mob_list" : "currentrun"] is gone!"
		*/
		msg += "ОШИБКА: Пропал критически важный список [currentrun ? "mob_list" : "currentrun"]!"
		// End of Bastion of Endeavor Translation
		log_game(msg)
		log_world(msg)
		return
	/* Bastion of Endeavor Translation
	msg += "Lists: currentrun: [currentrun.len], mob_list: [mob_list.len]\n"
	*/
	msg += "Списки: currentrun: [currentrun.len], mob_list: [mob_list.len]\n"
	// End of Bastion of Endeavor Translation

	if(!currentrun.len)
		/* Bastion of Endeavor Translation
		msg += "!!The subsystem just finished the mob_list list, and currentrun is empty (or has never run).\n"
		msg += "!!The info below is the tail of mob_list instead of currentrun.\n"
		*/
		msg += "!!Подсистема только что завершила список mob_list, и currentrun пуст (либо не запускался).\n"
		msg += "!!Информация внизу – хвост списка mob_list вместо currentrun.\n"
		// End of Bastion of Endeavor Translation

	var/datum/D = currentrun.len ? currentrun[currentrun.len] : mob_list[mob_list.len]
	/* Bastion of Endeavor Translation
	msg += "Tail entry: [describeThis(D)] (this is likely the item AFTER the problem item)\n"
	*/
	msg += "Запись хвоста: [describeThis(D)] (вероятнее всего, это предмет ПОСЛЕ проблемного)\n"
	// End of Bastion of Endeavor Translation

	var/position = mob_list.Find(D)
	if(!position)
		/* Bastion of Endeavor Translation
		msg += "Unable to find context of tail entry in mob_list list.\n"
		*/
		msg += "Не удалось найти контекст к записи хвоста в списке mob_list.\n"
		// End of Bastion of Endeavor Translation
	else
		if(position != mob_list.len)
			var/additional = mob_list.Find(D, position+1)
			if(additional)
				/* Bastion of Endeavor Translation
				msg += "WARNING: Tail entry found more than once in mob_list list! Context is for the first found.\n"
				*/
				msg += "ВНИМАНИЕ: Запись хвоста найдена в списке mob_list больше одного раза! Контекст принадлежит первой найденной.\n"
				// End of Bastion of Endeavor Translation
		var/start = clamp(position-2,1,mob_list.len)
		var/end = clamp(position+2,1,mob_list.len)
		/* Bastion of Endeavor Translation
		msg += "2 previous elements, then tail, then 2 next elements of mob_list list for context:\n"
		*/
		msg += "2 предыдущих элемента, хвост и 2 следующих элемента списка mob_list для контекста:\n"
		// End of Bastion of Endeavor Translation
		msg += "---\n"
		for(var/i in start to end)
			/* Bastion of Endeavor Translation
			msg += "[describeThis(mob_list[i])][i == position ? " << TAIL" : ""]\n"
			*/
			msg += "[describeThis(mob_list[i])][i == position ? " << ХВОСТ" : ""]\n"
			// End of Bastion of Endeavor Translation
		msg += "---\n"
	log_game(msg)
	log_world(msg)

/datum/controller/subsystem/mobs/fail()
	..()
	log_recent()

/datum/controller/subsystem/mobs/critfail()
	..()
	log_recent()

//CHOMPEdit Begin
//Mobs need to immediately removed from the SS list on Destroy
/mob/Destroy()
	. = ..()
	SSmobs.currentrun -= src
//CHOMPEdit End
