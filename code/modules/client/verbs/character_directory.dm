GLOBAL_DATUM(character_directory, /datum/character_directory)

/client/verb/show_character_directory()
	/* Bastion of Endeavor Translation
	set name = "Character Directory"
	set category = "OOC.Game" //CHOMPEdit
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."
	*/
	set name = "Список персонажей"
	set category = "OOC"
	set desc = "Показать список персонажей на станции вместе с их заметками ООС, описаниями внешности и т.д."
	// End of Bastion of Endeavor Translation

	// This is primarily to stop malicious users from trying to lag the server by spamming this verb
	if(!usr.checkMoveCooldown())
		/* Bastion of Endeavor Translation: this one is weird because it prevents you from using this verb while moving
		to_chat(usr, "<span class='warning'>Don't spam character directory refresh.</span>")
		*/
		to_chat(usr, "<span class='warning'>Список персонажей не может быть открыт многократно или во время передвижения.</span>")
		// End of Bastion of Endeavor Translation
		return
	usr.setMoveCooldown(10)

	if(!GLOB.character_directory)
		GLOB.character_directory = new
	GLOB.character_directory.tgui_interact(mob)


// This is a global singleton. Keep in mind that all operations should occur on usr, not src.
/datum/character_directory
/datum/character_directory/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/character_directory/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		/* Bastion of Endeavor Translation
		ui = new(user, src, "CharacterDirectory", "Character Directory")
		*/
		ui = new(user, src, "CharacterDirectory", "Список персонажей")
		// End of Bastion of Endeavor Translation
		ui.open()

/datum/character_directory/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	if (user?.mind)
		data["personalVisibility"] = user.mind.show_in_directory
		/* Bastion of Endeavor Translation
		data["personalTag"] = user.mind.directory_tag || "Unset"
		data["personalErpTag"] = user.mind.directory_erptag || "Unset"
		data["personalEventTag"] = vantag_choices_list[user.mind.vantag_preference] //CHOMPEdit
		data["personalGenderTag"] = user.mind.directory_gendertag || "Unset" // CHOMPStation Edit: Character Directory Update
		data["personalSexualityTag"] = user.mind.directory_sexualitytag || "Unset" // CHOMPStation Edit: Character Directory Update
		*/
		data["personalTag"] = user.mind.directory_tag || "Не указано"
		data["personalErpTag"] = user.mind.directory_erptag || "Не указано"
		data["personalEventTag"] = vantag_choices_list[user.mind.vantag_preference]
		data["personalGenderTag"] = user.mind.directory_gendertag || "Не указано"
		data["personalSexualityTag"] = user.mind.directory_sexualitytag || "Не указано"
		// End of Bastion of Endeavor Translation
	else if (user?.client?.prefs)
		/* Bastion of Endeavor Translation
		data["personalVisibility"] = user.client.prefs.show_in_directory
		data["personalTag"] = user.client.prefs.directory_tag || "Unset"
		data["personalErpTag"] = user.client.prefs.directory_erptag || "Unset"
		data["personalEventTag"] = vantag_choices_list[user.client.prefs.vantag_preference] //CHOMPEdit
		data["personalGenderTag"] = user.client.prefs.directory_gendertag || "Unset" // CHOMPStation Edit: Character Directory Update
		data["personalSexualityTag"] = user.client.prefs.directory_sexualitytag || "Unset" // CHOMPStation Edit: Character Directory Update
		*/
		data["personalVisibility"] = user.client.prefs.show_in_directory
		data["personalTag"] = user.client.prefs.directory_tag || "Не указано"
		data["personalErpTag"] = user.client.prefs.directory_erptag || "Не указано"
		data["personalEventTag"] = vantag_choices_list[user.client.prefs.vantag_preference]
		data["personalGenderTag"] = user.client.prefs.directory_gendertag || "Не указано"
		data["personalSexualityTag"] = user.client.prefs.directory_sexualitytag || "Не указано"
		// End of Bastion of Endeavor Translation

	return data

