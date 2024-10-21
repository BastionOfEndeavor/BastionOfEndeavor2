/datum/vote
	// Person who started the vote
	/* Bastion of Endeavor Translation
	var/initiator = "the server"
	*/
	var/initiator = "Сервер"
	// End of Bastion of Endeavor Translation
	// world.time the bote started at
	var/started_time
	// The question being asked
	var/question
	// Vote type text, for showing in UIs and stuff
	/* Bastion of Endeavor Translation
	var/vote_type_text = "unset"
	*/
	var/vote_type_text = "голосование без текста"
	// End of Bastion of Endeavor Translation
	// Do we want to show the vote count as it goes
	var/show_counts = FALSE
	// Vote result type. This determines how a winner is picked
	var/vote_result_type = VOTE_RESULT_TYPE_MAJORITY
	// Was this this vote custom started?
	var/is_custom = FALSE
	// Choices available in the vote
	var/list/choices = list()
	// Assoc list of [ckeys => choice] who have voted. We don't want to hold clients refs.___callbackvarset(list_or_datum, var_name, var_value)
	var/list/voted = list()
	// For how long will it be up
	var/vote_time = 60 SECONDS

/datum/vote/New(var/_initiator, var/_question, list/_choices, var/_is_custom = FALSE)
	if(SSvote.active_vote)
		/* Bastion of Endeavor Translation
		CRASH("Attempted to start another vote with one already in progress!")
		*/
		CRASH("Попытка инициировать голосование до окончания другого!")
		// End of Bastion of Endeavor Translation

	if(_initiator)
		initiator = _initiator
	if(_question)
		question = _question
	if(_choices)
		choices = _choices

	is_custom = _is_custom

	// If we have no choices, dynamically generate them
	if(!length(choices))
		generate_choices()

/datum/vote/proc/start()
	/* Bastion of Endeavor Translation
	var/text = "[capitalize(vote_type_text)] vote started by [initiator]."
	*/
	var/text = "[capitalize(initiator)] инициировал [vote_type_text]."
	// End of Bastion of Endeavor Translation
	if(is_custom)
		/* Bastion of Endeavor Translation
		vote_type_text = "custom"
		*/
		vote_type_text = "особый опрос"
		// End of Bastion of Endeavor Translation
		text += "\n[question]"
		if(usr)
			/* Bastion of Endeavor Translation
			log_admin("[capitalize(vote_type_text)] ([question]) vote started by [key_name(usr)].")
			*/
			log_admin("[key_name(usr)] инициировал [vote_type_text] ([question]).")
			// End of Bastion of Endeavor Translation

	else if(usr)
		/* Bastion of Endeavor Translation
		log_admin("[capitalize(vote_type_text)] vote started by [key_name(usr)].")
		*/
		log_admin("[key_name(usr)] инициировал [vote_type_text].")
		// End of Bastion of Endeavor Translation

	log_vote(text)
	started_time = world.time
	announce(text)

/datum/vote/proc/remaining()
	return max(((started_time + vote_time - world.time)/10), 0)

/datum/vote/proc/calculate_result()
    if(!length(voted))
        /* Bastion of Endeavor Translation
        to_chat(world, span_interface("No votes were cast. Do you all hate democracy?!"))
        */
        to_chat(world, span_interface("Голосование завершилось без единого голоса. Вам не нравится демократия?"))
        // End of Bastion of Endeavor Translation
        return null

    return calculate_vote_result(voted, choices, vote_result_type)


/datum/vote/proc/calculate_vote_result(var/list/voted, var/list/choices, var/vote_result_type)
    var/list/results = list()

    for(var/ck in voted)
        if(voted[ck] in results)
            results[voted[ck]]++
        else
            results[voted[ck]] = 1

    var/maxvotes = 0
    for(var/res in results)
        maxvotes = max(results[res], maxvotes)

    var/list/winning_options = list()

    for(var/res in results)
        if(results[res] == maxvotes)
            winning_options |= res

    for(var/res in results)
        /* Bastion of Endeavor Translation
        to_chat(world, span_interface("<code>[res]</code> - [results[res]] vote\s"))
        */
        to_chat(world, span_interface("<code>[res]</code> - [count_ru(results[res], "голос;;а;ов")]"))
        // End of Bastion of Endeavor Translation

    switch(vote_result_type)
        if(VOTE_RESULT_TYPE_MAJORITY)
            if(length(winning_options) == 1)
                var/res = winning_options[1]
                if(res in choices)
<<<<<<< HEAD
                    /* Bastion of Endeavor Translation
                    to_chat(world, span_interface("<b><code>[res]</code> won the vote!</b>"))
                    */
                    to_chat(world, span_interface("<b>В голосовании победил вариант \"<code>[res]</code>!\"</b>"))
                    // End of Bastion of Endeavor Translation
=======
                    to_chat(world, span_interface(span_bold("<code>[res]</code> won the vote!")))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
                    return res
                else
                    /* Bastion of Endeavor Translation
                    to_chat(world, span_interface("The winner of the vote ([sanitize(res)]) isn't a valid choice? What the heck?"))
                    stack_trace("Vote concluded with an invalid answer. Answer was [sanitize(res)], choices were [json_encode(choices)]")
                    */
                    to_chat(world, span_interface("Победивший в голосовании ответ \"([sanitize(res)])\" даже не участвовал. Как?"))
                    stack_trace("Голосование завершилось с недопустимым ответом. Ответ - [sanitize(res)], варианты - [json_encode(choices)]")
                    // End of Bastion of Endeavor Translation
                    return null

