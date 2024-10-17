//
// Ticker controls the state of the game, being responsible for round start, game mode, and round end.
//
SUBSYSTEM_DEF(ticker)
	/* Bastion of Endeavor Translation
	name = "Gameticker"
	*/
	name = "Тикер"
	// End of Bastion of Endeavor Translation
	wait = 2 SECONDS
	init_order = INIT_ORDER_TICKER
	priority = FIRE_PRIORITY_TICKER
	flags = SS_NO_TICK_CHECK | SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME // Every runlevel!

	var/const/restart_timeout = 4 MINUTES	// Default time to wait before rebooting in desiseconds.
	var/current_state = GAME_STATE_INIT	// We aren't even at pregame yet // TODO replace with CURRENT_GAME_STATE

	/* Relies upon the following globals (TODO move those in here) */
	// var/master_mode = "extended"		//The underlying game mode (so "secret" or the voted mode).
										// Set by SSvote when VOTE_GAMEMODE finishes.
	// var/round_progressing = 1		//Whether the lobby clock is ticking down.

	var/pregame_timeleft = 0			// Time remaining until game starts in seconds. Set by config
	var/start_immediately = FALSE		// If true there is no lobby phase, the game starts immediately.

	var/hide_mode = FALSE 				// If the true game mode should be hidden (because we chose "secret")
	var/datum/game_mode/mode = null		// The actual gamemode, if selected.

	var/end_game_state = END_GAME_NOT_OVER	// Track where we are ending game/round
	var/restart_timeleft				// Time remaining until restart in desiseconds
	var/last_restart_notify				// world.time of last restart warning.
	var/delay_end = FALSE               // If set, the round will not restart on its own.

	// var/login_music					// music played in pregame lobby // VOREStation Edit - We do music differently

	var/list/datum/mind/minds = list()	// The people in the game. Used for objective tracking.

	var/random_players = FALSE	// If set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	// TODO - Should this go here or in the job subsystem?
	var/triai = FALSE // Global flag for Triumvirate AI being enabled

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	var/round_start_time = 0 //CHOMPEdit

// This global variable exists for legacy support so we don't have to rename every 'ticker' to 'SSticker' yet.
var/global/datum/controller/subsystem/ticker/ticker
/datum/controller/subsystem/ticker/PreInit()
	global.ticker = src // TODO - Remove this! Change everything to point at SSticker intead

/datum/controller/subsystem/ticker/Initialize()
	pregame_timeleft = CONFIG_GET(number/pregame_time) // CHOMPEdit
	/* Bastion of Endeavor Translation
	send2mainirc("Server lobby is loaded and open at byond://[CONFIG_GET(string/serverurl) ? CONFIG_GET(string/serverurl) : (CONFIG_GET(string/server) ? CONFIG_GET(string/server) : "[world.address]:[world.port]")]") // CHOMPEdit
	*/
	send2mainirc("Лобби сервера загружено и открыто по адресу byond://[CONFIG_GET(string/serverurl) ? CONFIG_GET(string/serverurl) : (CONFIG_GET(string/server) ? CONFIG_GET(string/server) : "[world.address]:[world.port]")]") // CHOMPEdit
	// End of Bastion of Endeavor Translation
	SSwebhooks.send(
		WEBHOOK_ROUNDPREP,
		list(
			"map" = station_name(),
			"url" = get_world_url()
		)
	)
	GLOB.autospeaker = new (null, null, null, 1) //Set up Global Announcer
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	switch(current_state)
		if(GAME_STATE_INIT)
			pregame_welcome()
			current_state = GAME_STATE_PREGAME
		if(GAME_STATE_PREGAME)
			pregame_tick()
		if(GAME_STATE_SETTING_UP)
			setup_tick()
		if(GAME_STATE_PLAYING)
			playing_tick()
		if(GAME_STATE_FINISHED)
			post_game_tick()