/datum/character_directory/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/directory_mobs = list()
	for(var/client/C in GLOB.clients)
		// Allow opt-out.
		if(C?.mob?.mind ? !C.mob.mind.show_in_directory : !C?.prefs?.show_in_directory)
			continue

		// These are the three vars we're trying to find
		// The approach differs based on the mob the client is controlling
		var/name = null
		var/species = null
		var/ooc_notes = null
		//CHOMPEdit Start
		var/ooc_notes_favs = null
		var/ooc_notes_likes = null
		var/ooc_notes_maybes = null
		var/ooc_notes_dislikes = null
		var/ooc_notes_style = null
		var/gendertag = null
		var/sexualitytag = null
		var/eventtag = vantag_choices_list[VANTAG_NONE]
		//CHOMPEdit End
		var/flavor_text = null
		var/tag
		var/erptag
		var/character_ad
		if (C.mob?.mind) //could use ternary for all three but this is more efficient
			/* Bastion of Endeavor Translation
			tag = C.mob.mind.directory_tag || "Unset"
			erptag = C.mob.mind.directory_erptag || "Unset"
			character_ad = C.mob.mind.directory_ad
			//CHOMPEdit Start
			gendertag = C.mob.mind.directory_gendertag || "Unset"
			sexualitytag = C.mob.mind.directory_sexualitytag || "Unset"
			eventtag = vantag_choices_list[C.mob.mind.vantag_preference]
			//CHOMPEdit End
			*/
			tag = C.mob.mind.directory_tag || "Не указано"
			erptag = C.mob.mind.directory_erptag || "Не указано"
			character_ad = C.mob.mind.directory_ad
			//CHOMPEdit Start
			gendertag = C.mob.mind.directory_gendertag || "Не указано"
			sexualitytag = C.mob.mind.directory_sexualitytag || "Не указано"
			eventtag = vantag_choices_list[C.mob.mind.vantag_preference]
			//CHOMPEdit End
			// End of Bastion of Endeavor Translation
		else
			/* Bastion of Endeavor Translation
			tag = C.prefs.directory_tag || "Unset"
			erptag = C.prefs.directory_erptag || "Unset"
			character_ad = C.prefs.directory_ad
			//CHOMPEdit Start
			gendertag = C.prefs.directory_gendertag || "Unset"
			sexualitytag = C.prefs.directory_sexualitytag || "Unset"
			eventtag = vantag_choices_list[C.prefs.vantag_preference]
			//CHOMPEdit End
			*/
			tag = C.prefs.directory_tag || "Не указано"
			erptag = C.prefs.directory_erptag || "Не указано"
			character_ad = C.prefs.directory_ad
			//CHOMPEdit Start
			gendertag = C.prefs.directory_gendertag || "Не указано"
			sexualitytag = C.prefs.directory_sexualitytag || "Не указано"
			eventtag = vantag_choices_list[C.prefs.vantag_preference]
			//CHOMPEdit End
			// End of Bastion of Endeavor Translation

		if(ishuman(C.mob))
			var/mob/living/carbon/human/H = C.mob
			var/strangername = H.real_name //CHOMPEdit
			if(data_core && data_core.general)
				if(!find_general_record("name", H.real_name))
					if(!find_record("name", H.real_name, data_core.hidden_general)) //CHOMPEdit
						/* Bastion of Endeavor Translation
						strangername = "unknown" //CHOMPEdit
						*/
						strangername = "Имя неизвестно" //CHOMPEdit
						// End of Bastion of Endeavor Translation
			name = strangername
			species = "[H.custom_species ? H.custom_species : H.species.name]"
			ooc_notes = H.ooc_notes
			//CHOMPEdit Start
			if(H.ooc_notes_style && (H.ooc_notes_favs || H.ooc_notes_likes || H.ooc_notes_maybes || H.ooc_notes_dislikes))
				ooc_notes = H.ooc_notes + "\n\n"
				ooc_notes_favs = H.ooc_notes_favs
				ooc_notes_likes = H.ooc_notes_likes
				ooc_notes_maybes = H.ooc_notes_maybes
				ooc_notes_dislikes = H.ooc_notes_dislikes
				ooc_notes_style = H.ooc_notes_style
			else
				/* Bastion of Endeavor Translation
				if(H.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[H.ooc_notes_favs]"
				if(H.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[H.ooc_notes_likes]"
				if(H.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[H.ooc_notes_maybes]"
				if(H.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[H.ooc_notes_dislikes]"
				*/
				if(H.ooc_notes_favs)
					ooc_notes += "\n\nЛЮБИМОЕ\n\n[H.ooc_notes_favs]"
				if(H.ooc_notes_likes)
					ooc_notes += "\n\nНРАВИТСЯ\n\n[H.ooc_notes_likes]"
				if(H.ooc_notes_maybes)
					ooc_notes += "\n\nНЕОДНОЗНАЧНО\n\n[H.ooc_notes_maybes]"
				if(H.ooc_notes_dislikes)
					ooc_notes += "\n\nНЕ НРАВИТСЯ\n\n[H.ooc_notes_dislikes]"
				// End of Bastion of Endeavor Translation
			if(LAZYLEN(H.flavor_texts))
				flavor_text = H.flavor_texts["general"]
			//CHOMPEdit End

		if(isAI(C.mob))
			var/mob/living/silicon/ai/A = C.mob
			name = A.name
			/* Bastion of Endeavor Translation
			species = "Artificial Intelligence"
			*/
			species = "Искусственный интеллект"
			// End of Bastion of Endeavor Translation
			ooc_notes = A.ooc_notes
			//CHOMPEdit Start
			if(A.ooc_notes_style && (A.ooc_notes_favs || A.ooc_notes_likes || A.ooc_notes_maybes || A.ooc_notes_dislikes))
				ooc_notes = A.ooc_notes + "\n\n"
				ooc_notes_favs = A.ooc_notes_favs
				ooc_notes_likes = A.ooc_notes_likes
				ooc_notes_maybes = A.ooc_notes_maybes
				ooc_notes_dislikes = A.ooc_notes_dislikes
				ooc_notes_style = A.ooc_notes_style
			else
				/* Bastion of Endeavor Translation
				if(A.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[A.ooc_notes_favs]"
				if(A.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[A.ooc_notes_likes]"
				if(A.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[A.ooc_notes_maybes]"
				if(A.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[A.ooc_notes_dislikes]"
				*/
				if(A.ooc_notes_favs)
					ooc_notes += "\n\nЛЮБИМОЕ\n\n[A.ooc_notes_favs]"
				if(A.ooc_notes_likes)
					ooc_notes += "\n\nНРАВИТСЯ\n\n[A.ooc_notes_likes]"
				if(A.ooc_notes_maybes)
					ooc_notes += "\n\nНЕОДНОЗНАЧНО\n\n[A.ooc_notes_maybes]"
				if(A.ooc_notes_dislikes)
					ooc_notes += "\n\nНЕ НРАВИТСЯ\n\n[A.ooc_notes_dislikes]"
				// End of Bastion of Endeavor Translation
			//CHOMPEdit End

			flavor_text = null // No flavor text for AIs :c

		if(isrobot(C.mob))
			var/mob/living/silicon/robot/R = C.mob
			if(R.scrambledcodes || (R.module && R.module.hide_on_manifest))
				continue
			name = R.name
			species = "[R.modtype] [R.braintype]"
			ooc_notes = R.ooc_notes
			//CHOMPEdit Start
			if(R.ooc_notes_style && (R.ooc_notes_favs || R.ooc_notes_likes || R.ooc_notes_maybes || R.ooc_notes_dislikes))
				ooc_notes = R.ooc_notes + "\n\n"
				ooc_notes_favs = R.ooc_notes_favs
				ooc_notes_likes = R.ooc_notes_likes
				ooc_notes_maybes = R.ooc_notes_maybes
				ooc_notes_dislikes = R.ooc_notes_dislikes
				ooc_notes_style = R.ooc_notes_style
			else
				/* Bastion of Endeavor Translation
				if(R.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[R.ooc_notes_favs]"
				if(R.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[R.ooc_notes_likes]"
				if(R.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[R.ooc_notes_maybes]"
				if(R.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[R.ooc_notes_dislikes]"
				*/
				if(R.ooc_notes_favs)
					ooc_notes += "\n\nЛЮБИМОЕ\n\n[R.ooc_notes_favs]"
				if(R.ooc_notes_likes)
					ooc_notes += "\n\nНРАВИТСЯ\n\n[R.ooc_notes_likes]"
				if(R.ooc_notes_maybes)
					ooc_notes += "\n\nНЕОДНОЗНАЧНО\n\n[R.ooc_notes_maybes]"
				if(R.ooc_notes_dislikes)
					ooc_notes += "\n\nНЕ НРАВИТСЯ\n\n[R.ooc_notes_dislikes]"
				// End of Bastion of Endeavor Translation
			//CHOMPEdit End

			flavor_text = R.flavor_text

		//CHOMPEdit Start
		if(istype(C.mob, /mob/living/silicon/pai))
			var/mob/living/silicon/pai/P = C.mob
			name = P.name
			/* Bastion of Endeavor Translation
			species = "pAI"
			*/
			species = "Персональный ИИ"
			// End of Bastion of Endeavor Translation
			ooc_notes = P.ooc_notes
			if(P.ooc_notes_style && (P.ooc_notes_favs || P.ooc_notes_likes || P.ooc_notes_maybes || P.ooc_notes_dislikes))
				ooc_notes = P.ooc_notes + "\n\n"
				ooc_notes_favs = P.ooc_notes_favs
				ooc_notes_likes = P.ooc_notes_likes
				ooc_notes_maybes = P.ooc_notes_maybes
				ooc_notes_dislikes = P.ooc_notes_dislikes
				ooc_notes_style = P.ooc_notes_style
			else
				/* Bastion of Endeavor Translation
				if(P.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[P.ooc_notes_favs]"
				if(P.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[P.ooc_notes_likes]"
				if(P.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[P.ooc_notes_maybes]"
				if(P.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[P.ooc_notes_dislikes]"
				*/
				if(P.ooc_notes_favs)
					ooc_notes += "\n\nЛЮБИМОЕ\n\n[P.ooc_notes_favs]"
				if(P.ooc_notes_likes)
					ooc_notes += "\n\nНРАВИТСЯ\n\n[P.ooc_notes_likes]"
				if(P.ooc_notes_maybes)
					ooc_notes += "\n\nНЕОДНОЗНАЧНО\n\n[P.ooc_notes_maybes]"
				if(P.ooc_notes_dislikes)
					ooc_notes += "\n\nНЕ НРАВИТСЯ\n\n[P.ooc_notes_dislikes]"
				// End of Bastion of Endeavor Translation
			flavor_text = P.flavor_text

		if(istype(C.mob, /mob/living/simple_mob))
			var/mob/living/simple_mob/S = C.mob
			name = S.name
			species = S.character_directory_species()
			ooc_notes = S.ooc_notes
			if(S.ooc_notes_style && (S.ooc_notes_favs || S.ooc_notes_likes || S.ooc_notes_maybes || S.ooc_notes_dislikes))
				ooc_notes = S.ooc_notes + "\n\n"
				ooc_notes_favs = S.ooc_notes_favs
				ooc_notes_likes = S.ooc_notes_likes
				ooc_notes_maybes = S.ooc_notes_maybes
				ooc_notes_dislikes = S.ooc_notes_dislikes
				ooc_notes_style = S.ooc_notes_style
			else
				/* Bastion of Endeavor Translation
				if(S.ooc_notes_favs)
					ooc_notes += "\n\nFAVOURITES\n\n[S.ooc_notes_favs]"
				if(S.ooc_notes_likes)
					ooc_notes += "\n\nLIKES\n\n[S.ooc_notes_likes]"
				if(S.ooc_notes_maybes)
					ooc_notes += "\n\nMAYBES\n\n[S.ooc_notes_maybes]"
				if(S.ooc_notes_dislikes)
					ooc_notes += "\n\nDISLIKES\n\n[S.ooc_notes_dislikes]"
				*/
				if(S.ooc_notes_favs)
					ooc_notes += "\n\nЛЮБИМОЕ\n\n[S.ooc_notes_favs]"
				if(S.ooc_notes_likes)
					ooc_notes += "\n\nНРАВИТСЯ\n\n[S.ooc_notes_likes]"
				if(S.ooc_notes_maybes)
					ooc_notes += "\n\nНЕОДНОЗНАЧНО\n\n[S.ooc_notes_maybes]"
				if(S.ooc_notes_dislikes)
					ooc_notes += "\n\nНЕ НРАВИТСЯ\n\n[S.ooc_notes_dislikes]"
				// End of Bastion of Endeavor Translation
			flavor_text = S.desc
		//CHOMPEdit End

		// It's okay if we fail to find OOC notes and flavor text
		// But if we can't find the name, they must be using a non-compatible mob type currently.
		if(!name)
			continue

		directory_mobs.Add(list(list(
			"name" = name,
			"species" = species,
			//CHOMPEdit Start
			"ooc_notes_favs" = ooc_notes_favs,
			"ooc_notes_likes" = ooc_notes_likes,
			"ooc_notes_maybes" = ooc_notes_maybes,
			"ooc_notes_dislikes" = ooc_notes_dislikes,
			"ooc_notes_style" = ooc_notes_style,
			"gendertag" = gendertag,
			"sexualitytag" = sexualitytag,
			"eventtag" = eventtag,
			//CHOMPEdit End
			"ooc_notes" = ooc_notes,
			"tag" = tag,
			"erptag" = erptag,
			"character_ad" = character_ad,
			"flavor_text" = flavor_text,
		)))

	data["directory"] = directory_mobs

	return data


