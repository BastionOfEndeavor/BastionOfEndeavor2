var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
// Change these to 0 if the equivalent mode is disabled for whatever reason!
	/* Bastion of Endeavor Translation: Kinda iffy about these but hey who cares? We don't use antags anyway so these will be disabled for the time being
	"traitor" = 1,										// 0
	"operative" = 1,									// 1
	"changeling" = 1,									// 2
	"wizard" = 1,										// 3
	"malf AI" = 1,										// 4
	"revolutionary" = 1,								// 5
	"alien candidate" = 1,								// 6
	"positronic brain" = 1,								// 7
	"cultist" = 1,										// 8
	"renegade" = 1,										// 9
	"ninja" = 1,										// 10
	"raider" = 1,										// 11
	"diona" = 1,										// 12
	"mutineer" = 1,										// 13
	"loyalist" = 1,										// 14
	"GHOST" = 0,										// CHOMPEDIT - add seperate section for ghost roles
	"pAI candidate" = 1,								// 15
	//VOREStation Add
	"lost drone" = 1,									// 16
	"maint pred" = 1,									// 17
	"morph" = 1,										// 18
	"corgi" = 1,										// 19
	"cursed sword" = 1,									// 20
	"Ship Survivor" = 1,								// 21
	//VOREStation Add End
	*/
	"предателем" = 1,									// 0
	"оперативником" = 1,								// 1
	"генокрадом" = 1,									// 2
	"волшебником" = 1,									// 3
	"неисправным ИИ" = 1,								// 4
	"революционером" = 1,								// 5
	"ксеноморфом" = 1,									// 6
	"позитронным мозгом" = 1,							// 7
	"культистом" = 1,									// 8
	"отступником" = 1,									// 9
	"ниндзя" = 1,										// 10
	"налётчиком" = 1,									// 11
	"дионеей" = 1,										// 12
	"мятежником" = 1,									// 13
	"лоялистом" = 1,									// 14
	"призраком" = 0,									
	"персональным ИИ" = 1,								// 15
	"потерявшимся дроном" = 1,							// 16
	"техтоннельным хищником" = 1,						// 17
	"метаморфом" = 1,									// 18
	"корги" = 1,										// 19
	"проклятым мечом" = 1,								// 20
	"потерпевшим крушение" = 1							// 21
	// End of Bastion of Endeavor Translation
)

/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	/* Bastion of Endeavor Edit: So that it doesn't ruin the layout
	sort_order = 2
	*/
	sort_order = 3
	// End of Bastion of Endeavor Edit

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(list/save_data)
	pref.be_special = save_data["be_special"]

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(list/save_data)
	save_data["be_special"] = pref.be_special

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	pref.be_special	= sanitize_integer(pref.be_special, 0, 16777215, initial(pref.be_special)) //VOREStation Edit - 24 bits of support

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: Translate the jobbans
	if(jobban_isbanned(user, JOB_SYNDICATE))
		. += "<b>You are banned from antagonist roles.</b>"
	*/
	if(jobban_isbanned(user, JOB_SYNDICATE))
		. += "<b>Вам запрещено играть на особых ролях.</b>"
	// End of Bastion of Endeavor Translation
		pref.be_special = 0
	else
		/* Bastion of Endeavor Translation: Making a table so that it looks pretty, Bastion of Endeavor TODO: Translate the jobbans
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, JOB_AI) && jobban_isbanned(user, JOB_CYBORG)) || (i == "pAI candidate" && jobban_isbanned(user, JOB_PAI)))
					. += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					. += "<b>Be [i]:</b> <a href='?src=\ref[src];be_special=[n]'><b>[pref.be_special&(1<<n) ? "Yes" : "No"]</b></a><br>"
			// CHOMPEdit Start -  Add header for Ghost roles section
			if(i == "GHOST")
				. += "<h4><u>GHOST ROLES</u> - Roles that are joinable as ghosts, but not true antags.</h4><br>"
			else
			//CHOMPEdit End
				n++
		*/
		. += "<b>Появление в качестве особых ролей</b>"
		. += "<table>"
		var/n = 0
		for (var/i in special_roles)
			if(special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, "AI") && jobban_isbanned(user, "Cyborg")) || (i == "pAI candidate" && jobban_isbanned(user, "pAI")))
					. += "<tr><td>Быть [i]:</td><td><font color=red><b>\[ЗАПРЕЩЕНО]</b></font></td></tr>"
				else
					. += "<tr><td>Быть [i]:</td><td><a href='?src=\ref[src];be_special=[n]'><b>[pref.be_special&(1<<n) ? "Да" : "Нет"]</b></a></td></tr>"
			// CHOMPEdit Start -  Add header for Ghost roles section
			if(i == "призраком")
				. += "<tr><td><h4><u>РОЛИ ДЛЯ ПРИЗРАКОВ</u> – Эти роли не являются антагонистами и могут выбираться призраками.</h4></td></tr>"
			else
			//CHOMPEdit End
				n++
		. += "</table>"
		// End of Bastion of Endeavor Translation

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["be_special"])
		var/num = text2num(href_list["be_special"])
		pref.be_special ^= (1<<num)
		return TOPIC_REFRESH

	return ..()
