/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = "appendix"
	var/inflamed = 0
	var/inflame_progress = 0

/mob/living/carbon/human/proc/appendicitis()
	if(stat == DEAD)
		return 0
	var/obj/item/organ/internal/appendix/A = internal_organs_by_name[O_APPENDIX]
	if(istype(A) && !A.inflamed)
		A.inflamed = 1
		return 1
	return 0

/obj/item/organ/internal/appendix/process()
	..()

	if(!inflamed || !owner)
		return

	if(++inflame_progress > 200)
		++inflamed
		inflame_progress = 0

	if(inflamed == 1)
		if(prob(5))
			/* Bastion of Endeavor Translation
			to_chat(owner, "<span class='warning'>You feel a stinging pain in your abdomen!</span>")
			owner.custom_emote(VISIBLE_MESSAGE, "winces slightly.")
			*/
			to_chat(owner, "<span class='warning'>Вы чувствуете покалывание в своём животе!</span>")
			owner.custom_emote(VISIBLE_MESSAGE, "[verb_ru(owner, "слегка дёрнул;ся;ась;ось;ись;")].")
			// End of Bastion of Endeavor Translation
	if(inflamed > 1)
		if(prob(3))
			/* Bastion of Endeavor Translation
			to_chat(owner, "<span class='warning'>You feel a stabbing pain in your abdomen!</span>")
			owner.custom_emote(VISIBLE_MESSAGE, "winces painfully.")
			*/
			to_chat(owner, "<span class='warning'>Вы чувствуете колющую боль в своём животе!</span>")
			owner.custom_emote(VISIBLE_MESSAGE, "[verb_ru(owner, "корч;ится;ится;ится;атся;")] от боли.")
			// End of Bastion of Endeavor Translation
			owner.adjustToxLoss(1)
	if(inflamed > 2)
		if(prob(1))
			owner.vomit()
	if(inflamed > 3)
		if(prob(1))
			/* Bastion of Endeavor Translation
			to_chat(owner, "<span class='danger'>Your abdomen is a world of pain!</span>")
			*/
			to_chat(owner, "<span class='danger'>Ваш живот невыносимо болит!</span>")
			// End of Bastion of Endeavor Translation
			owner.Weaken(10)

			var/obj/item/organ/external/groin = owner.get_organ(BP_GROIN)
			var/datum/wound/W = new /datum/wound/internal_bleeding(20)
			owner.adjustToxLoss(25)
			groin.wounds += W
			inflamed = 1

/obj/item/organ/internal/appendix/removed()
	if(inflamed)
		icon_state = "[initial(icon_state)]inflamed"
		/* Bastion of Endeavor Translation
		name = "inflamed appendix"
		*/
		name = "Воспалённый аппендикс"
		update_blueprint_ru(left="воспалённ;adj1*a/b(2)", separator_left = " ")
		// End of Bastion of Endeavor Translation
	..()