//Supply packs are in /code/datums/supplypacks
//Computers are in /code/game/machinery/computer/supply.dm
SUBSYSTEM_DEF(supply)
	/* Bastion of Endeavor Translation
	name = "Supply"
	*/
	name = "Снабжение"
	// End of Bastion of Endeavor Translation
	wait = 20 SECONDS
	priority = FIRE_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1.0	// Processes every 20 seconds, so this is 3 per minute
	var/points_per_slip = 2
	var/points_per_money = 0.02 // 1 point for $50
	//control
	var/ordernum = 0						// Start at zero, it's per-shift tracking
	var/list/shoppinglist = list()			// Approved orders
	var/list/supply_pack = list()			// All supply packs
	var/list/exported_crates = list()		// Crates sent from the station
	var/list/order_history = list()			// History of orders, showing edits made by users
	var/list/adm_order_history = list() 	// Complete history of all orders, for admin use
	var/list/adm_export_history = list()	// Complete history of all crates sent back on the shuttle, for admin use
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle

/datum/controller/subsystem/supply/Initialize()
	// build master supply list
	for(var/typepath in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new typepath()
		if(P.name)
			supply_pack[P.name] = P
		else
			qdel(P)

	return SS_INIT_SUCCESS // CHOMPEdit

// Supply shuttle ticker - handles supply point regeneration. Just add points over time.
/datum/controller/subsystem/supply/fire()
	points += points_per_process

/datum/controller/subsystem/supply/stat_entry(msg)
	/* Bastion of Endeavor Translation
	msg = "Points: [points]"
	*/
	msg = "| Очки: [points]"
	// End of Bastion of Endeavor Translation
	return ..()

//To stop things being sent to CentCom which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(isliving(A))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/radio/beacon))
		return 1
	if(istype(A,/obj/item/perfect_tele_beacon))	//VOREStation Addition: Translocator beacons
		return 1										//VOREStation Addition: Translocator beacons
	if(istype(A,/obj/machinery/power/quantumpad)) //	//VOREStation Add: Quantum pads
		return 1					//VOREStation Add: Quantum pads
	if(istype(A,/obj/structure/extraction_point )) // CHOMPStation Add: Fulton beacons
		return 1

	for(var/atom/B in A.contents)
		if(.(B))
			return 1

//Selling
/datum/controller/subsystem/supply/proc/sell()
	// Loop over each area in the supply shuttle
	for(var/area/subarea in shuttle.shuttle_area)
		callHook("sell_shuttle", list(subarea));
		for(var/atom/movable/MA in subarea)
			if(MA.anchored)
				continue

			//Bastion of Endeavor TODO: Unsure if the names here need any translating. Will know once it's all tested.
			var/datum/exported_crate/EC = new /datum/exported_crate()
			EC.name = "\proper[MA.name]"
			EC.value = 0
			EC.contents = list()
			var/base_value = 0

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = MA
				callHook("sell_crate", list(CR, subarea))

				points += CR.points_per_crate
				if(CR.points_per_crate)
					base_value = CR.points_per_crate
				var/find_slip = 1

				for(var/atom/A in CR)
					EC.contents[++EC.contents.len] = list(
							"object" = "\proper[A.name]",
							"value" = 0,
							"quantity" = 1
						)

					// Sell manifests
					if(find_slip && istype(A,/obj/item/paper/manifest))
						var/obj/item/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
							points += points_per_slip
							EC.contents[EC.contents.len]["value"] = points_per_slip
							find_slip = 0
						continue

					// Sell phoron and platinum
					if(istype(A, /obj/item/stack))
						var/obj/item/stack/P = A
						var/datum/material/mat = P.get_material()
						if(mat?.supply_conversion_value)
							EC.contents[EC.contents.len]["value"] = P.get_amount() * mat.supply_conversion_value
						EC.contents[EC.contents.len]["quantity"] = P.get_amount()
						EC.value += EC.contents[EC.contents.len]["value"]

					//Sell spacebucks
					if(istype(A, /obj/item/spacecash))
						var/obj/item/spacecash/cashmoney = A
						EC.contents[EC.contents.len]["value"] = cashmoney.worth * points_per_money
						EC.contents[EC.contents.len]["quantity"] = cashmoney.worth
						EC.value += EC.contents[EC.contents.len]["value"]



			// Make a log of it, but it wasn't shipped properly, and so isn't worth anything
			else
				EC.contents = list(
						/* Bastion of Endeavor Translation
						"error" = "Error: Product was improperly packaged. Payment rendered null under terms of agreement."
						*/
						"error" = "Ошибка: посылка не была упакована как следует. Плата за данную покупку не взымается."
						// End of Bastion of Endeavor Translation
					)

			exported_crates += EC
			points += EC.value
			EC.value += base_value

			// Duplicate the receipt for the admin-side log
			var/datum/exported_crate/adm = new()
			adm.name = EC.name
			adm.value = EC.value
			adm.contents = deepCopyList(EC.contents)
			adm_export_history += adm

			qdel(MA)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T

	return clear_turfs

//Buying
/datum/controller/subsystem/supply/proc/buy()
	var/list/shoppinglist = list()
	for(var/datum/supply_order/SO in order_history)
		if(SO.status == SUP_ORDER_APPROVED)
			shoppinglist += SO

	if(!shoppinglist.len)
		return
	var/orderedamount = shoppinglist.len

	var/list/clear_turfs = get_clear_turfs()

	/* Bastion of Endeavor Translation
	var/shopping_log = "SUPPLY_BUY: "
	*/
	var/shopping_log = "ПОКУПКА ГРУЗА:"
	// End of Bastion of Endeavor Translation

	for(var/datum/supply_order/SO in shoppinglist)
		if(!clear_turfs.len)
			break

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		SO.status = SUP_ORDER_SHIPPED
		var/datum/supply_pack/SP = SO.object
		shopping_log += "[SP.name];"

		var/obj/A
		if(SP.containertype)
			A = new SP.containertype(pickedloc)
			A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"
			// Bastion of Endeavor Addition: Give the container itself some cases for grammatical polish, those are defined in supply pack datums
			// Bastion of Endeavor TODO: I can't be bothered to test if this works after one of our 20231234534 case system refactors but come back to this when cargo is localized ig
			A.cases_ru = deepCopyList(SP.cases_ru["containername"])
			// End of Bastion of Endeavor Addition	
			if(SP.access)
				if(isnum(SP.access))
					A.req_access = list(SP.access)
				else if(islist(SP.access) && SP.one_access)
					var/list/L = SP.access // access var is a plain var, we need a list
					A.req_one_access = L.Copy()
					LAZYCLEARLIST(A.req_access)
				else if(islist(SP.access) && !SP.one_access)
					var/list/L = SP.access
					A.req_access = L.Copy()
					LAZYCLEARLIST(A.req_one_access)
				else
					/* Bastion of Endeavor Translation
					log_debug(span_danger("Supply pack with invalid access restriction [SP.access] encountered!"))
					*/
					log_debug(span_danger("Обнаружен комплект снабжения с неправильным доступом [SP.access]!"))
					// End of Bastion of Endeavor Translation

		//supply manifest generation begin
		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			if(A)
				slip = new /obj/item/paper/manifest(A)
			else
				slip = new /obj/item/paper/manifest(pickedloc)
			slip.is_copy = 0
			/* Bastion of Endeavor Translation
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [station_name()]<br>"
			slip.info +="[orderedamount] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"
			*/
			slip.info = "<meta charset=\"UTF-8\">" 
			slip.info += "<h3>Договор о поставке с [command_name_ru(GCASE)]</h3><hr><br>"
			slip.info += "Заказ №[SO.ordernum]<br>"
			slip.info += "Получатель: [station_name_ru(NCASE)]<br>"
			slip.info += "В ДАННОЙ ПОСТАВКЕ [count_ru(orderedamount, "ПОСЫЛ;КА;КИ;ОК")]<br>"
			slip.info += "СОДЕРЖИМОЕ:<br><ul>"
			// End of Bastion of Endeavor Translation

		var/list/contains
		if(istype(SP,/datum/supply_pack/randomised))
			var/datum/supply_pack/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)
				continue

			var/number_of_items = max(1, contains[typepath])
			for(var/j = 1 to number_of_items)
				var/atom/B2
				if(A)
					B2 = new typepath(A)
				else
					B2 = new typepath(pickedloc)

				if(slip)
					slip.info += "<li>[B2.name]</li>" //add the item to the manifest

		//manifest finalisation
		if(slip)
			slip.info += "</ul><br>"
			/* Bastion of Endeavor Translation
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
			*/
			slip.info += "ПРОВЕРЬТЕ СОДЕРЖИМОЕ И ПОСТАВЬТЕ ПЕЧАТЬ ПОД ЧЕРТОЙ ДЛЯ ПОДТВЕРЖДЕНИЯ ПОЛУЧЕНИЯ.<hr>"
			// End of Bastion of Endeavor Translation

	log_game(shopping_log)
	return

