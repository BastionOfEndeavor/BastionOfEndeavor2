//VOREStation Edit - Most of this file has been changed to use the Eris-style PA announcements.
//You'll need to compare externally, or use your best judgement when merging.
/var/datum/announcement/priority/priority_announcement = new(do_log = 0)
/var/datum/announcement/priority/command/command_announcement = new(do_log = 0, do_newscast = 1)

/datum/announcement
	/* Bastion of Endeavor Translation
	var/title = "Attention"
	*/
	var/title = "Внимание"
	// End of Bastion of Endeavor Translation
	var/announcer = ""
	var/log = 0
	var/sound
	var/newscast = 0
	/* Bastion of Endeavor Translation
	var/channel_name = "Station Announcements"
	var/announcement_type = "Announcement"
	*/
	var/channel_name = "Объявления станции"
	var/announcement_type = "Объявление"
	// End of Bastion of Endeavor Translation

/datum/announcement/New(var/do_log = 0, var/new_sound = null, var/do_newscast = 0)
	sound = new_sound
	log = do_log
	newscast = do_newscast

/datum/announcement/priority/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	/* Bastion of Endeavor Translation
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"
	*/
	title = "Важное объявление"
	announcement_type = "Важное объявление"
	// End of Bastion of Endeavor Translation

/datum/announcement/priority/command/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	/* Bastion of Endeavor Translation
	title = "[command_name()] Update"
	announcement_type = "[command_name()] Update"
	*/
	title = "Объявление [command_name_ru(GCASE)]"
	announcement_type = "Объявление [command_name_ru(GCASE)]"
	// End of Bastion of Endeavor Translation

/datum/announcement/priority/security/New(var/do_log = 1, var/new_sound = 'sound/misc/notice2.ogg', var/do_newscast = 0)
	..(do_log, new_sound, do_newscast)
	/* Bastion of Endeavor Translation
	title = "Security Announcement"
	announcement_type = "Security Announcement"
	*/
	title = "Объявление службы безопасности"
	announcement_type = "Объявление службы безопасности"
	// End of Bastion of Endeavor Translation

/datum/announcement/proc/Announce(var/message as text, var/new_title = "", var/new_sound = null, var/do_newscast = newscast, var/msg_sanitized = 0, var/zlevel)
	if(!message)
		return
	var/message_title = new_title ? new_title : title
	var/message_sound = new_sound ? new_sound : sound

	if(!msg_sanitized)
		message = sanitize(message, extra = 0)
		message_title = sanitizeSafe(message_title)

	var/list/zlevels
	if(zlevel)
		zlevels = using_map.get_map_levels(zlevel, TRUE)

	Message(message, message_title, zlevels)
	if(do_newscast)
		NewsCast(message, message_title)
	Sound(message_sound, zlevels)
	Log(message, message_title)

/datum/announcement/proc/Message(message as text, message_title as text, var/list/zlevels)
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, "<h2 class='alert'>[title]</h2>")
			to_chat(M, span_alert("[message]"))
			if (announcer)
				to_chat(M, span_alert(" -[html_encode(announcer)]"))

// You'll need to update these to_world usages if you want to make these z-level specific ~Aro
/datum/announcement/minor/Message(message as text, message_title as text)
	to_world(span_bold("[message]"))

/datum/announcement/priority/Message(message as text, message_title as text)
	to_world("<h1 class='alert'>[message_title]</h1>")
	to_world(span_alert("[message]"))
	if(announcer)
		to_world(span_alert(" -[html_encode(announcer)]"))
	to_world(span_alert("<br>"))

/datum/announcement/priority/command/Message(message as text, message_title as text, var/list/zlevels)
	var/command
	/* Bastion of Endeavor Translation
	command += "<h1 class='alert'>[command_name()] Update</h1>"
	*/
	command += "<h1 class='alert'>Объявление [command_name_ru(GCASE)]</h1>"
	// End of Bastion of Endeavor Translation
	if (message_title)
		command += "<br><h2 class='alert'>[message_title]</h2>"

	command += "<br>[span_alert(message)]<br>"
	command += "<br>"
	for(var/mob/M in player_list)
		if(zlevels && !(get_z(M) in zlevels))
			continue
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			to_chat(M, command)

/datum/announcement/priority/Message(var/message as text, var/message_title as text, var/list/zlevels)
	/* Bastion of Endeavor Translation
	global_announcer.autosay(span_alert("[message_title]:") + " [message]", announcer ? announcer : ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)
	*/
	global_announcer.autosay(span_alert("[message_title]:") + " [message]", announcer ? announcer : ANNOUNCER_NAME, channel = "Общий", zlevels = zlevels)
	// End of Bastion of Endeavor Translation