/datum/controller/subsystem/ticker/proc/pregame_welcome()
	/* Bastion of Endeavor Translation
	to_world("<span class='boldannounce notice'><em>Welcome to the pregame lobby!</em></span>")
	to_world("<span class='boldannounce notice'>Please set up your character and select ready. The round will start in [pregame_timeleft] seconds.</span>")
	*/
	to_world("<span class='boldannounce notice'><em>Добро пожаловать в предыгровое лобби!</em></span>")
	to_world("<span class='boldannounce notice'>Настройте своего персонажа и нажмите \"Готов\". Раунд начнётся через [count_ru(pregame_timeleft, "секунд;у;ы;")].</span>")
	// End of Bastion of Endeavor Translation
	world << sound('sound/misc/server-ready.ogg', volume = 100)

// Called during GAME_STATE_PREGAME (RUNLEVEL_LOBBY)
/datum/controller/subsystem/ticker/proc/pregame_tick()
	if(round_progressing && last_fire)
		pregame_timeleft -= (world.time - last_fire) / (1 SECOND)

	if(start_immediately)
		pregame_timeleft = 0
	else if(SSvote.time_remaining)
		return // vote still going, wait for it.

	// Time to start the game!
	if(pregame_timeleft <= 0)
		current_state = GAME_STATE_SETTING_UP
		Master.SetRunLevel(RUNLEVEL_SETUP)
		if(start_immediately)
			fire() // Don't wait for next tick, do it now!
		return

	if(pregame_timeleft <= CONFIG_GET(number/vote_autogamemode_timeleft) && !SSvote.gamemode_vote_called)
		SSvote.autogamemode() // Start the game mode vote (if we haven't had one already)

// Called during GAME_STATE_SETTING_UP (RUNLEVEL_SETUP)
/datum/controller/subsystem/ticker/proc/setup_tick(resumed = FALSE)
	round_start_time = world.time //otherwise round_start_time would be 0 for the signals
	if(!setup_choose_gamemode())
		// It failed, go back to lobby state and re-send the welcome message
		pregame_timeleft = CONFIG_GET(number/pregame_time) // CHOMPEdit
		SSvote.gamemode_vote_called = FALSE // Allow another autogamemode vote
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		pregame_welcome()
		return
	// If we got this far we succeeded in picking a game mode.  Punch it!
	setup_startgame()
	return

// Formerly the first half of setup() - The part that chooses the game mode.
// Returns 0 if failed to pick a mode, otherwise 1
/datum/controller/subsystem/ticker/proc/setup_choose_gamemode()
	//Create and announce mode
	if(master_mode == "secret")
		src.hide_mode = TRUE

	var/list/runnable_modes = config.get_runnable_modes()
	if((master_mode == "random") || (master_mode == "secret"))
		if(!runnable_modes.len)
			/* Bastion of Endeavor Translation
			to_world("<span class='danger'><B>Unable to choose playable game mode.</B> Reverting to pregame lobby.</span>")
			*/
			to_world("<span class='danger'><B>Не удалось выбрать играбельный режим игры.</B> Возвращаемся в предыгровое лобби.</span>")
			// End of Bastion of Endeavor Translation
			return 0
		if(secret_force_mode != "secret")
			src.mode = config.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = CONFIG_GET(keyed_list/probabilities)[GM.config_tag] // CHOMPEdit
			src.mode = config.gamemode_cache[pickweight(weighted_modes)] // CHOMPEdit
	else
		src.mode = config.pick_mode(master_mode)

	if(!src.mode)
		/* Bastion of Endeavor Translation
		to_world("<span class='danger'>Serious error in mode setup! Reverting to pregame lobby.</span>") //Uses setup instead of set up due to computational context.
		*/
		to_world("<span class='danger'>Серьёзная ошибка в подготовке режима игры! Возвращаемся в предыгровое лобби.</span>")
		// End of Bastion of Endeavor Translation
		return 0

	job_master.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.mode.can_start())
		/* Bastion of Endeavor Translation
		to_world("<span class='danger'><B>Unable to start [mode.name].</B> Not enough players readied, [CONFIG_GET(keyed_list/player_requirements)[mode.config_tag]] players needed. Reverting to pregame lobby.</span>") // CHOMPEdit
		*/
		to_world("<span class='danger'><B>Не удалось запустить режим [mode.name].</B> Готово недостаточно игроков из необходимых, [CONFIG_GET(keyed_list/player_requirements)[mode.config_tag]]. Возвращаемся в предыгровое лобби.</span>") // CHOMPEdit
		// End of Bastion of Endeavor Translation
		mode.fail_setup()
		mode = null
		job_master.ResetOccupations()
		return 0

	if(hide_mode)
		/* Bastion of Endeavor Translation
		to_world("<span class='notice'><B>The current game mode is - Secret!</B></span>")
		*/
		to_world("<span class='notice'><B>Текущий режим игры – секретный!</B></span>")
		// End of Bastion of Endeavor Translation
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				/* Bastion of Endeavor Translation
				to_world("<span class='info'><B>Possibilities:</B> [english_list(tmpmodes, and_text= "; ", comma_text = "; ")]</span>")
				*/
				to_world("<span class='info'><B>Возможны:</B> [english_list(tmpmodes, and_text= ", ", comma_text = ", ")]</span>")
				// End of Bastion of Endeavor Translation
	else
		src.mode.announce()
	return 1

