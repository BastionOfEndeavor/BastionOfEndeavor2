SUBSYSTEM_DEF(job)
	/* Bastion of Endeavor Translation
	name = "Job"
	*/
	name = "Работы"
	// End of Bastion of Endeavor Translation
	init_order = INIT_ORDER_JOB
	flags = SS_NO_FIRE

	var/list/occupations = list()		//List of all jobs
	var/list/datum/job/name_occupations = list()	//Dict of all jobs, keys are titles
	var/list/type_occupations = list()	//Dict of all jobs, keys are types

	var/list/department_datums = list()
	var/debug_messages = FALSE

	var/savepath = "data/job_camp_list.json"	// CHOMPadd
	var/list/shift_keys = list()				// CHOMPadd
	var/list/restricted_keys = list()			// CHOMPadd


/datum/controller/subsystem/job/Initialize() // CHOMPEdit
	if(!department_datums.len)
		setup_departments()
	if(!occupations.len)
		setup_occupations()
	//CHOMPadd begin
	if(CONFIG_GET(number/job_camp_time_limit))
		load_camp_lists()
	//CHOMPadd end
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/job/proc/setup_occupations(faction = FACTION_STATION)
	occupations = list()
	var/list/all_jobs = subtypesof(/datum/job)
	if(!all_jobs.len)
		/* Bastion of Endeavor Translation
		to_chat(world, span("warning", "Error setting up jobs, no job datums found"))
		*/
		to_chat(world, span("warning", "Ошибка при инициализации работ: не найдены датумы работ."))
		// End of Bastion of Endeavor Translation
		return FALSE

	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)
			continue
		if(job.faction != faction)
			continue
		occupations += job
		name_occupations[job.title] = job
		type_occupations[J] = job
		if(LAZYLEN(job.departments))
			add_to_departments(job)

	sortTim(occupations, GLOBAL_PROC_REF(cmp_job_datums))
	for(var/D in department_datums)
		var/datum/department/dept = department_datums[D]
		sortTim(dept.jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)
		sortTim(dept.primary_jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)

	return TRUE

/datum/controller/subsystem/job/proc/add_to_departments(datum/job/J)
	// Adds to the regular job lists in the departments, which allow multiple departments for a job.
	for(var/D in J.departments)
		var/datum/department/dept = LAZYACCESS(department_datums, D)
		if(!istype(dept))
			/* Bastion of Endeavor Translation
			job_debug_message("Job '[J.title]' is defined as being inside department '[D]', but it does not exist.")
			*/
			job_debug_message("Работа '[J.title]' закреплена за отделом '[D]', но его не существует.")
			// End of Bastion of Endeavor Translation
			continue
		dept.jobs[J.title] = J

	// Now for the 'primary' department for a job, which is defined as being the first department in the list for a job.
	// This results in no duplicates, which can be useful in some situations.
	if(LAZYLEN(J.departments))
		var/primary_department = J.departments[1]
		var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
		if(!istype(dept))
			/* Bastion of Endeavor Translation
			job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
			*/
			job_debug_message("У работы '[J.title]' основной отдел – '[primary_department]', однако его не существует.")
			// End of Bastion of Endeavor Translation
		else
			dept.primary_jobs[J.title] = J

/datum/controller/subsystem/job/proc/setup_departments()
	for(var/t in subtypesof(/datum/department))
		var/datum/department/D = new t()
		department_datums[D.name] = D

	sortTim(department_datums, GLOBAL_PROC_REF(cmp_department_datums), TRUE)

/datum/controller/subsystem/job/proc/get_all_department_datums()
	var/list/dept_datums = list()
	for(var/D in department_datums)
		dept_datums += department_datums[D]
	return dept_datums

/datum/controller/subsystem/job/proc/get_job(rank)
	if(!occupations.len)
		setup_occupations()
	return name_occupations[rank]

/datum/controller/subsystem/job/proc/get_job_type(jobtype)
	if(!occupations.len)
		setup_occupations()
	return type_occupations[jobtype]

// Determines if a job title is inside of a specific department.
// Useful to replace the old `if(job_title in command_positions)` code.
/datum/controller/subsystem/job/proc/is_job_in_department(rank, target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		return LAZYFIND(D.jobs, rank) ? TRUE : FALSE
	return FALSE

// Returns a list of all job names in a specific department.
/datum/controller/subsystem/job/proc/get_job_titles_in_department(target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		var/list/job_titles = list()
		for(var/J in D.jobs)
			job_titles += J
		return job_titles

	/* Bastion of Endeavor Translation
	job_debug_message("Was asked to get job titles for a non-existant department '[target_department_name]'.")
	*/
	job_debug_message("Потребовалось получить названия работ для несуществующего отдела '[target_department_name]'.")
	// End of Bastion of Endeavor Translation
	return list()

// Returns a reference to the primary department datum that a job is in.
// Can receive job datum refs, typepaths, or job title strings.
/datum/controller/subsystem/job/proc/get_primary_department_of_job(datum/job/J)
	if(!istype(J, /datum/job))
		if(ispath(J))
			J = get_job_type(J)
		else if(istext(J))
			J = get_job(J)

	if(!istype(J))
		/* Bastion of Endeavor Translation
		job_debug_message("Was asked to get department for job '[J]', but input could not be resolved into a job datum.")
		*/
		job_debug_message("Потребовалось получить отдел работы '[J]', однако входные данные не являются датумом.")
		// End of Bastion of Endeavor Translation
		return

	if(!LAZYLEN(J.departments))
		return

	var/primary_department = J.departments[1]
	var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
	if(!istype(dept))
		/* Bastion of Endeavor Translation
		job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
		*/
		job_debug_message("У работы '[J.title]' основной отдел – '[primary_department]', однако его не существует.")
		// End of Bastion of Endeavor Translation
		return

	return department_datums[primary_department]

/datum/controller/subsystem/job/proc/get_ping_role(var/role)
	var/datum/job/J = get_job(role)
	if(J.requestable)
		return get_primary_department_of_job(J)

// Someday it might be good to port code/game/jobs/job_controller.dm to here and clean it up.

/datum/controller/subsystem/job/proc/job_debug_message(message)
	if(debug_messages)
		/* Bastion of Endeavor Translation
		log_debug("JOB DEBUG: [message]")
		*/
		log_debug("ОТЛАДКА РАБОТ: [message]")
		// End of Bastion of Endeavor Translation

//CHOMPadd start
/datum/controller/subsystem/job/proc/load_camp_lists()
	if(fexists(savepath))
		restricted_keys = json_decode(file2text(savepath))
		fdel(savepath)

/datum/controller/subsystem/job/Shutdown(Addr, Natural)
	. = ..()
	if(fexists(savepath))
		fdel(savepath)
	var/json_to_file = json_encode(shift_keys)
	if(!json_to_file)
		/* Bastion of Endeavor Translation
		log_debug("Saving: [savepath] failed jsonencode")
		*/
		log_debug("Сохранение: Для [savepath] провалился jsonencode.")
		// End of Bastion of Endeavor Translation
		return

	//Write it out
	rustg_file_write(json_to_file, savepath)
	if(!fexists(savepath))
		/* Bastion of Endeavor Translation
		log_debug("Saving: failed to save [savepath]")
		*/
		log_debug("Сохранение: Сохранение не удалось для [savepath].")
		// End of Bastion of Endeavor Translation
//CHOMPadd end
