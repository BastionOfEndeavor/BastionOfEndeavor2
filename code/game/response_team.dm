//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

var/global/send_emergency_team = 0 // Used for automagic response teams
                                   // 'admin_emergency_team' for admin-spawned response teams
var/ert_base_chance = 10 // Default base chance. Will be incremented by increment ERT chance.
var/can_call_ert
var/silent_ert = 0

/client/proc/response_team()
	/* Bastion of Endeavor Translation
	set name = "Dispatch Emergency Response Team"
	set category = "Fun.Event Kit" //CHOMPEdit
	set desc = "Send an emergency response team to the station"
	*/
	set name = "Отправить ОБР"
	set category = "Веселье.События"
	set desc = "Отправить на станцию отряд быстрого реагирования."
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
	if(send_emergency_team)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>[using_map.boss_name] has already dispatched an emergency response team!</span>")
		*/
		to_chat(usr, "<span class='danger'>Отряд быстрого реагирования уже отправлен!</span>")
		// End of Bastion of Endeavor Translation
		return
	/* Bastion of Endeavor Translation
	if(tgui_alert(usr, "Do you want to dispatch an Emergency Response Team?","ERT",list("Yes","No")) != "Yes")
	*/
	if(tgui_alert(usr, "Вы действительно хотите отправить отряд быстрого реагирования?","ОБР",list("Да","Нет")) != "Да")
	// End of Bastion of Endeavor Translation
		return
	/* Bastion of Endeavor Translation
	if(tgui_alert(usr, "Do you want this Response Team to be announced?","ERT",list("Yes","No")) != "Yes")
	*/
	if(tgui_alert(usr, "Объявить о прибытии ОБР?","ОБР",list("Да","Нет")) != "Да")
	// End of Bastion of Endeavor Translation
		silent_ert = 1
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		/* Bastion of Endeavor Translation
		if(tgui_alert(usr, "The station is not in red alert. Do you still want to dispatch a response team?","ERT",list("Yes","No")) != "Yes")
		*/
		if(tgui_alert(usr, "На станции не красная тревога. Вы уверены в своём решении?","ОБР",list("Да","Нет")) != "Да")
		// End of Bastion of Endeavor Translation
			return
	if(send_emergency_team)
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		*/
		to_chat(usr, "<span class='danger'>Вас кто-то опередил!</span>")
		// End of Bastion of Endeavor Translation
		return

	/* Bastion of Endeavor Translation
	message_admins("[key_name_admin(usr)] is dispatching an Emergency Response Team.", 1)
	admin_chat_message(message = "[key_name(usr)] is dispatching an Emergency Response Team", color = "#CC2222") //VOREStation Add
	log_admin("[key_name(usr)] used Dispatch Response Team.")
	*/
	message_admins("[key_name_admin(usr)] вызвал отряд быстрого реагирования.", 1)
	admin_chat_message(message = "Игрок [key_name(usr)] вызвал отряд быстрого реагирования.", color = "#CC2222") //VOREStation Add
	log_admin("[key_name(usr)] вызвал отряд быстрого реагирования.")
	// End of Bastion of Endeavor Translation
	trigger_armed_response_team(1)