/datum/character_directory/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	if(action == "refresh")
		// This is primarily to stop malicious users from trying to lag the server by spamming this verb
		if(!usr.checkMoveCooldown())
			/* Bastion of Endeavor Translation: This one is weird because it prevents you from accessing character directory while moving
			to_chat(usr, "<span class='warning'>Don't spam character directory refresh.</span>")
			*/
			to_chat(usr, "<span class='warning'>Список персонажей не может быть открыт многократно или в течение передвижения.</span>")
			// End of Bastion of Endeavor Translation
			return
		usr.setMoveCooldown(10)
		update_tgui_static_data(usr, ui)
		return TRUE
	else
		return check_for_mind_or_prefs(usr, action, params["overwrite_prefs"])

/datum/character_directory/proc/check_for_mind_or_prefs(mob/user, action, overwrite_prefs)
	if (!user.client)
		return
	var/can_set_prefs = overwrite_prefs && !!user.client.prefs
	var/can_set_mind = !!user.mind
	if (!can_set_prefs && !can_set_mind)
		if (!overwrite_prefs && !!user.client.prefs)
			/* Bastion of Endeavor Translation
			to_chat(user, "<span class='warning'>You cannot change these settings if you don't have a mind to save them to. Enable overwriting prefs and switch to a slot you're fine with overwriting.</span>")
			*/
			to_chat(user, "<span class='warning'>Вы не можете изменять эти настройки, не имея разума для их сохранения. Разрешите перезапись предпочтений и переключитесь на слот, в который вы хотите сохранить изменения.</span>")
			// End of Bastion of Endeavor Translation
		return
	switch(action)
		if ("setTag")
			/* Bastion of Endeavor Translation
			var/list/new_tag = tgui_input_list(usr, "Pick a new Vore tag for the character directory", "Character Tag", GLOB.char_directory_tags)
			*/
			var/list/new_tag = tgui_input_list(usr, "Укажите свои предпочтения относительно сцен с Vore:", "Предпочтения Vore", GLOB.char_directory_tags)
			// End of Bastion of Endeavor Translation
			if(!new_tag)
				return
			return set_for_mind_or_prefs(user, action, new_tag, can_set_prefs, can_set_mind)
		if ("setErpTag")
			/* Bastion of Endeavor Tranvscode-file://vscode-app/c:/Program%20Files/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.htmlslation
			var/list/new_erptag = tgui_input_list(usr, "Pick a new ERP tag for the character directory", "Character ERP Tag", GLOB.char_directory_erptags)
			*/
			var/list/new_erptag = tgui_input_list(usr, "Укажите свои предпочтения относительно сцен с ERP:", "Предпочтения ERP", GLOB.char_directory_erptags)
			// End of Bastion of Endeavor Translation
			if(!new_erptag)
				return
			return set_for_mind_or_prefs(user, action, new_erptag, can_set_prefs, can_set_mind)
		if ("setVisible")
			var/visible = TRUE
			if (can_set_mind)
				visible = user.mind.show_in_directory
			else if (can_set_prefs)
				visible = user.client.prefs.show_in_directory
			/* Bastion of Endeavor Translation
			to_chat(usr, "<span class='notice'>You are now [!visible ? "shown" : "not shown"] in the directory.</span>")
			*/
			to_chat(usr, "<span class='notice'>Ваш персонаж теперь [!visible ? "будет" : "не будет"] отображаться в списке.</span>")
			// End of Bastion of Endeavor Translation
			return set_for_mind_or_prefs(user, action, !visible, can_set_prefs, can_set_mind)
		if ("editAd")
			var/current_ad = (can_set_mind ? usr.mind.directory_ad : null) || (can_set_prefs ? usr.client.prefs.directory_ad : null)
			/* Bastion of Endeavor Translation
			var/new_ad = sanitize(tgui_input_text(usr, "Change your character ad", "Character Ad", current_ad, multiline = TRUE, prevent_enter = TRUE), extra = 0)
			*/
			var/new_ad = sanitize(tgui_input_text(usr, "Введите своё объявление для списка персонажей:", "Объявление в списке", current_ad, multiline = TRUE, prevent_enter = TRUE), extra = 0)
			// End of Bastion of Endeavor Translation
			if(isnull(new_ad))
				return
			return set_for_mind_or_prefs(user, action, new_ad, can_set_prefs, can_set_mind)
		// CHOMPStation Edit Start: Directory Update
		if("setGenderTag")
			/* Bastion of Endeavor Translation
			var/list/new_gendertag = tgui_input_list(usr, "Pick a new Gender tag for the character directory. This is YOUR gender, not what you prefer.", "Character Gender Tag", GLOB.char_directory_gendertags)
			*/
			var/list/new_gendertag = tgui_input_list(usr, "Укажите гендер вашего персонажа.", "Гендер персонажа", GLOB.char_directory_gendertags)
			// End of Bastion of Endeavor Translation
			if(!new_gendertag)
				return
			return set_for_mind_or_prefs(user, action, new_gendertag, can_set_prefs, can_set_mind)
		if("setSexualityTag")
			/* Bastion of Endeavor Translation
			var/list/new_sexualitytag = tgui_input_list(usr, "Pick a new Sexuality/Orientation tag for the character directory", "Character Sexuality/Orientation Tag", GLOB.char_directory_sexualitytags)
			*/
			var/list/new_sexualitytag = tgui_input_list(usr, "Укажите ориентацию вашего персонажа.", "Ориентация персонажа", GLOB.char_directory_sexualitytags)
			// End of Bastion of Endeavor Translation
			if(!new_sexualitytag)
				return
			return set_for_mind_or_prefs(user, action, new_sexualitytag, can_set_prefs, can_set_mind)
		if("setEventTag")
			var/list/names_list = list()
			for(var/C in vantag_choices_list)
				names_list[vantag_choices_list[C]] = C
			/* Bastion of Endeavor Translation
			var/list/new_eventtag = input(usr, "Pick your preference for event involvement", "Event Preference Tag", usr?.client?.prefs?.vantag_preference) as null|anything in names_list
			*/
			var/list/new_eventtag = input(usr, "Укажите желаемую роль при участии в событиях.", "Участие в событиях", usr?.client?.prefs?.vantag_preference) as null|anything in names_list
			// End of Bastion of Endeavor Translation
			if(!new_eventtag)
				return
			return set_for_mind_or_prefs(user, action, names_list[new_eventtag], can_set_prefs, can_set_mind)
		//CHOMPEdit end

