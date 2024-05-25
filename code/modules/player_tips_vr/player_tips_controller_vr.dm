/*Main file that controls frequency of OOC player tips
Whether player tips start firing at all is determined by a global preference
Weighted list of player tips held in a separate file.
Controlled by the player_tips subsystem under code/controllers/subsystems/player_tips

*/

/datum/player_tips
	var/min_tip_delay = 45 MINUTES
	var/max_tip_delay = 75 MINUTES
	var/tip_delay = 5 MINUTES //10 minute initial delay for first tip of the day. Timer starts 5 minutes after game starts, plus 5 minutes here. Gets overwritten afterwards
	var/last_tip_time = 0
	var/last_tip = null
	var/list/HasReceived = list() //Tracking who received tips. We let them know how to turn them off if they're not on this list. Stores CKeys until round-end.

//Called every 5 minutes as defined in the subsystem.
/datum/player_tips/proc/send_tips()
	if(world.time > last_tip_time + tip_delay)
		last_tip_time = world.time
		tip_delay = rand(min_tip_delay, max_tip_delay)
		/* Bastion of Endeavor Translation: Kinda janky out of context but this is okay
		var/tip = pick_tip("none") //"none" picks a random topic of advice.
		*/
		var/tip = pick_tip("Любую") //"none" picks a random topic of advice.
		// End of Bastion of Endeavor Translation
		var/stopWhile = 0
		while(tip == last_tip) //Prevent posting the same tip twice in a row if possible, but don't force it.
			/* Bastion of Endeavor Translation
			tip = pick_tip("none")
			*/
			tip = pick_tip("Любую")
			// End of Bastion of Endeavor Translation
			stopWhile = stopWhile + 1
			if(stopWhile >= 10)
				break
		last_tip = tip
		for(var/mob/M in player_list)
			if(M.is_preference_enabled(/datum/client_preference/player_tips))
				if(!M.key && !(M.key in HasReceived))
					/* Bastion of Endeavor Translation
					to_chat(M, SPAN_WARNING("You have periodic player tips enabled. You may turn them off at any time with the Toggle Receiving Player Tips verb in Preferences, or in character set up under the OOC tab!\n Player tips appear every 45-75 minutes."))
					*/
					to_chat(M, SPAN_WARNING("У вас включена рассылка периодических подсказок. Её можно выключить с помощью глагола Периодические подсказки во вкладке Предпочтения или в Редакторе персонажа!\n Подсказки появляются каждые 45-75 минут."))
					// End of Bastion of Endeavor Translation
					HasReceived.Add(M.key)
				tip = GLOB.is_valid_url.Replace(tip,"<span class='linkify'>$1</span>")
				to_chat(M, SPAN_NOTICE("[tip]"))





/mob/living/verb/request_automated_advice()
	/* Bastion of Endeavor Translation
	set name = "Request Automated Advice"
	set desc = "Sends you advice from a list of possibilities. You can choose to request a specific topic."
<<<<<<< HEAD
	*/
	set name = "Запросить периодическую подсказку"
	set desc = "Показать подсказку на выбранную тему."
	// End of Bastion of Endeavor Translation
	set category = "OOC"
=======
	set category = "OOC.Game Settings" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))

	/* Bastion of Endeavor Translation
	var/choice = tgui_input_list(src, "What topic would you like to receive advice on?", "Select Topic", list("none","general","gameplay","roleplay","lore","cancel"))
	if(choice == "cancel")
	*/
	var/choice = tgui_input_list(src, "На какую тему вы хотели бы получить подсказку?", "Выбор темы", list("Любую","Общий совет","Игровой процесс","Ролевой отыгрыш","Сеттинг и лор","Отмена"))
	if(choice == "Отмена")
	// End of Bastion of Endeavor Translation
		return
	var/static/datum/player_tips/player_tips = new
	to_chat(src, SPAN_NOTICE("[GLOB.is_valid_url.Replace(player_tips.pick_tip(choice),"<span class='linkify'>$1</span>")]"))
