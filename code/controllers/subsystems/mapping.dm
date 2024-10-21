// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	/* Bastion of Endeavor Translation
	name = "Mapping"
	*/
	name = "Маппинг"
	// End of Bastion of Endeavor Translation
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/obj/effect/landmark/engine_loader/engine_loader
	var/list/shelter_templates = list()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	shelter_templates = SSmapping.shelter_templates

/datum/controller/subsystem/mapping/Initialize() // CHOMPEdit
	if(subsystem_initialized)
		return
	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	load_map_templates()

	if(CONFIG_GET(flag/generate_map)) // CHOMPEdit
		// Map-gen is still very specific to the map, however putting it here should ensure it loads in the correct order.
		using_map.perform_map_generation()

	loadEngine()
	preloadShelterTemplates() // VOREStation EDIT: Re-enable Shelter Capsules
	// Mining generation probably should be here too
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	// Lateload Code related to Expedition areas.
	if(using_map) // VOREStation Edit: Re-enable this.
		loadLateMaps()
	return SS_INIT_SUCCESS // CHOMPEdit

/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/datum/map_template/template as anything in subtypesof(/datum/map_template))
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new template()
		map_templates[template.name] = template
	return TRUE

/datum/controller/subsystem/mapping/proc/loadEngine()
	if(!engine_loader)
		return // Seems this map doesn't need an engine loaded.

	var/turf/T = get_turf(engine_loader)
	if(!isturf(T))
		/* Bastion of Endeavor Translation
		to_world_log("[log_info_line(engine_loader)] not on a turf! Cannot place engine template.")
		*/
		to_world_log("[log_info_line(engine_loader)] не на тюрфе! Нельзя расположить шаблон генератора.")
		// End of Bastion of Endeavor Translation
		return

	// Choose an engine type
	var/datum/map_template/engine/chosen_type = null
	if (LAZYLEN(CONFIG_GET(str_list/engine_map))) // CHOMPEdit
		var/chosen_name = pick(CONFIG_GET(str_list/engine_map)) // CHOMPEdit
		chosen_type = map_templates[chosen_name]
		if(!istype(chosen_type))
			/* Bastion of Endeavor Translation
			error("Configured engine map [chosen_name] is not a valid engine map name!")
			*/
			error("В конфигурации указана карта генератора [chosen_name], но это имя не является допустимым!")
			// End of Bastion of Endeavor Translation
	if(!istype(chosen_type))
		var/list/engine_types = list()
		for(var/map in map_templates)
			var/datum/map_template/engine/MT = map_templates[map]
			if(istype(MT))
				engine_types += MT
		chosen_type = pick(engine_types)
	/* Bastion of Endeavor Translation
	to_world_log("Chose Engine Map: [chosen_type.name]")
	admin_notice(span_danger("Chose Engine Map: [chosen_type.name]"), R_DEBUG)
	*/
	to_world_log("Выбранная карта генератора: [chosen_type.name].")
	admin_notice(span_danger("Выбранная карта генератора: [chosen_type.name]."), R_DEBUG)
	// End of Bastion of Endeavor Translation

	// Annihilate movable atoms
	engine_loader.annihilate_bounds()
	//CHECK_TICK //Don't let anything else happen for now
	// Actually load it
	chosen_type.load(T)