// Formerly the second half of setup() - The part that actually initializes everything and starts the game.
/datum/controller/subsystem/ticker/proc/setup_startgame()
	setup_economy()
	create_characters() //Create player characters and transfer them.
	collect_minds()
	equip_characters()
//	data_core.manifest()

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			/* Bastion of Endeavor Translation
			if (S.name != "AI")
			*/
			if (S.name != "Искусственный интеллект")
			// End of Bastion of Endeavor Translation
				qdel(S)
		/* Bastion of Endeavor Translation
		to_world("<span class='boldannounce notice'><em>Enjoy the game!</em></span>")
		*/
		to_world("<span class='boldannounce notice'><em>Приятной игры!</em></span>")
		// End of Bastion of Endeavor Translation
		world << sound('sound/AI/welcome.ogg') //CHOMPEdit: Reverted to default welcome from Yawn edit
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	var/list/adm = get_admin_counts()
	if(adm["total"] == 0)
		/* Bastion of Endeavor Translation
		send2adminirc("A round has started with no admins online.")
		*/
		send2adminirc("Раунд начался без присутствия админов.")
		// End of Bastion of Endeavor Translation

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	if(CONFIG_GET(flag/sql_enabled)) // CHOMPEdit
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1


// Called during GAME_STATE_PLAYING (RUNLEVEL_GAME)
/datum/controller/subsystem/ticker/proc/playing_tick(resumed = FALSE)
	mode.process() // So THIS is where we run mode.process() huh? Okay

	if(mode.explosion_in_progress)
		return // wait until explosion is done.

	// Calculate if game and/or mode are finished (Complicated by the continuous_rounds config option)
	var/game_finished = FALSE
	var/mode_finished = FALSE
	if (CONFIG_GET(flag/continuous_rounds)) // Game keeps going after mode ends. // CHOMPEdit
		game_finished = (emergency_shuttle.returned() || mode.station_was_nuked)
		mode_finished = ((end_game_state >= END_GAME_MODE_FINISHED) || mode.check_finished()) // Short circuit if already finished.
	else // Game ends when mode does
		game_finished = (mode.check_finished() || (emergency_shuttle.returned() && emergency_shuttle.evac == 1)) || universe_has_ended
		mode_finished = game_finished

	if(game_finished && mode_finished)
		end_game_state = END_GAME_READY_TO_END
		current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)
		INVOKE_ASYNC(src, PROC_REF(declare_completion))
	else if (mode_finished && (end_game_state < END_GAME_MODE_FINISHED))
		end_game_state = END_GAME_MODE_FINISHED // Only do this cleanup once!
		mode.cleanup()
		//call a transfer shuttle vote
		/* Bastion of Endeavor Translation
		to_world("<span class='danger'>The round has ended!</span>")
		*/
		to_world("<span class='danger'>Раунд завершён!</span>")
		// End of Bastion of Endeavor Translation
		SSvote.autotransfer()

