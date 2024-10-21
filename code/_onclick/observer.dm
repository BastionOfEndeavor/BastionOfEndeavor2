/client/var/inquisitive_ghost = 1
/mob/observer/dead/verb/toggle_inquisition() // warning: unexpected inquisition
	/* Bastion of Endeavor Translation
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost.Settings" //CHOMPEdit
	*/
	set name = "Переключить любознательность"
	set desc = "Переключить осмотр вашим призраком всего, на что вы нажимаете."
	set category = "Призрак.Настройки"
	// End of Bastion of Endeavor Translation
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		/* Bastion of Endeavor Translation
		to_chat(src, span_notice("You will now examine everything you click on."))
		*/
		to_chat(src, span_notice("Вы теперь будете осматривать всё, на что нажимаете."))
		// End of Bastion of Endeavor Translation
	else
		/* Bastion of Endeavor Translation
		to_chat(src, span_notice("You will no longer examine things you click on."))
		*/
		to_chat(src, span_notice("Вы больше не будете осматривать всё, на что нажимаете."))
		// End of Bastion of Endeavor Translation

/mob/observer/dead/DblClickOn(var/atom/A, var/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return

	// Things you might plausibly want to follow
	if(istype(A,/atom/movable))
		ManualFollow(A)
	// Otherwise jump
	else
		if(following)
			stop_following()
		forceMove(get_turf(A))

/mob/observer/dead/ClickOn(var/atom/A, var/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(!checkClickCooldown()) return
	setClickCooldown(4)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		examinate(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		var/turf/T = get_turf(A)
		if(T && TurfAdjacent(T))
			set_listed_turf(T)
			return
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/dead/user as mob)
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)
	return

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/user as mob)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com?.teleport_control.locked)
		user.loc = get_turf(com.teleport_control.locked)

/obj/effect/portal/attack_ghost(mob/user as mob)
	if(target)
		user.loc = get_turf(target)

// VOREStation Edit Begin

/obj/machinery/gateway/centerstation/attack_ghost(mob/user as mob)
	if(awaygate)
		if(user.client.holder)
			user.loc = awaygate.loc
		else if(active)
			user.loc = awaygate.loc
		else
			return
	else
		/* Bastion of Endeavor Translation
		to_chat(user, "[src] has no destination.")
		*/
		to_chat(user, "У [gcase_ru(src)] отсутствует пункт назначения.")
		// End of Bastion of Endeavor Translation

// VOREStation Edit End

/obj/machinery/gateway/centeraway/attack_ghost(mob/user as mob)
	if(stationgate)
		user.loc = stationgate.loc
	else
		/* Bastion of Endeavor Translation
		to_chat(user, "[src] has no destination.")
		*/
		to_chat(user, "У [gcase_ru(src)] отсутствует пункт назначения.")
		// End of Bastion of Endeavor Translation

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/
