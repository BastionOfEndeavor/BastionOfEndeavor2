/obj/screen/proc/Click_vr(location, control, params)
	if(!usr)	return 1
	switch(name)

		//Shadekin
		/* Bastion of Endeavor Translation
		if("darkness")
		*/
		if("Тьма")
		// End of Bastion of Endeavor Translation
			var/turf/T = get_turf(usr)
			var/darkness = round(1 - T.get_lumcount(),0.1)
<<<<<<< HEAD
			/* Bastion of Endeavor Translation
			to_chat(usr,span_notice("<b>Darkness:</b> [darkness]"))
			*/
			to_chat(usr,span_notice("<b>Тьма:</b> [darkness]"))
			// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
=======
			to_chat(usr,span_notice(span_bold("Darkness:") + " [darkness]"))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
		if("energy")
		*/
		if("Энергия")
		// End of Bastion of Endeavor Translation
			var/mob/living/simple_mob/shadekin/SK = usr
			if(istype(SK))
<<<<<<< HEAD
				/* Bastion of Endeavor Translation
				to_chat(usr,span_notice("<b>Energy:</b> [SK.energy] ([SK.dark_gains])"))
				*/
				to_chat(usr,span_notice("<b>Энергия:</b> [SK.energy] ([SK.dark_gains])"))
				// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
=======
				to_chat(usr,span_notice(span_bold("Energy:") + " [SK.energy] ([SK.dark_gains])"))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
		if("shadekin status")
		*/
		if("Состояние")
		// End of Bastion of Endeavor Translation
			var/turf/T = get_turf(usr)
			if(T)
				var/darkness = round(1 - T.get_lumcount(),0.1)
<<<<<<< HEAD
				/* Bastion of Endeavor Translation
				to_chat(usr,span_notice("<b>Darkness:</b> [darkness]"))
				*/
				to_chat(usr,span_notice("<b>Тьма:</b> [darkness]"))
				// End of Bastion of Endeavor Translation
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/shadekin))
				/* Bastion of Endeavor Translation
				to_chat(usr,span_notice("<b>Energy:</b> [H.shadekin_get_energy(H)]"))
				*/
				to_chat(usr,span_notice("<b>Энергия:</b> [H.shadekin_get_energy(H)]"))
				// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
=======
				to_chat(usr,span_notice(span_bold("Darkness:") + " [darkness]"))
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/shadekin))
				to_chat(usr,span_notice(span_bold("Energy:") + " [H.shadekin_get_energy(H)]"))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
		if("glamour")
		*/
		if("Гламур")
		// End of Bastion of Endeavor Translation
			var/mob/living/carbon/human/H = usr
			if(istype(H))
<<<<<<< HEAD
				/* Bastion of Endeavor Translation
				to_chat(usr,span_notice("<b>Energy:</b> [H.species.lleill_energy]/[H.species.lleill_energy_max]"))
				*/
				to_chat(usr,span_notice("<b>Энергия:</b> [H.species.lleill_energy]/[H.species.lleill_energy_max]"))
				// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
=======
				to_chat(usr,span_notice(span_bold("Energy:") + " [H.species.lleill_energy]/[H.species.lleill_energy_max]"))
