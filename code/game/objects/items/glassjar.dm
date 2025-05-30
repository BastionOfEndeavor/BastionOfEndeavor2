
#define JAR_NOTHING 0
#define JAR_MONEY   1
#define JAR_ANIMAL  2
#define JAR_SPIDER  3

/obj/item/glass_jar
	name = "glass jar"
	desc = "A small empty jar."
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_GLASS = 200)
	flags = NOBLUDGEON
	var/list/accept_mobs = list(/mob/living/simple_mob/animal/passive/lizard, /mob/living/simple_mob/animal/passive/mouse, /mob/living/simple_mob/animal/sif/leech, /mob/living/simple_mob/animal/sif/frostfly, /mob/living/simple_mob/animal/sif/glitterfly)
	var/contains = 0 // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/glass_jar/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /mob))
		var/accept = 0
		for(var/D in accept_mobs)
			if(istype(A, D))
				accept = 1
		if(!accept)
			to_chat(user, "[A] doesn't fit into \the [src].")
			return
		var/mob/L = A
		user.visible_message(span_notice("[user] scoops [L] into \the [src]."), span_notice("You scoop [L] into \the [src]."))
		L.loc = src
		contains = JAR_ANIMAL
		update_icon()
		return
	else if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message(span_notice("[user] scoops [S] into \the [src]."), span_notice("You scoop [S] into \the [src]."))
		S.loc = src
		STOP_PROCESSING(SSobj, S) // No growing inside jars
		contains = JAR_SPIDER
		update_icon()
		return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(JAR_MONEY)
			for(var/obj/O in src)
				O.loc = user.loc
			to_chat(user, span_notice("You take money out of \the [src]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				M.loc = user.loc
				user.visible_message(span_notice("[user] releases [M] from \the [src]."), span_notice("You release [M] from \the [src]."))
			contains = JAR_NOTHING
			update_icon()
			return
		if(JAR_SPIDER)
			for(var/obj/effect/spider/spiderling/S in src)
				S.loc = user.loc
				user.visible_message(span_notice("[user] releases [S] from \the [src]."), span_notice("You release [S] from \the [src]."))
				START_PROCESSING(SSobj, S) // They can grow after being let out though
			contains = JAR_NOTHING
			update_icon()
			return
	//CHOMPDDITION: your god can not help you
	for(var/mob/M in src)
		if(istype(M,/mob/living/voice)) //Don't knock voices out!
			continue
		M.forceMove(get_turf(user))
		to_chat(M, span_warning("[user] shakes you out of \the [src]!"))
		to_chat(user, span_notice("You shake [M] out of \the [src]!"))
//CHOMPADD END
/obj/item/glass_jar/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/spacecash))
		if(contains == JAR_NOTHING)
			contains = JAR_MONEY
		if(contains != JAR_MONEY)
			return
		var/obj/item/spacecash/S = W
		user.visible_message(span_notice("[user] puts [S.worth] [S.worth > 1 ? "thalers" : "thaler"] into \the [src]."))
		user.drop_from_inventory(S)
		S.loc = src
		update_icon()
	//CHOMPDDITION: your god can not help you
	if(istype(W,/obj/item/holder/micro))
		var/full = 0
		for(var/mob/M in src)
			if(istype(M,/mob/living/voice)) //Don't count voices as people!
				continue
			full++
		if(full >= 2)
			to_chat(user, span_warning("You can't fit anyone else into \the [src]!"))
		else
			var/obj/item/holder/micro/holder = W
			if(holder.held_mob && (holder.held_mob in holder))
				var/mob/living/M = holder.held_mob
				holder.dump_mob()
				to_chat(M, span_warning("[user] stuffs you into \the [src]!"))
				M.forceMove(src)
				to_chat(user, span_notice("You stuff \the [M] into \the [src]!"))
