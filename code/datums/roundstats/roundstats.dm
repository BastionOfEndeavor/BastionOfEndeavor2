
/*
 * lbnesquik - Github
 * Provided massive components of this. Polaris PR #5720.
 */

//This is for the round end stats system.

//roundstat is used for easy finding of the variables, if you ever want to delete all of this,
//just search roundstat and you'll find everywhere this thing reaches into.
//It used to be bazinga but it only fly with microwaves.

GLOBAL_VAR_INIT(cans_opened_roundstat, 0)
GLOBAL_VAR_INIT(lights_switched_on_roundstat, 0)
GLOBAL_VAR_INIT(turbo_lift_floors_moved_roundstat, 0)
GLOBAL_VAR_INIT(lost_limbs_shift_roundstat, 0)
GLOBAL_VAR_INIT(seed_planted_shift_roundstat, 0)
GLOBAL_VAR_INIT(step_taken_shift_roundstat, 0)
GLOBAL_VAR_INIT(destroyed_research_items_roundstat, 0)
GLOBAL_VAR_INIT(items_sold_shift_roundstat, 0)
GLOBAL_VAR_INIT(disposals_flush_shift_roundstat, 0)
GLOBAL_VAR_INIT(rocks_drilled_roundstat, 0)
GLOBAL_VAR_INIT(mech_destroyed_roundstat, 0)
GLOBAL_VAR_INIT(prey_eaten_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(prey_absorbed_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(prey_digested_roundstat, 0)		//VOREStation Edit - Obviously
GLOBAL_VAR_INIT(items_digested_roundstat, 0)	//VOREStation Edit - Obviously
var/global/list/security_printer_tickets = list()	//VOREStation Edit


/hook/roundend/proc/RoundTrivia()//bazinga
	var/list/valid_stats_list = list() //This is to be populated with the good shit

	if(GLOB.lost_limbs_shift_roundstat > 1)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.lost_limbs_shift_roundstat] limbs left their owners bodies this shift, oh no!")
		*/
		valid_stats_list.Add("[count_ru(GLOB.lost_limbs_shift_roundstat, ";конечность покинула своего владельца;конечности покинули своих владельцев;конечностей покинуло своих владельцев")] за эту смену, о нет!")
		// End of Bastion of Endeavor Translation
	else if(GLOB.destroyed_research_items_roundstat > 13)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.destroyed_research_items_roundstat] objects were destroyed in the name of Science! Keep it up!")
		*/
		valid_stats_list.Add("[count_ru(GLOB.destroyed_research_items_roundstat, ";объект был уничтожен;объекта было уничтожено;объектов было уничтожено")] во имя науки! Так держать!")
		// End of Bastion of Endeavor Translation
	else if(GLOB.mech_destroyed_roundstat > 1)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.mech_destroyed_roundstat] mechs were destroyed this shift. What did you do?")
		*/
		valid_stats_list.Add("[count_ru(GLOB.mech_destroyed_roundstat, ";мех был уничтожен;меха было уничтожено;мехов было уничтожено")] за эту смену. Как вы умудрились?")
		// End of Bastion of Endeavor Translation
	else if(GLOB.seed_planted_shift_roundstat > 20)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.seed_planted_shift_roundstat] seeds were planted according to our sensors this shift.")
		*/
		valid_stats_list.Add("[count_ru(GLOB.seed_planted_shift_roundstat, ";семя;семени;семян")] было посажено за эту смену согласно нашим датчикам.")
		// End of Bastion of Endeavor Translation

	if(GLOB.rocks_drilled_roundstat > 80)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("Our strong miners pulverized a whole [GLOB.rocks_drilled_roundstat] piles of pathetic rubble.")
		*/
		valid_stats_list.Add("Наши могучие шахтёры выкопали аж [count_ru(GLOB.rocks_drilled_roundstat, "груд;у;ы;")] каменистой породы.")
		// End of Bastion of Endeavor Translation
	else if(GLOB.items_sold_shift_roundstat > 15)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("The vending machines sold [GLOB.items_sold_shift_roundstat] items today.")
		*/
		valid_stats_list.Add("Торговые автоматы за сегодня продали [count_ru(GLOB.items_sold_shift_roundstat, "предмет;;а;ов")].")
		// End of Bastion of Endeavor Translation
	else if(GLOB.step_taken_shift_roundstat > 900)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("The employees walked a total of [GLOB.step_taken_shift_roundstat] steps for this shift! It should put them on the road to fitness!")
		*/
		valid_stats_list.Add("Наши работники сделали [count_ru(GLOB.step_taken_shift_roundstat, "шаг;;а;ов")] за эту смену! Движение – жизнь!")
		// End of Bastion of Endeavor Translation

	if(GLOB.cans_opened_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.cans_opened_roundstat] cans were drank today!")
		*/
		valid_stats_list.Add("[count_ru(GLOB.cans_opened_roundstat, ";банка с газировкой была выпита;банки с газировкой было выпито;банок с газировкой было выпито")] за сегодня!")
		// End of Bastion of Endeavor Translation
	else if(GLOB.lights_switched_on_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("[GLOB.lights_switched_on_roundstat] light switches were flipped today!")
		*/
		valid_stats_list.Add("[count_ru(GLOB.lights_switched_on_roundstat, ";выключатель света был использован;выключателя света было использовано;выключателей света было использовано")] за сегодня!")
		// End of Bastion of Endeavor Translation
	else if(GLOB.turbo_lift_floors_moved_roundstat > 20)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("The elevator moved up [GLOB.turbo_lift_floors_moved_roundstat] floors today!")
		*/
		valid_stats_list.Add("Лифт проехал за сегодня [count_ru(GLOB.turbo_lift_floors_moved_roundstat, "этаж;;а;ей")]!")
		// End of Bastion of Endeavor Translation
	else if(GLOB.disposals_flush_shift_roundstat > 40)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("The disposal system flushed a whole [GLOB.disposals_flush_shift_roundstat] times for this shift. We should really invest in waste treatement.")
		*/
		valid_stats_list.Add("Система сортировки была активирована [count_ru(GLOB.disposals_flush_shift_roundstat, "раз;;а;")] за эту смену. Пора вложиться в переработку мусора!")
		// End of Bastion of Endeavor Translation

	//VOREStation add Start - Ticket time!
	if(security_printer_tickets.len)
		/* Bastion of Endeavor Translation
				valid_stats_list.Add(span_danger("[security_printer_tickets.len] unique security tickets were issued today!") + "<br>Examples include:")
		*/
		valid_stats_list.Add(span_danger("[count_ru(security_printer_tickets.len, ";штраф был выписан;штрафа было выписано;штрафов было выписано")] службой безопасности за эту смену!") + "<br>По таким причинам, как:")
		// End of Bastion of Endeavor Translation
		var/good_num = 5
		var/ourticket
		while(good_num > 0)
			ourticket = null
			if(security_printer_tickets.len)
				ourticket = pick(security_printer_tickets)
				security_printer_tickets -= ourticket
				if(ourticket)
					valid_stats_list.Add(span_bold("-")+"\"[ourticket]\"")
				good_num--
			else
				good_num = 0

	//VOREStation Add Start - Vore stats lets gooooo
	if(GLOB.prey_eaten_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("Individuals were eaten a total of [GLOB.prey_eaten_roundstat] times today!") //CHOMPEdit
		*/
		valid_stats_list.Add("За сегодня было съедено [count_ru(GLOB.prey_eaten_roundstat, "существ;о;а;")]!")
		// End of Bastion of Endeavor Translation
	if(GLOB.prey_digested_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("A total of [GLOB.prey_digested_roundstat] individuals were digested today!")
		*/
		valid_stats_list.Add("За сегодня было переварено [count_ru(GLOB.prey_digested_roundstat, "существ;о;а;")]!")
		// End of Bastion of Endeavor Translation
	if(GLOB.prey_absorbed_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("A total of [GLOB.prey_absorbed_roundstat] individuals were absorbed today!")
		*/
		valid_stats_list.Add("За сегодня было впитано [count_ru(GLOB.prey_absorbed_roundstat, "существ;о;а;")]!")
		// End of Bastion of Endeavor Translation
	if(GLOB.items_digested_roundstat > 0)
		/* Bastion of Endeavor Translation
		valid_stats_list.Add("A total of [GLOB.items_digested_roundstat] items were digested today!")
		*/
		valid_stats_list.Add("За сегодня [count_ru(GLOB.items_digested_roundstat, ";был переварен;было переварено;было переварено", TRUE)] [count_ru(GLOB.items_digested_roundstat, "предмет;;а;ов")]!")
		// End of Bastion of Endeavor Translation
	//VOREStation Add End

	if(LAZYLEN(valid_stats_list))
<<<<<<< HEAD
		/* Bastion of Endeavor Translation
		to_world("<B>Shift trivia!</B>")
		*/
		to_world("<B>Интересные факты о смене!</B>")
		// End of Bastion of Endeavor Translation
=======
		to_world(span_world("Shift trivia!"))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))

		for(var/body in valid_stats_list)
			to_world(span_filter_system("[body]"))