>>>>>>> 7416cbea22 ([MIRROR] next set of spans (#9247))
		if("danger level")
		*/
		if("Уровень опасности")
		// End of Bastion of Endeavor Translation
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/xenochimera))
				if(H.feral > 50)
					/* Bastion of Endeavor Translation
					to_chat(usr, span_warning("You are currently <b>completely feral.</b>"))
					*/
					to_chat(usr, span_warning("Вы <b>полностью одичали</b>."))
					// End of Bastion of Endeavor Translation
				else if(H.feral > 10)
					/* Bastion of Endeavor Translation
					to_chat(usr, span_warning("You are currently <b>crazed and confused.</b>"))
					*/
					to_chat(usr, span_warning("Вы постепенно <b>начинаете сходить с ума</b>."))
					// End of Bastion of Endeavor Translation
				else if(H.feral > 0)
					/* Bastion of Endeavor Translation
					to_chat(usr, span_warning("You are currently <b>acting on instinct.</b>"))
					*/
					to_chat(usr, span_warning("Вы сейчас <b>полагаетесь на инстинкты</b>."))
					// End of Bastion of Endeavor Translation
				else
					/* Bastion of Endeavor Translation
					to_chat(usr, span_notice("You are currently <b>calm and collected.</b>"))
					*/
					to_chat(usr, span_notice("Вы сейчас <b>полностью спокойны</b>."))
					// End of Bastion of Endeavor Translation
				if(H.feral > 0)
					var/feral_passing = TRUE
					if(H.traumatic_shock > min(60, H.nutrition/10))
						/* Bastion of Endeavor Translation
						to_chat(usr, span_warning("Your pain prevents you from regaining focus."))
						*/
						to_chat(usr, span_warning("Боль мешает вам сосредоточиться."))
						// End of Bastion of Endeavor Translation
						feral_passing = FALSE
					if(H.feral + H.nutrition < 150)
						/* Bastion of Endeavor Translation
						to_chat(usr, span_warning("Your hunger prevents you from regaining focus."))
						*/
						to_chat(usr, span_warning("Голод мешает вам сосредоточиться."))
						// End of Bastion of Endeavor Translation
						feral_passing = FALSE
					if(H.jitteriness >= 100)
						/* Bastion of Endeavor Translation
						to_chat(usr, span_warning("Your jitterness prevents you from regaining focus."))
						*/
						to_chat(usr, span_warning("Дрожь мешает вам сосредоточиться."))
						// End of Bastion of Endeavor Translation
						feral_passing = FALSE
					if(feral_passing)
						var/turf/T = get_turf(H)
						if(T.get_lumcount() <= 0.1)
							/* Bastion of Endeavor Translation
							to_chat(usr, span_notice("You are slowly calming down in darkness' safety..."))
							*/
							to_chat(usr, span_notice("Вы постепенно успокаиваетесь, находясь в родных объятиях тьмы..."))
							// End of Bastion of Endeavor Translation

						else if(isbelly(H.loc)) // Safety message for if inside a belly.
							/* Bastion of Endeavor Translation
							to_chat(usr, span_notice("You are slowly calming down within the darkness of something's belly, listening to their body as it moves around you. ...safe..."))
							*/
							to_chat(usr, span_notice("Вы постепенно успокиваетесь, находясь во тьме в чьём-то животе и слыша, как тело движется вокруг вас.. Вы в безопасности."))
							// End of Bastion of Endeavor Translation
						else
							/* Bastion of Endeavor Translation
							to_chat(usr, span_notice("You are slowly calming down... But safety of darkness is much preferred."))
							*/
							to_chat(usr, span_notice("Вы постепенно успокаиваетесь... но вам хочется обратно во тьму."))
							// End of Bastion of Endeavor Translation
				else
					if(H.nutrition < 150)
						/* Bastion of Endeavor Translation
						to_chat(usr, span_warning("Your hunger is slowly making you unstable."))
						*/
						to_chat(usr, span_warning("Голод постепенно доводит вас до неуравновешенности."))
						// End of Bastion of Endeavor Translation
		/* Bastion of Endeavor Translation
		if("Reconstructing Form") // Allow Viewing Reconstruction Timer + Hatching for 'chimera
		*/
		if("Воссоздание формы")
		// End of Bastion of Endeavor Translation
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/xenochimera)) // If you're somehow able to click this while not a chimera, this should prevent weird runtimes. Will need changing if regeneration is ever opened to non-chimera using the same alert.
				if(H.revive_ready == REVIVING_NOW)
					/* Bastion of Endeavor Translation
					to_chat(usr, span_notice("We are currently reviving, and will be done in [round((H.revive_finished - world.time) / 10)] seconds, or [round(((H.revive_finished - world.time) * 0.1) / 60)] minutes."))
					*/
					to_chat(usr, span_notice("Мы в процессе возрождения и закончим только через [count_ru(round((H.revive_finished - world.time) / 10), "секунд;у;ы;")] ([count_ru(round(((H.revive_finished - world.time) * 0.1) / 60), "минут;у;ы;")])."))
					// End of Bastion of Endeavor Translation
				else if(H.revive_ready == REVIVING_DONE)
					/* Bastion of Endeavor Translation
					to_chat(usr, span_warning("You should have a notification + alert for this! Bug report that this is still here!"))
					*/
					to_chat(usr, span_warning("Возрождение должно сопровождаться уведомлением и иконкой! Доложите об этом баге!"))
					// End of Bastion of Endeavor Translation

		/* Bastion of Endeavor Translation
		if("Ready to Hatch") // Allow Viewing Reconstruction Timer + Hatching for 'chimera
		*/
		if("Готовность вылупиться")
		// End of Bastion of Endeavor Translation
			var/mob/living/carbon/human/H = usr
			if(istype(H) && istype(H.species, /datum/species/xenochimera)) // If you're somehow able to click this while not a chimera, this should prevent weird runtimes. Will need changing if regeneration is ever opened to non-chimera using the same alert.
				if(H.revive_ready == REVIVING_DONE) // Sanity check.
					H.hatch() // Hatch.

		else
			return 0

	return 1