/datum/announcement/priority/command/Message(var/message as text, var/message_title as text, var/list/zlevels)
	/* Bastion of Endeavor Translation
	global_announcer.autosay(span_alert("[command_name()] - [message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)
	*/
	global_announcer.autosay(span_alert("[command_name_ru(NCASE)] – [message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Общий", zlevels = zlevels)
	// End of Bastion of Endeavor Translation

/datum/announcement/priority/security/Message(var/message as text, var/message_title as text, var/list/zlevels)
	/* Bastion of Endeavor Translation
	global_announcer.autosay(span_alert("[message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Common", zlevels = zlevels)
	*/
	global_announcer.autosay(span_alert("[message_title]:") + " [message]", ANNOUNCER_NAME, channel = "Общий", zlevels = zlevels)
	// End of Bastion of Endeavor Translation

/datum/announcement/proc/NewsCast(var/message as text, var/message_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news = new
	news.channel_name = channel_name
	news.author = announcer
	news.message = message
	news.message_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

/datum/announcement/proc/PlaySound(var/message_sound, var/list/zlevels)
	if(!message_sound)
		return

	for(var/mob/M in player_list)
		if(zlevels && !(M.z in zlevels))
			continue
		if(!istype(M,/mob/new_player) && !isdeaf(M))
			M << message_sound

/datum/announcement/proc/Sound(var/message_sound, var/list/zlevels)
	PlaySound(message_sound, zlevels)

/datum/announcement/proc/Log(message as text, message_title as text)
	if(log)
		/* Bastion of Endeavor Translation
		log_game("[key_name(usr)] has made \a [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] has made \a [announcement_type].", 1)
		*/
		log_game("[key_name(usr)] сделал: [announcement_type]: [message_title] - [message] - [announcer]")
		message_admins("[key_name_admin(usr)] сделал: [announcement_type].", 1)
		// End of Bastion of Endeavor Translation

/proc/GetNameAndAssignmentFromId(var/obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement() // Chomp note - Do not use this.
	/* Bastion of Endeavor Translation
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard \the [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')
	*/
	command_announcement.Announce("На территории [station_name_ru(GCASE)] подтверждена биологическая угроза уровня 7. Всему экипажу необходимо её немедленно ликвидировать.", "Биологическая угроза", new_sound = 'sound/AI/outbreak7.ogg')
	// End of Bastion of Endeavor Translation

/proc/ion_storm_announcement()
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: This might need map-specific gender distinction? I'm not sure if that's something that can be done.
	command_announcement.Announce("It has come to our attention that \the [station_name()] passed through an ion storm.  Please monitor all electronic equipment for malfunctions.", "Anomaly Alert")
	*/
	command_announcement.Announce("До нас дошли сведения, что [station_name_ru(GCASE)] прошла через ионную бурю. Пожалуйста, проверьте все электрические приборы на наличие неисправностей.", "Предупреждение об аномалии")
	// End of Bastion of Endeavor Translation

/* Bastion of Endeavor Translation
/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message, var/channel = "Common", var/zlevel)
*/
/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message, var/channel = "Общий", var/zlevel)
// End of Bastion of Endeavor Translation
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/list/zlevels = zlevel ? using_map.get_map_levels(zlevel, TRUE, om_range = DEFAULT_OVERMAP_RANGE) : null
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		/* Bastion of Endeavor Edit: Needed for proper gendered arrival displays
		AnnounceArrivalSimple(character.real_name, rank, join_message, channel, zlevels)
		*/
		AnnounceArrivalSimple(character, rank, join_message, channel, zlevels)
		// End of Bastion of Endeavor Edit

/* Bastion of Endeavor Translation: It's not as neat as I would have hoped, but I don't expect this to come back to bite me.
/proc/AnnounceArrivalSimple(var/name, var/rank = "visitor", var/join_message = "will arrive at the station shortly", var/channel = "Common", var/list/zlevels)
	global_announcer.autosay("[name], [rank], [join_message].", "Arrivals Announcement Computer", channel, zlevels)
*/
/proc/AnnounceArrivalSimple(var/mob/living/carbon/human/character, var/rank = "Гость", var/join_message = "скоро прибуд;ет;ет;ет;ут; на станцию", var/channel = "Общий", var/list/zlevels)
	global_announcer.autosay("[rank] [character.real_name] [verb_ru(character, join_message)].", "Мониторинг прибытий", channel, zlevels)
// End of Bastion of Endeavor Translation