/client/verb/JoinResponseTeam()

	/* Bastion of Endeavor Translation
	set name = "Join Response Team"
	set category = "IC.Event" //CHOMPEdit
	*/
	set name = "Присоединиться к ОБР"
	set category = "IC.События"
	// End of Bastion of Endeavor Translation

	if(!MayRespawn(1))
		/* Bastion of Endeavor Translation
		to_chat(usr, "<span class='warning'>You cannot join the response team at this time.</span>")
		*/
		to_chat(usr, "<span class='warning'>Вы не можете сейчас присоединиться к ОБР.</span>")
		// End of Bastion of Endeavor Translation
		return

	if(istype(usr,/mob/observer/dead) || istype(usr,/mob/new_player))
		if(!send_emergency_team)
			/* Bastion of Endeavor Translation
			to_chat(usr, "No emergency response team is currently being sent.")
			*/
			to_chat(usr, "На станцию не был отправлен отряд быстрого реагирования.")
			// End of Bastion of Endeavor Translation
			return
		if(jobban_isbanned(usr, JOB_SYNDICATE) || jobban_isbanned(usr, JOB_EMERGENCY_RESPONSE_TEAM) || jobban_isbanned(usr, JOB_SECURITY_OFFICER))
			/* Bastion of Endeavor Translation
			to_chat(usr, "<span class='danger'>You are jobbanned from the emergency reponse team!</span>")
			*/
			to_chat(usr, "<span class='danger'>Вам запрещено состоять в отряде быстрого реагирования!</span>")
			// End of Bastion of Endeavor Translation
			return
		if(ert.current_antagonists.len >= ert.hard_cap)
			/* Bastion of Endeavor Translation
			to_chat(usr, "The emergency response team is already full!")
			*/
			to_chat(usr, "Отряд быстрого реагирования уже заполнена!")
			// End of Bastion of Endeavor Translation
			return
		ert.create_default(usr)
	else
		/* Bastion of Endeavor Translation
		to_chat(usr, "You need to be an observer or new player to use this.")
		*/
		to_chat(usr, "Чтобы использовать этот глагол, необходимо быть наблюдателем или не участвовать в раунде.")
		// End of Bastion of Endeavor Translation

// returns a number of dead players in %
/proc/percentage_dead()
	var/total = 0
	var/deadcount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client) // Monkeys and mice don't have a client, amirite?
			if(H.stat == 2) deadcount++
			total++

	if(total == 0) return 0
	else return round(100 * deadcount / total)

// counts the number of antagonists in %
/proc/percentage_antagonists()
	var/total = 0
	var/antagonists = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(is_special_character(H) >= 1)
			antagonists++
		total++

	if(total == 0) return 0
	else return round(100 * antagonists / total)

// Increments the ERT chance automatically, so that the later it is in the round,
// the more likely an ERT is to be able to be called.
/proc/increment_ert_chance()
	while(send_emergency_team == 0) // There is no ERT at the time.
		if(get_security_level() == "green")
			ert_base_chance += 1
		if(get_security_level() == "yellow")
			ert_base_chance += 1
		if(get_security_level() == "violet")
			ert_base_chance += 2
		if(get_security_level() == "orange")
			ert_base_chance += 2
		if(get_security_level() == "blue")
			ert_base_chance += 2
		if(get_security_level() == "red")
			ert_base_chance += 3
		if(get_security_level() == "delta")
			ert_base_chance += 10           // Need those big guns
		sleep(600 * 3) // Minute * Number of Minutes


/proc/trigger_armed_response_team(var/force = 0)
	if(!can_call_ert && !force)
		return
	if(send_emergency_team)
		return

	var/send_team_chance = ert_base_chance // Is incremented by increment_ert_chance.
	send_team_chance += 2*percentage_dead() // the more people are dead, the higher the chance
	send_team_chance += percentage_antagonists() // the more antagonists, the higher the chance
	send_team_chance = min(send_team_chance, 100)

	if(force) send_team_chance = 100

	// there's only a certain chance a team will be sent
	if(!prob(send_team_chance))
		/* Bastion of Endeavor Translation
		command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. Unfortunately, we were unable to send one at this time.", "[using_map.boss_name]")
		*/
		command_announcement.Announce("Мы получили запрос на отправку отряда быстрого реагирования на [station_name_ru(ACASE)]. К сожалению, на данный момент мы не можем его выполнить.", "[command_name_ru(NCASE)]")
		// End of Bastion of Endeavor Translation
		can_call_ert = 0 // Only one call per round, ladies.
		return
	if(silent_ert == 0)
		/* Bastion of Endeavor Translation
		command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. We will prepare and send one as soon as possible.", "[using_map.boss_name]")
		*/
		command_announcement.Announce("Мы получили запрос на отправку отряда быстрого реагирования на [station_name_ru(ACASE)]. Отряд будет немедленно отправлен.", "[command_name_ru(NCASE)]")
		// End of Bastion of Endeavor Translation

	can_call_ert = 0 // Only one call per round, gentleman.
	send_emergency_team = 1
	consider_ert_load() //VOREStation Add

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.