// Will attempt to purchase the specified order, returning TRUE on success, FALSE on failure
/datum/controller/subsystem/supply/proc/approve_order(var/datum/supply_order/O, var/mob/user)
	// Not enough points to purchase the crate
	if(points <= O.object.cost)
		return FALSE

	// Based on the current model, there shouldn't be any entries in order_history, requestlist, or shoppinglist, that aren't matched in adm_order_history
	var/datum/supply_order/adm_order
	for(var/datum/supply_order/temp in adm_order_history)
		if(temp.ordernum == O.ordernum)
			adm_order = temp
			break

	/* Bastion of Endeavor Translation: Bastion of Endeavor TODO: This is minor, but the names this proc gets can be put under a case at some point.
	var/idname = "*None Provided*"
	*/
	var/idname = "*Не предоставлено*"
	// End of Bastion of Endeavor Translation
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	// Update order status
	O.status = SUP_ORDER_APPROVED
	O.approved_by = idname
	O.approved_at = stationdate2text() + " - " + stationtime2text()
	// Update admin-side mirror
	adm_order.status = SUP_ORDER_APPROVED
	adm_order.approved_by = idname
	adm_order.approved_at = stationdate2text() + " - " + stationtime2text()

	// Deduct cost
	points -= O.object.cost
	return TRUE