//CHOMPADD END
/obj/item/glass_jar/update_icon() // Also updates name and desc
	underlays.Cut()
	cut_overlays()
	switch(contains)
		if(JAR_NOTHING)
			name = initial(name)
			desc = initial(desc)
		if(JAR_MONEY)
			name = "tip jar"
			desc = "A small jar with money inside."
			for(var/obj/item/spacecash/S in src)
				var/image/money = image(S.icon, S.icon_state)
				money.pixel_x = rand(-2, 3)
				money.pixel_y = rand(-6, 6)
				money.transform *= 0.6
				underlays += money
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				var/image/victim = image(M.icon, M.icon_state)
				victim.pixel_y = 6
				victim.color = M.color
				if(M.plane == PLANE_LIGHTING_ABOVE)	// This will only show up on the ground sprite, due to the HuD being over it, so we need both images.
					var/image/victim_glow = image(M.icon, M.icon_state)
					victim_glow.pixel_y = 6
					victim_glow.color = M.color
					underlays += victim_glow
				underlays += victim
				name = "glass jar with [M]"
				desc = "A small jar with [M] inside."
		if(JAR_SPIDER)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				name = "glass jar with [S]"
				desc = "A small jar with [S] inside."
	return

/obj/item/glass_jar/fish
	name = "glass tank"
	desc = "A large glass tank."

	var/filled = FALSE

	w_class = ITEMSIZE_NORMAL

	accept_mobs = list(/mob/living/simple_mob/animal/passive/lizard, /mob/living/simple_mob/animal/passive/mouse, /mob/living/simple_mob/animal/sif/leech, /mob/living/simple_mob/animal/sif/frostfly, /mob/living/simple_mob/animal/sif/glitterfly, /mob/living/simple_mob/animal/passive/fish)

/obj/item/glass_jar/fish/plastic
	name = "plastic tank"
	desc = "A large plastic tank."
	matter = list(MAT_PLASTIC = 4000)

/obj/item/glass_jar/fish/update_icon() // Also updates name and desc
	underlays.Cut()
	cut_overlays()

	if(filled)
		underlays += image(icon, "[icon_state]_water")

	switch(contains)
		if(JAR_NOTHING)
			name = initial(name)
			desc = initial(desc)
		if(JAR_MONEY)
			name = "tip tank"
			desc = "A large [name] with money inside."
			for(var/obj/item/spacecash/S in src)
				var/image/money = image(S.icon, S.icon_state)
				money.pixel_x = rand(-2, 3)
				money.pixel_y = rand(-6, 6)
				money.transform *= 0.6
				underlays += money
		if(JAR_ANIMAL)
			for(var/mob/M in src)
				var/image/victim = image(M.icon, M.icon_state)
				var/initial_x_scale = M.icon_scale_x
				var/initial_y_scale = M.icon_scale_y
				M.adjust_scale(0.7)
				victim.appearance = M.appearance
				M.adjust_scale(initial_x_scale, initial_y_scale)
				victim.pixel_y = 4
				underlays += victim
				name = "[name] with [M]"
				desc = "A large [name] with [M] inside."
		if(JAR_SPIDER)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				name = "[name] with [S]"
				desc = "A large tank with [S] inside."

	if(filled)
		desc = "[desc] It contains water."

	return

/obj/item/glass_jar/fish/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!filled)
		if(istype(A, /obj/structure/sink) || istype(A, /turf/simulated/floor/water))
			if(contains && user.a_intent == I_HELP)
				to_chat(user, span_warning("That probably isn't the best idea."))
				return

			to_chat(user, span_notice("You fill \the [src] with water!"))
			filled = TRUE
			update_icon()
			return

	return ..()

/obj/item/glass_jar/fish/attack_self(var/mob/user)
	if(filled)
		if(contains == JAR_ANIMAL)
			if(user.a_intent == I_HELP)
				to_chat(user, span_notice("Maybe you shouldn't empty the water..."))
				return

			else
				filled = FALSE
				user.visible_message(span_warning("[user] dumps out \the [src]'s water!"))
				update_icon()
				return

		else
			user.visible_message(span_notice("[user] dumps \the [src]'s water."))
			filled = FALSE
			update_icon()
			return

	return ..()

#undef JAR_NOTHING
#undef JAR_MONEY
#undef JAR_ANIMAL
#undef JAR_SPIDER
