#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	/* Bastion of Endeavor Translation
	name = "Atoms"
	*/
	name = "Атомы"
	// End of Bastion of Endeavor Translation
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	var/static/initialized = INITIALIZATION_INSSATOMS
	// var/list/created_atoms // This is never used, so don't bother. ~Leshana
	var/static/old_initialized

	var/list/late_loaders
	var/list/created_atoms

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize() // CHOMPEdit
	setupgenetics() //to set the mutations' place in structural enzymes, so initializers know where to put mutations.
	initialized = INITIALIZATION_INNEW_MAPLOAD
	/* Bastion of Endeavor Translation
	to_world_log("Initializing objects")
	admin_notice("<span class='danger'>Initializing objects</span>", R_DEBUG)
	*/
	to_world_log("Инициализация объектов.")
	admin_notice("<span class='danger'>Инициализация объектов.</span>", R_DEBUG)
	// End of Bastion of Endeavor Translation
	InitializeAtoms()
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	initialized = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(late_loaders)

	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		created_atoms = list()
		count = atoms.len
		for(var/atom/A as anything in atoms)
			if(!(A.flags & ATOM_INITIALIZED)) //CHOMPEdit
				if(InitAtom(A, mapload_arg))
					atoms -= A
				CHECK_TICK
	else
		count = 0
		for(var/atom/A in world) // This must be world, since this operation adds all the atoms to their specific lists.
			if(!(A.flags & ATOM_INITIALIZED))
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	/* Bastion of Endeavor Translation
	log_world("Initialized [count] atoms")
	*/
	log_world("[count_ru(count, "Инициализирован;;о;о", TRUE)] [count_ru(count, "атом;;а;ов")].")
	// End of Bastion of Endeavor Translation

	initialized = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/atom/A as anything in late_loaders)
			A.LateInitialize()
			CHECK_TICK
		/* Bastion of Endeavor Translation
		testing("Late initialized [late_loaders.len] atoms")
		*/
		testing("Завершена поздняя инициализация [count_ru(late_loaders.len, "атом;а;ов;ов")].")
		// End of Bastion of Endeavor Translation
		late_loaders.Cut()

	// Nothing ever checks return value of this proc, so don't bother.  If this ever changes fix code in /atom/New() ~Leshana
	// if(atoms)
	// 	. = created_atoms + atoms
	// 	created_atoms = null

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					late_loaders += A
				else
					A.LateInitialize()
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.flags & ATOM_INITIALIZED))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_initialized = initialized
	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	initialized = old_initialized

/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_initialized = SSatoms.old_initialized
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		/* Bastion of Endeavor Translation
		. += "Path : [path] \n"
		*/
		. += "Путь : [path] \n"
		// End of Bastion of Endeavor Translation
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			/* Bastion of Endeavor Translation
			. += "- Didn't call atom/Initialize()\n"
			*/
			. += "- Не вызван atom/Initialize()\n"
			// End of Bastion of Endeavor Translation
		if(fails & BAD_INIT_NO_HINT)
			/* Bastion of Endeavor Translation
			. += "- Didn't return an Initialize hint\n"
			*/
			. += "- Не возвращен намёк на Initialize\n"
			// End of Bastion of Endeavor Translation
		if(fails & BAD_INIT_QDEL_BEFORE)
			/* Bastion of Endeavor Translation
			. += "- Qdel'd in New()\n"
			*/
			. += "- Qdel'нут в New()\n"
			// End of Bastion of Endeavor Translation
		if(fails & BAD_INIT_SLEPT)
			/* Bastion of Endeavor Translation
			. += "- Slept during Initialize()\n"
			*/
			. += "- Проспал во время Initialize()\n"
			// End of Bastion of Endeavor Translation

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[log_path]-initialize.log")

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