// Will deny the specified order. Only useful if the order is currently requested, but available at any status
/datum/controller/subsystem/supply/proc/deny_order(var/datum/supply_order/O, var/mob/user)
	// Based on the current model, there shouldn't be any entries in order_history, requestlist, or shoppinglist, that aren't matched in adm_order_history
	var/datum/supply_order/adm_order
	for(var/datum/supply_order/temp in adm_order_history)
		if(temp.ordernum == O.ordernum)
			adm_order = temp
			break

	/* Bastion of Endeavor Translation
	var/idname = "*None Provided*"
	*/
	var/idname = "*Не предоставлено*"
	// End of Bastion of Endeavor Translation
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	// Update order status
	O.status = SUP_ORDER_DENIED
	O.approved_by = idname
	O.approved_at = stationdate2text() + " - " + stationtime2text()
	// Update admin-side mirror
	adm_order.status = SUP_ORDER_DENIED
	adm_order.approved_by = idname
	adm_order.approved_at = stationdate2text() + " - " + stationtime2text()
	return

// Will deny all requested orders
/datum/controller/subsystem/supply/proc/deny_all_pending(var/mob/user)
	for(var/datum/supply_order/O in order_history)
		if(O.status == SUP_ORDER_REQUESTED)
			deny_order(O, user)

// Will delete the specified order from the user-side list
/datum/controller/subsystem/supply/proc/delete_order(var/datum/supply_order/O, var/mob/user)
	// Making sure they know what they're doing
	/* Bastion of Endeavor Translation
	if(tgui_alert(user, "Are you sure you want to delete this record? If it has been approved, cargo points will NOT be refunded!", "Delete Record",list("No","Yes")) == "Yes")
		if(tgui_alert(user, "Are you really sure? There is no way to recover the order once deleted.", "Delete Record", list("No","Yes")) == "Yes")
			log_admin("[key_name(user)] has deleted supply order \ref[O] [O] from the user-side order history.")
	*/
	if(tgui_alert(user, "Вы действительно хотите удалить эту запись? Если заказ был одобрен, очки снабжения НЕ БУДУТ возвращены!", "Удаление записи",list("Нет","Да")) == "Да")
		if(tgui_alert(user, "Вы точно уверены? Это действие невозможно отменить.", "Удаление записи", list("Нет","Да")) == "Да")
			log_admin("[key_name(user)] удалил заказ на поставку \ref[O] [O] из истории заказов на стороне пользователей.")
	// End of Bastion of Endeavor Translation
			order_history -= O
	return

