/datum/category_group/player_setup_category/volume_sliders
	/* Bastion of Endeavor Translation
	name = "Sound"
	*/
	name = "Звук"
	// End of Bastion of Endeavor Translation
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/volume_sliders

/datum/category_item/player_setup_item/volume_sliders/volume
	name = "General Volume"
	sort_order = 1

/datum/category_item/player_setup_item/volume_sliders/volume/load_preferences(var/savefile/S)
	S["volume_channels"] >> pref.volume_channels

/datum/category_item/player_setup_item/volume_sliders/volume/save_preferences(var/savefile/S)
	S["volume_channels"] << pref.volume_channels

/datum/category_item/player_setup_item/volume_sliders/volume/sanitize_preferences()
	if(isnull(pref.volume_channels))
		pref.volume_channels = list()

	for(var/channel in pref.volume_channels)
		if(!(channel in GLOB.all_volume_channels))
			// Channel no longer exists, yeet
			pref.volume_channels.Remove(channel)

	for(var/channel in GLOB.all_volume_channels)
		if(!(channel in pref.volume_channels))
			pref.volume_channels["[channel]"] = 1
		else
			pref.volume_channels["[channel]"] = clamp(pref.volume_channels["[channel]"], 0, 2)

/datum/category_item/player_setup_item/volume_sliders/volume/content(var/mob/user)
	/* Bastion of Endeavor Translation
	. += "<b>Volume Settings</b><br>"
	for(var/channel in pref.volume_channels)
		. += "[channel]: <a href='?src=\ref[src];change_volume=[channel];'><b>[pref.volume_channels[channel] * 100]%</b></a><br>"
	. += "<br>"
	*/
	. += "<b>Настройки звука</b><br><table>"
	for(var/channel in pref.volume_channels)
		. += "<tr><td>[channel]:</td><td><a href='?src=\ref[src];change_volume=[channel];'><b>[pref.volume_channels[channel] * 100]%</b></a></td></tr>"
	. += "</table><br>"
	// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/volume_sliders/volume/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["change_volume"])
		if(CanUseTopic(user))
			var/channel = href_list["change_volume"]
			if(!(channel in pref.volume_channels))
				pref.volume_channels["[channel]"] = 1
<<<<<<< HEAD
			/* Bastion of Endeavor Translation
			var/value = tgui_input_number(usr, "Choose your volume for [channel] (0-200%)", "[channel] volume", (pref.volume_channels[channel] * 100), 200, 0)
			*/
			var/value = tgui_input_number(usr, "Укажите громкость (0-200%):", "[channel]", (pref.volume_channels[channel] * 100), 200, 0)
			// End of Bastion of Endeavor Translation
=======
			var/value = tgui_input_number(user, "Choose your volume for [channel] (0-200%)", "[channel] volume", (pref.volume_channels[channel] * 100), 200, 0) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
			if(isnum(value))
				value = CLAMP(value, 0, 200)
				pref.volume_channels["[channel]"] = (value / 100)
			return TOPIC_REFRESH
	return ..()

/mob/proc/get_preference_volume_channel(volume_channel)
	if(!client)
		return 0
	return client.get_preference_volume_channel(volume_channel)

/client/proc/get_preference_volume_channel(volume_channel)
	if(!volume_channel || !prefs)
		return 1
	if(!(volume_channel in prefs.volume_channels))
		prefs.volume_channels["[volume_channel]"] = 1
	return prefs.volume_channels["[volume_channel]"]


// Neat little volume adjuster thing in case you don't wanna touch preferences by hand you lazy fuck
/datum/volume_panel
/datum/volume_panel/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/volume_panel/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		/* Bastion of Endeavor Translation
		ui = new(user, src, "VolumePanel", "Volume Panel")
		*/
		ui = new(user, src, "VolumePanel", "Микшер")
		// End of Bastion of Endeavor Translation
		ui.open()

/datum/volume_panel/tgui_data(mob/user)
	if(!user.client || !user.client.prefs)
		return list("error" = TRUE)

	var/list/data = ..()
	data["volume_channels"] = user.client.prefs.volume_channels
	return data

/datum/volume_panel/tgui_act(action, params)
	if(..())
		return TRUE

	if(!usr?.client?.prefs)
		return TRUE

	var/datum/preferences/P = usr.client.prefs
	switch(action)
		if("adjust_volume")
			var/channel = params["channel"]
			if(channel in P.volume_channels)
				P.volume_channels["[channel]"] = clamp(params["vol"], 0, 2)
				SScharacter_setup.queue_preferences_save(P)
				return TRUE

/client/verb/volume_panel()
	/* Bastion of Endeavor Translation
	set name = "Volume Panel"
	set category = "Preferences"
	set desc = "Allows you to adjust volume levels on the fly."
	*/
	set name = "Микшер"
	set category = "Предпочтения"
	set desc = "Позволяет регулировать громкость игры."
	// End of Bastion of Endeavor Translation

	if(!volume_panel)
		volume_panel = new(src)

	volume_panel.tgui_interact(mob)
