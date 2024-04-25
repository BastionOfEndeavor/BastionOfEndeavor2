var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL
	var/animations_toggle = FALSE

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

	var/ear_style		// Type of selected ear style
	var/r_ears = 30		// Ear color.
	var/g_ears = 30		// Ear color
	var/b_ears = 30		// Ear color
	var/r_ears2 = 30	// Ear extra color.
	var/g_ears2 = 30	// Ear extra color
	var/b_ears2 = 30	// Ear extra color
	var/r_ears3 = 30	// Ear tertiary color.
	var/g_ears3 = 30	// Ear tertiary color
	var/b_ears3 = 30	// Ear tertiary color
	var/tail_style		// Type of selected tail style
	var/r_tail = 30		// Tail/Taur color
	var/g_tail = 30		// Tail/Taur color
	var/b_tail = 30		// Tail/Taur color
	var/r_tail2 = 30 	// For extra overlay.
	var/g_tail2 = 30	// For extra overlay.
	var/b_tail2 = 30	// For extra overlay.
	var/r_tail3 = 30 	// For tertiary overlay.
	var/g_tail3 = 30	// For tertiary overlay.
	var/b_tail3 = 30	// For tertiary overlay.
	var/wing_style		// Type of selected wing style
	var/r_wing = 30		// Wing color
	var/g_wing = 30		// Wing color
	var/b_wing = 30		// Wing color
	var/r_wing2 = 30	// Wing extra color
	var/g_wing2 = 30	// Wing extra color
	var/b_wing2 = 30	// Wing extra color
	var/r_wing3 = 30	// Wing tertiary color
	var/g_wing3 = 30	// Wing tertiary color
	var/b_wing3 = 30	// Wing tertiary color
	var/datum/browser/markings_subwindow = null

