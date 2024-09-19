/datum/preferences
	var/show_in_directory = 1	//Show in Character Directory
	/* Bastion of Endeavor Translation
	var/directory_tag = "Unset" //Sorting tag to use in character directory
	var/directory_erptag = "Unset"	//ditto, but for non-vore scenes
	// CHOMPStation Edit Start: Directory Update
	var/directory_gendertag = "Unset" // Gender stuff!
	var/directory_sexualitytag = "Unset" // Sexuality!
	*/
	var/directory_tag = "Не указано"
	var/directory_erptag = "Не указано"
	var/directory_gendertag = "Не указано"
	var/directory_sexualitytag = "Не указано"
	// End of Bastion of Endeavor Translation
	// CHOMPStation Edit End: Directory Update
	var/directory_ad = ""		//Advertisement stuff to show in character directory.
	var/sensorpref = 5			//Set character's suit sensor level
	var/capture_crystal = 1	//Whether or not someone is able to be caught with capture crystals
	var/auto_backup_implant = FALSE //Whether someone starts with a backup implant or not.
	var/borg_petting = TRUE //Whether someone can be petted as a borg or not.
	var/stomach_vision = TRUE //Whether or not someone can view stomach sprites

	var/job_talon_high = 0
	var/job_talon_med = 0
	var/job_talon_low = 0

//Why weren't these in game toggles already?
<<<<<<< HEAD
/client/verb/toggle_eating_noises()
	/* Bastion of Endeavor Translation
	set name = "Toggle Eating Noises"
	set category = "Preferences.Sounds" //CHOMPEdit
	set desc = "Toggles hearing Vore Eating noises."
	*/
	set name = "Звуки поедания"
	set category = "Предпочтения.Звуки"
	set desc = "Включить или выключить звуки поедания при Vore."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/eating_noises

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear eating related vore noises.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете слышать звуки поедания при Vore.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEatNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_digestion_noises()
	/* Bastion of Endeavor Translation
	set name = "Toggle Digestion Noises"
	set category = "Preferences.Sounds" //CHOMPEdit
	set desc = "Toggles hearing Vore Digestion noises."
	*/
	set name = "Звуки переваривания"
	set category = "Предпочтения.Звуки"
	set desc = "Включить или выключить звуки переваривания при Vore."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/digestion_noises

	toggle_preference(pref_path)

/* Bastion of Endeavor Translation
	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear digestion related vore noises.")
*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете слышать звуки переваривания при Vore.")
// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDigestNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_belch_noises()
	/* Bastion of Endeavor Translation
	set name = "Toggle Audible Belching"
	set category = "Preferences.Sounds" //CHOMPEdit
	set desc = "Toggles hearing audible belches."
	*/
	set name = "Звуки отрыжек"
	set category = "Предпочтения.Звуки"
	set desc = "Включить или выключить звуки отрыжек после Vore."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/belch_noises

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear belching.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете слышать звуки отрыжек после Vore.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TBelchNoise")

/client/verb/toggle_emote_noises()
	/* Bastion of Endeavor Translation
	set name = "Toggle Emote Noises"
	set category = "Preferences.Sounds" //CHOMPEdit
	set desc = "Toggles hearing emote noises."
	*/
	set name = "Звуковые действия"
	set category = "Предпочтения.Звуки"
	set desc = "Включить или заглушить звуковые эффекты действий."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/emote_noises

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear emote-related noises.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете слышать звуки от действий со звуковыми эффектами.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEmoteNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_quiets()
	/* Bastion of Endeavor Translation
	set name = "Toggle Ghost Privacy"
	set category = "Preferences.Chat" //CHOMPEdit
	set desc = "Toggles ghosts being able to see your subtles/whispers."
	*/
	set name = "Секретность от призраков"
	set category = "Предпочтения.Чат"
	set desc = "Переключить скрытность ваших шёпотов и скрытых действий от призраков."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/whisubtle_vis

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "Ghosts will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear subtles/whispers made by you.")
	*/
	to_chat(src, "Ваши скрытые действия и шёпот [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будут видны призракам.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TWhisubtleVis") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_privacyvision()
	/* Bastion of Endeavor Translation
	set name = "Toggle Ghost Private Eyes/ears"
	set category = "Preferences.Admin" //CHOMPEdit
	set desc = "Toggles your ability to see subtles/whispers. Overrides admin status. Respects Ghost Privacy"
	*/
	set name = "Призрачная внимательность"
	set category = "Предпочтения.Администратор"
	set desc = "Переключить вашу возможность видеть чужие скрытые действия шёпот в случаях, когда это разрешено отправителями."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/ghost_see_whisubtle

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "As a ghost, you will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear subtles/whispers made by players.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете видеть скрытые действия или шёпот других игроков, будучи призраком.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TGhostSeeWhisSubtle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

