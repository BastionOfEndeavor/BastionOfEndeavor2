var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()

	//create a list of gear datums to sort
	for(var/datum/gear/G as anything in subtypesof(/datum/gear))
		if(initial(G.type_category) == G)
			continue
		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!use_name)
			/* Bastion of Endeavor Translation
			error("Loadout - Missing display name: [G]")
			*/
			error("Личные вещи - Отсутствует имя: [G]")
			// End of Bastion of Endeavor Translation
			continue
		if(isnull(initial(G.cost)))
			/* Bastion of Endeavor Translation
			error("Loadout - Missing cost: [G]")
			continue
			*/
			error("Личные вещи - Отсутствует стоимость: [G]")
			continue
			// End of Bastion of Endeavor Translation
		if(!initial(G.path))
			/* Bastion of Endeavor Translation
			error("Loadout - Missing path definition: [G]")
			*/
			error("Личные вещи - Отсутствует путь: [G]")
			// End of Bastion of Endeavor Translation
			continue

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		gear_datums[use_name] = new G
		LC.gear[use_name] = gear_datums[use_name]

	loadout_categories = sortAssoc(loadout_categories)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		LC.gear = sortAssoc(LC.gear)
	return 1

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"

/datum/category_item/player_setup_item/loadout/load_character(list/save_data)
	pref.gear_list = save_data["gear_list"]
	pref.gear_slot = save_data["gear_slot"]
	if(pref.gear_list!=null && pref.gear_slot!=null)
		pref.gear = pref.gear_list["[pref.gear_slot]"]
	else
		pref.gear = save_data["gear"]
		pref.gear_slot = 1