// Called during GAME_STATE_FINISHED (RUNLEVEL_POSTGAME)
/datum/controller/subsystem/ticker/proc/post_game_tick()
	switch(end_game_state)
		if(END_GAME_READY_TO_END)
			callHook("roundend")

			if (mode.station_was_nuked)
				/* Bastion of Endeavor Translation
				feedback_set_details("end_proper", "nuke")
				*/
				feedback_set_details("end_proper", "Ядерный взрыв")
				// End of Bastion of Endeavor Translation
				restart_timeleft = 1 MINUTE // No point waiting five minutes if everyone's dead.
				if(!delay_end)
					/* Bastion of Endeavor Translation
					to_world("<span class='notice'><b>Rebooting due to destruction of [station_name()] in [round(restart_timeleft/600)] minute\s.</b></span>")
					*/
					to_world("<span class='notice'><b>Перезагрузка в связи с уничтожением [station_name_ru(GCASE)] через [count_ru(round(restart_timeleft/600), "минут;у;ы;")].</b></span>")
					// End of Bastion of Endeavor Translation
					last_restart_notify = world.time
			else
				/* Bastion of Endeavor Translation
				feedback_set_details("end_proper", "proper completion")
				*/
				feedback_set_details("end_proper", "Нормальное завершение")
				// End of Bastion of Endeavor Translation
				restart_timeleft = restart_timeout

			if(blackbox)
				blackbox.save_all_data_to_sql()	// TODO - Blackbox or statistics subsystem

			end_game_state = END_GAME_ENDING
			return
		if(END_GAME_ENDING)
			restart_timeleft -= (world.time - last_fire)
			if(delay_end)
				/* Bastion of Endeavor Translation
				to_world("<span class='notice'><b>An admin has delayed the round end.</b></span>")
				*/
				to_world("<span class='notice'><b>Администратор отложил завершение раунда.</b></span>")
				// End of Bastion of Endeavor Translation
				end_game_state = END_GAME_DELAYED
			else if(restart_timeleft <= 0)
				/* Bastion of Endeavor Translation
				to_world("<span class='warning'><b>Restarting world!</b></span>")
				*/
				to_world("<span class='warning'><b>Производится перезапуск мира!</b></span>")
				// End of Bastion of Endeavor Translation
				sleep(5)
				world.Reboot()
			else if (world.time - last_restart_notify >= 1 MINUTE)
				/* Bastion of Endeavor Translation
				to_world("<span class='notice'><b>Restarting in [round(restart_timeleft/600, 1)] minute\s.</b></span>")
				*/
				to_world("<span class='notice'><b>Перезапуск мира через [count_ru(round(restart_timeleft/600, 1), "минут;у;ы;")].</b></span>")
				// End of Bastion of Endeavor Translation
				last_restart_notify = world.time
			return
		if(END_GAME_DELAYED)
			restart_timeleft -= (world.time - last_fire)
			if(!delay_end)
				end_game_state = END_GAME_ENDING
		else
			/* Bastion of Endeavor Translation
			log_error("Ticker arrived at round end in an unexpected endgame state '[end_game_state]'.")
			*/
			log_error("Тикер принял конец раунда с неожиданным состоянием игры '[end_game_state]'.")
			// End of Bastion of Endeavor Translation
			end_game_state = END_GAME_READY_TO_END


// ----------------------------------------------------------------------
// These two below are not used! But they could be

// Use these preferentially to directly examining ticker.current_state to help prepare for transition to ticker as subsystem!

/datum/controller/subsystem/ticker/proc/PreRoundStart()
	return (current_state < GAME_STATE_PLAYING)

/datum/controller/subsystem/ticker/proc/IsSettingUp()
	return (current_state == GAME_STATE_SETTING_UP)

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return (current_state == GAME_STATE_PLAYING)

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return (current_state >= GAME_STATE_PLAYING)

// ------------------------------------------------------------------------
// HELPER PROCS!
// ------------------------------------------------------------------------

//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
	if( cinematic )	return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 100
	cinematic.plane = PLANE_PLAYER_HUD
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	var/obj/structure/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && (T.z in using_map.station_levels))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.set_stat(DEAD)
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.set_stat(DEAD)

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				// Bastion of Endeavor TODO: Leaving these for now. Come back to this when localizing antags/gamemodes.
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			world << sound('sound/effects/explosionfar.ogg')


		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in living_mob_list)
				if(M.loc.z in using_map.station_levels)
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)	qdel(cinematic)		//end the cinematic
	if(temp_buckle)	qdel(temp_buckle)	//release everybody
	return


