#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3

#define ORGANICS	1
#define SYNTHETICS	2

var/global/list/valid_bloodreagents = list("default","iron","copper","phoron","silver","gold","slimejelly")	//allowlist-based so people don't make their blood restored by alcohol or something really silly. use reagent IDs!

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

	var/custom_say = null
	var/custom_whisper = null
	var/custom_ask = null
	var/custom_exclaim = null

	var/list/custom_heat = list()
	var/list/custom_cold = list()

	var/list/pos_traits	= list()	// What traits they've selected for their custom species
	var/list/neu_traits = list()
	var/list/neg_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = 0
	var/max_traits = MAX_SPECIES_TRAITS
	var/dirty_synth = 0		//Are you a synth
	var/gross_meatbag = 0		//Where'd I leave my Voight-Kampff test kit?

// Bastion of Endeavor TODO: I have literally no idea how to go about this just yet and will look at this later
/datum/preferences/proc/get_custom_bases_for_species(var/new_species)
	if (!new_species)
		new_species = species
	var/list/choices
	var/datum/species/spec = GLOB.all_species[new_species]
	if (spec.selects_bodytype == SELECTS_BODYTYPE_SHAPESHIFTER)
		choices = spec.get_valid_shapeshifter_forms()
		choices = choices.Copy()
	else if (spec.selects_bodytype == SELECTS_BODYTYPE_CUSTOM)
		choices = GLOB.custom_species_bases.Copy()
		if(new_species != SPECIES_CUSTOM)
			choices = (choices | new_species)
	return choices

/datum/category_item/player_setup_item/vore/traits/proc/get_html_for_trait(var/datum/trait/trait, var/list/trait_prefs = null)
	. = ""
	if (!LAZYLEN(trait.has_preferences))
		return
	. = "<br><ul>"
	var/altered = FALSE
	if (!LAZYLEN(trait_prefs))
		trait_prefs = trait.get_default_prefs()
		altered = TRUE
	for (var/identifier in trait.has_preferences)
		var/pref_list = trait.has_preferences[identifier] //faster
		if (LAZYLEN(pref_list) >= 2)
			if (!(identifier in trait_prefs))
				trait_prefs[identifier] = trait.default_value_for_pref(identifier) //won't be called at all often
				altered = TRUE
			. += "<li>- [pref_list[2]]:"
			var/link = " <a href='?src=\ref[src];clicked_trait_pref=[trait.type];pref=[identifier]'>"
			switch (pref_list[1])
				if (1) //TRAIT_PREF_TYPE_BOOLEAN
					/* Bastion of Endeavor Translation: Tricky to localize for all traits at once
					. += link + (trait_prefs[identifier] ? "Enabled" : "Disabled")
					*/
					. += link + (trait_prefs[identifier] ? "Включить" : "Выключить")
					// End of Bastion of Endeavor Translation
				if (2) //TRAIT_PREF_TYPE_COLOR
					/* Bastion of Endeavor Translation
					. += " " + color_square(hex = trait_prefs[identifier]) + link + "Change"
				if (3) //TRAIT_PREF_TYPE_STRING - CHOMPEdit
					var/string = trait_prefs[identifier]
					. += link + (length(string) > 0 ? string : "\[Empty\]")
					*/
					. += " " + color_square(hex = trait_prefs[identifier]) + link + "Изменить"
				if (3) //TRAIT_PREF_TYPE_STRING - CHOMPEdit
					var/string = trait_prefs[identifier]
					. += link + (length_char(string) > 0 ? string : "\[Пусто\]")
					// End of Bastion of Endeavor Translation
			. += "</a></li>"
	. += "</ul>"
	if (altered)
		switch(trait.category)
			if (1) //TRAIT_TYPE_POSITIVE
				pref.pos_traits[trait.type] = trait_prefs
			if (0) //TRAIT_TYPE_NEUTRAL
				pref.neu_traits[trait.type] = trait_prefs
			if (-1)//TRAIT_TYPE_NEGATIVE
				pref.neg_traits[trait.type] = trait_prefs