/datum/category_item/player_setup_item/loadout/save_character(list/save_data)
	pref.gear_list["[pref.gear_slot]"] = pref.gear
	save_data["gear_list"] = pref.gear_list
	save_data["gear_slot"] = pref.gear_slot

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob() //VOREStation Add
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]

		if(G.whitelisted && CONFIG_GET(flag/loadout_whitelist) != LOADOUT_WHITELIST_OFF && pref.client) //VOREStation Edit. // CHOMPEdit
			if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_STRICT && G.whitelisted != pref.species) // CHOMPEdit
				continue
			if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_LAX && !is_alien_whitelisted(preference_mob(), GLOB.all_species[G.whitelisted])) // CHOMPEdit
				continue

		if(max_cost && G.cost > max_cost)
			continue
		//VOREStation Edit Start
		if(preference_mob && preference_mob.client)
			if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(preference_mob.client.prefs.real_name in G.character_name))
				continue
		//VOREStation Edit End
		. += gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character()
	var/mob/preference_mob = preference_mob()
	if(!islist(pref.gear))
		pref.gear = list()
	if(!islist(pref.gear_list))
		pref.gear_list = list()

	for(var/gear_name in pref.gear)
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			/* Bastion of Endeavor Translation: Hacky and afwul
			to_chat(preference_mob, "<span class='warning'>You cannot have more than one of the \the [gear_name]</span>")
			*/
			to_chat(preference_mob, "<span class='warning'>Вы не можете иметь больше одного экземпляра данного предмета ([gear_name]).</span>")
			// End of Bastion of Endeavor Translation
			pref.gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			/* Bastion of Endeavor Translation
			to_chat(preference_mob, "<span class='warning'>You cannot take \the [gear_name] as you are not whitelisted for the species or item.</span>")		//Vorestation Edit
			*/
			to_chat(preference_mob, "<span class='warning'>Вы не можете выбрать данный предмет ([gear_name]), поскольку не обладаете вайтлистом на него или расу, для которой он предназначен.</span>")		//Vorestation Edit
			// End of Bastion of Endeavor Translation
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				pref.gear -= gear_name
				/* Bastion of Endeavor Translation
				to_chat(preference_mob, "<span class='warning'>You cannot afford to take \the [gear_name]</span>")
				*/
				to_chat(preference_mob, "<span class='warning'>У вас не хватает очков, чтобы выбрать данный предмет ([gear_name]).</span>")
				// End of Bastion of Endeavor Translation
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/content()
	. = list()
	var/mob/preference_mob = preference_mob()	//Vorestation Edit
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < MAX_GEAR_COST)
		fcolor = "#E67300"

	. += "<table align = 'center' width = 100%>"
	/* Bastion of Endeavor Translation
	. += "<tr><td colspan=3><center><a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a><b><font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> loadout points spent.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"
	*/
	. += "<tr><td colspan=4><center><a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a><b><font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> [count_ru(total_cost, "оч;ко;ка;ков", TRUE)] потрачено.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Сбросить всё</a>\]</center></td></tr>"
	// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Edit: Rearrange stuff
	. += "<tr><td colspan=3><center><b>"
	*/
	// </center></b> -- pleasing the linter gods
	. += "<tr><td colspan=4><center><b>"
	// End of Bastion of Endeavor Edit
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"

		var/datum/loadout_category/LC = loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear)
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		if(category == current_tab)
			. += " <span class='linkOn'>[category] - [category_cost]</span> "
		else
			if(category_cost)
				. += " <a href='?src=\ref[src];select_category=[category]'><font color = '#E67300'>[category] - [category_cost]</font></a> "
			else
				. += " <a href='?src=\ref[src];select_category=[category]'>[category] - 0</a> "
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]
	/* Bastion of Endeavor Edit: Rearrange stuff
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	*/
	. += "<tr><td colspan=4><hr></td></tr>"
	. += "<tr><td colspan=4><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=4></td></tr>"
	. += "<tr><td colspan=4><hr></td></tr>"
	// End of Bastion of Endeavor Edit
	for(var/gear_name in LC.gear)
		var/datum/gear/G = LC.gear[gear_name]
		if(preference_mob && preference_mob.client)
			if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(preference_mob.client.prefs.real_name in G.character_name))
				continue
		var/ticked = (G.display_name in pref.gear)
		/* Bastion of Endeavor Translation: Buffing the names to account for our lengthy names, nerfing the cost width, adding a new column
		. += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name]</a></td>"
		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		. += "<td><font size=2><i>[G.description]</i></font></td></tr>"
		*/
		if(G.categorized_ru)
			. += "<tr><td colspan=4><b>[G.categorized_ru]</b><hr></td></tr>"
		if(G.display_name_ru)
			. += "<tr style='vertical-align:top;'><td width=30%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name_ru]</a></td>"
		else
			. += "<tr style='vertical-align:top;'><td width=30%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name]</a></td>"
		. += "<td width = 15% style='vertical-align:top; text-align:center'>[G.allowed_roles_list_ru]</td>"
		. += "<td width = 5% style='vertical-align:top; text-align:center';>[G.cost]</td>"
		. += "<td><font size=2><i>[G.description]</i></font></td></tr>"
		if(G.show_roles && G.allowed_roles)
			. += "<td colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Только для: [list2text(G.allowed_roles,", ")]</td>"
		if(G.has_bottom_bar_ru)
			. += "<tr><td colspan=4><hr></td></tr>"
		// End of Bastion of Endeavor Translation
		if(ticked)
			/* Bastion of Endeavor Edit: We want more space
			. += "<tr><td colspan=3>"
			*/
			. += "<tr><td colspan=4>"
			// End of Bastion of Endeavor Edit
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				. += " <a href='?src=\ref[src];gear=[url_encode(G.display_name)];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G)
	. = pref.gear[G.display_name]
	if(!.)
		. = list()
		pref.gear[G.display_name] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in pref.gear)
			pref.gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= MAX_GEAR_COST)
				pref.gear += TG.display_name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[url_decode(href_list["gear"])]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["next_slot"] || href_list["prev_slot"])
		//Set the current slot in the gear list to the currently selected gear
		pref.gear_list["[pref.gear_slot]"] = pref.gear
		//If we're moving up a slot..
		if(href_list["next_slot"])
			//change the current slot number
			pref.gear_slot = pref.gear_slot+1
			if(pref.gear_slot > CONFIG_GET(number/loadout_slots)) // CHOMPEdit
				pref.gear_slot = 1
		//If we're moving down a slot..
		else if(href_list["prev_slot"])
			//change current slot one down
			pref.gear_slot = pref.gear_slot-1
			if(pref.gear_slot<1)
				pref.gear_slot = CONFIG_GET(number/loadout_slots) // CHOMPEdit
		// Set the currently selected gear to whatever's in the new slot
		if(pref.gear_list["[pref.gear_slot]"])
			pref.gear = pref.gear_list["[pref.gear_slot]"]
		else
			pref.gear = list()
			pref.gear_list["[pref.gear_slot]"] = list()
		// Refresh?
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/show_roles = TRUE	//Show the role restrictions on this item?
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category = "General"
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.
	var/exploitable = 0		//Does it go on the exploitable information list?
	var/type_category = null
	// Bastion of Endeavor Addition
	var/display_name_ru
	var/allowed_roles_list_ru
	var/categorized_ru
	var/has_bottom_bar_ru = FALSE
	// End of Bastion of Endeavor Addition

/datum/gear/New()
	..()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	gear_tweaks = list(gear_tweak_free_name, gear_tweak_free_desc, GLOB.gear_tweak_item_tf_spawn, GLOB.gear_tweak_free_matrix_recolor) //CHOMPEdit - Item TF spawnpoints

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata)
	var/datum/gear_data/gd = new(path, location)
	if(length(gear_tweaks) && metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_gear_data(metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	if(length(gear_tweaks) && metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_item(item, metadata["[gt]"])
	var/mob/M = location
	if(istype(M) && exploitable) //Update exploitable info records for the mob without creating a duplicate object at their feet.
		M.amend_exploitable(item)
	return item