/datum/character_directory/proc/set_for_mind_or_prefs(mob/user, action, new_value, can_set_prefs, can_set_mind)
	can_set_prefs &&= !!user.client.prefs
	can_set_mind &&= !!user.mind
	if (!can_set_prefs && !can_set_mind)
		/* Bastion of Endeavor Translation
		to_chat(user, "<span class='warning'>You seem to have lost either your mind, or your current preferences, while changing the values.[action == "editAd" ? " Here is your ad that you wrote. [new_value]" : null]</span>")
		*/
		to_chat(user, "<span class='warning'>Ошибка: пока вы изменяли предпочтения, затерялась запись о ваших настройках или разума персонажа.[action == "editAd" ? " Вот, что вы написали. [new_value]" : null]</span>")
		// End of Bastion of Endeavor Translation
		return
	switch(action)
		if ("setTag")
			if (can_set_prefs)
				user.client.prefs.directory_tag = new_value
			if (can_set_mind)
				user.mind.directory_tag = new_value
			return TRUE
		if ("setErpTag")
			if (can_set_prefs)
				user.client.prefs.directory_erptag = new_value
			if (can_set_mind)
				user.mind.directory_erptag = new_value
			return TRUE
		if ("setVisible")
			if (can_set_prefs)
				user.client.prefs.show_in_directory = new_value
			if (can_set_mind)
				user.mind.show_in_directory = new_value
			return TRUE
		if ("editAd")
			if (can_set_prefs)
				user.client.prefs.directory_ad = new_value
			if (can_set_mind)
				user.mind.directory_ad = new_value
			return TRUE
		//CHOMPEdit Start
		if ("setEventTag")
			if (can_set_prefs)
				user.client.prefs.vantag_preference = new_value
			if (can_set_mind)
				user.mind.vantag_preference = new_value
		if ("setGenderTag")
			if (can_set_prefs)
				user.client.prefs.directory_gendertag = new_value
			if (can_set_mind)
				user.mind.directory_gendertag = new_value
		if ("setSexualityTag")
			if (can_set_prefs)
				user.client.prefs.directory_sexualitytag = new_value
			if (can_set_mind)
				user.mind.directory_sexualitytag = new_value
		//CHOMPEdit End