=======
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))
/client/verb/toggle_capture_crystal()
	/* Bastion of Endeavor Translation
	set name = "Toggle Catchable"
	set category = "Preferences.Character" //CHOMPEdit
	set desc = "Toggles being catchable with capture crystals."
	*/
	set name = "Отлавливаемость кристаллами"
	set category = "Предпочтения.Персонаж"
	set desc = "Разрешить или запретить заключение вашего персонажа в кристаллы."
	// End of Bastion of Endeavor Translation

	var/mob/living/L = mob

	if(prefs.capture_crystal)
		/* Bastion of Endeavor Translation
		to_chat(src, "You are no longer catchable.")
		*/
		to_chat(src, "Вас теперь нельзя заключить в кристалл.")
		// End of Bastion of Endeavor Translation
		prefs.capture_crystal = 0
	else
		/* Bastion of Endeavor Translation
		to_chat(src, "You are now catchable.")
		*/
		to_chat(src, "Вас теперь можно заключить в кристалл.")
		// End of Bastion of Endeavor Translation
		prefs.capture_crystal = 1
	if(L && istype(L))
		L.capture_crystal = prefs.capture_crystal
	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TCaptureCrystal") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
<<<<<<< HEAD

/client/verb/toggle_mentorhelp_ping()
	/* Bastion of Endeavor Translation
	set name = "Toggle Mentorhelp Ping"
	set category = "Preferences.Admin" //CHOMPEdit
	set desc = "Toggles the mentorhelp ping"
	*/
	set name = "Звук Помощи ментора"
	set category = "Предпочтения.Администратор"
	set desc = "Включить или выключить звуковое оповещение при получении сообщения в Помощи ментора."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/play_mentorhelp_ping

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "Mentorhelp pings are now [ is_preference_enabled(pref_path) ? "enabled" : "disabled"]")
	*/
	to_chat(src, "Вы [ is_preference_enabled(pref_path) ? "теперь" : "больше не"] будете слышать звуковое оповещение при получении сообщений в Помощи ментора.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TSoundMentorhelps")

/client/verb/toggle_player_tips()
	/* Bastion of Endeavor Translation
	set name = "Toggle Receiving Player Tips"
	set category = "Preferences.Chat" //CHOMPEdit
	set desc = "When toggled on, you receive tips periodically on roleplay and gameplay."
	*/
	set name = "Периодические подсказки"
	set category = "Предпочтения.Чат"
	set desc = "Если эта настройка включена, вы будете получать периодические советы об отыгрыше и игровых механиках."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/player_tips

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "You are [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] periodically receiving advice on gameplay and roleplay.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете получать периодические советы об отыгрыше и игровых механиках.")
	// End of Bastion of Endeavor Translation

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb", "TReceivePlayerTips")

/client/verb/toggle_pain_frequency()
	/* Bastion of Endeavor Translation
	set name = "Toggle Pain Frequency"
	set category = "Preferences.Game" //CHOMPEdit
	set desc = "When toggled on, increases the cooldown of pain messages sent to chat for minor injuries"
	*/
	set name = "Таймер болевых сообщений"
	set category = "Предпочтения.Игра"
	set desc = "Если эта настройка включена, болевые сообщения в чате будут отображаться реже."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/pain_frequency

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "The cooldown between pain messages for minor (under 20/5 injury. Multi-limb injuries are still faster) is now [ (is_preference_enabled(pref_path)) ? "extended" : "default"].")
	*/
	to_chat(src, "Таймер болевых сообщений теперь [ (is_preference_enabled(pref_path)) ? "длиннее" : "в нормальном режиме"] (не действует при ранении нескольких конечностей).")
	// End of Bastion of Endeavor Translation

/client/verb/toggle_automatic_afk()
	/* Bastion of Endeavor Translation
	set name = "Toggle Automatic AFK"
	set category = "Preferences.Game" //CHOMPEdit
	set desc = "When enabled, causes you to be automatically marked as AFK if you are idle for too long."
	*/
	set name = "Автоматический статус AFK"
	set category = "Предпочтения.Игра"
	set desc = "Если эта настройка включена, вы автоматически будете получать статус 'Отошёл' при длительном бездействии."
	// End of Bastion of Endeavor Translation

	var/pref_path = /datum/client_preference/auto_afk

	toggle_preference(pref_path)

	/* Bastion of Endeavor Translation
	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "not"] be automatically marked as AFK if you are idle for ten minutes or more.")
	*/
	to_chat(src, "Вы [ (is_preference_enabled(pref_path)) ? "теперь" : "больше не"] будете получать статус 'Отошёл' (AFK) при длительном бездействии.")
	// End of Bastion of Endeavor Translation
=======
>>>>>>> 2986497a43 ([MIRROR] Revert "Revert "/tg/ preference datums part 1: take two"" (#8929))
