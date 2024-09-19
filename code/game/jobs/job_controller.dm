var/global/datum/controller/occupations/job_master

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()
		//Cache of icons for job info window
	var/list/job_icons = list()

<<<<<<< HEAD
/* Bastion of Endeavor Translation
/datum/controller/occupations/proc/SetupOccupations(var/faction = "Station")
*/
/datum/controller/occupations/proc/SetupOccupations(var/faction = "Станция")
// End of Bastion of Endeavor Translation
=======
/datum/controller/occupations/proc/SetupOccupations(var/faction = FACTION_STATION)
>>>>>>> 4153768ba1 ([MIRROR] Job rank and radio channel rework (#8965))
	occupations = list()
	//var/list/all_jobs = typesof(/datum/job)
	var/list/all_jobs = list(/datum/job/assistant) | using_map.allowed_jobs
	if(!all_jobs.len)
		/* Bastion of Endeavor Translation
		to_world("<span class='warning'>Error setting up jobs, no job datums found!</span>")
		*/
		to_world("<span class='warning'>Ошибка при инициализации работ: не найдены датумы работ!</span>")
		// End of Bastion of Endeavor Translation
		return 0
	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)	continue
		if(job.faction != faction)	continue
		occupations += job
	sortTim(occupations, GLOBAL_PROC_REF(cmp_job_datums))


	return 1


/datum/controller/occupations/proc/Debug(var/text)
	if(!Debug2)	return 0
	job_debug.Add(text)
	return 1


/datum/controller/occupations/proc/GetJob(var/rank)
	if(!rank)	return null
	for(var/datum/job/J in occupations)
		if(!J)	continue
		if(J.title == rank)	return J
	return null

/datum/controller/occupations/proc/GetPlayerAltTitle(mob/new_player/player, rank)
	return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

/datum/controller/occupations/proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
	/* Bastion of Endeavor Translation
	Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	*/
	Debug("Выполняем AR, игрок: [player], должность: [rank], лейт: [latejoin]")
	// End of Bastion of Endeavor Translation
	if(player && player.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return 0
		if((job.minimum_character_age || job.min_age_by_species) && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		//VOREStation Add
		if(!job.player_has_enough_playtime(player.client))
			return 0
		if(!is_job_whitelisted(player, rank))
			return 0
		//VOREStation Add End

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			/* Bastion of Endeavor Translation
			Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			*/
			Debug("Игрок [player] теперь имеет должность: [rank], осталось [job.current_positions] из [position_limit]")
			// End of Bastion of Endeavor Translation
			player.mind.assigned_role = rank
			player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
			unassigned -= player
			job.current_positions++
			//CHOMPadd START
			if(job.camp_protection && round_duration_in_ds < transfer_controller.shift_hard_end - 30 MINUTES)
				job.register_shift_key(player.client.ckey)
			//CHOMPadd END
			return 1
	/* Bastion of Endeavor Translation
	Debug("AR has failed, Player: [player], Rank: [rank]")
	*/
	Debug("AR не удался, игрок: [player], должность: [rank]")
	// End of Bastion of Endeavor Translation
	return 0

/datum/controller/occupations/proc/FreeRole(var/rank)	//making additional slot on the fly
	var/datum/job/job = GetJob(rank)
	if(job && job.total_positions != -1)
		job.total_positions++
		return 1
	return 0

//CHOMPAdd Start
/datum/controller/occupations/proc/update_limit(var/rank, var/comperator)
	var/datum/job/job = GetJob(rank)
	if(job && job.total_positions != -1)
		job.update_limit(comperator)
		return 1
	return 0
//CHOMPAdd End

/datum/controller/occupations/proc/FindOccupationCandidates(datum/job/job, level, flag)
	/* Bastion of Endeavor Translation
	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	*/
	Debug("Выполняем FOC, должность: [job], уровень: [level], флаг: [flag]")
	// End of Bastion of Endeavor Translation
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			/* Bastion of Endeavor Translation
			Debug("FOC isbanned failed, Player: [player]")
			*/
			Debug("FOC: не пройден isbanned, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		if(!job.player_old_enough(player.client))
			/* Bastion of Endeavor Translation
			Debug("FOC player not old enough, Player: [player]")
			*/
			Debug("FOC: низкий возраст учётной записи, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		if(job.minimum_character_age && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			/* Bastion of Endeavor Translation
			Debug("FOC character not old enough, Player: [player]")
			*/
			Debug("FOC: персонаж младше мин. возраста учётной записи, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		//VOREStation Code Start
		if(!job.player_has_enough_playtime(player.client))
			/* Bastion of Endeavor Translation
			Debug("FOC character not enough playtime, Player: [player]")
			*/
			Debug("FOC: недостаточно наигранных часов, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		if(!is_job_whitelisted(player, job.title))
			/* Bastion of Endeavor Translation
			Debug("FOC is_job_whitelisted failed, Player: [player]")
			*/
			Debug("FOC: не пройден is_job_whitelisted, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		//VOREStation Code End
		if(job.is_species_banned(player.client.prefs.species, player.client.prefs.organ_data["brain"]) == TRUE)
			/* Bastion of Endeavor Translation
			Debug("FOC character species invalid for job, Player: [player]")
			*/
			Debug("FOC: недопустимая для работы раса, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		if(flag && !(player.client.prefs.be_special & flag))
			/* Bastion of Endeavor Translation
			Debug("FOC flag failed, Player: [player], Flag: [flag], ")
			*/
			Debug("FOC: не пройдена проверка флага, игрок: [player], флаг: [flag], ")
			// End of Bastion of Endeavor Translation
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			/* Bastion of Endeavor Translation
			Debug("FOC pass, Player: [player], Level:[level]")
			*/
			Debug("FOC пройден, игрок: [player], уровень [level]")
			// End of Bastion of Endeavor Translation
			candidates += player
	return candidates

/datum/controller/occupations/proc/GiveRandomJob(var/mob/new_player/player)
	/* Bastion of Endeavor Translation
	Debug("GRJ Giving random job, Player: [player]")
	*/
	Debug("GRJ: Выдаем случайную работу, игрок: [player]")
	// End of Bastion of Endeavor Translation
	for(var/datum/job/job in shuffle(occupations))
		if(!job)
			continue

		if((job.minimum_character_age || job.min_age_by_species) && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			continue

		if(job.is_species_banned(player.client.prefs.species, player.client.prefs.organ_data["brain"]) == TRUE)
			continue

		if(istype(job, GetJob(JOB_ALT_VISITOR))) // We don't want to give him assistant, that's boring! //VOREStation Edit - Visitor not Assistant
			continue

		if(SSjob.is_job_in_department(job.title, DEPARTMENT_COMMAND)) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			/* Bastion of Endeavor Translation
			Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			*/
			Debug("GRJ: не пройден isbanned, игрок: [player], работа: [job.title]")
			// End of Bastion of Endeavor Translation
			continue

		if(!job.player_old_enough(player.client))
			/* Bastion of Endeavor Translation
			Debug("GRJ player not old enough, Player: [player]")
			*/
			Debug("GRJ: низкий возраст учётной записи, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue

		//VOREStation Code Start
		if(!job.player_has_enough_playtime(player.client))
			/* Bastion of Endeavor Translation
			Debug("GRJ player not enough playtime, Player: [player]")
			*/
			Debug("GRJ: недостаточно наигранных часов, игрок: [player]")
			// End of Bastion of Endeavor Translation
			continue
		if(!is_job_whitelisted(player, job.title))
			/* Bastion of Endeavor Translation
			Debug("GRJ player not whitelisted for this job, Player: [player], Job: [job.title]")
			*/
			Debug("GRJ: игрок не в вайтлисте работы, игрок: [player], работа: [job.title]")
			// End of Bastion of Endeavor Translation
			continue
		//VOREStation Code End

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			/* Bastion of Endeavor Translation
			Debug("GRJ Random job given, Player: [player], Job: [job]")
			*/
			Debug("GRJ: выдана случайная работа, игрок: [player], работа: [job]")
			// End of Bastion of Endeavor Translation
			AssignRole(player, job.title)
			unassigned -= player
			break

/datum/controller/occupations/proc/ResetOccupations()
	for(var/mob/new_player/player in player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	SetupOccupations()
	unassigned = list()
	return


///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/occupations/proc/FillHeadPosition()
	for(var/level = 1 to 3)
		for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.age

				if(age < job.get_min_age(V.client.prefs.species, V.client.prefs.organ_data["brain"])) // Nope.
					continue

				var/idealage = job.get_ideal_age(V.client.prefs.species, V.client.prefs.organ_data["brain"])
				var/agediff = abs(idealage - age) // Compute the absolute difference in age from target
				switch(agediff) /// If the math sucks, it's because I almost failed algebra in high school.
					if(20 to INFINITY)
						weightedCandidates[V] = 3 // Too far off
					if(10 to 20)
						weightedCandidates[V] = 6 // Nearer the mark, but not quite
					if(0 to 10)
						weightedCandidates[V] = 10 // On the mark
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1


			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(AssignRole(candidate, command_position))
				return 1
	return 0


///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/occupations/proc/CheckHeadPositions(var/level)
	for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
		var/datum/job/job = GetJob(command_position)
		if(!job)	continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		AssignRole(candidate, command_position)
	return


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/occupations/proc/DivideOccupations()
	//Setup new player list and get the jobs list
	/* Bastion of Endeavor Translation
	Debug("Running DO")
	*/
	Debug("Выполняем DivideOccupations")
	// End of Bastion of Endeavor Translation
	SetupOccupations()

	//Holder for Triumvirate is stored in the ticker, this just processes it
	if(ticker && ticker.triai)
		for(var/datum/job/A in occupations)
<<<<<<< HEAD
			/* Bastion of Endeavor Translation
			if(A.title == "AI")
			*/
			if(A.title == "Искусственный интеллект")
			// End of Bastion of Endeavor Translation
=======
			if(A.title == JOB_AI)
>>>>>>> 4153768ba1 ([MIRROR] Job rank and radio channel rework (#8965))
				A.spawn_positions = 3
				break

	//Get the players who are ready
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned += player

	/* Bastion of Endeavor Translation
	Debug("DO, Len: [unassigned.len]")
	*/
	Debug("Всего на DivideOccupations: [unassigned.len]")
	// End of Bastion of Endeavor Translation
	if(unassigned.len == 0)	return 0

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	//People who wants to be assistants, sure, go on.
	/* Bastion of Endeavor Translation
	Debug("DO, Running Assistant Check 1")
	*/
	Debug("DivideOccupations: проверка ассистентов")
	// End of Bastion of Endeavor Translation
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
	/* Bastion of Endeavor Translation
	Debug("AC1, Candidates: [assistant_candidates.len]")
	*/
	Debug("Проверка ассистентов 1, кандидатов: [assistant_candidates.len]")
	// End of Bastion of Endeavor Translation
	for(var/mob/new_player/player in assistant_candidates)
		/* Bastion of Endeavor Translation
		Debug("AC1 pass, Player: [player]")
<<<<<<< HEAD
		*/
		Debug("Проверка ассистентов 1 пройдена, игрок: [player]")
		// End of Bastion of Endeavor Translation
		AssignRole(player, USELESS_JOB) //VOREStation Edit - Visitor not Assistant
=======
		AssignRole(player, JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant
>>>>>>> 4153768ba1 ([MIRROR] Job rank and radio channel rework (#8965))
		assistant_candidates -= player
	/* Bastion of Endeavor Translation
	Debug("DO, AC1 end")
	*/
	Debug("DivideOccupations: проверка ассистентов 1 завершена")
	// End of Bastion of Endeavor Translation

	//Select one head
	/* Bastion of Endeavor Translation
	Debug("DO, Running Head Check")
	*/
	Debug("DivideOccupations: проверка глав")
	// End of Bastion of Endeavor Translation
	FillHeadPosition()
	/* Bastion of Endeavor Translation
	Debug("DO, Head Check end")
	*/
	Debug("DivideOccupations: проверка глав завершена")
	// End of Bastion of Endeavor Translation

	//Other jobs are now checked
	/* Bastion of Endeavor Translation
	Debug("DO, Running Standard Check")
	*/
	Debug("DivideOccupations: стандартная проверка")
	// End of Bastion of Endeavor Translation


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	// var/list/disabled_jobs = ticker.mode.disabled_jobs  // So we can use .Find down below without a colon.
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/new_player/player in unassigned)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job || ticker.mode.disabled_jobs.Find(job.title) )
					continue

				if(jobban_isbanned(player, job.title))
					/* Bastion of Endeavor Translation
					Debug("DO isbanned failed, Player: [player], Job:[job.title]")
					*/
					Debug("DivideOccupations: не пройден isbanned, игрок: [player], работа: [job.title]")
					// End of Bastion of Endeavor Translation
					continue

				if(!job.player_old_enough(player.client))
					/* Bastion of Endeavor Translation
					Debug("DO player not old enough, Player: [player], Job:[job.title]")
					*/
					Debug("DivideOccupations: низкий возраст учётной записи, игрок: [player], работа: [job.title]")
					// End of Bastion of Endeavor Translation
					continue

				//VOREStation Add
				if(!job.player_has_enough_playtime(player.client))
					/* Bastion of Endeavor Translation
					Debug("DO player not enough playtime, Player: [player]")
					*/
					Debug("DivideOccupations: недостаточно наигранных часов, игрок: [player]")
					// End of Bastion of Endeavor Translation
					continue
				//VOREStation Add End

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						/* Bastion of Endeavor Translation
						Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						*/
						Debug("DivideOccupations пройден, игрок: [player], уровень: [level], работа: [job.title]")
						// End of Bastion of Endeavor Translation
						AssignRole(player, job.title)
						unassigned -= player
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			GiveRandomJob(player)
	/*
	Old job system
	for(var/level = 1 to 3)
		for(var/datum/job/job in occupations)
			Debug("Checking job: [job]")
			if(!job)
				continue
			if(!unassigned.len)
				break
			if((job.current_positions >= job.spawn_positions) && job.spawn_positions != -1)
				continue
			var/list/candidates = FindOccupationCandidates(job, level)
			while(candidates.len && ((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
				var/mob/new_player/candidate = pick(candidates)
				Debug("Selcted: [candidate], for: [job.title]")
				AssignRole(candidate, job.title)
				candidates -= candidate*/

	/* Bastion of Endeavor Translation
	Debug("DO, Standard Check end")
	*/
	Debug("DivideOccupation: стандартная проверка завершена")
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	Debug("DO, Running AC2")
	*/
	Debug("DivideOccupations: проверка ассистентов 2")
	// End of Bastion of Endeavor Translation

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			/* Bastion of Endeavor Translation
			Debug("AC2 Assistant located, Player: [player]")
<<<<<<< HEAD
			*/
			Debug("Проверка ассистентов 2, найден ассистент, игрок: [player]")
			// End of Bastion of Endeavor Translation
			AssignRole(player, USELESS_JOB) //VOREStation Edit - Visitor not Assistant
=======
			AssignRole(player, JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant
>>>>>>> 4153768ba1 ([MIRROR] Job rank and radio channel rework (#8965))

	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel_proc()
			unassigned -= player
	return 1


/datum/controller/occupations/proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0, var/announce = TRUE)
	if(!H)	return null

	var/datum/job/job = GetJob(rank)
	var/list/spawn_in_storage = list()

	if(!joined_late)
		var/obj/S = null
		var/list/possible_spawns = list()
		for(var/obj/effect/landmark/start/sloc in landmarks_list)
			if(sloc.name != rank)	continue
			if(locate(/mob/living) in sloc.loc)	continue
			possible_spawns.Add(sloc)
		if(possible_spawns.len)
			S = pick(possible_spawns)
		if(!S)
			S = locate("start*[rank]") // use old stype
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		else
			var/list/spawn_props = LateSpawn(H.client, rank)
			var/turf/T = spawn_props["turf"]
			if(!T)
				/* Bastion of Endeavor Translation
				to_chat(H, "<span class='critical'>You were unable to be spawned at your chosen late-join spawnpoint. Please verify your job/spawn point combination makes sense, and try another one.</span>")
				*/
				to_chat(H, "<span class='critical'>Вам не удалось появиться в выбранной точке позднего появления. Убедитесь в соответствии точки появления вашей профессии и попробуйте другую.</span>")
				// End of Bastion of Endeavor Translation
				return
			else
				H.forceMove(T)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	if(job)

		//Equip custom gear loadout.
		var/list/custom_equip_slots = list()
		var/list/custom_equip_leftovers = list()
		if(H.client && H.client.prefs && H.client.prefs.gear && H.client.prefs.gear.len && !(job.mob_type & JOB_SILICON))
			for(var/thing in H.client.prefs.gear)
				var/datum/gear/G = gear_datums[thing]
				// Bastion of Endeavor Addition: I'm not satisfied with datum display names being shown in context
				var/thing_obj
				if(ispath(G.path))
					thing_obj = new G.path // in which we fetch the obj the datum is linked to
				// End of Bastion of Endeavor Addition
				if(!G) //Not a real gear datum (maybe removed, as this is loaded from their savefile)
					continue

				var/permitted
				// Check if it is restricted to certain roles
				if(G.allowed_roles)
					for(var/job_name in G.allowed_roles)
						if(job.title == job_name)
							permitted = 1
				else
					permitted = 1

				// Check if they're whitelisted for this gear (in alien whitelist? seriously?)
				if(G.whitelisted && !is_alien_whitelisted(H, GLOB.all_species[G.whitelisted]))
					permitted = 0

				// If they aren't, tell them
				if(!permitted)
					/* Bastion of Endeavor Translation
					to_chat(H, "<span class='warning'>Your current species, job or whitelist status does not permit you to spawn with [thing]!</span>")
					*/
					to_chat(H, "<span class='warning'>Ваша раса, должность или запись в вайтлисте не позволяют вам надеть [acase_ru(thing_obj)]!</span>")
					// End of Bastion of Endeavor Translation
					continue

				// Implants get special treatment
				if(G.slot == "implant")
					var/obj/item/weapon/implant/I = G.spawn_item(H, H.client.prefs.gear[G.display_name])
					I.invisibility = 100
					I.implant_loadout(H)
					continue

				// Try desperately (and sorta poorly) to equip the item. Now with increased desperation!
				if(G.slot && !(G.slot in custom_equip_slots))
					var/metadata = H.client.prefs.gear[G.display_name]
					//if(G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
					//	custom_equip_leftovers += thing
					//else
					/* CHOMPRemove Start, remove RS No shoes
					if(G.slot == slot_shoes && H.client?.prefs?.shoe_hater)	//RS ADD
						continue
					*///CHOMPRemove End, remove RS No shoes
					if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
						/* Bastion of Endeavor Translation
						to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
						*/
						to_chat(H, "<span class='notice'>На вас [verb_ru(thing_obj, "надет;;а;о;ы;")] [ncase_ru(thing_obj)]!</span>")
						// End of Bastion of Endeavor Translation
						if(G.slot != slot_tie)
							custom_equip_slots.Add(G.slot)
					else
						custom_equip_leftovers.Add(thing)
				else
					spawn_in_storage += thing

		// Set up their account
		job.setup_account(H)

		// Equip job items.
		job.equip(H, H.mind ? H.mind.role_alt_title : "")

		// Stick their fingerprints on literally everything
		job.apply_fingerprints(H)

		// Only non-silicons get post-job-equip equipment
		if(!(job.mob_type & JOB_SILICON))
			H.equip_post_job()

		// If some custom items could not be equipped before, try again now.
		for(var/thing in custom_equip_leftovers)
			var/datum/gear/G = gear_datums[thing]
			// Bastion of Endeavor Addition: Same thing as above
			var/thing_obj
			if(ispath(G.path))
				thing_obj = new G.path // in which we fetch the obj the datum is linked to
			// End of Bastion of Endeavor Addition
			/* CHOMPRemove Start, remove RS No shoes
			if(G.slot == slot_shoes && H.client?.prefs?.shoe_hater)	//RS ADD
				continue
			*///CHOMPRemove End, remove RS No shoes
			if(G.slot in custom_equip_slots)
				spawn_in_storage += thing
			else
				var/metadata = H.client.prefs.gear[G.display_name]
				if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
					/* Bastion of Endeavor Translation
					to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
					*/
					to_chat(H, "<span class='notice'>На вас [verb_ru(thing_obj, "надет;;а;о;ы;")] [ncase_ru(thing_obj)]!</span>")
					// End of Bastion of Endeavor Translation
					custom_equip_slots.Add(G.slot)
				else
					spawn_in_storage += thing
	else
		/* Bastion of Endeavor Translation
		to_chat(H, "<span class='filter_notice'>Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.</span>")
		*/
		to_chat(H, "<span class='filter_notice'>Ваша должность – [rank], и игра к этому не была готова! Доложите об этом администратору.</span>")
		// End of Bastion of Endeavor Translation

	H.job = rank
	/* Bastion of Endeavor Translation
	log_game("JOINED [key_name(H)] as \"[rank]\"")
	log_game("SPECIES [key_name(H)] is a: \"[H.species.name]\"") //VOREStation Add
	*/
	log_game("ЗАШЁЛ [key_name(H)] за должность: \"[rank]\"")
	log_game("РАСОЙ [key_name(H)] является: \"[H.species.name]\"") //VOREStation Add
	// End of Bastion of Endeavor Translation

	// If they're head, give them the account info for their department
	if(H.mind && job.department_accounts)
		var/remembered_info = ""
		for(var/D in job.department_accounts)
			var/datum/money_account/department_account = department_accounts[D]
			if(department_account)
				/* Bastion of Endeavor Translation
				remembered_info += "<b>Department account number ([D]):</b> #[department_account.account_number]<br>"
				remembered_info += "<b>Department account pin ([D]):</b> [department_account.remote_access_pin]<br>"
				remembered_info += "<b>Department account funds ([D]):</b> $[department_account.money]<br>"
				*/
				remembered_info += "<b>Номер счёта отдела ([D]):</b> #[department_account.account_number]<br>"
				remembered_info += "<b>Пароль счёта отдела ([D]):</b> [department_account.remote_access_pin]<br>"
				remembered_info += "<b>Баланс счёта отдела ([D]):</b> $[department_account.money]<br>"
				// End of Bastion of Endeavor Translation

		H.mind.store_memory(remembered_info)

	var/alt_title = null
	if(H.mind)
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

		// If we're a silicon, we may be done at this point
		if(job.mob_type & JOB_SILICON_ROBOT)
			return H.Robotize()
		if(job.mob_type & JOB_SILICON_AI)
			return H

		// TWEET PEEP
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		if(rank == "Site Manager" && announce)
		*/
		if(rank == "Менеджер объекта" && announce)
		// End of Bastion of Endeavor Translation
			var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP) ? null : sound('sound/misc/boatswain.ogg', volume=20)
			/* Bastion of Endeavor Translation
			captain_announcement.Announce("All hands, [alt_title ? alt_title : "Site Manager"] [H.real_name] on deck!", new_sound = announce_sound, zlevel = H.z)
			*/
			captain_announcement.Announce("Внимание, экипаж! На станцию [verb_ru(H, "прибыл")] [alt_title ? lowertext(alt_title) : "менеджер объекта"] [H.real_name]!", new_sound = announce_sound, zlevel = H.z)
			// End of Bastion of Endeavor Translation
=======
		if(rank == JOB_SITE_MANAGER && announce)
			var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP) ? null : sound('sound/misc/boatswain.ogg', volume=20)
			captain_announcement.Announce("All hands, [alt_title ? alt_title : JOB_SITE_MANAGER] [H.real_name] on deck!", new_sound = announce_sound, zlevel = H.z)
>>>>>>> 4153768ba1 ([MIRROR] Job rank and radio channel rework (#8965))

		//Deferred item spawning.
		if(spawn_in_storage && spawn_in_storage.len)
			var/obj/item/weapon/storage/B
			for(var/obj/item/weapon/storage/S in H.contents)
				B = S
				break

			if(!isnull(B))
				for(var/thing in spawn_in_storage)
					/* Bastion of Endeavor Edit: Reordered stuff basically
					to_chat(H, "<span class='notice'>Placing \the [thing] in your [B.name]!</span>")
					var/datum/gear/G = gear_datums[thing]
					*/
					var/datum/gear/G = gear_datums[thing]
					var/thing_obj
					if(ispath(G.path))
						thing_obj = new G.path
					to_chat(H, "<span class='notice'>[cap_ru(thing_obj)] [verb_ru(thing, "был")] [verb_ru(thing, "помещ;ён;ена;ено;ены;")] в [concat_ru("ваш;;у;е;и;", B, ACASE)]!</span>")
					var/metadata = H.client.prefs.gear[G.display_name]
					G.spawn_item(B, metadata)
			else
				/* Bastion of Endeavor Translation
				to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>")
				*/
				to_chat(H, "<span class='danger'>Не удалось найти свободное место на вашем существе; либо вы заспавнились без рук и рюкзака, либо это баг.</span>")
				// End of Bastion of Endeavor Translation

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		var/obj/item/weapon/storage/S = locate() in H.contents
		var/obj/item/wheelchair/R
		if(S)
			R = locate() in S.contents
		if(!l_foot || !r_foot || R)
			var/wheelchair_type = R?.unfolded_type || /obj/structure/bed/chair/wheelchair
			var/obj/structure/bed/chair/wheelchair/W = new wheelchair_type(H.loc)
			W.buckle_mob(H)
			H.update_canmove()
			W.set_dir(H.dir)
			W.add_fingerprint(H)
			if(R)
				W.color = R.color
				qdel(R)

	/* Bastion of Endeavor Translation
	to_chat(H, "<span class='filter_notice'><B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B></span>")
	*/
	to_chat(H, "<span class='filter_notice'><B>Ваша должность – [uncapitalize_ru("[alt_title ? alt_title : rank]")].</B></span>")
	// End of Bastion of Endeavor Translation

	if(job.supervisors)
		/* Bastion of Endeavor Translation: supervisors var has more text so yeah
		to_chat(H, "<span class='filter_notice'><b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b></span>")
		*/
		to_chat(H, "<span class='filter_notice'><b>[job.supervisors]<br>Особые обстоятельства могут это изменить.</b></span>")
		// End of Bastion of Endeavor Translation
	if(job.has_headset)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		/* Bastion of Endeavor Translation: Oddly, I am removing a bit of clarity here, since say code isn't localized at the time of doing this
		to_chat(H, "<span class='filter_notice'><b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b></span>")
		*/
		to_chat(H, "<span class='filter_notice'><b>Осмотрите свою гарнитуру, чтобы увидеть список доступных вам каналов рации.</b></span>")
		// End of Bastion of Endeavor Translation

	if(job.req_admin_notify)
		/* Bastion of Endeavor Translation
		to_chat(H, "<span class='filter_notice'><b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b></span>")
		*/
		to_chat(H, "<span class='filter_notice'><b>Ваша должность важна для развития раунда. Если вам необходимо резко отключиться, просьба предварительно сообщить администраторам через глагол Помощь администратора (F1).</b></span>")
		// End of Bastion of Endeavor Translation

	// EMAIL GENERATION
	// Email addresses will be created under this domain name. Mostly for the looks.
	/* Bastion of Endeavor Translation
	var/domain = "freemail.nt"
	*/
	var/domain = "почта.нт"
	// End of Bastion of Endeavor Translation
	if(using_map && LAZYLEN(using_map.usable_email_tlds))
		domain = using_map.usable_email_tlds[1]
	/* Bastion of Endeavor Unicode Edit
	var/sanitized_name = sanitize(replacetext(replacetext(lowertext(H.real_name), " ", "."), "'", ""))
	*/
	var/sanitized_name = sanitize(replacetext_char(replacetext_char(lowertext(H.real_name), " ", "."), "'", ""))
	// End of Bastion of Endeavor Unicode Edit
	var/complete_login = "[sanitized_name]@[domain]"

	// It is VERY unlikely that we'll have two players, in the same round, with the same name and branch, but still, this is here.
	// If such conflict is encountered, a random number will be appended to the email address. If this fails too, no email account will be created.
	if(ntnet_global.does_email_exist(complete_login))
		complete_login = "[sanitized_name][random_id(/datum/computer_file/data/email_account/, 100, 999)]@[domain]"

	// If even fallback login generation failed, just don't give them an email. The chance of this happening is astronomically low.
	if(ntnet_global.does_email_exist(complete_login))
		/* Bastion of Endeavor Translation
		to_chat(H, "<span class='filter_notice'>You were not assigned an email address.</span>")
		H.mind.store_memory("You were not assigned an email address.")
		*/
		to_chat(H, "<span class='filter_notice'>За вами не закреплён адрес электронной почты.</span>")
		H.mind.store_memory("За вами не закреплён адрес электронной почты.")
		// End of Bastion of Endeavor Translation
	else
		var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account()
		EA.password = GenerateKey()
		EA.login = 	complete_login
		/* Bastion of Endeavor Translation
		to_chat(H, "<span class='filter_notice'>Your email account address is <b>[EA.login]</b> and the password is <b>[EA.password]</b>. This information has also been placed into your notes.</span>")
		H.mind.store_memory("Your email account address is [EA.login] and the password is [EA.password].")
		*/
		to_chat(H, "<span class='filter_notice'>Ваш адрес электронной почты – <b>[EA.login]</b>, пароль – <b>[EA.password]</b>. Эта информация размещена в Заметках.</span>")
		H.mind.store_memory("Ваш адрес электронной почты – [EA.login], пароль – [EA.password].")
		// End of Bastion of Endeavor Translation
	// END EMAIL GENERATION

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = 1

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)
	return H

/datum/controller/occupations/proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
	if(!CONFIG_GET(flag/load_jobs_from_txt)) // CHOMPEdit
		return 0

	var/list/jobEntries = file2list(jobsfile)

	for(var/job in jobEntries)
		if(!job)
			continue

		job = trim(job)
		/* Bastion of Endeavor Unicode Edit
		if (!length(job))
		*/
		if (!length_char(job))
		// End of Bastion of Endeavor Unicode Edit
			continue

		/* Bastion of Endeavor Unicode Edit
		var/pos = findtext(job, "=")
		*/
		var/pos = findtext_char(job, "=")
		// End of Bastion of Endeavor Unicode Edit
		var/name = null
		var/value = null

		if(pos)
			/* Bastion of Endeavor Unicode Edit
			name = copytext(job, 1, pos)
			value = copytext(job, pos + 1)
			*/
			name = copytext_char(job, 1, pos)
			value = copytext_char(job, pos + 1)
			// End of Bastion of Endeavor Unicode Edit
		else
			continue

		if(name && value)
			var/datum/job/J = GetJob(name)
			if(!J)	continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)
			if(J.mob_type & JOB_SILICON)
				J.total_positions = 0

	return 1


/datum/controller/occupations/proc/HandleFeedbackGathering()
	for(var/datum/job/job in occupations)
		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		var/level6 = 0 //account too young
		for(var/mob/new_player/player in player_list)
			if(!(player.ready && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(!job.player_old_enough(player.client))
				level6++
				continue
			//VOREStation Add
			if(!job.player_has_enough_playtime(player.client))
				level6++
				continue
			//VOREStation Add End
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		feedback_add_details("job_preferences",tmp_str)

/datum/controller/occupations/proc/LateSpawn(var/client/C, var/rank)

	var/datum/spawnpoint/spawnpos
	var/fail_deadly = FALSE
	var/obj/belly/vore_spawn_gut
	var/absorb_choice = FALSE //CHOMPAdd - Ability to start absorbed with vorespawn
	var/mob/living/prey_to_nomph
	var/obj/item/item_to_be //CHOMPEdit - Item TF spawning
	var/mob/living/item_carrier //CHOMPEdit - Capture crystal spawning
	var/vorgans = FALSE //CHOMPEdit - capture crystal simplemob spawning

	//CHOMPEdit -  Remove fail_deadly addition on offmap_spawn

	//Spawn them at their preferred one
	if(C && C.prefs.spawnpoint)
		/* Bastion of Endeavor Translation
		if(C.prefs.spawnpoint == "Vorespawn - Prey")
		*/
		if(C.prefs.spawnpoint == "Появление с помощью Vore – Жертва")
		// End of Bastion of Endeavor Translation
			var/list/preds = list()
			var/list/pred_names = list() //This is cringe
			for(var/client/V in GLOB.clients)
				if(!isliving(V.mob))
					continue
				var/mob/living/M = V.mob
				if(M.stat == UNCONSCIOUS || M.stat == DEAD || (M.client.is_afk(10 MINUTES) && !M.no_latejoin_vore_warning)) //CHOMPEdit
					continue
				if(!M.latejoin_vore)
					continue
				if(!(M.z in using_map.vorespawn_levels))
					continue
				preds += M
				pred_names += M.real_name //very cringe

			if(preds.len)
				/* Bastion of Endeavor Translation
				var/pred_name = input(C, "Choose a Predator.", "Pred Spawnpoint") as null|anything in pred_names
				*/
				var/pred_name = input(C, "Выберите хищника.", "Появление с помощью Vore") as null|anything in pred_names
				// End of Bastion of Endeavor Translation
				if(!pred_name)
					return
				var/index = pred_names.Find(pred_name)
				var/mob/living/pred = preds[index]
				var/list/available_bellies = list()
				for(var/obj/belly/Y in pred.vore_organs)
					if(Y.vorespawn_blacklist)
						continue
					//CHOMPAdd Start
					if(LAZYLEN(Y.vorespawn_whitelist) && !(C.ckey in Y.vorespawn_whitelist))
						continue
					//CHOMPAdd End
					available_bellies += Y
				/* Bastion of Endeavor Translation
				var/backup = alert(C, "Do you want a mind backup?", "Confirm", "Yes", "No")
				if(backup == "Yes")
				*/
				var/backup = alert(C, "Хотите ли вы сделать резервную копию разума?", "Подтверждение", "Да", "Нет")
				if(backup == "Да")
				// End of Bastion of Endeavor Translation
					backup = 1
				/* Bastion of Endeavor Translation
				vore_spawn_gut = input(C, "Choose a Belly.", "Belly Spawnpoint") as null|anything in available_bellies
				*/
				vore_spawn_gut = input(C, "Выберите орган.", "Появление с помощью Vore") as null|anything in available_bellies
				// End of Bastion of Endeavor Translation
				if(!vore_spawn_gut)
					return
				//CHOMPAdd Start
				if(vore_spawn_gut.vorespawn_absorbed & VS_FLAG_ABSORB_YES)
					absorb_choice = TRUE
					/* Bastion of Endeavor Translation
					if(vore_spawn_gut.vorespawn_absorbed & VS_FLAG_ABSORB_PREY)
						if(alert(C, "Do you want to start absorbed into [pred]'s [vore_spawn_gut]?", "Confirm", "Yes", "No") != "Yes")
							absorb_choice = FALSE
					else if(alert(C, "[pred]'s [vore_spawn_gut] will start with you absorbed. Continue?", "Confirm", "Yes", "No") != "Yes")
					*/
					if(vore_spawn_gut.vorespawn_absorbed & VS_FLAG_ABSORB_PREY)
						if(alert(C, "Желаете ли вы появиться впитанным [prep_adv_ru("в", vore_spawn_gut)] [gcase_ru(pred)]?", "Подтверждение", "Да", "Нет") != "Да")
							absorb_choice = FALSE
					else if(alert(C, "Вы будете впитаны [prep_adv_ru("в", vore_spawn_gut)] [gcase_ru(pred)]. Продолжить?", "Подтверждение", "Да", "Нет") != "Да")
					// End of Bastion of Endeavor Translation
						return
				//CHOMPAdd End
				/* Bastion of Endeavor Translation
				to_chat(C, "<b><span class='warning'>[pred] has received your spawn request. Please wait.</span></b>")
				log_admin("[key_name(C)] has requested to vore spawn into [key_name(pred)]")
				message_admins("[key_name(C)] has requested to vore spawn into [key_name(pred)]")
				*/
				to_chat(C, "<b><span class='warning'>[interact_ru(pred, "получил")] ваш запрос на появление. Пожалуйста, подождите.</span></b>")
				log_admin("[key_name(C)] запросил появиться внутри [key_name(pred)]")
				message_admins("[key_name(C)] запросил появиться внутри [key_name(pred)]")
				// End of Bastion of Endeavor Translation

				var/confirm
				if(pred.no_latejoin_vore_warning)
					if(pred.no_latejoin_vore_warning_time > 0)
						//CHOMPEdit Start
						if(absorb_choice)
							/* Bastion of Endeavor Translation
							confirm = tgui_alert(pred, "[C.prefs.real_name] is attempting to spawn absorbed as your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), pred.no_latejoin_vore_warning_time SECONDS)
							*/
							confirm = tgui_alert(pred, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] появиться впитанным в [concat_ru("ваш;;ей;е;и;", vore_spawn_gut, PCASE)]. Разрешить?", "Подтверждение", list("Нет", "Да"), pred.no_latejoin_vore_warning_time SECONDS)
							// End of Bastion of Endeavor Translation
						else
							/* Bastion of Endeavor Translation:
							confirm = tgui_alert(pred, "[C.prefs.real_name] is attempting to spawn into your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), pred.no_latejoin_vore_warning_time SECONDS)
							*/
							confirm = tgui_alert(pred, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] появиться в [concat_ru("ваш;ем;ей;ем;их;", vore_spawn_gut, PCASE)]. Разрешить?", "Подтверждение", list("Нет", "Да"), pred.no_latejoin_vore_warning_time SECONDS)
							// End of Bastion of Endeavor Translation
						//CHOMPEdit End
					if(!confirm)
						/* Bastion of Endeavor Translation
						confirm = "Yes"
						*/
						confirm = "Да"
						// End of Bastion of Endeavor Translation
				else
				/* Bastion of Endeavor Translation
					//CHOMPEdit Start
					if(absorb_choice)
						confirm = alert(pred, "[C.prefs.real_name] is attempting to spawn absorbed as your [vore_spawn_gut]. Let them?", "Confirm", "No", "Yes")
					else
						confirm = alert(pred, "[C.prefs.real_name] is attempting to spawn into your [vore_spawn_gut]. Let them?", "Confirm", "No", "Yes")
					//CHOMPEdit End
				if(confirm != "Yes")
					to_chat(C, "<span class='warning'>[pred] has declined your spawn request.</span>")
					var/message = sanitizeSafe(input(pred,"Do you want to leave them a message?")as text|null)
					if(message)
						to_chat(C, "<span class='notice'>[pred] message : [message]</span>")
				*/
					if(absorb_choice)
						confirm = tgui_alert(pred, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] появиться впитанным в [concat_ru("ваш;;ей;е;и;", vore_spawn_gut, PCASE)]. Разрешить?", "Подтверждение", list("Нет", "Да"), pred.no_latejoin_vore_warning_time SECONDS)
					else
						confirm = alert(pred, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] появиться в [concat_ru("ваш;ем;ей;ем;их;", vore_spawn_gut, PCASE)]. Разрешить?", "Подтверждение", "Нет", "Да")
				if(confirm != "Да")
					to_chat(C, "<span class='warning'>[interact_ru(pred, "отклонил")] ваш запрос на появление.</span>")
					var/message = sanitizeSafe(input(pred,"Хотите ли вы оставить этому игроку сообщение?")as text|null)
					if(message)
						to_chat(C, "<span class='notice'>Сообщение от [gcase_ru(pred)]: [message]</span>")
				// End of Bastion of Endeavor Translation
					return
				if(!vore_spawn_gut || QDELETED(vore_spawn_gut))
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>Somehow, the belly you were trying to enter no longer exists.</span>")
					*/
					to_chat(C, "<span class='warning'>Каким-то образом, орган, в который вы пытаетесь проникнуть, больше не существует.</span>")
					// End of Bastion of Endeavor Translation
					return
				if(pred.stat == UNCONSCIOUS || pred.stat == DEAD)
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>[pred] is not conscious.</span>")
					to_chat(pred, "<span class='warning'>You must be conscious to accept.</span>")
					*/
					to_chat(C, "<span class='warning'>[cap_ru(pred)] не в сознании.</span>")
					to_chat(pred, "<span class='warning'>Чтобы принять запрос, вы должны быть в сознании.</span>")
					// End of Bastion of Endeavor Translation
					return
				if(!(pred.z in using_map.vorespawn_levels))
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>[pred] is no longer in station grounds.</span>")
					to_chat(pred, "<span class='warning'>You must be within station grounds to accept.</span>")
					*/
					to_chat(C, "<span class='warning'>[interact_ru(pred, "больше не наход;ит;ит;ит;ят;ся")] на территории станции.</span>")
					to_chat(pred, "<span class='warning'>Чтобы принять запрос, вы должны быть на территории станции.</span>")
					// End of Bastion of Endeavor Translation
					return
				if(backup)
					addtimer(CALLBACK(src, PROC_REF(m_backup_client), C), 5 SECONDS)
				/* Bastion of Endeavor Translation
				log_admin("[key_name(C)] has vore spawned into [key_name(pred)]")
				message_admins("[key_name(C)] has vore spawned into [key_name(pred)]")
				to_chat(C, "<span class='notice'>You have been spawned via vore. You are free to roleplay how you got there as you please, such as teleportation or having had already been there.</span>")
				if(vore_spawn_gut.entrance_logs) //CHOMPEdit
					to_chat(pred, "<span class='notice'>Your prey has spawned via vore. You are free to roleplay this how you please, such as teleportation or having had already been there.</span>")
				*/
				log_admin("[key_name(C)] появился внутри [key_name(pred)]")
				message_admins("[key_name(C)] появился внутри [key_name(pred)]")
				to_chat(C, "<span class='notice'>Вы появились с помощью Vore. Вы можете отыграть это любым способом, например – вы телепортировались туда, либо там были всё это время.</span>")
				if(vore_spawn_gut.entrance_logs) //CHOMPEdit
					to_chat(pred, "<span class='notice'>Ваша жертва появилась с помощью Vore. Вы можете отыграть это любым способом, например – она телепортировалась туда, либо там была всё это время.</span>")
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				to_chat(C, "<span class='warning'>No predators were available to accept you.</span>")
				*/
				to_chat(C, "<span class='warning'>Не найдены доступные хищники.</span>")
				// End of Bastion of Endeavor Translation
				return
			spawnpos = spawntypes[C.prefs.spawnpoint]
		/* Bastion of Endeavor Translation
		if(C.prefs.spawnpoint == "Vorespawn - Pred") //Same as above, but in reverse!
		*/
		if(C.prefs.spawnpoint == "Появление с помощью Vore – Хищник ") //Same as above, but in reverse!
		// End of Bastion of Endeavor Translation
			var/list/preys = list()
			var/list/prey_names = list() //This is still cringe
			for(var/client/V in GLOB.clients)
				if(!isliving(V.mob))
					continue
				var/mob/living/M = V.mob
				if(M.stat == UNCONSCIOUS || M.stat == DEAD || (M.client.is_afk(10 MINUTES) && !M.no_latejoin_prey_warning)) //CHOMPEdit
					continue
				if(!M.latejoin_prey)
					continue
				if(!(M.z in using_map.vorespawn_levels))
					continue
				preys += M
				prey_names += M.real_name
			if(preys.len)
				/* Bastion of Endeavor Translation
				var/prey_name = input(C, "Choose a Prey to spawn nom.", "Prey Spawnpoint") as null|anything in prey_names
				*/
				var/prey_name = input(C, "Выберите жертву, которую намерены проглотить.", "Появление с помощью Vore") as null|anything in prey_names
				// End of Bastion of Endeavor Translation
				if(!prey_name)
					return
				var/index = prey_names.Find(prey_name)
				var/mob/living/prey = preys[index]
				var/list/available_bellies = list()

				var/datum/vore_preferences/P = C.prefs_vr
				for(var/Y in P.belly_prefs)
					available_bellies += Y["name"]
				/* Bastion of Endeavor Translation
				vore_spawn_gut = input(C, "Choose your Belly.", "Belly Spawnpoint") as null|anything in available_bellies
				*/
				vore_spawn_gut = input(C, "Выберите свой орган.", "Появление с помощью Vore") as null|anything in available_bellies
				// End of Bastion of Endeavor Translation
				if(!vore_spawn_gut)
					return
				/* Bastion of Endeavor Translation
				//CHOMPAdd Start
				if(alert(C, "Do you want to instantly absorb them?", "Confirm", "Yes", "No") == "Yes")
					absorb_choice = TRUE
				//CHOMPAdd End
				to_chat(C, "<b><span class='warning'>[prey] has received your spawn request. Please wait.</span></b>")
				log_admin("[key_name(C)] has requested to pred spawn onto [key_name(prey)]")
				message_admins("[key_name(C)] has requested to pred spawn onto [key_name(prey)]")
				*/
				if(alert(C, "Желаете ли вы мгновенно впитать [verb_ru(prey, "его")]?", "Подтверждение", "Да", "Нет") == "Да")
					absorb_choice = TRUE
				to_chat(C, "<b><span class='warning'>[interact_ru(prey, "получил")] ваш запрос. Пожалуйста, подождите.</span></b>")
				log_admin("[key_name(C)] запросил появиться вокруг [key_name(prey)]")
				message_admins("[key_name(C)] запросил появиться вокруг [key_name(prey)]")
				// End of Bastion of Endeavor Translation

				var/confirm
				if(prey.no_latejoin_prey_warning)
					if(prey.no_latejoin_prey_warning_time > 0)
						//CHOMPEdit Start
						if(absorb_choice)
							/* Bastion of Endeavor Translation
							confirm = tgui_alert(prey, "[C.prefs.real_name] is attempting to televore and instantly absorb you with their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), prey.no_latejoin_prey_warning_time SECONDS)
							*/
							confirm = tgui_alert(prey, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] телепортировать и мгновенно впитать вас в [concat_ru("сво;й;ю;й;и;", vore_spawn_gut, ACASE)]. Разрешить?", "Подтверждение", list("Нет", "Да"), prey.no_latejoin_prey_warning_time SECONDS)
							// End of Bastion of Endeavor Translation
						else
							/* Bastion of Endeavor Translation
							confirm = tgui_alert(prey, "[C.prefs.real_name] is attempting to televore you into their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), prey.no_latejoin_prey_warning_time SECONDS)
							*/
							confirm = tgui_alert(prey, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] телепортировать вас в [concat_ru("сво;й;ю;й;и;", vore_spawn_gut, ACASE)]. Разрешить?", "Подтверждение", list("Нет", "Да"), prey.no_latejoin_prey_warning_time SECONDS)
							// End of Bastion of Endeavor Translation
						//CHOMPEdit End
					if(!confirm)
						/* Bastion of Endeavor Translation
						confirm = "Yes"
						*/
						confirm = "Да"
						// End of Bastion of Endeavor Translation
				else
					//CHOMPEdit Start
					if(absorb_choice)
						/* Bastion of Endeavor Translation
						confirm = alert(prey, "[C.prefs.real_name] is attempting to televore and instantly absorb you with their [vore_spawn_gut]. Let them?", "Confirm", "No", "Yes")
						*/
						confirm = alert(prey, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] телепортировать и мгновенно впитать вас в [concat_ru("сво;й;ю;й;и;", vore_spawn_gut, ACASE)]. Разрешить?", "Подтверждение", "Нет", "Да")
						// End of Bastion of Endeavor Translation
					else
						/* Bastion of Endeavor Translation
						confirm = alert(prey, "[C.prefs.real_name] is attempting to televore you into their [vore_spawn_gut]. Let them?", "Confirm", "No", "Yes")
						*/
						confirm = alert(prey, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] телепортировать вас в [concat_ru("сво;й;ю;й;и;", vore_spawn_gut, ACASE)]. Разрешить?", "Подтверждение", "Нет", "Да")
						// End of Bastion of Endeavor Translation
					//CHOMPEdit End
				/* Bastion of Endeavor Translation
				if(confirm != "Yes")
					to_chat(C, "<span class='warning'>[prey] has declined your spawn request.</span>")
					var/message = sanitizeSafe(input(prey,"Do you want to leave them a message?")as text|null)
					if(message)
						to_chat(C, "<span class='notice'>[prey] message : [message]</span>")
				*/
				if(confirm != "Да")
					to_chat(C, "<span class='warning'>[interact_ru(prey, "отклонил")] ваш запрос на появление.</span>")
					var/message = sanitizeSafe(input(prey,"Хотите ли вы оставить этому игроку сообщение?")as text|null)
					if(message)
						to_chat(C, "<span class='notice'>Сообщение от [gcase_ru(prey)]: [message]</span>")
				// End of Bastion of Endeavor Translation
					return
				if(prey.stat == UNCONSCIOUS || prey.stat == DEAD)
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>[prey] is not conscious.</span>")
					to_chat(prey, "<span class='warning'>You must be conscious to accept.</span>")
					*/
					to_chat(C, "<span class='warning'>[cap_ru(prey)] не в сознании.</span>")
					to_chat(prey, "<span class='warning'>Чтобы принять запрос, вы должны быть в сознании.</span>")
					// End of Bastion of Endeavor Translation
					return
				if(!(prey.z in using_map.vorespawn_levels))
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>[prey] is no longer in station grounds.</span>")
					to_chat(prey, "<span class='warning'>You must be within station grounds to accept.</span>")
					*/
					to_chat(C, "<span class='warning'>[interact_ru(prey, "больше не наход;ит;ит;ит;ят;ся")] на территории станции.</span>")
					to_chat(prey, "<span class='warning'>Чтобы принять запрос, вы должны быть на территории станции.</span>")
					// End of Bastion of Endeavor Translation
					return
				/* Bastion of Endeavor Translation
				log_admin("[key_name(C)] has pred spawned onto [key_name(prey)]")
				message_admins("[key_name(C)] has pred spawned onto [key_name(prey)]")
				*/
				log_admin("[key_name(C)] появился вокруг [key_name(prey)]")
				message_admins("[key_name(C)] появился вокруг [key_name(prey)]")
				// End of Bastion of Endeavor Translation
				prey_to_nomph = prey
			else
				/* Bastion of Endeavor Translation
				to_chat(C, "<span class='warning'>No prey were available to accept you.</span>")
				*/
				to_chat(C, "<span class='warning'>Не найдены доступные жертвы.</span>")
				// End of Bastion of Endeavor Translation
				return
		//CHOMPEdit - Item TF spawnpoints!
		/* Bastion of Endeavor Translation
		else if(C.prefs.spawnpoint == "Item TF spawn")
		*/
		else if(C.prefs.spawnpoint == "Появление в качестве предмета")
		// End of Bastion of Endeavor Translation
			var/list/items = list()
			var/list/item_names = list()
			var/list/carriers = list()
			for(var/obj/item/I in item_tf_spawnpoints)
				if(LAZYLEN(I.ckeys_allowed_itemspawn))
					if(!(C.ckey in I.ckeys_allowed_itemspawn))
						continue
				var/atom/item_loc = I.loc
				var/mob/living/carrier
				while(!isturf(item_loc))
					if(isliving(item_loc))
						carrier = item_loc
						break
					else
						item_loc = item_loc.loc
				if(istype(carrier))
					if(!(carrier.z in using_map.vorespawn_levels))
						continue
					if(carrier.stat == UNCONSCIOUS || carrier.stat == DEAD || carrier.client.is_afk(10 MINUTES))
						continue
					carriers += carrier
				else
					if(!(item_loc.z in using_map.vorespawn_levels))
						continue
					carriers += null

				if(istype(I, /obj/item/capture_crystal))
					if(carrier)
						items += I
						var/obj/item/capture_crystal/cryst = I
						if(cryst.spawn_mob_type)
							/* Bastion of Endeavor Translation
							item_names += "\a [cryst.spawn_mob_name] inside of [carrier]'s [I.name] ([I.loc.name])"
							*/
							item_names += "[cryst.spawn_mob_name] [prep_adv_ru("В", I, PCASE)] [gcase_ru(carrier)] ([I.loc.name])"
							// End of Bastion of Endeavor Translation
						else
							/* Bastion of Endeavor Translation
							item_names += "Inside of [carrier]'s [I.name] ([I.loc.name])"
							*/
							item_names += "Внутри [gcase_ru(I)] [gcase_ru(carrier)] ([I.loc.name])"
							// End of Bastion of Endeavor Translation
				else if(I.name == initial(I.name))
					items += I
					if(carrier)
						/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: fuck this. i hate this. i genuinely, honestly hate this. anyway come back here when we figure out how to handle initial vars
						item_names += "[carrier]'s [I.name] ([I.loc.name])"
						*/
						item_names += "[ncase_ru(I)] [gcase_ru(carrier)] ([I.loc.name])" // unsure how this will go
						// End of Bastion of Endeavor Translation
					else
						/* Bastion of Endeavor Translation
						item_names += "[I.name] ([I.loc.name])"
						*/
						item_names += "[I.name] ([I.loc.name])"
						// End of Bastion of Endeavor Translation
				else
					items += I
					if(carrier)
						/* Bastion of Endeavor Translation
						item_names += "[carrier]'s [I.name] (\a [initial(I.name)] at [I.loc.name])"
						*/
						item_names += "[ncase_ru(I)] [gcase_ru(carrier)] ([ncase_ru(I, secondary = "initial")], [I.loc.name])" // fuck off honestly
						// End of Bastion of Endeavor Translation
					else
						/* Bastion of Endeavor Translation
						item_names += "[I.name] (\a [initial(I.name)] at [I.loc.name])"
						*/
						item_names += "[ncase_ru(I)] ([ncase_ru(I, secondary = "initial")], [I.loc.name])"
						// End of Bastion of Endeavor Translation
			if(LAZYLEN(items))
				/* Bastion of Endeavor Translation
				var/backup = alert(C, "Do you want a mind backup?", "Confirm", "Yes", "No")
				if(backup == "Yes")
					backup = 1
				var/item_name = input(C, "Choose an Item to spawn as.", "Item TF Spawnpoint") as null|anything in item_names
				*/
				var/backup = alert(C, "Хотите ли вы сделать резервную копию разума?", "Подтверждение", "Да", "Нет")
				if(backup == "Да")
					backup = 1
				var/item_name = input(C, "Выберите предмет, в качестве которого хотите появиться.", "Появление в качестве предмета") as null|anything in item_names
				// End of Bastion of Endeavor Translation
				if(!item_name)
					return
				var/index = item_names.Find(item_name)
				var/obj/item/item = items[index]

				var/mob/living/carrier = carriers[index]
				if(istype(carrier))
					/* Bastion of Endeavor Translation
					to_chat(C, "<b><span class='warning'>[carrier] has received your spawn request. Please wait.</span></b>")
					log_and_message_admins("[key_name(C)] has requested to item spawn into [key_name(carrier)]'s possession")

					var/confirm = alert(carrier, "[C.prefs.real_name] is attempting to join as the [item_name] in your possession.", "Confirm", "No", "Yes")
					if(confirm != "Yes")
						to_chat(C, "<span class='warning'>[carrier] has declined your spawn request.</span>")
						var/message = sanitizeSafe(input(carrier,"Do you want to leave them a message?")as text|null)
					*/
					to_chat(C, "<b><span class='warning'>[interact_ru(carrier, "получил")] ваш запрос. Пожалуйста, подождите.</span></b>")
					log_and_message_admins("[key_name(C)] запросил появиться в качестве предмета [key_name(carrier)]")

					var/confirm = alert(carrier, "[C.prefs.real_name] [C.prefs.identifying_gender == PLURAL ? "желают" : "желает"] появиться в качестве вашего предмета – [item_name]. Разрешить?", "Подтверждение", "Нет", "Да")
					if(confirm != "Да")
						to_chat(C, "<span class='warning'>[interact_ru(carrier, "отклонил")] ваш запрос на появление.</span>")
						var/message = sanitizeSafe(input(carrier,"Хотите ли вы оставить этому игроку сообщение?")as text|null)
					// End of Bastion of Endeavor Translation
						if(message)
							/* Bastion of Endeavor Translation
							to_chat(C, "<span class='notice'>[carrier] message : [message]</span>")
							*/
							to_chat(C, "<span class='notice'>Сообщение от [gcase_ru(carrier)]: [message]</span>")
							// End of Bastion of Endeavor Translation
						return
					if(carrier.stat == UNCONSCIOUS || carrier.stat == DEAD)
						/* Bastion of Endeavor Translation
						to_chat(C, "<span class='warning'>[carrier] is not conscious.</span>")
						to_chat(carrier, "<span class='warning'>You must be conscious to accept.</span>")
						*/
						to_chat(C, "<span class='warning'>[cap_ru(carrier)] не в сознании.</span>")
						to_chat(carrier, "<span class='warning'>Чтобы принять запрос, вы должны быть в сознании.</span>")
						// End of Bastion of Endeavor Translation
						return
					if(!(carrier.z in using_map.vorespawn_levels))
						/* Bastion of Endeavor Translation
						to_chat(C, "<span class='warning'>[carrier] is no longer in station grounds.</span>")
						to_chat(carrier, "<span class='warning'>You must be within station grounds to accept.</span>")
						*/
						to_chat(C, "<span class='warning'>[interact_ru(carrier, "больше не наход;ит;ит;ит;ят;ся")] на территории станции.</span>")
						to_chat(carrier, "<span class='warning'>Чтобы принять запрос, вы должны быть на территории станции.</span>")
						// End of Bastion of Endeavor Translation
						return
					/* Bastion of Endeavor Translation
					log_and_message_admins("[key_name(C)] has item spawned onto [key_name(carrier)]")
					*/
					log_and_message_admins("[key_name(C)] появился в качестве предмета [key_name(carrier)]")
					// End of Bastion of Endeavor Translation
					item_to_be = item
					item_carrier = carrier
					if(backup)
						addtimer(CALLBACK(src, PROC_REF(m_backup_client), C), 5 SECONDS)
				else
					/* Bastion of Endeavor Translation
					var/confirm = alert(C, "\The [item.name] is currently not in any character's possession! Do you still want to spawn as it?", "Confirm", "No", "Yes")
					if(confirm != "Yes")
						return
					log_and_message_admins("[key_name(C)] has item spawned into \a [item.name] that was not held by anyone")
					*/
					var/confirm = alert(C, "[interact_ru(item, "на данный момент никому не принадлеж;ит;ит;ит;ат;")]. Вы точно хотите появиться в [verb_ru(item, ";нём;ней;нём;них;")]?", "Подтверждение", "Нет", "Да")
					if(confirm != "Yes")
						return
					log_and_message_admins("[key_name(C)] появился в качестве [gcase_ru(item)], [verb_ru(item, "не принадлежащ;ем;ей;ем;им;")] никому")
					// End of Bastion of Endeavor Translation
					item_to_be = item
					if(backup)
						addtimer(CALLBACK(src, PROC_REF(m_backup_client), C), 5 SECONDS)
				if(istype(item, /obj/item/capture_crystal))
					var/obj/item/capture_crystal/cryst = item
					if(cryst.spawn_mob_type)
						/* Bastion of Endeavor Translation
						var/confirm = alert(C, "Do you want to spawn with your slot's vore organs and prefs?", "Confirm", "No", "Yes")
						if(confirm == "Yes")
						*/
						var/confirm = alert(C, "Появиться со всеми органами Vore и предпочтениями своего текущего слота персонажа?", "Подтверждение", "Нет", "Да")
						if(confirm == "Да")
						// End of Bastion of Endeavor Translation
							vorgans = TRUE
			else
				/* Bastion of Endeavor Translation
				to_chat(C, "<span class='warning'>No items were available to accept you.</span>")
				*/
				to_chat(C, "<span class='warning'>Не найдены доступные предметы для появления.</span>")
				// End of Bastion of Endeavor Translation
				return
		//CHOMPEdit End
		else
			if(!(C.prefs.spawnpoint in using_map.allowed_spawns))
				if(fail_deadly)
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>Your chosen spawnpoint is unavailable for this map and your job requires a specific spawnpoint. Please correct your spawn point choice.</span>")
					*/
					to_chat(C, "<span class='warning'>Выбранная вами и требуемая для вашей должности точка появления недоступна. Пожалуйста, исправьте свой выбор.</span>")
					// End of Bastion of Endeavor Translation
					return
				else
					/* Bastion of Endeavor Translation
					to_chat(C, "<span class='warning'>Your chosen spawnpoint ([C.prefs.spawnpoint]) is unavailable for the current map. Spawning you at one of the enabled spawn points instead.</span>")
					*/
					to_chat(C, "<span class='warning'>Выбранная вами точка появления ([uncapitalize_ru(C.prefs.spawnpoint)]) недоступна на текущей карте. Вы появитесь на одной из доступных точек.</span>")
					// End of Bastion of Endeavor Translation
					spawnpos = null
			else
				spawnpos = spawntypes[C.prefs.spawnpoint]

	//We will return a list key'd by "turf" and "msg"
	. = list("turf","msg", "voreny", "prey", "itemtf", "vorgans", "carrier") //CHOMPEdit - Item TF spawnpoints, spawn as mob
	if(vore_spawn_gut)
		.["voreny"] = vore_spawn_gut
		.["absorb"] = absorb_choice //CHOMPAdd
	if(prey_to_nomph)
		.["prey"] = prey_to_nomph	//We pass this on later to reverse the vorespawn in new_player.dm
	//CHOMPEdit Start - Item TF spawnpoints
	if(item_to_be)
		.["carrier"] = item_carrier
		.["vorgans"] = vorgans
		.["itemtf"] = item_to_be
	//CHOMPEdit End
	if(spawnpos && istype(spawnpos) && spawnpos.turfs.len)
		if(spawnpos.check_job_spawning(rank))
			.["turf"] = spawnpos.get_spawn_position()
			.["msg"] = spawnpos.msg
			.["channel"] = spawnpos.announce_channel
		else
			var/datum/job/J = SSjob.get_job(rank)
			if(fail_deadly || J?.offmap_spawn)
				/* Bastion of Endeavor Translation
				to_chat(C, "<span class='warning'>Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Please correct your spawn point choice.</span>")
				*/
				to_chat(C, "<span class='warning'>Выбранная вами точка появления ([spawnpos.display_name]) недоступна для вашей должности. Пожалуйста, исправьте свой выбор.</span>")
				// End of Bastion of Endeavor Translation
				return
			/* Bastion of Endeavor Translation
			to_chat(C, "<span class='filter_warning'>Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Arrivals shuttle instead.</span>")
			*/
			to_chat(C, "<span class='filter_warning'>Выбранная вами точка появления ([spawnpos.display_name]) недоступна для вашей должности. Вы появитесь у шаттла у прибытия.</span>")
			// End of Bastion of Endeavor Translation
			var/spawning = pick(latejoin)
			.["turf"] = get_turf(spawning)
			/* Bastion of Endeavor Translation
			.["msg"] = "will arrive at the station shortly"
			*/
			.["msg"] = "скоро прибуд;ет;ет;ет;ут; на станцию"
			// End of Bastion of Endeavor Translation
	else if(!fail_deadly)
		var/spawning = pick(latejoin)
		.["turf"] = get_turf(spawning)
		/* Bastion of Endeavor Translation
		.["msg"] = "has arrived on the station"
		*/
		.["msg"] = "прибыл; на станцию;а на станцию;о на станцию;и на станцию;"
		// End of Bastion of Endeavor Translation

/datum/controller/occupations/proc/m_backup_client(var/client/C)	//Same as m_backup, but takes a client entry. Used for vore late joining.
	if(!ishuman(C.mob))
		return
	var/mob/living/carbon/human/CM = C.mob
	SStranscore.m_backup(CM.mind, CM.nif, TRUE)