// Sanitize ear/wing/tail styles
/datum/preferences/proc/sanitize_body_styles()

	// Grandfather in anyone loading paths from a save.
	if(ispath(ear_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.ear_styles_list[ear_style]
		if(istype(instance))
			ear_style = instance.name
	if(ispath(wing_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.wing_styles_list[wing_style]
		if(istype(instance))
			wing_style = instance.name
	if(ispath(tail_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.tail_styles_list[tail_style]
		if(istype(instance))
			tail_style = instance.name

	// Sanitize for non-existent keys.
	if(ear_style && !(ear_style in get_available_styles(global.ear_styles_list)))
		ear_style = null
	if(wing_style && !(wing_style in get_available_styles(global.wing_styles_list)))
		wing_style = null
	if(tail_style && !(tail_style in get_available_styles(global.tail_styles_list)))
		tail_style = null

/datum/preferences/proc/get_available_styles(var/style_list)
	/* Bastion of Endeavor Translation: There's no way to translate this to make sense because for some reason normal ears and wings means a lack of thereof but not the tails
	. = list("Normal" = null)
	*/
	. = list("\[ Сбросить \]" = null)
	// End of Bastion of Endeavor Translation

	for(var/path in style_list)
		var/datum/sprite_accessory/instance = style_list[path]
		if(!istype(instance))
			continue
		if(instance.ckeys_allowed && (!client || !(client.ckey in instance.ckeys_allowed)))
			continue
		if(instance.species_allowed && (!species || !(species in instance.species_allowed)) && (!client || !check_rights(R_ADMIN | R_EVENT | R_FUN, 0, client)) && (!custom_base || !(custom_base in instance.species_allowed))) //VOREStation Edit: Custom Species
			continue
		// Bastion of Endeavor Addition: This is hacky but if no one is fixing these entries, fine I'll do it myself
		if(instance.name == "Вы не должны видеть этот текст...")
			continue
		// End of Bastion of Endeavor Addition
		.[instance.name] = instance

/datum/preferences/proc/mass_edit_marking_list(var/marking, var/change_on = TRUE, var/change_color = TRUE, var/marking_value = null, var/on = TRUE, var/color = "#000000")
	var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[marking]
	var/list/new_marking = marking_value||mark_datum.body_parts
	for (var/NM in new_marking)
		if (marking_value && !islist(new_marking[NM])) continue
		new_marking[NM] = list("on" = (!change_on && marking_value) ? marking_value[NM]["on"] : on, "color" = (!change_color && marking_value) ? marking_value[NM]["color"] : color)
	if (change_color)
		new_marking["color"] = color
	return new_marking

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["species"]			>> pref.species
	S["hair_red"]			>> pref.r_hair
	S["hair_green"]			>> pref.g_hair
	S["hair_blue"]			>> pref.b_hair
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["facial_red"]			>> pref.r_facial
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["facial_green"]		>> pref.g_facial
	S["facial_blue"]		>> pref.b_facial
	S["skin_tone"]			>> pref.s_tone
	S["skin_red"]			>> pref.r_skin
	S["skin_green"]			>> pref.g_skin
	S["skin_blue"]			>> pref.b_skin
	S["hair_style_name"]	>> pref.h_style
	S["grad_style_name"]	>> pref.grad_style
	S["facial_style_name"]	>> pref.f_style
	S["grad_style_name"]	>> pref.grad_style
	S["eyes_red"]			>> pref.r_eyes
	S["eyes_green"]			>> pref.g_eyes
	S["eyes_blue"]			>> pref.b_eyes
	S["b_type"]				>> pref.b_type
	S["disabilities"]		>> pref.disabilities
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data
	S["body_markings"]		>> pref.body_markings
	S["synth_color"]		>> pref.synth_color
	S["synth_red"]			>> pref.r_synth
	S["synth_green"]		>> pref.g_synth
	S["synth_blue"]			>> pref.b_synth
	S["synth_markings"]		>> pref.synth_markings
	S["bgstate"]			>> pref.bgstate
	S["body_descriptors"]	>> pref.body_descriptors
	S["Wingdings"]			>> pref.wingdings //YWadd start
	S["colorblind_mono"]	>> pref.colorblind_mono
	S["colorblind_vulp"]	>> pref.colorblind_vulp
	S["colorblind_taj"] 	>> pref.colorblind_taj
	S["haemophilia"]        >> pref.haemophilia //YWadd end
	S["ear_style"]		>> pref.ear_style
	S["r_ears"]			>> pref.r_ears
	S["g_ears"]			>> pref.g_ears
	S["b_ears"]			>> pref.b_ears
	S["r_ears2"]		>> pref.r_ears2
	S["g_ears2"]		>> pref.g_ears2
	S["b_ears2"]		>> pref.b_ears2
	S["r_ears3"]		>> pref.r_ears3
	S["g_ears3"]		>> pref.g_ears3
	S["b_ears3"]		>> pref.b_ears3
	S["tail_style"]		>> pref.tail_style
	S["r_tail"]			>> pref.r_tail
	S["g_tail"]			>> pref.g_tail
	S["b_tail"]			>> pref.b_tail
	S["r_tail2"]		>> pref.r_tail2
	S["g_tail2"]		>> pref.g_tail2
	S["b_tail2"]		>> pref.b_tail2
	S["r_tail3"]		>> pref.r_tail3
	S["g_tail3"]		>> pref.g_tail3
	S["b_tail3"]		>> pref.b_tail3
	S["wing_style"]		>> pref.wing_style
	S["r_wing"]			>> pref.r_wing
	S["g_wing"]			>> pref.g_wing
	S["b_wing"]			>> pref.b_wing
	S["r_wing2"]		>> pref.r_wing2
	S["g_wing2"]		>> pref.g_wing2
	S["b_wing2"]		>> pref.b_wing2
	S["r_wing3"]		>> pref.r_wing3
	S["g_wing3"]		>> pref.g_wing3
	S["b_wing3"]		>> pref.b_wing3
	S["digitigrade"] 	>> pref.digitigrade

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["species"]			<< pref.species
	S["hair_red"]			<< pref.r_hair
	S["hair_green"]			<< pref.g_hair
	S["hair_blue"]			<< pref.b_hair
	S["grad_red"]			<< pref.r_grad
	S["grad_green"]			<< pref.g_grad
	S["grad_blue"]			<< pref.b_grad
	S["facial_red"]			<< pref.r_facial
	S["facial_green"]		<< pref.g_facial
	S["facial_blue"]		<< pref.b_facial
	S["skin_tone"]			<< pref.s_tone
	S["skin_red"]			<< pref.r_skin
	S["skin_green"]			<< pref.g_skin
	S["skin_blue"]			<< pref.b_skin
	S["hair_style_name"]	<< pref.h_style
	S["grad_style_name"]	<< pref.grad_style
	S["facial_style_name"]	<< pref.f_style
	S["grad_style_name"]	<< pref.grad_style
	S["eyes_red"]			<< pref.r_eyes
	S["eyes_green"]			<< pref.g_eyes
	S["eyes_blue"]			<< pref.b_eyes
	S["b_type"]				<< pref.b_type
	S["disabilities"]		<< pref.disabilities
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data
	S["body_markings"]		<< pref.body_markings
	S["synth_color"]		<< pref.synth_color
	S["synth_red"]			<< pref.r_synth
	S["synth_green"]		<< pref.g_synth
	S["synth_blue"]			<< pref.b_synth
	S["synth_markings"]		<< pref.synth_markings
	S["bgstate"]			<< pref.bgstate
	S["body_descriptors"]	<< pref.body_descriptors
	S["Wingdings"]          << pref.wingdings //YWadd start
	S["colorblind_mono"]	<< pref.colorblind_mono
	S["colorblind_vulp"]	<< pref.colorblind_vulp
	S["colorblind_taj"] 	<< pref.colorblind_taj
	S["haemophilia"]        << pref.haemophilia //YWadd end
	S["ear_style"]		<< pref.ear_style
	S["r_ears"]			<< pref.r_ears
	S["g_ears"]			<< pref.g_ears
	S["b_ears"]			<< pref.b_ears
	S["r_ears2"]		<< pref.r_ears2
	S["g_ears2"]		<< pref.g_ears2
	S["b_ears2"]		<< pref.b_ears2
	S["r_ears3"]		<< pref.r_ears3
	S["g_ears3"]		<< pref.g_ears3
	S["b_ears3"]		<< pref.b_ears3
	S["tail_style"]		<< pref.tail_style
	S["r_tail"]			<< pref.r_tail
	S["g_tail"]			<< pref.g_tail
	S["b_tail"]			<< pref.b_tail
	S["r_tail2"]		<< pref.r_tail2
	S["g_tail2"]		<< pref.g_tail2
	S["b_tail2"]		<< pref.b_tail2
	S["r_tail3"]		<< pref.r_tail3
	S["g_tail3"]		<< pref.g_tail3
	S["b_tail3"]		<< pref.b_tail3
	S["wing_style"]		<< pref.wing_style
	S["r_wing"]			<< pref.r_wing
	S["g_wing"]			<< pref.g_wing
	S["b_wing"]			<< pref.b_wing
	S["r_wing2"]		<< pref.r_wing2
	S["g_wing2"]		<< pref.g_wing2
	S["b_wing2"]		<< pref.b_wing2
	S["r_wing3"]		<< pref.r_wing3
	S["g_wing3"]		<< pref.g_wing3
	S["b_wing3"]		<< pref.b_wing3
	S["digitigrade"]	<< pref.digitigrade

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	if(!pref.species || !(pref.species in GLOB.playable_species))
		pref.species = SPECIES_HUMAN
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_grad			= sanitize_integer(pref.r_grad, 0, 255, initial(pref.r_grad))
	pref.g_grad			= sanitize_integer(pref.g_grad, 0, 255, initial(pref.g_grad))
	pref.b_grad			= sanitize_integer(pref.b_grad, 0, 255, initial(pref.b_grad))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style		= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.f_style		= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= body_marking_styles_list
	for (var/M in pref.body_markings) //VOREStation Edit
		if (!islist(pref.body_markings[M]))
			var/col = istext(pref.body_markings[M]) ? pref.body_markings[M] : "#000000"
			pref.body_markings[M] = pref.mass_edit_marking_list(M,color=col)
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

	pref.r_ears		= sanitize_integer(pref.r_ears, 0, 255, initial(pref.r_ears))
	pref.g_ears		= sanitize_integer(pref.g_ears, 0, 255, initial(pref.g_ears))
	pref.b_ears		= sanitize_integer(pref.b_ears, 0, 255, initial(pref.b_ears))
	pref.r_ears2	= sanitize_integer(pref.r_ears2, 0, 255, initial(pref.r_ears2))
	pref.g_ears2	= sanitize_integer(pref.g_ears2, 0, 255, initial(pref.g_ears2))
	pref.b_ears2	= sanitize_integer(pref.b_ears2, 0, 255, initial(pref.b_ears2))
	pref.r_ears3	= sanitize_integer(pref.r_ears3, 0, 255, initial(pref.r_ears3))
	pref.g_ears3	= sanitize_integer(pref.g_ears3, 0, 255, initial(pref.g_ears3))
	pref.b_ears3	= sanitize_integer(pref.b_ears3, 0, 255, initial(pref.b_ears3))
	pref.r_tail		= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail		= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail		= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))
	pref.r_tail2	= sanitize_integer(pref.r_tail2, 0, 255, initial(pref.r_tail2))
	pref.g_tail2	= sanitize_integer(pref.g_tail2, 0, 255, initial(pref.g_tail2))
	pref.b_tail2	= sanitize_integer(pref.b_tail2, 0, 255, initial(pref.b_tail2))
	pref.r_tail3	= sanitize_integer(pref.r_tail3, 0, 255, initial(pref.r_tail3))
	pref.g_tail3	= sanitize_integer(pref.g_tail3, 0, 255, initial(pref.g_tail3))
	pref.b_tail3	= sanitize_integer(pref.b_tail3, 0, 255, initial(pref.b_tail3))
	pref.r_wing		= sanitize_integer(pref.r_wing, 0, 255, initial(pref.r_wing))
	pref.g_wing		= sanitize_integer(pref.g_wing, 0, 255, initial(pref.g_wing))
	pref.b_wing		= sanitize_integer(pref.b_wing, 0, 255, initial(pref.b_wing))
	pref.r_wing2	= sanitize_integer(pref.r_wing2, 0, 255, initial(pref.r_wing2))
	pref.g_wing2	= sanitize_integer(pref.g_wing2, 0, 255, initial(pref.g_wing2))
	pref.b_wing2	= sanitize_integer(pref.b_wing2, 0, 255, initial(pref.b_wing2))
	pref.r_wing3	= sanitize_integer(pref.r_wing3, 0, 255, initial(pref.r_wing3))
	pref.g_wing3	= sanitize_integer(pref.g_wing3, 0, 255, initial(pref.g_wing3))
	pref.b_wing3	= sanitize_integer(pref.b_wing3, 0, 255, initial(pref.b_wing3))
	pref.digitigrade	= sanitize_integer(pref.digitigrade, 0, 1, initial(pref.digitigrade))

	pref.sanitize_body_styles()

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.r_eyes	= pref.r_eyes
	character.g_eyes	= pref.g_eyes
	character.b_eyes	= pref.b_eyes
	character.h_style	= pref.h_style
	character.r_hair	= pref.r_hair
	character.g_hair	= pref.g_hair
	character.b_hair	= pref.b_hair
	character.r_grad	= pref.r_grad
	character.g_grad	= pref.g_grad
	character.b_grad	= pref.b_grad
	character.f_style	= pref.f_style
	character.r_facial	= pref.r_facial
	character.g_facial	= pref.g_facial
	character.b_facial	= pref.b_facial
	character.r_skin	= pref.r_skin
	character.g_skin	= pref.g_skin
	character.b_skin	= pref.b_skin
	character.s_tone	= pref.s_tone
	character.h_style	= pref.h_style
	character.grad_style= pref.grad_style
	character.f_style	= pref.f_style
	character.grad_style= pref.grad_style
	character.b_type	= pref.b_type
	character.synth_color = pref.synth_color
	character.r_synth	= pref.r_synth
	character.g_synth	= pref.g_synth
	character.b_synth	= pref.b_synth
	character.synth_markings = pref.synth_markings
	if(character.species.digi_allowed)
		character.digitigrade = pref.digitigrade
	else
		character.digitigrade = 0

	//sanity check
	if(character.digitigrade == null)
		character.digitigrade = 0
		pref.digitigrade = 0

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	character.ear_style =  ear_styles[pref.ear_style]
	character.r_ears =     pref.r_ears
	character.b_ears =     pref.b_ears
	character.g_ears =     pref.g_ears
	character.r_ears2 =    pref.r_ears2
	character.b_ears2 =    pref.b_ears2
	character.g_ears2 =    pref.g_ears2
	character.r_ears3 =    pref.r_ears3
	character.b_ears3 =    pref.b_ears3
	character.g_ears3 =    pref.g_ears3

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	character.tail_style = tail_styles[pref.tail_style]
	character.r_tail =     pref.r_tail
	character.b_tail =     pref.b_tail
	character.g_tail =     pref.g_tail
	character.r_tail2 =    pref.r_tail2
	character.b_tail2 =    pref.b_tail2
	character.g_tail2 =    pref.g_tail2
	character.r_tail3 =    pref.r_tail3
	character.b_tail3 =    pref.b_tail3
	character.g_tail3 =    pref.g_tail3

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	character.wing_style = wing_styles[pref.wing_style]
	character.r_wing =     pref.r_wing
	character.b_wing =     pref.b_wing
	character.g_wing =     pref.g_wing
	character.r_wing2 =    pref.r_wing2
	character.b_wing2 =    pref.b_wing2
	character.g_wing2 =    pref.g_wing2
	character.r_wing3 =    pref.r_wing3
	character.b_wing3 =    pref.b_wing3
	character.g_wing3 =    pref.g_wing3

	character.set_gender(pref.biological_gender)

	/* Bastion of Endeavor Translation
	if(pref.species == "Grey")//YWadd START
	*/
	if(pref.species == "Серый")//YWadd START
	// End of Bastion of Endeavor Translation
		character.wingdings = pref.wingdings

	if(pref.colorblind_mono == 1)
		character.add_modifier(/datum/modifier/trait/colorblind_monochrome)

	else if(pref.colorblind_vulp == 1)
		character.add_modifier(/datum/modifier/trait/colorblind_vulp)

	else if(pref.colorblind_taj == 1)
		character.add_modifier(/datum/modifier/trait/colorblind_taj)

	if(pref.haemophilia == 1)
		character.add_modifier(/datum/modifier/trait/haemophilia)
	//YWadd END

	// Destroy/cyborgize organs and limbs.
	//VOREStation Edit
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Might need to be rolled back depending on species localization
	character.synthetic = pref.species == "Protean" ? all_robolimbs["protean"] : null //Clear the existing var. (unless protean, then switch it to the normal protean limb)
	*/
	character.synthetic = pref.species == SPECIES_PROTEAN ? all_robolimbs["protean"] : null
	// End of Bastion of Endeavor Translation
	var/list/organs_to_edit = list()
	for (var/name in list(BP_TORSO, BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if (O)
			var/x = organs_to_edit.Find(O.parent_organ)
			if (x == 0)
				organs_to_edit += name
			else
				organs_to_edit.Insert(x+(O.robotic == ORGAN_NANOFORM ? 1 : 0), name)
	for(var/name in organs_to_edit) //VOREStation edit end
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					O.robotize(pref.rlimb_data[name])
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	var/priority = 0
	for(var/M in pref.body_markings)
		priority += 1
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]
		//var/mark_color = "[pref.body_markings[M]]" //VOREStation Edit

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O && islist(O.markings) && islist(pref.body_markings[M]) && islist(pref.body_markings[M][BP]))
				O.markings[M] = list("color" = pref.body_markings[M][BP]["color"], "datum" = mark_datum, "priority" = priority, "on" = pref.body_markings[M][BP]["on"])
	character.markings_len = priority

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	var/datum/species/mob_species = GLOB.all_species[pref.species]
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = CLAMP(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	. = list()

	var/datum/species/mob_species = GLOB.all_species[pref.species]
	/* Bastion of Endeavor Translation
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Species: <a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	. += "<b>Disabilities</b><br> <a href='?src=\ref[src];disabilities_yw=1'>Adjust</a><br>" // YWadd
	//YWcommented moved onto disabilities. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
	. += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"
	. += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"
	*/
	. += "<table><tr style='vertical-align:top'><td><b>Тело</b> "
	// . += "(<a href='?src=\ref[src];random=1'>&reg;</A>)" // this does nothing, i'm removing this
	. += "<br>"
	. += "Раса: <a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	. += "Группа крови: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Тон кожи: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>" // i dont think this is still relevant but sure?
	. += "Инвалидность: <a href='?src=\ref[src];disabilities_yw=1'>Настроить</a><br>" // YWadd
	. += "Части тела: <a href='?src=\ref[src];limbs=1'>Настроить</a><a href='?src=\ref[src];reset_limbs=1'>Сбросить</a><br>"
	. += "Внутренние органы: <a href='?src=\ref[src];organs=1'>Настроить</a><br>"
	// End of Bastion of Endeavor Translation
	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null

		switch(name)
			/* Bastion of Endeavor Translation: UGH
			if(BP_TORSO)
				organ_name = "torso"
			if(BP_GROIN)
				organ_name = "groin"
			if(BP_HEAD)
				organ_name = "head"
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(O_HEART)
				organ_name = "heart"
			if(O_EYES)
				organ_name = "eyes"
			if(O_VOICE)
				organ_name = "larynx"
			if(O_BRAIN)
				organ_name = "brain"
			if(O_LUNGS)
				organ_name = "lungs"
			if(O_LIVER)
				organ_name = "liver"
			if(O_KIDNEYS)
				organ_name = "kidneys"
			if(O_SPLEEN)
				organ_name = "spleen"
			if(O_STOMACH)
				organ_name = "stomach"
			if(O_INTESTINE)
				organ_name = "intestines"
			*/
			if(BP_TORSO)
				organ_name = "торс"
			if(BP_GROIN)
				organ_name = "пах"
			if(BP_HEAD)
				organ_name = "голова"
			if(BP_L_ARM)
				organ_name = "левая рука"
			if(BP_R_ARM)
				organ_name = "правая рука"
			if(BP_L_LEG)
				organ_name = "левая нога"
			if(BP_R_LEG)
				organ_name = "правая нога"
			if(BP_L_FOOT)
				organ_name = "левая ступня"
			if(BP_R_FOOT)
				organ_name = "правая ступня"
			if(BP_L_HAND)
				organ_name = "левая ладонь"
			if(BP_R_HAND)
				organ_name = "правая ладонь"
			if(O_HEART)
				organ_name = "сердце"
			if(O_EYES)
				organ_name = "глаза"
			if(O_VOICE)
				organ_name = "гортань"
			if(O_BRAIN)
				organ_name = "мозг"
			if(O_LUNGS)
				organ_name = "лёгкие"
			if(O_LIVER)
				organ_name = "печень"
			if(O_KIDNEYS)
				organ_name = "почки"
			if(O_SPLEEN)
				organ_name = "селезёнка"
			if(O_STOMACH)
				organ_name = "желудок"
			if(O_INTESTINE)
				organ_name = "кишечник"
			// End of Bastion of Endeavor Translation

		if(status == "cyborg")
			++ind
			if(ind > 1)
				/* Bastion of Endeavor Translation: not really a translation buuuuuuuut
				. += ", "
				*/
				. += "<br>"
				// End of Bastion of Endeavor Translation
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			/* Bastion of Endeavor Translation
			. += "\t[R.company] [organ_name] prosthesis"
			*/
			. += "\t– [non_type_verb_ru(morphable_1 = "простетическ;ий ;ая ;ое ;ие ", noun = organ_name, after_word = " ([R.company])")]"
			// End of Bastion of Endeavor Translation
		else if(status == "amputated")
			++ind
			if(ind > 1)
				/* Bastion of Endeavor Translation
				. += ", "
			. += "\tAmputated [organ_name]"
				*/
				. += "<br>"
			. += "\t– [non_type_verb_ru(morphable_1 = "ампутированн;ый ;ая ;ое ;ые ", noun = organ_name)]"
				// End of Bastion of Endeavor Translation
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				/* Bastion of Endeavor Translation
				. += ", "
				*/
				. += "<br>"
				// End of Bastion of Endeavor Translation
			switch(organ_name)
				/* Bastion of Endeavor Translation
				if ("brain")
					. += "\tPositronic [organ_name]"
				*/
				if ("мозг")
					. += "\t– [non_type_verb_ru(morphable_1 = "позитронн;ый ;ая ;ое ;ые ", noun = organ_name)]"
				// End of Bastion of Endeavor Translation
				else
					/* Bastion of Endeavor Translation
					. += "\tSynthetic [organ_name]"
					*/
					. += "\t– [non_type_verb_ru(morphable_1 = "синтетическ;ий ;ая ;ое ;ие ", noun = organ_name)]"
					// End of Bastion of Endeavor Translation
		else if(status == "digital")
			++ind
			if(ind > 1)
				/* Bastion of Endeavor Translation
				. += ", "
			. += "\tDigital [organ_name]"
				*/
				. += "<br>"
			. += "\t– [non_type_verb_ru(morphable_1 = "цифров;ой ;ая ;ое ;ые ", noun = organ_name)]"
				// End of Bastion of Endeavor Translation
		else if(status == "assisted")
			++ind
			if(ind > 1)
				/* Bastion of Endeavor Translation
				. += ", "
				*/
				. += "<br>"
				// End of Bastion of Endeavor Translation
			switch(organ_name)
				/* Bastion of Endeavor Translation
				if("heart")
					. += "\tPacemaker-assisted [organ_name]"
				if("lungs")
					. += "\tAssisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tSurgically altered [organ_name]"
				if("eyes")
					. += "\tRetinal overlayed [organ_name]"
				if("brain")
					. += "\tAssisted-interface [organ_name]"
				else
					. += "\tMechanically assisted [organ_name]"
				*/
				if("сердце")
					. += "\t– кардиостимулируемое сердце"
				if("лёгкие")
					. += "\t– искусственно усиленные лёгкие"
				if("гортань")
					. += "\t– модифицированная гортань"
				if("глаза")
					. += "\t– глаза с искусственной сетчаткой"
				if("мозг")
					. += "\t– вспомогательный мозговой интерфейс"
				else
					. += "\t– [non_type_verb_ru(morphable_1 = "полумеханическ;ий ;ая ;ое ;ие ", noun = organ_name)]"
				// End of Bastion of Endeavor Translation
	/* Bastion of Endeavor Edit: Really don't see the point of this
	if(!ind)
		. += "\[...\]<br><br>"
	else
		. += "<br><br>"
	*/
	. += "<br>"
	// End of Bastion of Endeavor Edit

	if(LAZYLEN(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			/* Bastion of Endeavor Translation: do we need this?
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=\ref[src];change_descriptor=[entry]'>Change</a><br/></td></tr>"
			*/
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=\ref[src];change_descriptor=[entry]'>Изменить</a><br/></td></tr>"
			// End of Bastion of Endeavor Translation
		. += "</table><br>"

	/* Bastion of Endeavor Translation
	. += "</td><td><b>Preview</b><br>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_animations=1'>[pref.animations_toggle ? "Stop animations" : "Show animations"]</a>"
	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	*/
	. += "</td><td><b>Предпросмотр</b><br>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Сменить фон</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Скрыть личные вещи" : "Показать личные вещи"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Скрыть униформу" : "Показать униформу"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_animations=1'>[pref.animations_toggle ? "Выключить анимации" : "Включить анимации"]</a>"
	. += "</td></tr></table>"
	. += "<b>Причёска</b><br>"
	// End of Bastion of Endeavor Translation
	if(has_flag(mob_species, HAS_HAIR_COLOR))
	/* Bastion of Endeavor Translation
		. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> [color_square(pref.r_hair, pref.g_hair, pref.b_hair)] "
	. += " Style: <a href='?src=\ref[src];hair_style_left=[pref.h_style]'><</a> <a href='?src=\ref[src];hair_style_right=[pref.h_style]''>></a> <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>" //The <</a> & ></a> in this line is correct-- those extra characters are the arrows you click to switch between styles.

	. += "<b>Gradient</b><br>"
	. += "<a href='?src=\ref[src];grad_color=1'>Change Color</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
	. += " Style: <a href='?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	*/
		. += "<a href='?src=\ref[src];hair_color=1'>Выбрать цвет</a> [color_square(pref.r_hair, pref.g_hair, pref.b_hair)] "
	. += " Вид: <a href='?src=\ref[src];hair_style_left=[pref.h_style]'><</a> <a href='?src=\ref[src];hair_style_right=[pref.h_style]''>></a> <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>"
	. += "<b>Градиент</b><br>"
	. += "<a href='?src=\ref[src];grad_color=1'>Выбрать цвет</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
	. += " Вид: <a href='?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"
	. += "<br><b>Лицевая растительность</b><br>"
	// End of Bastion of Endeavor Translation
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		/* Bastion of Endeavor Translation
		. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> [color_square(pref.r_facial, pref.g_facial, pref.b_facial)] "
	. += " Style: <a href='?src=\ref[src];facial_style_left=[pref.f_style]'><</a> <a href='?src=\ref[src];facial_style_right=[pref.f_style]''>></a> <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>" //Same as above with the extra > & < characters
		*/
		. += "<a href='?src=\ref[src];facial_color=1'>Выбрать цвет</a> [color_square(pref.r_facial, pref.g_facial, pref.b_facial)] "
	. += " Вид: <a href='?src=\ref[src];facial_style_left=[pref.f_style]'><</a> <a href='?src=\ref[src];facial_style_right=[pref.f_style]''>></a> <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>"
		// End of Bastion of Endeavor Translation

	if(has_flag(mob_species, HAS_EYE_COLOR))
		/* Bastion of Endeavor Translation
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> [color_square(pref.r_eyes, pref.g_eyes, pref.b_eyes)]<br>"
		*/
		. += "<br><b>Глаза</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Выбрать цвет</a> [color_square(pref.r_eyes, pref.g_eyes, pref.b_eyes)]<br>"
		// End of Bastion of Endeavor Translation

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		/* Bastion of Endeavor Translation
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> [color_square(pref.r_skin, pref.g_skin, pref.b_skin)]<br>"
		*/
		. += "<br><b>Цвет тела</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Выбрать цвет</a> [color_square(pref.r_skin, pref.g_skin, pref.b_skin)]<br>"
		// End of Bastion of Endeavor Translation

	if(mob_species.digi_allowed)
		/* Bastion of Endeavor Translation
		. += "<br><b>Digitigrade?:</b> <a href='?src=\ref[src];digitigrade=1'><b>[pref.digitigrade ? "Yes" : "No"]</b></a><br>"
		*/
		. += "<br><b>Пальцехождение:</b> <a href='?src=\ref[src];digitigrade=1'><b>[pref.digitigrade ? "Да" : "Нет"]</b></a><br>"
		// End of Bastion of Endeavor Translation

	/* Bastion of Endeavor Translation
	. += "<h2>Genetics Settings</h2>"
	*/
	. += "<h2>Особенности</h2>"
	// End of Bastion of Endeavor Translation

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	var/datum/sprite_accessory/ears/ear = ear_styles[pref.ear_style]
	/* Bastion of Endeavor Translation
	. += "<b>Ears</b><br>"
	if(istype(ear))
		. += " Style: <a href='?src=\ref[src];ear_style=1'>[ear.name]</a><br>"
		if(ear.do_colouration)
			. += "<a href='?src=\ref[src];ear_color=1'>Change Color</a> [color_square(pref.r_ears, pref.g_ears, pref.b_ears)]<br>"
		if(ear.extra_overlay)
			. += "<a href='?src=\ref[src];ear_color2=1'>Change Secondary Color</a> [color_square(pref.r_ears2, pref.g_ears2, pref.b_ears2)]<br>"
		if(ear.extra_overlay2)
			. += "<a href='?src=\ref[src];ear_color3=1'>Change Tertiary Color</a> [color_square(pref.r_ears3, pref.g_ears3, pref.b_ears3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];ear_style=1'>Select</a><br>"
	*/
	. += "<b>Голова (уши, рога, усики)</b><br>"
	if(istype(ear))
		. += " Вид: <a href='?src=\ref[src];ear_left=[pref.ear_style]'><</a> <a href='?src=\ref[src];ear_right=[pref.ear_style]''>></a> <a href='?src=\ref[src];ear_style=1'>[ear.name]</a><br>"
		if(ear.do_colouration)
			. += "<a href='?src=\ref[src];ear_color=1'>Выбрать цвет</a> [color_square(pref.r_ears, pref.g_ears, pref.b_ears)]<br>"
		if(ear.extra_overlay)
			. += "<a href='?src=\ref[src];ear_color2=1'>Выбрать второй цвет</a> [color_square(pref.r_ears2, pref.g_ears2, pref.b_ears2)]<br>"
		if(ear.extra_overlay2)
			. += "<a href='?src=\ref[src];ear_color3=1'>Выбрать третий цвет</a> [color_square(pref.r_ears3, pref.g_ears3, pref.b_ears3)]<br>"
	else
		. += " Вид: <a href='?src=\ref[src];ear_style=1'>Выбрать</a><br>"
	// End of Bastion of Endeavor Translation

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	var/datum/sprite_accessory/tail/tail = tail_styles[pref.tail_style]
	/* Bastion of Endeavor Translation
	. += "<b>Tail</b><br>"
	if(istype(tail))
		. += " Style: <a href='?src=\ref[src];tail_style=1'>[tail.name]</a><br>"
		if(tail.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Change Color</a> [color_square(pref.r_tail, pref.g_tail, pref.b_tail)]<br>"
		if(tail.extra_overlay)
			. += "<a href='?src=\ref[src];tail_color2=1'>Change Secondary Color</a> [color_square(pref.r_tail2, pref.g_tail2, pref.b_tail2)]<br>"
		if(tail.extra_overlay2)
			. += "<a href='?src=\ref[src];tail_color3=1'>Change Tertiary Color</a> [color_square(pref.r_tail3, pref.g_tail3, pref.b_tail3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];tail_style=1'>Select</a><br>"
	*/
	. += "<b>Нижняя часть тела (хвосты, тавровые туловища)</b><br>"
	if(istype(tail))
		. += " Вид: <a href='?src=\ref[src];tail_left=[pref.tail_style]'><</a> <a href='?src=\ref[src];tail_right=[pref.tail_style]''>></a> <a href='?src=\ref[src];tail_style=1'>[tail.name]</a><br>"
		if(tail.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Выбрать цвет</a> [color_square(pref.r_tail, pref.g_tail, pref.b_tail)]<br>"
		if(tail.extra_overlay)
			. += "<a href='?src=\ref[src];tail_color2=1'>Выбрать второй цвет</a> [color_square(pref.r_tail2, pref.g_tail2, pref.b_tail2)]<br>"
		if(tail.extra_overlay2)
			. += "<a href='?src=\ref[src];tail_color3=1'>Выбрать третий цвет</a> [color_square(pref.r_tail3, pref.g_tail3, pref.b_tail3)]<br>"
	else
		. += " Вид: <a href='?src=\ref[src];tail_style=1'>Выбрать</a><br>"
	// End of Bastion of Endeavor Translation

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	var/datum/sprite_accessory/wing/wings = wing_styles[pref.wing_style]
	/* Bastion of Endeavor Translation: might as well just grab all of it
	. += "<b>Wing</b><br>"
	if(istype(wings))
		. += " Style: <a href='?src=\ref[src];wing_style=1'>[wings.name]</a><br>"
		if(wings.do_colouration)
			. += "<a href='?src=\ref[src];wing_color=1'>Change Color</a> [color_square(pref.r_wing, pref.g_wing, pref.b_wing)]<br>"
		if(wings.extra_overlay)
			. += "<a href='?src=\ref[src];wing_color2=1'>Change Secondary Color</a> [color_square(pref.r_wing2, pref.g_wing2, pref.b_wing2)]<br>"
		if(wings.extra_overlay2)
			. += "<a href='?src=\ref[src];wing_color3=1'>Change Secondary Color</a> [color_square(pref.r_wing3, pref.g_wing3, pref.b_wing3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];wing_style=1'>Select</a><br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	. += "<table>"
	for(var/M in pref.body_markings)
		. += "<tr><td>[M]</td><td>[pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>[color_square(hex = pref.body_markings[M]["color"] ? pref.body_markings[M]["color"] : "#000000")] - <a href='?src=\ref[src];marking_submenu=[M]'>Customize</a></td></tr>"

	. += "</table>"
	. += "<br>"
	. += "<b>Allow Synth markings:</b> <a href='?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Yes" : "No"]</b></a><br>"
	. += "<b>Allow Synth color:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Change Color</a> [color_square(pref.r_synth, pref.g_synth, pref.b_synth)]"
	*/
	. += "<b>Спина (крылья, панцири)</b><br>"
	if(istype(wings))
		. += " Вид: <a href='?src=\ref[src];wing_style=1'>[wings.name]</a><br>"
		if(wings.do_colouration)
			. += "<a href='?src=\ref[src];wing_color=1'>Выбрать цвет</a> [color_square(pref.r_wing, pref.g_wing, pref.b_wing)]<br>"
		if(wings.extra_overlay)
			. += "<a href='?src=\ref[src];wing_color2=1'>Выбрать второй цвет</a> [color_square(pref.r_wing2, pref.g_wing2, pref.b_wing2)]<br>"
		if(wings.extra_overlay2)
			. += "<a href='?src=\ref[src];wing_color3=1'>Выбрать третий цвет</a> [color_square(pref.r_wing3, pref.g_wing3, pref.b_wing3)]<br>"
	else
		. += " Вид: <a href='?src=\ref[src];wing_style=1'>Выбрать</a><br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Особенности тела +</a><br>"
	. += "<table>"
	for(var/M in pref.body_markings)
		. += "<tr><td>[M]</td><td>[pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Цвет</a> [color_square(hex = pref.body_markings[M]["color"] ? pref.body_markings[M]["color"] : "#000000")] <a href='?src=\ref[src];marking_submenu=[M]'>Настроить</a></td></tr>"
	. += "</table>"
	. += "<br>"
	. += "<b>Особенности тела поверх синтетических частей:</b> <a href='?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Да" : "Нет"]</b></a><br>"
	. += "<b>Цвет поверх синтетических частей:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Да" : "Нет"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Выбрать цвет</a> [color_square(pref.r_synth, pref.g_synth, pref.b_synth)]"
	// End of Bastion of Endeavor Translation

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = GLOB.all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
<<<<<<< HEAD
				/* Bastion of Endeavor Translation: A bit iffy about this, might need to get looked at for mob localization
				var/choice = tgui_input_list(usr, "Please select a descriptor.", "Descriptor", descriptor.chargen_value_descriptors)
				*/
				var/choice = tgui_input_list(usr, "Выберите описание.", "Описание", descriptor.chargen_value_descriptors)
				// End of Bastion of Endeavor Translation
=======
				var/choice = tgui_input_list(user, "Please select a descriptor.", "Descriptor", descriptor.chargen_value_descriptors) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TOPIC_REFRESH

	else if(href_list["blood_type"])
		/* Bastion of Endeavor Translation
		var/new_b_type = tgui_input_list(user, "Choose your character's blood-type:", "Character Preference", valid_bloodtypes)
		*/
		var/new_b_type = tgui_input_list(user, "Выберите группу крови вашего персонажа:", "Группа крови", valid_bloodtypes)
		// End of Bastion of Endeavor Translation
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		var/choice = tgui_input_list(usr, "Which species would you like to look at?", "Species Choice", GLOB.playable_species)
		*/
		var/choice = tgui_input_list(usr, "Выберите интересующую расу, чтобы увидеть её описание:", "Выбор расы", GLOB.playable_species)
		// End of Bastion of Endeavor Translation
=======
		var/choice = tgui_input_list(user, "Which species would you like to look at?", "Species Choice", GLOB.playable_species) //ChompEDIT - usr removal
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		if(!choice) return
		pref.species_preview = choice
		SetSpecies(preference_mob())
		pref.alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?
		return TOPIC_HANDLED

	else if(href_list["disabilities_yw"])
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in GLOB.all_species))
			return TOPIC_NOACTION

		var/datum/species/setting_species

		if(GLOB.all_species[href_list["set_species"]])
			setting_species = GLOB.all_species[href_list["set_species"]]
		else
			return TOPIC_NOACTION

		if(((!(setting_species.spawn_flags & SPECIES_CAN_JOIN)) || (!is_alien_whitelisted(preference_mob(),setting_species))) && !check_rights(R_ADMIN|R_EVENT, 0) && !(setting_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE))	//VOREStation Edit: selectability
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])
			pref.custom_species = null //VOREStation Edit - This is cleared on species changes
			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = pref.get_valid_hairstyles()

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				/* Bastion of Endeavor Translation: I sure hope the above comment is true
				pref.h_style = hair_styles_list["Bald"]
				*/
				pref.h_style = hair_styles_list["Лысая голова"]
				// End of Bastion of Endeavor Translation

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				/* Bastion of Endeavor Translation
				pref.f_style = facial_hair_styles_list["Shaved"]
				*/
				pref.f_style = facial_hair_styles_list["Бритое лицо"]
				// End of Bastion of Endeavor Translation

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = -75

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			pref.sanitize_body_styles()

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.age = max(min(pref.age, max_age), min_age)

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		*/
		var/new_hair = input(user, "Выберите цвет волос вашего персонажа:", "Цвет волос", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		// End of Bastion of Endeavor Translation
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		*/
		var/new_grad = input(user, "Выберите второй цвет волос вашего персонажа:", "Цвет градиента волос", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null		// End of Bastion of Endeavor Translation
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation: Why tho
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		*/
		var/new_grad = input(user, "Выберите второй цвет волос вашего персонажа:", "Цвет градиента волос", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null		// End of Bastion of Endeavor Translation
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = pref.get_valid_hairstyles()

		/* Bastion of Endeavor Translation
		var/new_h_style = tgui_input_list(user, "Choose your character's hair style:", "Character Preference", valid_hairstyles, pref.h_style)
		*/
		var/new_h_style = tgui_input_list(user, "Выберите причёску вашего персонажа:", "Причёска", valid_hairstyles, pref.h_style)
		// End of Bastion of Endeavor Translation
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		/* Bastion of Endeavor Translation
		var/new_grad_style = input(user, "Choose a color pattern for your hair:", "Character Preference", pref.grad_style)  as null|anything in valid_gradients
		*/
		var/new_grad_style = input(user, "Выберите вид градиента волос вашего персонажа:", "Вид градиента волос", pref.grad_style)  as null|anything in valid_gradients
		// End of Bastion of Endeavor Translation
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		/* Bastion of Endeavor Translation
		var/new_grad_style = tgui_input_list(user, "Choose a color pattern for your hair:", "Character Preference", valid_gradients, pref.grad_style)
		*/
		var/new_grad_style = tgui_input_list(user, "Выберите вид градиента волос вашего персонажа:", "Вид градиента волос", valid_gradients, pref.grad_style)
		// End of Bastion of Endeavor Translation
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_left"])
		var/H = href_list["hair_style_left"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.h_style = valid_hairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.h_style = valid_hairstyles[valid_hairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_right"])
		var/H = href_list["hair_style_right"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != valid_hairstyles.len) //If we're not the end of the list, become the next element.
			pref.h_style = valid_hairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.h_style = valid_hairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		*/
		var/new_facial = input(user, "Выберите цвет лицевой растительности вашего персонажа:", "Цвет лицевой растительности", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		// End of Bastion of Endeavor Translation
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["digitigrade"])
		pref.digitigrade = !pref.digitigrade

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		*/
		var/new_eyes = input(user, "Выберите цвет глаз вашего персонажа:", "Цвет глаз", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		// End of Bastion of Endeavor Translation
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_s_tone = tgui_input_number(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35, 220, 1)
		*/
		var/new_s_tone = tgui_input_number(user, "Выберите тон кожи вашего персонажа от 1 (светлый) до 220 (тёмный):", "Тон кожи", (-pref.s_tone) + 35, 220, 1)
		// End of Bastion of Endeavor Translation
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		*/
		var/new_skin = input(user, "Выберите цвет тела вашего персонажа:", "Цвет тела", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		// End of Bastion of Endeavor Translation
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

		/* Bastion of Endeavor Translation
		var/new_f_style = tgui_input_list(user, "Choose your character's facial-hair style:", "Character Preference", valid_facialhairstyles, pref.f_style)
		*/
		var/new_f_style = tgui_input_list(user, "Выберите вид лицевой растительности вашего персонажа:", "Лицевая растительность", valid_facialhairstyles, pref.f_style)
		// End of Bastion of Endeavor Translation
		if(new_f_style && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_left"])
		var/F = href_list["facial_style_left"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.f_style = valid_facialhairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.f_style = valid_facialhairstyles[valid_facialhairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_right"])
		var/F = href_list["facial_style_right"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != valid_facialhairstyles.len) //If we're not the end of the list, become the next element.
			pref.f_style = valid_facialhairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.f_style = valid_facialhairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings.Copy() ^ body_marking_styles_list.Copy()
		/* VOREStation Removal - No markings whitelist, let people mix/match
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			var/datum/species/spec = GLOB.all_species[pref.species]
			if(!S.species_allowed.len)
				continue
			else if(!(pref.species in S.species_allowed) && !(pref.custom_base in S.species_allowed) && !(spec.base_species in S.species_allowed))
				usable_markings -= M
		*/ //VOREStation Removal End
		/* Bastion of Endeavor Translation
		var/new_marking = tgui_input_list(user, "Choose a body marking:", "Character Preference", usable_markings)
		*/
		var/new_marking = tgui_input_list(user, "Выберите особенность тела:", "Особенности тела", usable_markings)
		// End of Bastion of Endeavor Translation
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = pref.mass_edit_marking_list(new_marking) //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_markings.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			moveElement(pref.body_markings, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			moveElement(pref.body_markings, start, pref.body_markings.len+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_markings.Find(M)
		if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
			moveElement(pref.body_markings, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			moveElement(pref.body_markings, start, 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_move"])
		var/M = href_list["marking_move"]
		var/start = pref.body_markings.Find(M)
		var/list/move_locs = pref.body_markings - M
		if(start != 1)
			move_locs -= pref.body_markings[start-1]

		/* Bastion of Endeavor Translation
		var/inject_after = tgui_input_list(user, "Move [M] ahead of...", "Character Preference", move_locs) //Move ahead of any marking that isn't the current or previous one.
		*/
		var/inject_after = tgui_input_list(user, "Передвинуть особенность '[M]' вперёд какой другой особенности?", "Особенности тела", move_locs)
		// End of Bastion of Endeavor Translation
		var/newpos = pref.body_markings.Find(inject_after)
		if(newpos)
			moveElement(pref.body_markings, start, newpos+1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		winshow(user, "prefs_markings_subwindow", FALSE)
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		if (isnull(pref.body_markings[M]["color"]))
			/* Bastion of Endeavor Translation
			if (tgui_alert(user, "You currently have customized marking colors. This will reset each bodypart's color. Are you sure you want to continue?","Reset Bodypart Colors",list("Yes","No")) == "No")
			*/
			if (tgui_alert(user, "Ваша особенность тела настроена отдельно для разных частей тела. Смена цвета приведёт к сбросу этой настройки. Вы действительно хотите изменить цвет?","Сброс цвета части тела",list("Да","Нет")) == "No")
			// End of Bastion of Endeavor Translation
				return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/mark_color = input(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]["color"]) as color|null
		*/
		var/mark_color = input(user, "Выберите цвет особенности тела – [M]: ", "[M]", pref.body_markings[M]["color"]) as color|null
		// End of Bastion of Endeavor Translation
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = pref.mass_edit_marking_list(M,FALSE,TRUE,pref.body_markings[M],color="[mark_color]")
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["marking_submenu"])
		var/M = href_list["marking_submenu"]
		markings_subwindow(user, M)
		return TOPIC_NOACTION

	else if (href_list["toggle_all_marking_selection"])
		var/toggle = text2num(href_list["toggle"])
		var/marking = href_list["toggle_all_marking_selection"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		pref.body_markings[marking] = pref.mass_edit_marking_list(marking,TRUE,FALSE,pref.body_markings[marking],on=toggle)
		markings_subwindow(user, marking)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["color_all_marking_selection"])
		var/marking = href_list["color_all_marking_selection"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		/* Bastion of Endeavor Translation
		var/mark_color = input(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking]["color"]) as color|null
		*/
		var/mark_color = input(user, "Выберите цвет особенности тела – [marking]: ", "[marking]", pref.body_markings[marking]["color"]) as color|null
		// End of Bastion of Endeavor Translation
		if(mark_color && CanUseTopic(user))
			pref.body_markings[marking] = pref.mass_edit_marking_list(marking,FALSE,TRUE,pref.body_markings[marking],color="[mark_color]")
			markings_subwindow(user, marking)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["zone_marking_color"])
		var/marking = href_list["zone_marking_color"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		var/zone = href_list["zone"]
		pref.body_markings[marking]["color"] = null //turn off the color button outside the submenu
		/* Bastion of Endeavor Translation
		var/mark_color = input(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking][zone]["color"]) as color|null
		*/
		var/mark_color = input(user, "Выберите цвет особенности тела – [marking]: ", "[marking]", pref.body_markings[marking][zone]["color"]) as color|null
		// End of Bastion of Endeavor Translation
		if(mark_color && CanUseTopic(user))
			pref.body_markings[marking][zone]["color"] = "[mark_color]"
			markings_subwindow(user, marking)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["zone_marking_toggle"])
		var/marking = href_list["zone_marking_toggle"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		var/zone = href_list["zone"]
		pref.body_markings[marking][zone]["on"] = text2num(href_list["toggle"])
		markings_subwindow(user, marking)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		/* Bastion of Endeavor Translation
		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")
		*/
		var/list/limb_selection_list = list("Левая нога","Правая нога","Левая рука","Правая рука","Левая ступня","Правая ступня","Левая ладонь","Правая ладонь","Всё тело")
		// End of Bastion of Endeavor Translation

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = GLOB.all_species[pref.species]
		if(!current_species.has_organ["brain"])
			/* Bastion of Endeavor Translation
			limb_selection_list -= "Full Body"
			*/
			limb_selection_list -= "Всё тело"
			// End of Bastion of Endeavor Translation
		else if(pref.organ_data[BP_TORSO] == "cyborg")
			/* Bastion of Endeavor Translation
			limb_selection_list |= "Head"
			*/
			limb_selection_list |= "Голова"
			// End of Bastion of Endeavor Translation

		/* Bastion of Endeavor Translation
		var/organ_tag = tgui_input_list(user, "Which limb do you want to change?", "Limb Choice", limb_selection_list)
		*/
		var/organ_tag = tgui_input_list(user, "Какую часть тела вы хотели бы изменить?", "Выбор части тела", limb_selection_list)
		// End of Bastion of Endeavor Translation

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		/* Bastion of Endeavor Translation: WE BLOATIN THE CODE
		var/list/choice_options = list("Normal","Amputated","Prosthesis")
		switch(organ_tag)
			if("Left Leg")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Right Foot")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Left Hand")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Right Hand")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_TORSO
				second_limb = BP_HEAD
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "State Choice", choice_options)
		*/
		var/list/choice_options = list("Органическое","Ампутированное","Механическое")
		switch(organ_tag)
			if("Левая нога")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Правая нога")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Левая рука")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Правая рука")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Левая ступня")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Правая ступня")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Левая рука")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Правая рука")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Голова")
				limb =        BP_HEAD
				choice_options = list("Механическое")
			if("Всё тело")
				limb =        BP_TORSO
				second_limb = BP_HEAD
				third_limb =  BP_GROIN
				choice_options = list("Органическое","Механическое")

		var/new_state = tgui_input_list(user, "Выберите состояние части (частей) тела:", "Части тела", choice_options) // a bit ugly but its annoying to account for FBPs
		// End of Bastion of Endeavor Translation
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		switch(new_state)
			/* Bastion of Endeavor Translation
			if("Normal")
			*/
			if("Органическое")
			// End of Bastion of Endeavor Translation
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal in O_STANDARD)
							pref.organ_data[internal] = null
							pref.rlimb_data[internal] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null

			/* Bastion of Endeavor Translation
			if("Amputated")
			*/
			if("Ампутированное")
			// End of Bastion of Endeavor Translation
				if(limb == BP_TORSO)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			/* Bastion of Endeavor Translation
			if("Prosthesis")
			*/
			if("Механическое")
			// End of Bastion of Endeavor Translation
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(!(limb in M.parts))
						continue
					if(tmp_species in M.species_cannot_use)
						continue
					//VOREStation Add - Cyberlimb whitelisting.
					if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
						continue
					//VOREStation Add End
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				/* Bastion of Endeavor Translation
				var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "Manufacturer Choice", usable_manufacturers)
				*/
				var/choice = tgui_input_list(user, "Выберите изготовителя/бренд части тела:", "Выбор производителя", usable_manufacturers)
				// End of Bastion of Endeavor Translation
				if(!choice)
					return

				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"

				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						if(pref.organ_data[other_limb])
							continue
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[O_BRAIN])
						pref.organ_data[O_BRAIN] = "assisted"
					for(var/internal_organ in list(O_HEART,O_EYES))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])

		/* Bastion of Endeavor Translation
		var/organ_name = tgui_input_list(user, "Which internal function do you want to change?", "Internal Organ", list("Heart", "Eyes", "Larynx", "Lungs", "Liver", "Kidneys", "Spleen", "Intestines", "Stomach", "Brain"))
		*/
		var/organ_name = tgui_input_list(user, "Выберите внутренний орган на замену:", "Внутренние органы", list("Сердце", "Глаза", "Гортань", "Лёгкие", "Печень", "Почки", "Селезёнка", "Кишечник", "Желудок", "Мозг"))
		// End of Bastion of Endeavor Translation
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			/* Bastion of Endeavor Translation
			if("Heart")
				organ = O_HEART
			if("Eyes")
				organ = O_EYES
			if("Larynx")
				organ = O_VOICE
			if("Lungs")
				organ = O_LUNGS
			if("Liver")
				organ = O_LIVER
			if("Kidneys")
				organ = O_KIDNEYS
			if("Spleen")
				organ = O_SPLEEN
			if("Intestines")
				organ = O_INTESTINE
			if("Stomach")
				organ = O_STOMACH
			if("Brain")
				if(pref.organ_data[BP_HEAD] != "cyborg")
					to_chat(user, "<span class='warning'>You may only select a cybernetic or synthetic brain if you have a full prosthetic body.</span>")
					return
				organ = "brain"
			*/
			if("Сердце")
				organ = O_HEART
			if("Глаза")
				organ = O_EYES
			if("Гортань")
				organ = O_VOICE
			if("Лёгкие")
				organ = O_LUNGS
			if("Печень")
				organ = O_LIVER
			if("Почки")
				organ = O_KIDNEYS
			if("Селезёнка")
				organ = O_SPLEEN
			if("Кишечник")
				organ = O_INTESTINE
			if("Желудок")
				organ = O_STOMACH
			if("Мозг")
				if(pref.organ_data[BP_HEAD] != "cyborg")
					to_chat(user, "<span class='warning'>Иметь неорганический мозг разрешено только в полностью простетическом теле.</span>")
					return
				organ = "brain"
			// End of Bastion of Endeavor Translation

		var/datum/species/current_species = GLOB.all_species[pref.species]
		/* Bastion of Endeavor Translation
		var/list/organ_choices = list("Normal")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Normal"
			if(organ_name == "Brain")
				organ_choices += "Cybernetic"
				if(!(current_species.spawn_flags & SPECIES_NO_POSIBRAIN))
					organ_choices += "Positronic"
				if(!(current_species.spawn_flags & SPECIES_NO_DRONEBRAIN))
					organ_choices += "Drone"
			else
				organ_choices += "Assisted"
				organ_choices += "Mechanical"
		else
			organ_choices += "Assisted"
			organ_choices += "Mechanical"

		var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "State Choice", organ_choices)
		*/
		var/list/organ_choices = list("Органический")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Органический"
			if(organ_name == "Мозг")
				organ_choices += "Кибернетический"
				if(!(current_species.spawn_flags & SPECIES_NO_POSIBRAIN))
					organ_choices += "Позитронный"
				if(!(current_species.spawn_flags & SPECIES_NO_DRONEBRAIN))
					organ_choices += "Цифровой"
			else
				organ_choices += "Полумеханический"
				organ_choices += "Механический"
		else
			organ_choices += "Полумеханический"
			organ_choices += "Механический"

		var/new_state = tgui_input_list(user, "Укажите состояние выбранного органа:", "Внутренние органы", organ_choices)
		// End of Bastion of Endeavor Translation
		if(!new_state) return

		switch(new_state)
			/* Bastion of Endeavor Translation
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Cybernetic")
				pref.organ_data[organ] = "assisted"
			if("Mechanical")
				pref.organ_data[organ] = "mechanical"
			if("Drone")
				pref.organ_data[organ] = "digital"
			if("Positronic")
				pref.organ_data[organ] = "mechanical"
			*/
			if("Органический")
				pref.organ_data[organ] = null
			if("Полумеханический")
				pref.organ_data[organ] = "assisted"
			if("Кибернетический")
				pref.organ_data[organ] = "assisted"
			if("Механический")
				pref.organ_data[organ] = "mechanical"
			if("Цифровой")
				pref.organ_data[organ] = "digital"
			if("Позитронный")
				pref.organ_data[organ] = "mechanical"
			// End of Bastion of Endeavor Translation

		return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		Disabilities_YW(user) //YW Edit //ChompEDIT - usr removal

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_animations"])
		pref.animations_toggle = !pref.animations_toggle
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		/* Bastion of Endeavor Translation
		var/new_color = input(user, "Choose your character's synth colour: ", "Character Preference", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		*/
		var/new_color = input(user, "Выберите цвет синтетических частей тела вашего персонажа: ", "Цвет синтетических частей", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		// End of Bastion of Endeavor Translation
		if(new_color && CanUseTopic(user))
			pref.r_synth = hex2num(copytext(new_color, 2, 4))
			pref.g_synth = hex2num(copytext(new_color, 4, 6))
			pref.b_synth = hex2num(copytext(new_color, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_markings"])
		pref.synth_markings = !pref.synth_markings
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	//YW Add Start

	else if(href_list["wingdings"])
		pref.wingdings = !pref.wingdings
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["colorblind_mono"])
		pref.colorblind_mono = !pref.colorblind_mono
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["colorblind_vulp"])
		pref.colorblind_vulp = !pref.colorblind_vulp
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["colorblind_taj"])
		pref.colorblind_taj = !pref.colorblind_taj
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["haemophilia"])
		pref.haemophilia = !pref.haemophilia
		Disabilities_YW(user) //ChompEDIT - usr removal

	else if(href_list["reset_disabilities"])
		pref.wingdings = 0
		pref.colorblind_mono = 0
		pref.colorblind_taj = 0
		pref.colorblind_vulp = 0
		pref.haemophilia = 0
		Disabilities_YW(user) //ChompEDIT - usr removal

	//YW Add End

	else if(href_list["ear_style"])
		/* Bastion of Endeavor Translation
		var/new_ear_style = tgui_input_list(user, "Select an ear style for this character:", "Character Preference", pref.get_available_styles(global.ear_styles_list), pref.ear_style)
		*/
		var/new_ear_style = tgui_input_list(user, "Выберите вид головы вашего персонажа:", "Вид головы", sortList(pref.get_available_styles(global.ear_styles_list)), pref.ear_style)
		// End of Bastion of Endeavor Translation
		if(new_ear_style)
			pref.ear_style = new_ear_style

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color"])
		/* Bastion of Endeavor Translation
		var/new_earc = input(user, "Choose your character's ear colour:", "Character Preference",
		*/
		var/new_earc = input(user, "Выберите цвет головы вашего персонажа:", "Цвет головы",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_ears, pref.g_ears, pref.b_ears)) as color|null
		if(new_earc)
			pref.r_ears = hex2num(copytext(new_earc, 2, 4))
			pref.g_ears = hex2num(copytext(new_earc, 4, 6))
			pref.b_ears = hex2num(copytext(new_earc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color2"])
		/* Bastion of Endeavor Translation
		var/new_earc2 = input(user, "Choose your character's ear colour:", "Character Preference",
		*/
		var/new_earc2 = input(user, "Выберите второй цвет головы вашего персонажа:", "Второй цвет головы",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_ears2, pref.g_ears2, pref.b_ears2)) as color|null
		if(new_earc2)
			pref.r_ears2 = hex2num(copytext(new_earc2, 2, 4))
			pref.g_ears2 = hex2num(copytext(new_earc2, 4, 6))
			pref.b_ears2 = hex2num(copytext(new_earc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color3"])
		/* Bastion of Endeavor Translation
		var/new_earc3 = input(user, "Choose your character's tertiary ear colour:", "Character Preference",
		*/
		var/new_earc3 = input(user, "Выберите третий цвет головы вашего персонажа:", "Третий цвет головы",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_ears3, pref.g_ears3, pref.b_ears3)) as color|null
		if(new_earc3)
			pref.r_ears3 = hex2num(copytext(new_earc3, 2, 4))
			pref.g_ears3 = hex2num(copytext(new_earc3, 4, 6))
			pref.b_ears3 = hex2num(copytext(new_earc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	// Bastion of Endeavor Addition: Selector arrows
	else if(href_list["ear_left"])
		var/H = href_list["ear_left"]
		var/list/ear_styles = sortList(pref.get_available_styles(global.ear_styles_list))
		var/start = ear_styles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.ear_style = ear_styles[start-1]
		else //But if we ARE, become the final element.
			pref.ear_style = ear_styles[ear_styles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_right"])
		var/H = href_list["ear_right"]
		var/list/ear_styles = sortList(pref.get_available_styles(global.ear_styles_list))
		var/start = ear_styles.Find(H)

		if(start != ear_styles.len) //If we're not the end of the list, become the next element.
			pref.ear_style = ear_styles[start+1]
		else //But if we ARE, become the first element.
			pref.ear_style = ear_styles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	
	else if(href_list["tail_left"])
		var/H = href_list["tail_left"]
		var/list/tail_styles = sortList(pref.get_available_styles(global.tail_styles_list))
		var/start = tail_styles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.tail_style = tail_styles[start-1]
		else //But if we ARE, become the final element.
			pref.tail_style = tail_styles[tail_styles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_right"])
		var/H = href_list["tail_right"]
		var/list/tail_styles = sortList(pref.get_available_styles(global.tail_styles_list))
		var/start = tail_styles.Find(H)

		if(start != tail_styles.len) //If we're not the end of the list, become the next element.
			pref.tail_style = tail_styles[start+1]
		else //But if we ARE, become the first element.
			pref.tail_style = tail_styles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	
	else if(href_list["wing_left"])
		var/H = href_list["wing_left"]
		var/list/wing_styles = sortList(pref.get_available_styles(global.wing_styles_list))
		var/start = wing_styles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.wing_style = wing_styles[start-1]
		else //But if we ARE, become the final element.
			pref.wing_style = wing_styles[wing_styles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_right"])
		var/H = href_list["wing_right"]
		var/list/wing_styles = sortList(pref.get_available_styles(global.wing_styles_list))
		var/start = wing_styles.Find(H)

		if(start != wing_styles.len) //If we're not the end of the list, become the next element.
			pref.wing_style = wing_styles[start+1]
		else //But if we ARE, become the first element.
			pref.wing_style = wing_styles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	// End of Bastion of Endeavor Addition

	else if(href_list["tail_style"])
		/* Bastion of Endeavor Translation
		var/new_tail_style = tgui_input_list(user, "Select a tail style for this character:", "Character Preference", pref.get_available_styles(global.tail_styles_list), pref.tail_style)
		*/
		var/new_tail_style = tgui_input_list(user, "Выберите вид нижней части туловища вашего персонажа:", "Вид нижней части", sortList(pref.get_available_styles(global.tail_styles_list)), pref.tail_style)
		// End of Bastion of Endeavor Translation
		if(new_tail_style)
			pref.tail_style = new_tail_style
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		/* Bastion of Endeavor Translation
		var/new_tailc = input(user, "Choose your character's tail/taur colour:", "Character Preference",
		*/
		var/new_tailc = input(user, "Выберите цвет нижней части туловища вашего персонажа:", "Цвет нижней части",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		if(new_tailc)
			pref.r_tail = hex2num(copytext(new_tailc, 2, 4))
			pref.g_tail = hex2num(copytext(new_tailc, 4, 6))
			pref.b_tail = hex2num(copytext(new_tailc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color2"])
		/* Bastion of Endeavor Translation
		var/new_tailc2 = input(user, "Choose your character's secondary tail/taur colour:", "Character Preference",
		*/
		var/new_tailc2 = input(user, "Выберите второй цвет нижней части туловища вашего персонажа:", "Второй цвет нижней части",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_tail2, pref.g_tail2, pref.b_tail2)) as color|null
		if(new_tailc2)
			pref.r_tail2 = hex2num(copytext(new_tailc2, 2, 4))
			pref.g_tail2 = hex2num(copytext(new_tailc2, 4, 6))
			pref.b_tail2 = hex2num(copytext(new_tailc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color3"])
		/* Bastion of Endeavor Translation
		var/new_tailc3 = input(user, "Choose your character's tertiary tail/taur colour:", "Character Preference",
		*/
		var/new_tailc3 = input(user, "Выберите третий цвет нижней части туловища вашего персонажа:", "Третий цвет нижней части",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_tail3, pref.g_tail3, pref.b_tail3)) as color|null
		if(new_tailc3)
			pref.r_tail3 = hex2num(copytext(new_tailc3, 2, 4))
			pref.g_tail3 = hex2num(copytext(new_tailc3, 4, 6))
			pref.b_tail3 = hex2num(copytext(new_tailc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_style"])
		/* Bastion of Endeavor Translation
		var/new_wing_style = tgui_input_list(user, "Select a wing style for this character:", "Character Preference", pref.get_available_styles(global.wing_styles_list), pref.wing_style)
		*/
		var/new_wing_style = tgui_input_list(user, "Выберите вид спины вашего персонажа:", "Вид спины", pref.get_available_styles(global.wing_styles_list), pref.wing_style)
		// End of Bastion of Endeavor Translation
		if(new_wing_style)
			pref.wing_style = new_wing_style

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color"])
		/* Bastion of Endeavor Translation
		var/new_wingc = input(user, "Choose your character's wing colour:", "Character Preference",
		*/
		var/new_wingc = input(user, "Выберите цвет спины вашего персонажа:", "Цвет спины",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_wing, pref.g_wing, pref.b_wing)) as color|null
		if(new_wingc)
			pref.r_wing = hex2num(copytext(new_wingc, 2, 4))
			pref.g_wing = hex2num(copytext(new_wingc, 4, 6))
			pref.b_wing = hex2num(copytext(new_wingc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color2"])
		/* Bastion of Endeavor Translation
		var/new_wingc2 = input(user, "Choose your character's secondary wing colour:", "Character Preference",
		*/
		var/new_wingc2 = input(user, "Выберите второй цвет спины вашего персонажа:", "Второй цвет спины",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_wing2, pref.g_wing2, pref.b_wing2)) as color|null
		if(new_wingc2)
			pref.r_wing2 = hex2num(copytext(new_wingc2, 2, 4))
			pref.g_wing2 = hex2num(copytext(new_wingc2, 4, 6))
			pref.b_wing2 = hex2num(copytext(new_wingc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color3"])
		/* Bastion of Endeavor Translation
		var/new_wingc3 = input(user, "Choose your character's tertiary wing colour:", "Character Preference",
		*/
		var/new_wingc3 = input(user, "Выберите третий цвет спины вашего персонажа:", "Третий цвет спины",
		// End of Bastion of Endeavor Translation
			rgb(pref.r_wing3, pref.g_wing3, pref.b_wing3)) as color|null
		if(new_wingc3)
			pref.r_wing3 = hex2num(copytext(new_wingc3, 2, 4))
			pref.g_wing3 = hex2num(copytext(new_wingc3, 4, 6))
			pref.b_wing3 = hex2num(copytext(new_wingc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/body/proc/reset_limbs()

	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null

	// Sanitize the name so that there aren't any numbers sticking around.
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	if(!pref.species_preview || !(pref.species_preview in GLOB.all_species))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = GLOB.all_species[pref.species_preview]
	/* Bastion of Endeavor Translation
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	*/
	var/dat = "<meta charset='utf-8'><body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>изменить</a>\]</h2></center><hr/>"
	// End of Bastion of Endeavor Translation
	dat += "<table padding='8px'>"
	dat += "<tr>"
	//vorestation edit begin
	/* Bastion of Endeavor Edit: We have a dedicated wiki button and this one just opens a page in the same browser window it's in, unnecessary and clunky
	if(current_species.wikilink)
		dat += "<td width = 400>[current_species.blurb]<br><br>See <a href=[current_species.wikilink]>the wiki</a> for more details.</td>"
		
	else
		dat += "<td width = 400>[current_species.blurb]</td>"
	*/
	dat += "<td width = 400>[current_species.blurb]</td>"
	// End of Bastion of Endeavor Edit
	//vorestation edit end
	dat += "<td width = 200 align='center'>"
	if("preview" in cached_icon_states(current_species.icobase))
<<<<<<< HEAD
		// Bastion of Endeavor TODO: Pay special attention to this when localizing species
		usr << browse_rsc(icon(current_species.icobase,"preview"), "species_preview_[current_species.name].png")
=======
		user << browse_rsc(icon(current_species.icobase,"preview"), "species_preview_[current_species.name].png") //ChompEDIT usr -> user
>>>>>>> 8d04b28ec2 (Remove many incorrect uses of usr (#8296))
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	/* Bastion of Endeavor Translation
	dat += "<b>Language:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Often present on human stations.</b>"
			if(3 to 4)
				dat += "</br><b>Rarely present on human stations.</b>"
			if(5)
				dat += "</br><b>Unheard of on human stations.</b>"
			else
				dat += "</br><b>May be present on human stations.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Does not have a circulatory system.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Does not have a respiratory system.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_DEFIB)
		dat += "</br><b>Cannot be defibrillated.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	*/
	dat += "<b>Язык:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Распространены на станциях.</b>"
			if(3 to 4)
				dat += "</br><b>Практически не встречаются на станциях.</b>"
			if(5)
				dat += "</br><b>Никогда не встречаются на станциях.</b>"
			else
				dat += "</br><b>Иногда встречаются на станциях.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Раса защищена вайтлистом.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Не имеют кровеносной системы.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Не имеют дыхательной системы.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Не имеют ДНК.</b>"
	if(current_species.flags & NO_DEFIB)
		dat += "</br><b>Не могут быть реанимированы дефибрилятором.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Не чувствуют боли.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Обладают хорошим сцеплением.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Обладают иммунитетом от ядов.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Могут иметь различный тон кожи.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Могут иметь различный цвет тела.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Могут иметь различный цвет глаз.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Обладают растительным строением.</b>"
	// End of Bastion of Endeavor Translation
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0

	if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
		restricted = 2
	else if(!is_alien_whitelisted(preference_mob(),current_species))
		restricted = 1

	if(restricted)
		if(restricted == 1)
			/* Bastion of Endeavor Translation
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
			*/
			dat += "<font color='red'><b>Вам недоступна эта раса.</br><small>Чтобы выбрать эту расу, необходимо подать особую заявку в Discord и дождаться её принятия.</small></b></font></br>"
			// End of Bastion of Endeavor Translation
		else if(restricted == 2)
			/* Bastion of Endeavor Translation
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
			*/
			dat += "<font color='red'><b>Вам недоступна эта раса.</br><small>Эта раса недоступна для игры в качестве экипажа.</small></b></font></br>"
			// End of Bastion of Endeavor Translation
	if(!restricted || check_rights(R_ADMIN|R_EVENT, 0) || current_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE)	//VOREStation Edit: selectability
		/* Bastion of Endeavor Translation
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
		*/
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>Выбрать</a>\]"
		// End of Bastion of Endeavor Translation
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")

/datum/category_item/player_setup_item/general/body/proc/markings_subwindow(mob/user, marking)
	/* Bastion of Endeavor Translation
	var/static/list/part_to_string = list(BP_HEAD = "Head", BP_TORSO = "Upper Body", BP_GROIN = "Lower Body", BP_R_ARM = "Right Arm", BP_L_ARM = "Left Arm", BP_R_HAND = "Right Hand", BP_L_HAND = "Left Hand", BP_R_LEG = "Right Leg", BP_L_LEG = "Left Leg", BP_R_FOOT = "Right Foot", BP_L_FOOT = "Left Foot")
	var/dat = "<html><body><center><h2>Editing '[marking]'</h2><br>"
	dat += "<a href='?src=\ref[src];toggle_all_marking_selection=[marking];toggle=1'>Enable All</a> "
	dat += "<a href='?src=\ref[src];toggle_all_marking_selection=[marking];toggle=0'>Disable All</a> "
	dat += "<a href='?src=\ref[src];color_all_marking_selection=[marking]'>Change Color of All</a><br></center>"
	*/
	var/static/list/part_to_string = list(BP_HEAD = "Голова", BP_TORSO = "Верхняя часть тела", BP_GROIN = "Нижняя часть тела", BP_R_ARM = "Правая рука", BP_L_ARM = "Левая рука", BP_R_HAND = "Правая ладонь", BP_L_HAND = "Левая ладонь", BP_R_LEG = "Правая нога", BP_L_LEG = "Левая нога", BP_R_FOOT = "Правая ступня", BP_L_FOOT = "Левая ступня")
	var/dat = "<html><body><center><h2>[marking]</h2>"
	dat += "<a href='?src=\ref[src];toggle_all_marking_selection=[marking];toggle=1'>Показывать на всех частях тела</a><br>"
	dat += "<a href='?src=\ref[src];toggle_all_marking_selection=[marking];toggle=0'>Скрыть на всех частях тела</a><br>"
	dat += "<a href='?src=\ref[src];color_all_marking_selection=[marking]'>Изменить цвет на всех частях тела</a><br></center>"
	// End of Bastion of Endeavor Translation
	dat += "<br>"
	for (var/bodypart in pref.body_markings[marking])
		if (!islist(pref.body_markings[marking][bodypart])) continue
		/* Bastion of Endeavor Translation
		dat += "[part_to_string[bodypart]]: [color_square(hex = pref.body_markings[marking][bodypart]["color"])] "
		dat += "<a href='?src=\ref[src];zone_marking_color=[marking];zone=[bodypart]'>Change</a> "
		dat += "<a href='?src=\ref[src];zone_marking_toggle=[marking];zone=[bodypart];toggle=[!pref.body_markings[marking][bodypart]["on"]]'>[pref.body_markings[marking][bodypart]["on"] ? "Toggle Off" : "Toggle On"]</a><br>"
		*/
		dat += "<table><tr><td>[part_to_string[bodypart]]: [color_square(hex = pref.body_markings[marking][bodypart]["color"])]</td>"
		dat += "<td><a href='?src=\ref[src];zone_marking_color=[marking];zone=[bodypart]'>Изменить</a></td>"
		dat += "<td><a href='?src=\ref[src];zone_marking_toggle=[marking];zone=[bodypart];toggle=[!pref.body_markings[marking][bodypart]["on"]]'>[pref.body_markings[marking][bodypart]["on"] ? "Показывается" : "Не показывается"]</a><br></td></tr>"
		dat += "</table>"
		// End of Bastion of Endeavor Translation

	dat += "</body></html>"
	winshow(user, "prefs_markings_subwindow", TRUE)
	/* Bastion of Endeavor Translation
	pref.markings_subwindow = new(user, "prefs_markings_browser", "Marking Editor", 400, 400)
	*/
	pref.markings_subwindow = new(user, "prefs_markings_browser", "Редактор особенности тела", 400, 500)
	// End of Bastion of Endeavor Translation
	pref.markings_subwindow.set_content(dat)
	pref.markings_subwindow.open(FALSE)
	onclose(user, "prefs_markings_subwindow", src)
