/* Bastion of Endeavor Removal: We don't want this as a separate tab
/datum/category_group/player_setup_category/volume_sliders
	name = "Sound"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/volume_sliders
*/
// End of Bastion of Endeavor Removal

/* Bastion of Endeavor Edit: We don't want a separate tab for this
/datum/category_item/player_setup_item/volume_sliders/volume
*/
/datum/category_item/player_setup_item/player_global/volume
// End of Bastion of Endeavor Edit
	name = "General Volume"
	/* Bastion of Endeavor Edit: 
	sort_order = 1
	*/
	sort_order = 3
	// End of Bastion of Endeavor Edit

/* Bastion of Endeavor Edit: 
/datum/category_item/player_setup_item/volume_sliders/volume/load_preferences(datum/json_savefile/savefile)
*/
/datum/category_item/player_setup_item/player_global/volume/load_preferences(datum/json_savefile/savefile)
// End of Bastion of Endeavor Edit
	pref.volume_channels = savefile.get_entry("volume_channels")

/* Bastion of Endeavor Edit: 
/datum/category_item/player_setup_item/volume_sliders/volume/save_preferences(datum/json_savefile/savefile)
*/
/datum/category_item/player_setup_item/player_global/volume/save_preferences(datum/json_savefile/savefile)
// End of Bastion of Endeavor Edit
	savefile.set_entry("volume_channels", pref.volume_channels)

/* Bastion of Endeavor Edit: 
/datum/category_item/player_setup_item/volume_sliders/volume/sanitize_preferences()
*/
/datum/category_item/player_setup_item/player_global/volume/sanitize_preferences()
// End of Bastion of Endeavor Edit
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

/* Bastion of Endeavor Edit: 
/datum/category_item/player_setup_item/volume_sliders/volume/content(var/mob/user)
*/
/datum/category_item/player_setup_item/player_global/volume/content(var/mob/user)
// End of Bastion of Endeavor Edit
	/* Bastion of Endeavor Translation
	. += span_bold("Volume Settings") + "<br>"
	for(var/channel in pref.volume_channels)
		. += "[channel]: <a href='?src=\ref[src];change_volume=[channel];'><b>[pref.volume_channels[channel] * 100]%</b></a><br>"
	. += "<br>"
	*/
	. += span_bold("Настройки звука") + "<br><table>"
	for(var/channel in pref.volume_channels)
		. += "<tr><td>[channel]:</td><td><a href='?src=\ref[src];change_volume=[channel];'><b>[pref.volume_channels[channel] * 100]%</b></a></td></tr>"
	. += "</table><br>"
	// End of Bastion of Endeavor Translation

/* Bastion of Endeavor Edit: 
/datum/category_item/player_setup_item/volume_sliders/volume/OnTopic(var/href, var/list/href_list, var/mob/user)
*/
/datum/category_item/player_setup_item/player_global/volume/OnTopic(var/href, var/list/href_list, var/mob/user)
// End of Bastion of Endeavor Edit
	if(href_list["change_volume"])
		if(CanUseTopic(user))
			var/channel = href_list["change_volume"]
			if(!(channel in pref.volume_channels))
				pref.volume_channels["[channel]"] = 1
			/* Bastion of Endeavor Translation
			var/value = tgui_input_number(user, "Choose your volume for [channel] (0-200%)", "[channel] volume", (pref.volume_channels[channel] * 100), 200, 0) //ChompEDIT - usr removal
			*/
			var/value = tgui_input_number(user, "Укажите громкость (0-200%):", "[channel]", (pref.volume_channels[channel] * 100), 200, 0)
			// End of Bastion of Endeavor Translation
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
	set category = "Preferences.Sounds" //CHOMPEdit
	set desc = "Allows you to adjust volume levels on the fly."
	*/
	set name = "Микшер"
	set category = "Предпочтения.Игра"
	set desc = "Позволяет регулировать громкость игры."
	// End of Bastion of Endeavor Translation

	if(!volume_panel)
		volume_panel = new(src)

	volume_panel.tgui_interact(mob)