/datum/category_item/player_setup_item/vore/traits/proc/get_pref_choice_from_trait(var/mob/user, var/datum/trait/trait, var/preference)
	if (!trait || !preference)
		return
	var/list/trait_prefs
	var/datum/trait/instance = all_traits[trait]
	var/list/traitlist
	switch(instance.category)
		if (1)
			traitlist = pref.pos_traits
		if (0)
			traitlist = pref.neu_traits
		if (-1)
			traitlist = pref.neg_traits
	if (!LAZYLEN(instance.has_preferences) || !(preference in instance.has_preferences) || !traitlist)
		return
	if (!LAZYLEN(traitlist[trait]))
		traitlist[trait] = instance.get_default_prefs()
	trait_prefs = traitlist[trait]
	if (!(preference in trait_prefs))
		trait_prefs[preference] = instance.default_value_for_pref(preference) //won't be called at all often
	switch(instance.has_preferences[preference][1])
		if (1) //TRAIT_PREF_TYPE_BOOLEAN
			trait_prefs[preference] = !trait_prefs[preference]
		if (2) //TRAIT_PREF_TYPE_COLOR
			/* Bastion of Endeavor Translation
			var/new_color = input(user, "Choose the color for this trait preference:", "Trait Preference", trait_prefs[preference]) as color|null
			*/
			var/new_color = input(user, "Выберите цвет для этой способности:", "Выбор цвета", trait_prefs[preference]) as color|null
			// End of Bastion of Endeavor Translation
			if (new_color)
				trait_prefs[preference] = new_color
		if (3) //TRAIT_PREF_TYPE_STRING - CHOMPEdit
			/* Bastion of Endeavor Translation
			var/new_string = instance.apply_sanitization_to_string(preference, tgui_input_text(user, "What should the new value be?", instance.has_preferences[preference][2], trait_prefs[preference], MAX_NAME_LEN))
			*/
			var/new_string = instance.apply_sanitization_to_string(preference, tgui_input_text(user, "Введите новое значение:", instance.has_preferences[preference][2], trait_prefs[preference], MAX_NAME_LEN))
			// End of Bastion of Endeavor Translation
			trait_prefs[preference] = new_string

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/traits
	name = "Traits"
	sort_order = 7

/datum/category_item/player_setup_item/vore/traits/load_character(var/savefile/S)
	S["custom_species"]	>> pref.custom_species
	S["custom_base"]	>> pref.custom_base
	S["pos_traits"]		>> pref.pos_traits
	S["neu_traits"]		>> pref.neu_traits
	S["neg_traits"]		>> pref.neg_traits
	S["blood_color"]	>> pref.blood_color
	S["blood_reagents"]		>> pref.blood_reagents

	S["traits_cheating"]	>> pref.traits_cheating
	S["max_traits"]		>> pref.max_traits
	S["trait_points"]	>> pref.starting_trait_points

	S["custom_say"]		>> pref.custom_say
	S["custom_whisper"]	>> pref.custom_whisper
	S["custom_ask"]		>> pref.custom_ask
	S["custom_exclaim"]	>> pref.custom_exclaim

	S["custom_heat"]	>> pref.custom_heat
	S["custom_cold"]	>> pref.custom_cold

/datum/category_item/player_setup_item/vore/traits/save_character(var/savefile/S)
	S["custom_species"]	<< pref.custom_species
	S["custom_base"]	<< pref.custom_base
	S["pos_traits"]		<< pref.pos_traits
	S["neu_traits"]		<< pref.neu_traits
	S["neg_traits"]		<< pref.neg_traits
	S["blood_color"]	<< pref.blood_color
	S["blood_reagents"]		<< pref.blood_reagents

	S["traits_cheating"]	<< pref.traits_cheating
	S["max_traits"]		<< pref.max_traits
	S["trait_points"]	<< pref.starting_trait_points

	S["custom_say"]		<< pref.custom_say
	S["custom_whisper"]	<< pref.custom_whisper
	S["custom_ask"]		<< pref.custom_ask
	S["custom_exclaim"]	<< pref.custom_exclaim

	S["custom_heat"]	<< pref.custom_heat
	S["custom_cold"]	<< pref.custom_cold

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.pos_traits) pref.pos_traits = list()
	if(!pref.neu_traits) pref.neu_traits = list()
	if(!pref.neg_traits) pref.neg_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, default="#A10808")
	pref.blood_reagents	= sanitize_text(pref.blood_reagents, initial(pref.blood_reagents))

	if(!pref.traits_cheating)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(S)
			pref.starting_trait_points = S.trait_points
		else
			pref.starting_trait_points = 0
		pref.max_traits = MAX_SPECIES_TRAITS

	if(pref.organ_data[O_BRAIN])	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	// Clean up positive traits
	for(var/datum/trait/path as anything in pref.pos_traits)
		if(!(path in positive_traits))
			pref.pos_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_positive))
			pref.pos_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.pos_traits -= path
	//Neutral traits
	for(var/datum/trait/path as anything in pref.neu_traits)
		if(!(path in neutral_traits))
			pref.neu_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_neutral))
			pref.neu_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.neu_traits -= path
	//Negative traits
	for(var/datum/trait/path as anything in pref.neg_traits)
		if(!(path in negative_traits))
			pref.neg_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_negative))
			pref.neg_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.neg_traits -= path

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		if (!(pref.custom_base in pref.get_custom_bases_for_species()))
			pref.custom_base = SPECIES_HUMAN
		//otherwise, allowed!
	else if(!pref.custom_base || !(pref.custom_base in GLOB.custom_species_bases))
		pref.custom_base = SPECIES_HUMAN

	pref.custom_say = lowertext(trim(pref.custom_say))
	pref.custom_whisper = lowertext(trim(pref.custom_whisper))
	pref.custom_ask = lowertext(trim(pref.custom_ask))
	pref.custom_exclaim = lowertext(trim(pref.custom_exclaim))

	if (islist(pref.custom_heat)) //don't bother checking these for actual singular message length, they should already have been checked and it'd take too long every time it's sanitized
		if (length(pref.custom_heat) > 10)
			pref.custom_heat.Cut(11)
	else
		pref.custom_heat = list()
	if (islist(pref.custom_cold))
		if (length(pref.custom_cold) > 10)
			pref.custom_cold.Cut(11)
	else
		pref.custom_cold = list()