/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/new_player/player in player_list)
		if(player && player.ready && player.mind?.assigned_role)
			var/datum/job/J = SSjob.get_job(player.mind.assigned_role)

			// Ask their new_player mob to spawn them
			if(!player.spawn_checks_vr(player.mind.assigned_role))
				var/datum/job/job_datum = job_master.GetJob(J.title)
				job_datum.current_positions--
				player.mind.assigned_role = null
				continue //VOREStation Add

			// Snowflakey AI treatment
			if(J?.mob_type & JOB_SILICON_AI)
				player.close_spawn_windows()
				player.AIize(move = TRUE)
				continue

			var/mob/living/carbon/human/new_char = player.create_character()

			// Created their playable character, delete their /mob/new_player
			if(new_char)
				qdel(player)
				if(new_char.client)
					var/obj/screen/splash/S = new(new_char.client, TRUE)
					S.Fade(TRUE)
					new_char.client.init_verbs()

			// If they're a carbon, they can get manifested
			if(J?.mob_type & JOB_CARBON)
				data_core.manifest_inject(new_char)

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			minds += player.mind


/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == JOB_SITE_MANAGER)
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				job_master.EquipRank(player, player.mind.assigned_role, 0)
				UpdateFactionList(player)
				//equip_custom_items(player)	//VOREStation Removal
				//player.apply_traits() //VOREStation Removal
		//VOREStation Addition Start
		if(player.client)
			if(player.client.prefs.auto_backup_implant)
				var/obj/item/weapon/implant/backup/imp = new(src)

				if(imp.handle_implant(player,player.zone_sel.selecting))
					imp.post_implant(player)
		//VOREStation Addition End
	if(captainless)
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				/* Bastion of Endeavor Translation
				to_chat(M, "<span class='notice'>Site Management is not forced on anyone.</span>")
				*/
				to_chat(M, "<span class='notice'>Менеджер объекта на данный момент отсутствует.</span>")
				// End of Bastion of Endeavor Translation