<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            to_chat(world, span_interface("<b>No clear winner. The vote did not pass.</b>"))
            */
            to_chat(world, span_interface("<b>Голосование завершилось без победителя.</b>"))
            // End of Bastion of Endeavor Translation
=======
            to_chat(world, span_interface(span_bold("No clear winner. The vote did not pass.")))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
            return null

        if(VOTE_RESULT_TYPE_SKEWED)
            var/required_votes = ceil(length(voted) * 0.7)  // 70% of total votes
            if(maxvotes >= required_votes && length(winning_options) == 1)
                var/res = winning_options[1]
                if(res in choices)
<<<<<<< HEAD
                    /* Bastion of Endeavor Translation
                    to_chat(world, span_interface("<b><code>[res]</code> won the vote with a 70% majority!</b>"))
                    */
                    to_chat(world, span_interface("<b>В голосовании победил вариант \"<code>[res]</code>\", собрав 70% и более голосов!</b>"))
                    // End of Bastion of Endeavor Translation
=======
                    to_chat(world, span_interface(span_bold("<code>[res]</code> won the vote with a 70% majority!")))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
                    return res
                else
                    /* Bastion of Endeavor Translation
                    to_chat(world, span_interface("The winner of the vote ([sanitize(res)]) isn't a valid choice? What the heck?"))
                    stack_trace("Vote concluded with an invalid answer. Answer was [sanitize(res)], choices were [json_encode(choices)]")
                    */
                    to_chat(world, span_interface("Победивший в голосовании ответ \"([sanitize(res)])\" даже не участвовал. Как?"))
                    stack_trace("Голосование завершилось с недопустимым ответом. Ответ - [sanitize(res)], варианты - [json_encode(choices)]")
                    // End of Bastion of Endeavor Translation
                    return null

<<<<<<< HEAD
            /* Bastion of Endeavor Translation
            to_chat(world, span_interface("<b>No option received 70% of the votes. The vote did not pass.</b>"))
            */
            to_chat(world, span_interface("<b>Ни один вариант ответа голосования не собрал 70% голосов. Голосование завершено.</b>"))
            // End of Bastion of Endeavor Translation
=======
            to_chat(world, span_interface(span_bold("No option received 70% of the votes. The vote did not pass.")))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
            return null

    return null

/datum/vote/proc/announce(start_text, var/time = vote_time/10)
    /* Bastion of Endeavor Translation
    to_chat(world, span_lightpurple("Type <b>vote</b> or click <a href='?src=\ref[src];[HrefToken()];vote=open'>here</a> to place your vote. \
        You have [time] seconds to vote."))
    */
    to_chat(world, span_lightpurple("Введите <b>Голосовать</b> или нажмите <a href='?src=\ref[src];[HrefToken()];vote=open'>здесь</a>, чтобы участвовать в голосовании. \
        Голосование продлится [count_ru(time, "секунд;а;ы;")]."))
    // End of Bastion of Endeavor Translation
    world << sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3)

/datum/vote/Topic(href, list/href_list)
    if(href_list["vote"] == "open")
        if(src)
            tgui_interact(usr)
        else
            /* Bastion of Endeavor Translation
            to_chat(usr, "There is no active vote to participate in.")
            */
            to_chat(usr, "На данный момент не проводится голосование.")
            // End of Bastion of Endeavor Translation

/datum/vote/proc/tick()
	if(remaining() == 0)
		var/result = calculate_result()
		handle_result(result)
		qdel(src)

/datum/vote/Destroy(force)
	if(SSvote.active_vote == src)
		SSvote.active_vote = null
	return ..()

/datum/vote/proc/handle_result(result)
	return

/datum/vote/proc/generate_choices()
	return

/*
	UI STUFFS
*/

/datum/vote/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/vote/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		/* Bastion of Endeavor Translation
		ui = new(user, src, "VotePanel", "Vote Panel")
		*/
		ui = new(user, src, "VotePanel", "Голосование")
		// End of Bastion of Endeavor Translation
		ui.open()

/datum/vote/tgui_data(mob/user)
	var/list/data = list()
	data["remaining"] = remaining()
	data["user_vote"] = null
	if(user.ckey in voted)
		data["user_vote"] = voted[user.ckey]

	data["question"] = question
	data["choices"] = choices

	if(show_counts || check_rights(R_ADMIN, FALSE, user))
		data["show_counts"] = TRUE

		var/list/counts = list()
		for(var/ck in voted)
			if(voted[ck] in counts)
				counts[voted[ck]]++
			else
				counts[voted[ck]] = 1

		data["counts"] = counts
	else
		data["show_counts"] = FALSE
		data["counts"] = list()

	return data

/datum/vote/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return

	. = TRUE

	switch(action)
		if("vote")
			if(params["target"] in choices)
				voted[usr.ckey] = params["target"]
			else
				/* Bastion of Endeavor Translation
				message_admins(span_warning("User [key_name_admin(usr)] spoofed a vote in the vote panel!"))
				*/
				message_admins(span_warning("Пользователь [key_name_admin(usr)] подкрутил голос в панели голосования!"))
				// End of Bastion of Endeavor Translation
