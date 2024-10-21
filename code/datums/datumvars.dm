/datum/proc/CanProcCall(procname)
	return TRUE

/datum/proc/can_vv_get(var_name)
	return TRUE

/datum/proc/vv_edit_var(var_name, var_value) //called whenever a var is edited
	if(var_name == NAMEOF(src, vars) || var_name == NAMEOF(src, parent_type))
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/datum/proc/vv_get_var(var_name)
	switch(var_name)
		if ("vars")
			return debug_variable(var_name, list(), 0, src)
	return debug_variable(var_name, get_variable_value(var_name), 0, src)

//please call . = ..() first and append to the result, that way parent items are always at the top and child items are further down
//add separaters by doing . += "---"
/datum/proc/vv_get_dropdown()
	. = list()
	VV_DROPDOWN_OPTION("", "---")
	/* Bastion of Endeavor Translation
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Add Component/Element")
	*/
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Вызвать прок")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Отметить объект")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Удалить")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Показать редактор игроку")
	VV_DROPDOWN_OPTION(VV_HK_ADDCOMPONENT, "Добавить компонент/элемент")
	// End of Bastion of Endeavor Translation

//This proc is only called if everything topic-wise is verified. The only verifications that should happen here is things like permission checks!
//href_list is a reference, modifying it in these procs WILL change the rest of the proc in topic.dm of admin/view_variables!
/datum/proc/vv_do_topic(list/href_list)
	if(!usr || !usr.client.holder)
		return			//This is VV, not to be called by anything else.
	IF_VV_OPTION(VV_HK_EXPOSE)
		if(!check_rights(R_ADMIN, FALSE))
			return
		var/value = usr.client.vv_get_value(VV_CLIENT)
		if (value["class"] != VV_CLIENT)
			return
		var/client/C = value["value"]
		if (!C)
			return
		/* Bastion of Endeavor Translation
		var/prompt = tgui_alert(usr, "Do you want to grant [C] access to view this VV window? (they will not be able to edit or change anysrc nor open nested vv windows unless they themselves are an admin)", "Confirm", list("Yes", "No"))
		if (prompt != "Yes" || !usr.client)
		*/
		var/prompt = tgui_alert(usr, "Вы действительно хотите дать игроку [C] доступ к этому окну Редактора переменных? (Он не сможет редактировать или изменять переменные и открывать дополнительные окна, не являясь администратором)", "Подтверждение", list("Да", "Нет"))
		if (prompt != "Да" || !usr.client)
		// End of Bastion of Endeavor Translation
			return
		/* Bastion of Endeavor Translation
		message_admins("[key_name_admin(usr)] Showed [key_name_admin(C)] a <a href='?_src_=vars;[HrefToken()];datumrefresh=\ref[src]'>VV window</a>")
		log_admin("Admin [key_name(usr)] Showed [key_name(C)] a VV window of a [src]")
		to_chat(C, "[usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"] has granted you access to view a View Variables window")
		*/
		message_admins("[key_name_admin(usr)] показал игроку [key_name_admin(C)] <a href='?_src_=vars;[HrefToken()];datumrefresh=\ref[src]'>Редактор переменных</a>.")
		log_admin("[key_name(usr)] показал игроку [key_name(C)] Редактор переменных [gcase_ru(src)]")
		to_chat(C, "[usr.client.holder.fakekey ? "Администратор" : "[usr.client.key]"] дал вам доступ к окну Редактора переменных.")
		// End of Bastion of Endeavor Translation
		C.debug_variables(src)
	IF_VV_OPTION(VV_HK_DELETE)
		if(!check_rights(R_DEBUG))
			return
		usr.client.admin_delete(src)
		if (isturf(src))  // show the turf that took its place
			usr.client.debug_variables(src)
	IF_VV_OPTION(VV_HK_MARK)
		usr.client.mark_datum(src)
	IF_VV_OPTION(VV_HK_CALLPROC)
		usr.client.callproc_datum(src)
	IF_VV_OPTION(VV_HK_ADDCOMPONENT)
		if(!check_rights(NONE))
			return
		var/list/names = list()
		var/list/componentsubtypes = sortTim(subtypesof(/datum/component), GLOBAL_PROC_REF(cmp_typepaths_asc))
		/* Bastion of Endeavor Translation
		names += "---Components---"
		*/
		names += "---Компоненты---"
		// End of Bastion of Endeavor Translation
		names += componentsubtypes
		/* Bastion of Endeavor Translation
		names += "---Elements---"
		*/
		names += "---Элементы---"
		// End of Bastion of Endeavor Translation
		names += sortTim(subtypesof(/datum/element), GLOBAL_PROC_REF(cmp_typepaths_asc))
		/* Bastion of Endeavor Translation
		var/result = tgui_input_list(usr, "Choose a component/element to add:", "Add Component/Element", names)
		if(!usr || !result || result == "---Components---" || result == "---Elements---")
		*/
		var/result = tgui_input_list(usr, "Укажите компонент или элемент, который хотите добавить:", "Добавить компонент/элемент", names)
		if(!usr || !result || result == "---Компоненты---" || result == "---Элементы---")
		// End of Bastion of Endeavor Translation
			return
		if(QDELETED(src))
			/* Bastion of Endeavor Translation
			to_chat(usr, "That thing doesn't exist anymore!")
			*/
			to_chat(usr, "Редактируемый объект больше не существует!")
			// End of Bastion of Endeavor Translation
			return
		var/list/lst = usr.client.get_callproc_args()
		if(!lst)
			return
		/* Bastion of Endeavor Translation
		var/datumname = "error"
		*/
		var/datumname = "ошибка"
		// End of Bastion of Endeavor Translation
		lst.Insert(1, result)
		if(result in componentsubtypes)
			/* Bastion of Endeavor Translation
			datumname = "component"
			*/
			datumname = "компонент"
			// End of Bastion of Endeavor Translation
			_AddComponent(lst)
		else
			/* Bastion of Endeavor Translation
			datumname = "element"
			*/
			datumname = "элемент"
			// End of Bastion of Endeavor Translation
			_AddElement(lst)
		/* Bastion of Endeavor Translation
		log_admin("[key_name(usr)] has added [result] [datumname] to [key_name(src)].")
		message_admins(span_notice("[key_name_admin(usr)] has added [result] [datumname] to [key_name_admin(src)]."))
		*/
		log_admin("[key_name(usr)] применил [datumname] [result] к [key_name(src)].")
		message_admins(span_notice("[key_name_admin(usr)] применил [datumname] [result] к [key_name_admin(src)]."))
		// End of Bastion of Endeavor Translation

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += span_bold("[vars["name"]]") + "<br>"

/datum/proc/on_reagent_change(changetype)
	return