// VOREStation Edit Start: Enable This
/datum/controller/subsystem/mapping/proc/loadLateMaps()
	var/list/deffo_load = using_map.lateload_z_levels
	var/list/maybe_load = using_map.lateload_gateway
	var/list/also_load = using_map.lateload_overmap
	var/list/redgate_load = using_map.lateload_redgate

	for(var/list/maplist in deffo_load)
		if(!islist(maplist))
			/* Bastion of Endeavor Translation
			error("Lateload Z level [maplist] is not a list! Must be in a list!")
			*/
			error("Поздно загруженный Z-уровень [maplist] не является списком, хотя должен!")
			// End of Bastion of Endeavor Translation
			continue
		for(var/mapname in maplist)
			var/datum/map_template/MT = map_templates[mapname]
			if(!istype(MT))
				/* Bastion of Endeavor Translation
				error("Lateload Z level \"[mapname]\" is not a valid map!")
				*/
				error("Поздно загруженный Z-уровень \"[mapname]\" не является допустимой картой!")
				// End of Bastion of Endeavor Translation
				continue
			/* Bastion of Endeavor Translation
			admin_notice("Lateload: [MT]", R_DEBUG)
			*/
			admin_notice("Поздняя загрузка: [MT]", R_DEBUG)
			// End of Bastion of Endeavor Translation
			MT.load_new_z(centered = FALSE)
			CHECK_TICK

	if(LAZYLEN(maybe_load))
		var/picklist = pick(maybe_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			/* Bastion of Endeavor Translation
			error("Randompick Z level [picklist] is not a list! Must be in a list!")
			*/
			error("Случайно выбранный Z-уровень [picklist] не является списком, хотя должен!")
			// End of Bastion of Endeavor Translation
			return

		for(var/map in picklist)
			if(islist(map))
				// TRIPLE NEST. In this situation we pick one at random from the choices in the list.
				//This allows a sort of a1,a2,a3,b1,b2,b3,c1,c2,c3 setup where it picks one 'a', one 'b', one 'c'
				map = pick(map)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				/* Bastion of Endeavor Translation
				error("Randompick Z level \"[map]\" is not a valid map!")
				*/
				error("Случайно выбранный Z-уровень \"[map]\" не является допустимой картой!")
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				admin_notice("Gateway: [MT]", R_DEBUG)
				*/
				admin_notice("Синепространственные врата: [MT].", R_DEBUG)
				// End of Bastion of Endeavor Translation
				MT.load_new_z(centered = FALSE)

	if(LAZYLEN(also_load)) //Just copied from gateway picking, this is so we can have a kind of OM map version of the same concept.
		var/picklist = pick(also_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			/* Bastion of Endeavor Translation
			error("Randompick Z level [picklist] is not a list! Must be in a list!")
			*/
			error("Случайно выбранный Z-уровень [picklist] не является списком, хотя должен!")
			// End of Bastion of Endeavor Translation
			return

		for(var/map in picklist)
			if(islist(map))
				// TRIPLE NEST. In this situation we pick one at random from the choices in the list.
				//This allows a sort of a1,a2,a3,b1,b2,b3,c1,c2,c3 setup where it picks one 'a', one 'b', one 'c'
				map = pick(map)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				/* Bastion of Endeavor Translation
				error("Randompick Z level \"[map]\" is not a valid map!")
				*/
				error("Случайно выбранный Z-уровень \"[map]\" не является допустимой картой!")
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				admin_notice("OM Adventure: [MT]", R_DEBUG)
				*/
				admin_notice("Приключение на надкарте: [MT].", R_DEBUG)
				// End of Bastion of Endeavor Translation
				MT.load_new_z(centered = FALSE)

	if(LAZYLEN(redgate_load))
		var/picklist = pick(redgate_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			/* Bastion of Endeavor Translation
			error("Randompick Z level [picklist] is not a list! Must be in a list!")
			*/
			error("Случайно выбранный Z-уровень [picklist] не является списком, хотя должен!")
			// End of Bastion of Endeavor Translation
			return

		for(var/map in picklist)
			if(islist(map))
				// TRIPLE NEST. In this situation we pick one at random from the choices in the list.
				//This allows a sort of a1,a2,a3,b1,b2,b3,c1,c2,c3 setup where it picks one 'a', one 'b', one 'c'
				map = pick(map)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				/* Bastion of Endeavor Translation
				error("Randompick Z level \"[map]\" is not a valid map!")
				*/
				error("Случайно выбранный Z-уровень \"[map]\" не является допустимой картой!")
				// End of Bastion of Endeavor Translation
			else
				/* Bastion of Endeavor Translation
				admin_notice("Redgate: [MT]", R_DEBUG)
				*/
				admin_notice("Краснопространственные врата: [MT].", R_DEBUG)
				// End of Bastion of Endeavor Translation
				MT.load_new_z(centered = FALSE)


/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/datum/map_template/shelter/shelter_type as anything in subtypesof(/datum/map_template/shelter))
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
// VOREStation Edit End: Re-enable this

/datum/controller/subsystem/mapping/stat_entry(msg)
	if (!Debug2)
		return // Only show up in stat panel if debugging is enabled.
	return ..() //CHOMPEdit

// VOREStation Edit: BAPI-dmm
/datum/controller/subsystem/mapping/Shutdown()
	// Force bapi to drop it's cached maps on server shutdown.
	_bapidmm_clear_map_data()
	fdel("data/baked_dmm_files/")
// VOREStation Edit End