/datum/controller/subsystem/ticker/proc/declare_completion()
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: This is cheap af and will need changing after we get localized gamemodes. (one day)
	to_world("<span class='filter_system'><br><br><br><H1>A round of [mode.name] has ended!</H1></span>")
	*/
	to_world("<span class='filter_system'><br><br><br><H1>[mode.name] раунд окончен!</H1></span>")
	// End of Bastion of Endeavor Translation
	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(emergency_shuttle.departed && emergency_shuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						/* Bastion of Endeavor Translation
						to_chat(Player, "<span class='filter_system'>[span_blue("<b>You survived the round, but remained on [station_name()] as [Player.real_name].</b>")]</span>")
						*/
						to_chat(Player, "<span class='filter_system'>[span_blue("<b>[Player.real_name] успешно [verb_ru(Player, "пережил")] смену, однако [verb_ru(Player, "остал;ся;ась;ось;ись;")] на территории [station_name_ru(GCASE)].</b>")]</span>")
						// End of Bastion of Endeavor Translation
					else
						/* Bastion of Endeavor Translation
						to_chat(Player, "<span class='filter_system'>[span_green("<b>You managed to survive the events on [station_name()] as [Player.real_name].</b>")]</span>")
						*/
						to_chat(Player, "<span class='filter_system'>[span_green("<b>[Player.real_name] успешно [verb_ru(Player, "пережил")] события на [station_name_ru(PCASE)].</b>")]</span>")
						// End of Bastion of Endeavor Translation
				else if(isAdminLevel(playerTurf.z))
					/* Bastion of Endeavor Translation
					to_chat(Player, "<span class='filter_system'>[span_green("<b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b>")]</span>")
					*/
					to_chat(Player, "<span class='filter_system'>[span_green("<b>[Player.real_name] успешно [verb_ru(Player, "завершил")] трансфер экипажа после событий на [station_name_ru(PCASE)].</b>")]</span>")
					// End of Bastion of Endeavor Translation
				else if(issilicon(Player))
					/* Bastion of Endeavor Translation
					to_chat(Player, "<span class='filter_system'>[span_green("<b>You remain operational after the events on [station_name()] as [Player.real_name].</b>")]</span>")
					*/
					to_chat(Player, "<span class='filter_system'>[span_green("<b>[Player.real_name] [verb_ru(Player, "сохранил")] исправность после событий на [station_name_ru(PCASE)].</b>")]</span>")
					// End of Bastion of Endeavor Translation
				else
					/* Bastion of Endeavor Translation
					to_chat(Player, "<span class='filter_system'>[span_blue("<b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b>")]</span>")
					*/
					to_chat(Player, "<span class='filter_system'>[span_blue("<b>[Player.real_name] [verb_ru(Player, "пропустил")] трансфер экипажа после событий на [station_name_ru(PCASE)].</b>")]</span>")
					// End of Bastion of Endeavor Translation
			else
				if(istype(Player,/mob/observer/dead))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						/* Bastion of Endeavor Translation
						to_chat(Player, "<span class='filter_system'>[span_red("<b>You did not survive the events on [station_name()]...</b>")]</span>")
						*/
						to_chat(Player, "<span class='filter_system'>[span_red("<b>[Player.real_name] не [verb_ru(Player, "пережил")] события, произошедшие на [station_name_ru(PCASE)]...</b>")]</span>")
						// End of Bastion of Endeavor Translation
				else
					/* Bastion of Endeavor Translation
					to_chat(Player, "<span class='filter_system'>[span_red("<b>You did not survive the events on [station_name()]...</b>")]</span>")
					*/
					to_chat(Player, "<span class='filter_system'>[span_red("<b>[Player.real_name] не [verb_ru(Player, "пережил")] события, произошедшие на [station_name_ru(PCASE)]...</b>")]</span>")
					// End of Bastion of Endeavor Translation
	to_world("<br>")

	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			/* Bastion of Endeavor Translation
			to_world("<span class='filter_system'><b>[aiPlayer.name]'s laws at the end of the round were:</b></span>") // VOREStation edit
			*/
			to_world("<span class='filter_system'><b>Перечень законов [gcase_ru(aiPlayer)] к концу раунда был следующим:</b></span>") // VOREStation edit
			// End of Bastion of Endeavor Translation
		else
			/* Bastion of Endeavor Translation
			to_world("<span class='filter_system'><b>[aiPlayer.name]'s laws when it was deactivated were:</b></span>") // VOREStation edit
			*/
			to_world("<span class='filter_system'><b>Перечень законов [gcase_ru(aiPlayer)] на момент деактивации был следующим:</b></span>") // VOREStation edit
			// End of Bastion of Endeavor Translation
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			/* Bastion of Endeavor Translation
			var/robolist = "<b>The AI's loyal minions were:</b> "
			*/
			var/robolist = "<b>[aiPlayer.connected_robots==1? "Верный миньон ИИ:" : "Верными миньонами ИИ были"]</b> "
			// End of Bastion of Endeavor Translation
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				/* Bastion of Endeavor Translation
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"  // VOREStation edit
				*/
				robolist += "[robo.name][robo.stat?" ([verb_ru(robo, "Деактивирован;;а;о;ы;")]), ":", "]"  // VOREStation edit
				// End of Bastion of Endeavor Translation
			to_world("<span class='filter_system'>[robolist]</span>")

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in mob_list)

		if(istype(robo, /mob/living/silicon/robot/platform))
			var/mob/living/silicon/robot/platform/tank = robo
			if(!tank.has_had_player)
				continue

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				/* Bastion of Endeavor Translation: Probably going to stick to name vars as well
				to_world("<span class='filter_system'><b>[robo.name] survived as an AI-less stationbound synthetic! Its laws were:</b></span>") // VOREStation edit
				*/
				to_world("<span class='filter_system'><b>[robo.name] [verb_ru(robo, "выжил")], будучи станционным синтетиком без ИИ. [verb_ru(robo, ";Его;Её;Его;Их;")] перечень законов:</b></span>") // VOREStation edit
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				to_world("<span class='filter_system'><b>[robo.name] was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:</b></span>") // VOREStation edit
				*/
				to_world("<span class='filter_system'><b>[robo.name] не [verb_ru(robo, "смог;;ла;ло;ли;;")] пережить события на станции, будучи станционным синтетиком без ИИ. [verb_ru(robo, ";Его;Её;Его;Их;")] перечень законов:</b></span>") // VOREStation edit
				// End of Bastion of Endeavor Translation

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		/* Bastion of Endeavor Translation
		to_world("<span class='filter_system'><b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b></span>")
		*/
		to_world("<span class='filter_system'><b>На момент конца раунда [dronecount>1 ? "было активно" : "был активен"] [count_ru(dronecount, ";ремонтный дрон;ремонтных дрона;ремонтных дронов")].</b></span>")
		// End of Bastion of Endeavor Translation

	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	/* Bastion of Endeavor Translation
	log_game("Antagonists at round end were...")
	*/
	log_game("[total_antagonists.len == 1? "Антагонистом на момент конца раунда был..." : "Антагонистами на момент конца раунда были..."]")
	// End of Bastion of Endeavor Translation
	for(var/i in total_antagonists)
		// Bastion of Endeavor TODO: What the hell is this
		log_game("[i]s[total_antagonists[i]].")

	SSdbcore.SetRoundEnd() // CHOMPEdit

	return 1

