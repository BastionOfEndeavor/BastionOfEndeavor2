//Based on the ERT setup

var/global/send_beruang = 0
var/can_call_traders = 1

/client/proc/trader_ship()
	/* Bastion of Endeavor Translation
	set name = "Dispatch Beruang Trader Ship"
	set category = "Fun.Event Kit" //CHOMPEdit
	set desc = "Invite players to join the Beruang."
	*/
	set name = "Отправить Беруанг"
	set category = "Особые глаголы"
	set desc = "Пригласить игроков присоединиться к Беруангу."
	// End of Bastion of Endeavor Translation

	if(!holder)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		*/
		to_chat(usr, "<span class='danger'>Эта команда доступна только администраторам.</span>")
		// End of Bastion of Endeavor Translation
		return
	if(!ticker)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>The game hasn't started yet!</span>")
		*/
		to_chat(usr, "<span class='danger'>Игра ещё не началась!</span>")
		// End of Bastion of Endeavor Translation
		return
	if(ticker.current_state == 1)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		*/
		to_chat(usr, "<span class='danger'>Раунд ещё не начался!</span>")
		// End of Bastion of Endeavor Translation
		return
	if(send_beruang)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>The Beruang has already been sent this round!</span>")
		*/
		to_chat(usr, "<span class='danger'>Беруанг уже был отправлен в этом раунде!</span>")
		// End of Bastion of Endeavor Translation
		return
	/* Bastion of Endeavor Translation
	if(tgui_alert(usr, "Do you want to dispatch the Beruang trade ship?","Trade Ship",list("Yes","No")) != "Yes")
	*/
	if(tgui_alert(usr, "Вы действительно хотите отправить торговое судно Беруанг?","Торговое судно",list("Да","Нет")) != "Да")
	// End of Bastion of Endeavor Translation
		return
	if(get_security_level() == "red") // Allow admins to reconsider if the alert level is Red
		/* Bastion of Endeavor Translation
		switch(tgui_alert(usr, "The station is in red alert. Do you still want to send traders?","Trade Ship",list("Yes","No")))
			if("No")
		*/
		switch(tgui_alert(usr, "На станции красная тревога. Вы уверены, что хотите отправить торговцев?","Торговое судно",list("Да","Нет")))
			if("Нет")
		// End of Bastion of Endeavor Translation
				return
	if(send_beruang)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		*/
		to_chat(usr, "<span class='danger'>Вас кто-то опередил!</span>")
		// End of Bastion of Endeavor Translation
		return

	/* Bastion of Endeavor Translation
	message_admins("[key_name_admin(usr)] is dispatching the Beruang.", 1)
	log_admin("[key_name(usr)] used Dispatch Beruang Trader Ship.")
	*/
	message_admins("[key_name_admin(usr)] отправил торговое судно Беруанг.", 1)
	log_admin("[key_name(usr)] отправил торговое судно Беруанг.")
	// End of Bastion of Endeavor Translation
	trigger_trader_visit()

/client/verb/JoinTraders()

	/* Bastion of Endeavor Translation
	set name = "Join Trader Visit"
<<<<<<< HEAD
	*/
	set name = "Присоединиться к торговцам"
	// End of Bastion of Endeavor Translation
	set category = "IC"
=======
	set category = "IC.Event" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))

	if(!MayRespawn(1))
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='warning'>You cannot join the traders.</span>")
		*/
		to_chat(usr, "<span class='warning'>Вы не можете сейчас присоединиться к торговцам.</span>")
		// End of Bastion of Endeavor Translation
		return

	if(istype(usr,/mob/observer/dead) || istype(usr,/mob/new_player))
		if(!send_beruang)
			/* Bastion of Endeavor Translation
			to_chat(usr, "The Beruang is not currently heading to the station.")
			*/
			to_chat(usr, "Судно Беруанг сейчас не держит курс на станцию.")
			// End of Bastion of Endeavor Translation
			return
		if(traders.current_antagonists.len >= traders.hard_cap)
			/* Bastion of Endeavor Translation
			to_chat(usr, "The number of trader slots is already full!")
			*/
			to_chat(usr, "На судне больше нет места!")
			// End of Bastion of Endeavor Translation
			return
		traders.create_default(usr)
	else
		/* Bastion of Endeavor Translation
		to_chat(usr, "You need to be an observer or new player to use this.")
		*/
		to_chat(usr, "Чтобы использовать этот глагол, необходимо быть наблюдателем или не участвовать в раунде.")
		// End of Bastion of Endeavor Translation

/proc/trigger_trader_visit()
	if(!can_call_traders)
		return
	if(send_beruang)
		return

	/* Bastion of Endeavor Translation: Cutting down on english letters when able
	command_announcement.Announce("Incoming cargo hauler: Beruang (Reg: VRS 22EB1F11C2).", "[station_name()] Traffic Control")
	*/
	command_announcement.Announce("К объекту приближается перевозчик груза: судно Беруанг (регистрационный номер ВРС 22А1Е11О2).", "Мониторинг трафика [station_name_ru(GCASE)]")
	// End of Bastion of Endeavor Translation

	can_call_traders = 0 // Only one call per round.
	send_beruang = 1
	consider_trader_load() //VOREStation Add

	sleep(600 * 5)
	send_beruang = 0 // Can no longer join the traders.
