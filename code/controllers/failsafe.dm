 /**
  * Failsafe
  *
  * Pretty much pokes the MC to make sure it's still alive.
 **/

GLOBAL_REAL(Failsafe, /datum/controller/failsafe) // CHOMPEdit - Managed Globals

/datum/controller/failsafe // This thing pretty much just keeps poking the master controller
	/* Bastion of Endeavor Translation
	name = "Failsafe"
	*/
	name = "Проверочный контроллер"
	// End of Bastion of Endeavor Translation

	// The length of time to check on the MC (in deciseconds).
	// Set to 0 to disable.
	var/processing_interval = 20
	// The alert level. For every failed poke, we drop a DEFCON level. Once we hit DEFCON 1, restart the MC.
	var/defcon = 5
	//the world.time of the last check, so the mc can restart US if we hang.
	//	(Real friends look out for *eachother*)
	var/lasttick = 0

	// Track the MC iteration to make sure its still on track.
	var/master_iteration = 0
	var/running = TRUE

/datum/controller/failsafe/New()
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.
	if(Failsafe != src)
		if(istype(Failsafe))
			qdel(Failsafe)
	Failsafe = src
	Initialize()

/datum/controller/failsafe/Initialize()
	set waitfor = 0
	Failsafe.Loop()
	if(!QDELETED(src))
		qdel(src) //when Loop() returns, we delete ourselves and let the mc recreate us

/datum/controller/failsafe/Destroy()
	running = FALSE
	..()
	return QDEL_HINT_HARDDEL_NOW

/datum/controller/failsafe/proc/Loop()
	while(running)
		lasttick = world.time
		if(!Master)
			// Replace the missing Master! This should never, ever happen.
			new /datum/controller/master()
		// Only poke it if overrides are not in effect.
		if(processing_interval > 0)
			if(Master.processing && Master.iteration)
				// Check if processing is done yet.
				if(Master.iteration == master_iteration)
					log_debug("DEFCON [defcon]: Master.iteration=[Master.iteration] Master.last_run=[Master.last_run] world.time=[world.time]")
					switch(defcon)
						if(4,5)
							--defcon
						if(3)
							/* Bastion of Endeavor Translation
							log_and_message_admins(span_adminnotice("SSfailsafe Notice: DEFCON [defcon_pretty()]. The Master Controller (\ref[Master]) has not fired in the last [(5-defcon) * processing_interval] ticks."))
							*/
							log_and_message_admins(span_adminnotice("Информация SSfailsafe: DEFCON [defcon_pretty()]. Главный контроллер (\ref[Master]) не срабатывает уже [count_ru(((5-defcon) * processing_interval), "тик;;а;ов")]."))
							// End of Bastion of Endeavor Translation
							--defcon
						if(2)
							/* Bastion of Endeavor Translation
							log_and_message_admins(span_boldannounce("SSfailsafe Warning: DEFCON [defcon_pretty()]. The Master Controller (\ref[Master]) has not fired in the last [(5-defcon) * processing_interval] ticks. Automatic restart in [processing_interval] ticks."))
							*/
							log_and_message_admins(span_boldannounce("Предупреждение SSfailsafe: DEFCON [defcon_pretty()]. Главный контроллер (\ref[Master]) не срабатывает уже [count_ru(((5-defcon) * processing_interval), "тик;;а;ов")]. Автоматический перезапуск через [count_ru(processing_interval, "тик;;а;ов")]."))
							// End of Bastion of Endeavor Translation
							--defcon
						if(1)

							/* Bastion of Endeavor Translation
							log_and_message_admins(span_boldannounce("SSfailsafe Warning: DEFCON [defcon_pretty()]. The Master Controller (\ref[Master]) has still not fired within the last [(5-defcon) * processing_interval] ticks. Killing and restarting..."))
							*/
							log_and_message_admins(span_boldannounce("Предупреждение SSfailsafe: DEFCON [defcon_pretty()]. Главный контроллер (\ref[Master]) всё ещё не срабатывает уже [count_ru(((5-defcon) * processing_interval), "тик;;а;ов")]. Производим принудительный перезапуск..."))
							// End of Bastion of Endeavor Translation
							--defcon
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								/* Bastion of Endeavor Translation
								log_and_message_admins(span_adminnotice("SSfailsafe Notice: MC (New:\ref[Master]) restarted successfully"))
								*/
								log_and_message_admins(span_adminnotice("Информация SSfailsafe: ГК (Новый:\ref[Master]) успешно перезапущен."))
								// End of Bastion of Endeavor Translation
							else if(rtn < 0)
								/* Bastion of Endeavor Translation
								log_game("SSfailsafe Notice: Could not restart MC (\ref[Master]), runtime encountered. Entering defcon 0")
								log_and_message_admins(span_boldannounce("SSFAILSAFE ERROR: DEFCON [defcon_pretty()]. Could not restart MC (\ref[Master]), runtime encountered. I will silently keep retrying."))
								*/
								log_game("Предупреждение SSfailsafe: Не удалось перезапустить ГК (\ref[Master]), получен рантайм. Входим в defcon 0.")
								log_and_message_admins(span_boldannounce("ОШИБКА SSFAILSAFE: DEFCON [defcon_pretty()]. Не удалось перезапустить ГК (\ref[Master]), получен рантайм. Продолжаем попытки молча..."))
								// End of Bastion of Endeavor Translation
							//if the return number was 0, it just means the mc was restarted too recently, and it just needs some time before we try again
							//no need to handle that specially when defcon 0 can handle it
						if(0) //DEFCON 0! (mc failed to restart)
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								/* Bastion of Endeavor Translation
								log_and_message_admins(span_adminnotice("SSfailsafe Notice: MC (New:\ref[Master]) restarted successfully"))
								*/
								log_and_message_admins(span_adminnotice("Информация SSfailsafe: ГК (Новый:\ref[Master]) успешно перезапущен."))
								// End of Bastion of Endeavor Translation
				else
					defcon = min(defcon + 1,5)
					master_iteration = Master.iteration
			if (defcon <= 1)
				sleep(processing_interval*2)
			else
				sleep(processing_interval)
		else
			defcon = 5
			sleep(initial(processing_interval))

/datum/controller/failsafe/proc/defcon_pretty()
	return defcon

/datum/controller/failsafe/stat_entry(msg)
	if(!statclick)
		/* Bastion of Endeavor Translation
		statclick = new/obj/effect/statclick/debug(null, "Initializing...", src)
		*/
		statclick = new/obj/effect/statclick/debug(null, "Инициализация...", src)
		// End of Bastion of Endeavor Translation

<<<<<<< HEAD
	/* Bastion of Endeavor Translation
	msg = "Failsafe Controller: [statclick.update("Defcon: [defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])")]" //CHOMPEdit
	*/
	msg = "Проверочный контроллер: [statclick.update("Defcon: [defcon_pretty()] | Интервал: [Failsafe.processing_interval] | Итерация: [Failsafe.master_iteration]")]" //CHOMPEdit
	// End of Bastion of Endeavor Translation
	return msg //CHOMPEdit
=======
	msg = "Failsafe Controller: [statclick.update("Defcon: [defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])")]"
	return msg
>>>>>>> 4d9879937f ([MIRROR] Port tg statpanel (#9242))