/datum/controller/subsystem/ticker/stat_entry(msg)
	switch(current_state)
		if(GAME_STATE_INIT)
			..()
		if(GAME_STATE_PREGAME) // RUNLEVEL_LOBBY
			/* Bastion of Endeavor Translation
			msg = "START [round_progressing ? "[round(pregame_timeleft)]s" : "(PAUSED)"]"
			*/
			msg = "| НАЧАЛО [round_progressing ? "[round(pregame_timeleft)]с" : "(ПАУЗА)"]"
			// End of Bastion of Endeavor Translation
		if(GAME_STATE_SETTING_UP) // RUNLEVEL_SETUP
			/* Bastion of Endeavor Translation
			msg = "SETUP"
			*/
			msg = "| ПОДГОТОВКА"
			// End of Bastion of Endeavor Translation
		if(GAME_STATE_PLAYING) // RUNLEVEL_GAME
			/* Bastion of Endeavor Translation
			msg = "GAME"
			*/
			msg = "| ИГРА"
			// End of Bastion of Endeavor Translation
		if(GAME_STATE_FINISHED) // RUNLEVEL_POSTGAME
			switch(end_game_state)
				if(END_GAME_MODE_FINISHED)
					/* Bastion of Endeavor Translation
					msg = "MODE OVER, WAITING"
					*/
					msg = "| РЕЖИМ ЗАВЕРШЁН, ОЖИДАЕМ"
					// End of Bastion of Endeavor Translation
				if(END_GAME_READY_TO_END)
					/* Bastion of Endeavor Translation
					msg = "ENDGAME PROCESSING"
					*/
					msg = "| ОБРАБОТКА КОНЦА ИГРЫ"
					// End of Bastion of Endeavor Translation
				if(END_GAME_ENDING)
					/* Bastion of Endeavor Translation
					msg = "END IN [round(restart_timeleft/10)]s"
					*/
					msg = "| КОНЕЦ ЧЕРЕЗ [round(restart_timeleft/10)]с"
					// End of Bastion of Endeavor Translation
				if(END_GAME_DELAYED)
					/* Bastion of Endeavor Translation
					msg = "END PAUSED"
					*/
					msg = "| КОНЕЦ ОТЛОЖЕН"
					// End of Bastion of Endeavor Translation
				else
					/* Bastion of Endeavor Translation
					msg = "ENDGAME ERROR:[end_game_state]"
					*/
					msg = "| ОШИБКА СОСТОЯНИЯ:[end_game_state]"
					// End of Bastion of Endeavor Translation
	return ..()

/datum/controller/subsystem/ticker/Recover()
	flags |= SS_NO_INIT // Don't initialize again

	current_state = SSticker.current_state
	mode = SSticker.mode
	pregame_timeleft = SSticker.pregame_timeleft

	end_game_state = SSticker.end_game_state
	delay_end = SSticker.delay_end
	restart_timeleft = SSticker.restart_timeleft

	minds = SSticker.minds

	random_players = SSticker.random_players

	round_start_time = SSticker.round_start_time