// Will generate a new, requested order, for the given supply pack type
/datum/controller/subsystem/supply/proc/create_order(var/datum/supply_pack/S, var/mob/user, var/reason)
	var/datum/supply_order/new_order = new()
	var/datum/supply_order/adm_order = new() // Admin-recorded order must be a separate copy in memory, or user-made edits will corrupt it

	/* Bastion of Endeavor Translation
	var/idname = "*None Provided*"
	*/
	var/idname = "*Не предоставлено*"
	// End of Bastion of Endeavor Translation
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	new_order.ordernum = ++ordernum // Ordernum is used to track the order between the playerside list of orders and the adminside list
	new_order.index = new_order.ordernum // Index can be fabricated, or falsified. Ordernum is a permanent marker used to track the order
	new_order.object = S
	new_order.name = S.name
	new_order.cost = S.cost
	new_order.ordered_by = idname
	new_order.comment = reason
	new_order.ordered_at = stationdate2text() + " - " + stationtime2text()
	new_order.status = SUP_ORDER_REQUESTED

	adm_order.ordernum = new_order.ordernum
	adm_order.index = new_order.index
	adm_order.object = new_order.object
	adm_order.name = new_order.name
	adm_order.cost = new_order.cost
	adm_order.ordered_by = new_order.ordered_by
	adm_order.comment = new_order.comment
	adm_order.ordered_at = new_order.ordered_at
	adm_order.status = new_order.status

	order_history += new_order
	adm_order_history += adm_order

// Will delete the specified export receipt from the user-side list
/datum/controller/subsystem/supply/proc/delete_export(var/datum/exported_crate/E, var/mob/user)
	// Making sure they know what they're doing
	/* Bastion of Endeavor Translation
	if(tgui_alert(user, "Are you sure you want to delete this record?", "Delete Record",list("No","Yes")) == "Yes")
		if(tgui_alert(user, "Are you really sure? There is no way to recover the receipt once deleted.", "Delete Record", list("No","Yes")) == "Yes")
			log_admin("[key_name(user)] has deleted export receipt \ref[E] [E] from the user-side export history.")
	*/
	if(tgui_alert(user, "Вы действительно хотите удалить эту запись?", "Удаление записи",list("Нет","Да")) == "Да")
		if(tgui_alert(user, "Вы точно уверены? Чек невозможно восстановить после удаления.", "Удаление записи", list("Нет","Да")) == "Да")
			log_admin("[key_name(user)] удалил чек поставки \ref[E] [E] из истории экспорта на стороне пользователей.")
	// End of Bastion of Endeavor Translation
			exported_crates -= E
	return

// Will add an item entry to the specified export receipt on the user-side list
/datum/controller/subsystem/supply/proc/add_export_item(var/datum/exported_crate/E, var/mob/user)
	/* Bastion of Endeavor Translation
	var/new_name = tgui_input_text(user, "Name", "Please enter the name of the item.")
	*/
	var/new_name = tgui_input_text(user, "Название", "Введите название товара.")
	// End of Bastion of Endeavor Translation
	if(!new_name)
		return

	/* Bastion of Endeavor Translation
	var/new_quantity = tgui_input_number(user, "Name", "Please enter the quantity of the item.")
	*/
	var/new_quantity = tgui_input_number(user, "Количество", "Введите количество товара.")
	// End of Bastion of Endeavor Translation
	if(!new_quantity)
		return

	/* Bastion of Endeavor Translation
	var/new_value = tgui_input_number(user, "Name", "Please enter the value of the item.")
	*/
	var/new_value = tgui_input_number(user, "Стоимость", "Введите стоимость товара.")
	// End of Bastion of Endeavor Translation
	if(!new_value)
		return

	E.contents[++E.contents.len] = list(
			"object" = new_name,
			"quantity" = new_quantity,
			"value" = new_value
		)

/datum/exported_crate
	var/name
	var/value
	var/list/contents

/datum/supply_order
	var/ordernum							// Unfabricatable index
	var/index								// Fabricatable index
	var/datum/supply_pack/object = null
	var/cost								// Cost of the supply pack (Fabricatable) (Changes not reflected when purchasing supply packs, this is cosmetic only)
	var/name								// Name of the supply pack datum (Fabricatable)
	var/ordered_by = null					// Who requested the order
	var/comment = null						// What reason was given for the order
	var/approved_by = null					// Who approved the order
	var/ordered_at							// Date and time the order was requested at
	var/approved_at							// Date and time the order was approved at
	var/status								// [Requested, Accepted, Denied, Shipped]
