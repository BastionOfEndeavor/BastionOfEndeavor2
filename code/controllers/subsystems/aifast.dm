SUBSYSTEM_DEF(aifast)
	/* Bastion of Endeavor Translation
	name = "AI (Fast)"
	*/
	name = "ИИ (быстрый)"
	// End of Bastion of Endeavor Translation
	init_order = INIT_ORDER_AI_FAST
	priority = FIRE_PRIORITY_AI
	wait = 0.25 SECONDS // Every quarter second
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/aifast/stat_entry(msg)
	/* Bastion of Endeavor Translation
	msg = "P:[processing.len]"
	*/
	msg = "| Обрабатывается: [processing.len]"
	// End of Bastion of Endeavor Translation
	return ..()

/datum/controller/subsystem/aifast/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue
		A.handle_tactics()

		if(MC_TICK_CHECK)
			return