/datum/category_item/player_setup_item/vore/traits/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species
	character.custom_say		= lowertext(trim(pref.custom_say))
	character.custom_ask		= lowertext(trim(pref.custom_ask))
	character.custom_whisper	= lowertext(trim(pref.custom_whisper))
	character.custom_exclaim	= lowertext(trim(pref.custom_exclaim))
	character.custom_heat = pref.custom_heat
	character.custom_cold = pref.custom_cold


	if(character.isSynthetic())	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	var/datum/species/S = character.species
	var/datum/species/new_S = S.produceCopy(pref.pos_traits + pref.neu_traits + pref.neg_traits, character, pref.custom_base)

	for(var/datum/trait/T in new_S.traits)
		T.apply_pref(src)

	//Any additional non-trait settings can be applied here
	new_S.blood_color = pref.blood_color
	if(!(pref.blood_reagents == "default"))
		new_S.blood_reagents = pref.blood_reagents

	//Any additional non-trait settings can be applied here
	new_S.blood_color = pref.blood_color

	/*
	if(pref.species_sound) // CHOMPEdit: Custom Scream/Death/Gasp/Pain Sounds. Don't try to do this if it doesn't exist. //  && new_S.selects_bodytype && pref.custom_base) // we aren't a custom species, and we don't have a custom base.
		new_S.copy_species_sounds(new_S, pref.species_sound, pref.custom_base) // CHOMPEdit: Custom Scream/Death/Gasp/Pain Sounds
	*/
	// CHOMPEdit: Custom Scream/Death/Gasp/Pain Sounds.
	var/species_sounds_to_copy = pref.species_sound // What sounds are we using?
	/* Bastion of Endeavor Translation
	if(species_sounds_to_copy == "Unset") // Are we unset?
	*/
	if(species_sounds_to_copy == "Не установлено")
	// End of Bastion of Endeavor Translation
		species_sounds_to_copy = select_default_species_sound(pref) // This will also grab gendered versions of the sounds, if they exist.

	new_S.species_sounds = species_sounds_to_copy // Now we send our sounds over to the mob

	if(pref.species == SPECIES_CUSTOM)
		//Statistics for this would be nice
		var/english_traits = english_list(new_S.traits, and_text = ";", comma_text = ";")
		/* Bastion of Endeavor Translation
		log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet
		*/
		log_game("ЧЕРТЫ: [pref.client_ckey]/([character]) с чертами: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet
		// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/vore/traits/content(var/mob/user)
	/* Bastion of Endeavor Translation
	. += "<b>Custom Species Name:</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"
	*/
	. += "<b>Особое название расы:</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Введите название-"]</a><br>"
	// End of Bastion of Endeavor Translation

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Needs to get looked at, at some point
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : "Human"]</a><br>"
		*/
		. += "<b>Тип туловища: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : SPECIES_HUMAN]</a><br>"
		// End of Bastion of Endeavor Translation

	var/traits_left = pref.max_traits


	var/points_left = pref.starting_trait_points


	for(var/T in pref.pos_traits + pref.neg_traits) // CHOMPEdit: Only Positive traits cost slots now.
		points_left -= traits_costs[T]
	for(var/T in pref.pos_traits)
		traits_left--
	/* Bastion of Endeavor Translation
	. += "<b>Traits Left:</b> [traits_left]<br>"
	. += "<b>Points Left:</b> [points_left]<br>"
	*/
	. += "<b>Осталось черт:</b> [traits_left]<br>"
	. += "<b>Осталось очков:</b> [points_left]<br>"
	// End of Bastion of Endeavor Translation
	if(points_left < 0 || traits_left < 0 || (!pref.custom_species && pref.species == SPECIES_CUSTOM))
		/* Bastion of Endeavor Translation
		. += "<span style='color:red;'><b>^ Fix things! ^</b></span><br>"
		*/
		. += "<span style='color:red;'><b>^ Исправьте! ^</b></span><br>"
		// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Positive Trait(s) (Limited) +</a><br>" // CHOMPEdit: More obvious/clear to players.
	*/
	. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Добавить положительную черту (ограниченно)</a><br>"
	// End of Bastion of Endeavor Translation
	. += "<ul>"
	for(var/T in pref.pos_traits)
		var/datum/trait/trait = positive_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_pos_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.pos_traits[T])]</li>"
	. += "</ul>"

	/* Bastion of Endeavor Translation
	. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Neutral Trait(s) (No Limit) +</a><br>" // CHOMPEdit: More obvious/clear to players.
	*/
	. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Добавить нейтральную черту (неограниченно)</a><br>" // CHOMPEdit: More obvious/clear to players.
	// End of Bastion of Endeavor Translation
	. += "<ul>"
	for(var/T in pref.neu_traits)
		var/datum/trait/trait = neutral_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.neu_traits[T])]</li>"
	. += "</ul>"

	/* Bastion of Endeavor Translation
	. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Negative Trait(s) (No Limit) +</a><br>" // CHOMPEdit: More obvious/clear to players.
	*/
	. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Добавить отрицательную черту (неограниченно)</a><br>" // CHOMPEdit: More obvious/clear to players.
	// End of Bastion of Endeavor Translation
	. += "<ul>"
	for(var/T in pref.neg_traits)
		var/datum/trait/trait = negative_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.neg_traits[T])]</li>"
	. += "</ul>"

	/* Bastion of Endeavor Translation: Augh
	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"
	. += "<b>Blood Reagent: </b>"	//Wanna be copper-based? Go ahead.
	. += "<a href='?src=\ref[src];blood_reagents=1'>[pref.blood_reagents]</a><br>"
	. += "<br>"

	. += "<b>Custom Say: </b>"
	. += "<a href='?src=\ref[src];custom_say=1'>Set Say Verb</a>"
	. += "(<a href='?src=\ref[src];reset_say=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Whisper: </b>"
	. += "<a href='?src=\ref[src];custom_whisper=1'>Set Whisper Verb</a>"
	. += "(<a href='?src=\ref[src];reset_whisper=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Ask: </b>"
	. += "<a href='?src=\ref[src];custom_ask=1'>Set Ask Verb</a>"
	. += "(<a href='?src=\ref[src];reset_ask=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Exclaim: </b>"
	. += "<a href='?src=\ref[src];custom_exclaim=1'>Set Exclaim Verb</a>"
	. += "(<a href='?src=\ref[src];reset_exclaim=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Heat Discomfort: </b>"
	. += "<a href='?src=\ref[src];custom_heat=1'>Set Heat Messages</a>"
	. += "(<a href='?src=\ref[src];reset_heat=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Cold Discomfort: </b>"
	. += "<a href='?src=\ref[src];custom_cold=1'>Set Cold Messages</a>"
	. += "(<a href='?src=\ref[src];reset_cold=1'>Reset</A>)"
	. += "<br>"
	*/
	. += "<b>Цвет крови: </b>"
	. += "<a href='?src=\ref[src];blood_color=1'>Выбрать</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>Сбросить</a><br>"
	. += "<b>Кроветворное вещество: </b>" // sounds a lil silly but okay
	. += "<a href='?src=\ref[src];blood_reagents=1'>[pref.blood_reagents]</a><br>"
	. += "<br><table><tr>" // no reason why this shouldn't be a table
	. += "<td><b>Глаголы речи</b></td></tr><tr>"
	. += "<td>Глагол речи:</td><td>"
	. += "<a href='?src=\ref[src];custom_say=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_say=1'>Сбросить</A>"
	. += "</td></tr><tr>"
	. += "<td>Глагол шёпота:</td><td>"
	. += "<a href='?src=\ref[src];custom_whisper=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_whisper=1'>Сбросить</A>"
	. += "</td></tr><tr>"
	. += "<td>Глагол вопросов:</td><td>"
	. += "<a href='?src=\ref[src];custom_ask=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_ask=1'>Сбросить</A>"
	. += "</td></tr><tr>"
	. += "<td>Глагол восклицаний:</td><td>"
	. += "<a href='?src=\ref[src];custom_exclaim=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_exclaim=1'>Сбросить</A>"
	. += "</td></tr><tr>"
	. += "<td><b>Сообщения о дискомфорте</b></td></tr><tr>"
	. += "<td>От жары:</td><td>"
	. += "<a href='?src=\ref[src];custom_heat=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_heat=1'>Сбросить</A>"
	. += "</td></tr><tr>"
	. += "<td>От холода:</td><td>"
	. += "<a href='?src=\ref[src];custom_cold=1'>Установить</a>"
	. += "<a href='?src=\ref[src];reset_cold=1'>Сбросить</A>"
	. += "</td></tr></table>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/vore/traits/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["custom_species"])
		/* Bastion of Endeavor Translation
		var/raw_choice = sanitize(tgui_input_text(user, "Input your custom species name:",
			"Character Preference", pref.custom_species, MAX_NAME_LEN), MAX_NAME_LEN)
		*/
		var/raw_choice = sanitize(tgui_input_text(user, "Введите особое название расы вашего персонажа:", "Особое название расы", pref.custom_species, MAX_NAME_LEN), MAX_NAME_LEN)
		// End of Bastion of Endeavor Translation
		if (CanUseTopic(user))
			pref.custom_species = raw_choice
		return TOPIC_REFRESH

	else if(href_list["custom_base"])
		var/list/choices = pref.get_custom_bases_for_species()
		/* Bastion of Endeavor Translation
		var/text_choice = tgui_input_list(usr, "Pick an icon set for your species:","Icon Base", choices)
		*/
		var/text_choice = tgui_input_list(usr, "Выберите тип телосложения вашего персонажа:","Основа внешности", choices)
		// End of Bastion of Endeavor Translation
		if(text_choice in choices)
			pref.custom_base = text_choice
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_color"])
		/* Bastion of Endeavor Translation
		var/color_choice = input(usr, "Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color) as color
		*/
		var/color_choice = input(usr, "Выберите цвет крови вашего персонажа (не действует на синтетов):","Цвет крови",pref.blood_color) as color
		// End of Bastion of Endeavor Translation
		if(color_choice)
			pref.blood_color = sanitize_hexcolor(color_choice, default="#A10808")
		return TOPIC_REFRESH

	else if(href_list["blood_reset"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_alert(usr, "Reset blood color to human default (#A10808)?","Reset Blood Color",list("Reset","Cancel"))
		if(choice == "Reset")
		*/
		var/choice = tgui_alert(usr, "Сбросить цвет крови на красный (#A10808)?","Цвет крови",list("Сбросить","Отмена"))
		if(choice == "Сбросить")
		// End of Bastion of Endeavor Translation
			pref.blood_color = "#A10808"
		return TOPIC_REFRESH

	else if(href_list["blood_reagents"])
		/* Bastion of Endeavor Translation
		var/new_blood_reagents = tgui_input_list(user, "Choose your character's blood restoration reagent:", "Character Preference", valid_bloodreagents)
		*/
		var/new_blood_reagents = tgui_input_list(user, "Укажите вещество, необходимое вашему персонажу для восстановления крови:", "Кроветворное вещество", valid_bloodreagents)
		// End of Bastion of Endeavor Translation
		if(new_blood_reagents && CanUseTopic(user))
			pref.blood_reagents = new_blood_reagents
			return TOPIC_REFRESH

	else if(href_list["clicked_pos_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_pos_trait"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
		*/
		var/choice = tgui_alert(usr, "Удалить черту [initial(trait.name)] и вернуть [count_ru(initial(trait.cost), ";очко;очка;очков")]?","Удалить черту",list("Удалить","Отмена"))
		if(choice == "Удалить")
		// End of Bastion of Endeavor Translation
			pref.pos_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)]?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
		*/
		var/choice = tgui_alert(usr, "Удалить черту [initial(trait.name)]?","Удалить черту",list("Удалить","Отмена"))
		if(choice == "Удалить")
		// End of Bastion of Endeavor Translation
			pref.neu_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_neg_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neg_trait"])
		/* Bastion of Endeavor Translation
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
		*/
		var/choice = tgui_alert(usr, "Удалить черту [initial(trait.name)] и потерять [count_ru(initial(trait.cost), ";очко;очка;очков")]?","Удалить черту",list("Удалить","Отмена"))
		if(choice == "Удалить")
		// End of Bastion of Endeavor Translation
			pref.neg_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_trait_pref"])
		var/datum/trait/trait = text2path(href_list["clicked_trait_pref"])
		get_pref_choice_from_trait(user, trait, href_list["pref"])
		return TOPIC_REFRESH

	else if(href_list["custom_say"])
		/* Bastion of Endeavor Translation: This is hacky and ugly I KNOW but I want to account for plural forms too
		var/say_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'says': [pref.real_name] says, \"Hi.\"", "Custom Say", pref.custom_say, 12), 12)
		*/
		var/say_choice = sanitize(tgui_input_text(usr, "Введите глагол, отображаемый вместо \"[pref.identifying_gender == PLURAL ? "говорят" : "говорит"]\":\n[pref.real_name] [pref.identifying_gender == PLURAL ? "говорят" : "говорит"], \"Привет.\"", "Глагол речи", pref.custom_say, 12), 12)
		// End of Bastion of Endeavor Translation
		if(say_choice)
			pref.custom_say = say_choice
		return TOPIC_REFRESH

	else if(href_list["custom_whisper"])
		/* Bastion of Endeavor Translation
		var/whisper_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'whispers': [pref.real_name] whispers, \"Hi...\"", "Custom Whisper", pref.custom_whisper, 12), 12)
		*/
		var/whisper_choice = sanitize(tgui_input_text(usr, "Введите глагол, отображаемый вместо \"[pref.identifying_gender == PLURAL ? "шепчут" : "шепчет"]\":\n[pref.real_name] [pref.identifying_gender == PLURAL ? "шепчут" : "шепчет"], \"Привет...\"", "Глагол шёпота", pref.custom_whisper, 12), 12)
		// End of Bastion of Endeavor Translation
		if(whisper_choice)
			pref.custom_whisper = whisper_choice
		return TOPIC_REFRESH

	else if(href_list["custom_ask"])
		/* Bastion of Endeavor Translation
		var/ask_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'asks': [pref.real_name] asks, \"Hi?\"", "Custom Ask", pref.custom_ask, 12), 12)
		*/
		var/ask_choice = sanitize(tgui_input_text(usr, "Введите глагол, отображаемый вместо \"[pref.identifying_gender == PLURAL ? "спрашивают" : "спрашивает"]\":\n[pref.real_name] [pref.identifying_gender == PLURAL ? "спрашивают" : "спрашивает"], \"Привет?\"", "Глагол вопроса", pref.custom_ask, 12), 12)
		// End of Bastion of Endeavor Translation
		if(ask_choice)
			pref.custom_ask = ask_choice
		return TOPIC_REFRESH

	else if(href_list["custom_exclaim"])
		/* Bastion of Endeavor Translation
		var/exclaim_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [pref.real_name] exclaims, \"Hi!\"", "Custom Exclaim", pref.custom_exclaim, 12), 12)
		*/
		var/exclaim_choice = sanitize(tgui_input_text(usr, "Введите глагол, отображаемый вместо \"[pref.identifying_gender == PLURAL ? "восклицают\", \"кричат\" или \"выкрикивают" : "восклицает\", \"кричит\" или \"выкрикивает"]\":\n[pref.real_name] [pref.identifying_gender == PLURAL ? "восклицают" : "восклицает"], \"Привет!\"", "Глагол восклицания", pref.custom_exclaim, 12), 12)
		// End of Bastion of Endeavor Translation
		if(exclaim_choice)
			pref.custom_exclaim = exclaim_choice
		return TOPIC_REFRESH

	else if(href_list["custom_heat"])
		/* Bastion of Endeavor Removal: Unnecessary, the wiki will handle this
		tgui_alert(user, "You are setting custom heat messages. These will overwrite your species' defaults. To return to defaults, click reset.")
		*/
		// End of Bastion of Endeavor Removal
		var/old_message = pref.custom_heat.Join("\n\n")
		/* Bastion of Endeavor Translation
		var/new_message = sanitize(tgui_input_text(usr,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Heat Discomfort messages",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		*/
		var/new_message = sanitize(tgui_input_text(usr,"Введите сообщения, отображаемые при дискомфорте от жары, по одному на строку. Допускается до 10 сообщений от 3 до 160 символов.","Сообщение о дискомфорте",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		// End of Bastion of Endeavor Translation
		if(length(new_message) > 0)
			var/list/raw_list = splittext(new_message,"\n\n")
			if(raw_list.len > 10)
				raw_list.Cut(11)
			for(var/i = 1, i <= raw_list.len, i++)
				if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
					raw_list.Cut(i,i)
				else
					raw_list[i] = readd_quotes(raw_list[i])
			ASSERT(raw_list.len <= 10)
			pref.custom_heat = raw_list
		return TOPIC_REFRESH

	else if(href_list["custom_cold"])
		/* Bastion of Endeavor Removal: Unnecessary
		tgui_alert(user, "You are setting custom cold messages. These will overwrite your species' defaults. To return to defaults, click reset.")
		*/
		// End of Bastion of Endeavor Removal
		var/old_message = pref.custom_cold.Join("\n\n") //CHOMP Edit
		/* Bastion of Endeavor Translation
		var/new_message = sanitize(tgui_input_text(usr,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Cold Discomfort messages",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		*/
		var/new_message = sanitize(tgui_input_text(usr,"Введите сообщения, отображаемые при дискомфорте от холода, по одному на строку. Допускается до 10 сообщений от 3 до 160 символов. При сбросе будут восстановлены сообщения вашей расы по умолчанию.","Сообщение о дискомфорте",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		// End of Bastion of Endeavor Translation
		if(length(new_message) > 0)
			var/list/raw_list = splittext(new_message,"\n\n")
			if(raw_list.len > 10)
				raw_list.Cut(11)
			for(var/i = 1, i <= raw_list.len, i++)
				if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
					raw_list.Cut(i,i)
				else
					raw_list[i] = readd_quotes(raw_list[i])
			ASSERT(raw_list.len <= 10)
			pref.custom_cold = raw_list
		return TOPIC_REFRESH

	else if(href_list["reset_say"])
		/* Bastion of Endeavor Translation: Don't see the point of these but sure
		var/say_choice = tgui_alert(usr, "Reset your Custom Say Verb?","Reset Verb",list("Yes","No"))
		if(say_choice == "Yes")
		*/
		var/say_choice = tgui_alert(usr, "Сбросить глагол речи?","Сбросить глагол",list("Да","Нет"))
		if(say_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.custom_say = null
		return TOPIC_REFRESH

	else if(href_list["reset_whisper"])
		/* Bastion of Endeavor Translation
		var/whisper_choice = tgui_alert(usr, "Reset your Custom Whisper Verb?","Reset Verb",list("Yes","No"))
		if(whisper_choice == "Yes")
		*/
		var/whisper_choice = tgui_alert(usr, "Сбросить глагол шёпота?","Сбросить глагол",list("Да","Нет"))
		if(whisper_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.custom_whisper = null
		return TOPIC_REFRESH

	else if(href_list["reset_ask"])
		/* Bastion of Endeavor Translation
		var/ask_choice = tgui_alert(usr, "Reset your Custom Ask Verb?","Reset Verb",list("Yes","No"))
		*/
		var/ask_choice = tgui_alert(usr, "Сбросить глагол вопроса?","Сбросить глагол",list("Да","Нет"))
		// End of Bastion of Endeavor Translation
		if(ask_choice == "Yes")
			pref.custom_ask = null
		return TOPIC_REFRESH

	else if(href_list["reset_exclaim"])
		/* Bastion of Endeavor Translation
		var/exclaim_choice = tgui_alert(usr, "Reset your Custom Exclaim Verb?","Reset Verb",list("Yes","No"))
		if(exclaim_choice == "Yes")
		*/
		var/exclaim_choice = tgui_alert(usr, "Сбросить глагол восклицания?","Сбросить глагол",list("Да","Нет"))
		if(exclaim_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.custom_exclaim = null
		return TOPIC_REFRESH

	else if(href_list["reset_cold"])
		/* Bastion of Endeavor Translation
		var/cold_choice = tgui_alert(usr, "Reset your Custom Cold Discomfort messages?", "Reset Discomfort",list("Yes","No"))
		if(cold_choice == "Yes")
		*/
		var/cold_choice = tgui_alert(usr, "Сбросить сообщение о дискомфорте от холода?","Сбросить сообщение о дискомфорте",list("Да","Нет"))
		if(cold_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.custom_cold = list()
		return TOPIC_REFRESH

	else if(href_list["reset_heat"])
		/* Bastion of Endeavor Translation
		var/heat_choice = tgui_alert(usr, "Reset your Custom Heat Discomfort messages?", "Reset Discomfort",list("Yes","No"))
		if(heat_choice == "Yes")
		*/
		var/heat_choice = tgui_alert(usr, "Сбросить сообщение о дискомфорте от жары?","Сбросить сообщение о дискомфорте",list("Да","Нет"))
		if(heat_choice == "Да")
		// End of Bastion of Endeavor Translation
			pref.custom_heat = list()
		return TOPIC_REFRESH

	else if(href_list["add_trait"])
		var/mode = text2num(href_list["add_trait"])
		var/list/picklist
		var/list/mylist
		switch(mode)
			if(POSITIVE_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = positive_traits.Copy() - pref.pos_traits
					mylist = pref.pos_traits
				else
					picklist = everyone_traits_positive.Copy() - pref.pos_traits
					mylist = pref.pos_traits
			if(NEUTRAL_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = neutral_traits.Copy() - pref.neu_traits
					mylist = pref.neu_traits
				else
					picklist = everyone_traits_neutral.Copy() - pref.neu_traits
					mylist = pref.neu_traits
			if(NEGATIVE_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = negative_traits.Copy() - pref.neg_traits
					mylist = pref.neg_traits
				else
					picklist = everyone_traits_negative.Copy() - pref.neg_traits
					mylist = pref.neg_traits
			else

		if(isnull(picklist))
			return TOPIC_REFRESH

		if(isnull(mylist))
			return TOPIC_REFRESH

		var/list/nicelist = list()
		for(var/P in picklist)
			var/datum/trait/T = picklist[P]
			nicelist[T.name] = P

		var/points_left = pref.starting_trait_points
		for(var/T in pref.pos_traits + pref.neu_traits + pref.neg_traits)
			points_left -= traits_costs[T]

		var/traits_left = pref.max_traits - pref.pos_traits.len // CHOMPEdit: Only positive traits have a slot limit, to prevent broken builds

		/* Bastion of Endeavor Translation
		var/message = "Select a trait to learn more."
		*/
		var/message = "Выберите черту, чтобы узнать о ней больше."
		// End of Bastion of Endeavor Translation
		if(mode != NEUTRAL_MODE)
			/* Bastion of Endeavor Translation
			message = "\[Remaining: [points_left] points, [traits_left] traits\]\n" + message
			*/
			message = "\[Осталось [count_ru(points_left, ";очко;очка;очков")], [count_ru(traits_left, ";черта;черты;черт")]\]\n" + message
			// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
		var/title = "Traits"
		switch(mode)
			if(POSITIVE_MODE)
				title = "Positive Traits"
			if(NEUTRAL_MODE)
				title = "Neutral Traits"
			if(NEGATIVE_MODE)
				title = "Negative Traits"
		*/
		var/title = "Черты"
		switch(mode)
			if(POSITIVE_MODE)
				title = "Положительные черты"
			if(NEUTRAL_MODE)
				title = "Нейтральные черты"
			if(NEGATIVE_MODE)
				title = "Отрицательные черты"
		// End of Bastion of Endeavor Translation

		var/trait_choice
		var/done = FALSE
		while(!done)
			trait_choice = tgui_input_list(usr, message, title, nicelist)
			if(!trait_choice)
				done = TRUE
			if(trait_choice in nicelist)
				var/datum/trait/path = nicelist[trait_choice]
				/* Bastion of Endeavor Translation
				var/choice = tgui_alert(usr, "\[Cost:[initial(path.cost)]\] [initial(path.desc)]",initial(path.name), list("Take Trait","Go Back"))
				if(choice != "Go Back")
				*/
				var/choice = tgui_alert(usr, "\[Стоимость: [initial(path.cost)]\] [initial(path.desc)]",initial(path.name), list("Взять черту","Назад"))
				if(choice != "Назад")
				// End of Bastion of Endeavor Translation
					done = TRUE

		if(!trait_choice)
			return TOPIC_REFRESH
		else if(trait_choice in nicelist)
			var/datum/trait/path = nicelist[trait_choice]
			var/datum/trait/instance = all_traits[path]

			var/conflict = FALSE

			if(pref.dirty_synth && !(instance.can_take & SYNTHETICS))
				/* Bastion of Endeavor Translation
				tgui_alert_async(usr, "The trait you've selected can only be taken by organic characters!", "Error")
				*/
				tgui_alert_async(usr, "Данная черта может быть выбрана только органическими персонажами!", "Отмена")
				// End of Bastion of Endeavor Translation
				//pref.dirty_synth = 0	//Just to be sure //CHOMPEdit this shit broke, stop.
				return TOPIC_REFRESH

			if(pref.gross_meatbag && !(instance.can_take & ORGANICS))
				/* Bastion of Endeavor Translation
				tgui_alert_async(usr, "The trait you've selected can only be taken by synthetic characters!", "Error")
				*/
				tgui_alert_async(usr, "Данная черта может быть выбрана только синтетическими персонажами!", "Отмена")
				// End of Bastion of Endeavor Translation
				return TOPIC_REFRESH

			if(pref.species in instance.banned_species)
				/* Bastion of Endeavor Translation
				tgui_alert_async(usr, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
				*/
				tgui_alert_async(usr, "Данная черта не может быть выбрана для расы вашего персонажа!", "Ошибка")
				// End of Bastion of Endeavor Translation
				return TOPIC_REFRESH

			if( LAZYLEN(instance.allowed_species) && !(pref.species in instance.allowed_species))
				/* Bastion of Endeavor Translation
				tgui_alert_async(usr, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
				*/
				tgui_alert_async(usr, "Данная черта не может быть выбрана для расы вашего персонажа!", "Ошибка")
				// End of Bastion of Endeavor Translation
				return TOPIC_REFRESH

			if(trait_choice in pref.pos_traits + pref.neu_traits + pref.neg_traits)
				conflict = instance.name

			varconflict:
				for(var/P in pref.pos_traits + pref.neu_traits + pref.neg_traits)
					var/datum/trait/instance_test = all_traits[P]
					if(path in instance_test.excludes)
						conflict = instance_test.name
						break varconflict

					for(var/V in instance.var_changes)
						if(V == "flags")
							continue
						if(V in instance_test.var_changes)
							conflict = instance_test.name
							break varconflict

					for(var/V in instance.var_changes_pref)
						if(V in instance_test.var_changes_pref)
							conflict = instance_test.name
							break varconflict

			if(conflict)
				/* Bastion of Endeavor Translation
				tgui_alert_async(usr, "You cannot take this trait and [conflict] at the same time. Please remove that trait, or pick another trait to add.", "Error")
				*/
				tgui_alert_async(usr, "Вы не можете взять эту черту одновременно с чертой \"[conflict].", "Ошибка")
				// End of Bastion of Endeavor Translation
				return TOPIC_REFRESH

			instance.apply_pref(pref)
			mylist[path] = instance.get_default_prefs()
			return TOPIC_REFRESH

	return ..()

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
