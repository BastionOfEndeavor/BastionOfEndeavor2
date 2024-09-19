//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want


/mob/proc/throw_alert(category, type, severity, obj/new_master)

/* Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 path is a type path of the actual alert type to throw
 severity is an optional number that will be placed at the end of the icon_state for this alert
 For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 Clicks are forwarded to master */

	if(!category)
		return

	var/obj/screen/alert/alert
	if(alerts[category])
		alert = alerts[category]
		if(new_master && new_master != alert.master)
			/* Bastion of Endeavor Translation
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [alert.master]")
			*/
			WARNING("[interact_ru(src, "отправил")] alert [category] с new_master [new_master], уже имея alert с master [alert.master].")
			// End of Bastion of Endeavor Translation
			clear_alert(category)
			return .()
		else if(alert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == alert.severity)
			if(alert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		alert = new type

	if(new_master)
		alert.icon_state = "itembased"
		var/image/I = image(icon = new_master.icon, icon_state = new_master.icon_state, dir = SOUTH)
		I.plane = PLANE_PLAYER_HUD_ABOVE
		I.color = new_master.color
		alert.add_overlay(I)
		alert.master = new_master
	else
		alert.icon_state = "[initial(alert.icon_state)][severity]"
		alert.severity = severity

	alerts[category] = alert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	alert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(alert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(alert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), alert, category), alert.timeout)
		alert.timeout = world.time + alert.timeout - world.tick_lag
	return alert

/mob/proc/alert_timeout(obj/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category)
	var/obj/screen/alert/alert = alerts[category]
	if(!alert)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/obj/screen/alert
	/* Bastion of Endeavor Edit: We have a dmi with russian icons.
	icon = 'icons/mob/screen_alert.dmi'
	*/
	icon = 'russian/_modular/icons/mob/screen_alert_ru.dmi'
	// End of Bastion of Endeavor Edit
	icon_state = "default"
	/* Bastion of Endeavor Translation
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	*/
	name = "Уведомление"
	desc = "С этим уведомлением что-то пошло не так, так что просьба доложить об этом баге."
	// End of Bastion of Endeavor Translation
	mouse_opacity = 1
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/no_underlay // Don't underlay the UI style's blank template icon under this


/obj/screen/alert/MouseEntered(location,control,params)
	openToolTip(usr, src, params, title = name, content = desc, theme = alerttooltipstyle)


/obj/screen/alert/MouseExited()
	closeToolTip(usr)


//Gas alerts
/obj/screen/alert/not_enough_oxy
	/* Bastion of Endeavor Translation
	name = "Choking (No O2)"
	desc = "You're not getting enough oxygen. Find some good air before you pass out! \
The box in your backpack has an oxygen tank and breath mask in it."
	*/
	name = "Удушье (Мало O2)"
	desc = "Вам не хватает кислорода. Сделайте глоток свежего воздуха, пока не упали в обморок! \
В вашем рюкзаке есть коробка с баллоном и дыхательной маской."
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_oxy"

/obj/screen/alert/too_much_oxy
	/* Bastion of Endeavor Translation
	name = "Choking (O2)"
	desc = "There's too much oxygen in the air, and you're breathing it in! Find some good air before you pass out!"
	*/
	name = "Удушье (O2)"
	desc = "В воздухе слишком много кислорода, невозможно дышать! Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "too_much_oxy"

/obj/screen/alert/not_enough_nitro
	/* Bastion of Endeavor Translation
	name = "Choking (No N)"
	desc = "You're not getting enough nitrogen. Find some good air before you pass out!"
	*/
	name = "Удушье (мало N)"
	desc = "Вам не хватает азота, чтобы дышать. Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_nitro"

/obj/screen/alert/too_much_nitro
	/* Bastion of Endeavor Translation
	name = "Choking (N)"
	desc = "There's too much nitrogen in the air, and you're breathing it in! Find some good air before you pass out!"
	*/
	name = "Удушье (N)"
	desc = "В воздухе слишком много азота, невозможно дышать! Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "too_much_nitro"

/obj/screen/alert/not_enough_co2
	/* Bastion of Endeavor Translation
	name = "Choking (No CO2)"
	desc = "You're not getting enough carbon dioxide. Find some good air before you pass out!"
	*/
	name = "Удушье (мало CO2)"
	desc = "Вам не хватает углекислого газа. Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_co2"

/obj/screen/alert/too_much_co2
	/* Bastion of Endeavor Translation
	name = "Choking (CO2)"
	desc = "There's too much carbon dioxide in the air, and you're breathing it in! Find some good air before you pass out!"
	*/
	name = "Удушье (CO2)"
	desc = "В воздухе слишком много углекислого газа, невозможно дышать! Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "too_much_co2"

/obj/screen/alert/too_much_co2/plant
	/* Bastion of Endeavor Translation
	name = "Livin' the good life"
	desc = "There's so much carbon dioxide in the air, you're in fucking heaven. Watch out for passed out fleshies, though."
	*/
	name = "Жизнь прекрасна"
	desc = "В воздухе столько углекислого газа, это просто райское наслаждение. Разве что, остерегайтесь мешков мяса в обмороке."
	// End of Bastion of Endeavor Translation
	icon_state = "too_much_co2"

/obj/screen/alert/not_enough_tox
	/* Bastion of Endeavor Translation
	name = "Choking (No Phoron)"
	desc = "You're not getting enough phoron. Find some good air before you pass out!"
	*/
	name = "Удушье (мало форона)"
	desc = "Вам не хватает форона, чтобы дышать. Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_tox"

/obj/screen/alert/tox_in_air											// CHOMP EDIT : Oxygen is toxic to phoron breathers and nitrogen breathers. I'm tired of seeing "You're choking on phoron!" when it's not phoron.
	/* Bastion of Endeavor Translation
	name = "Choking (Toxic)"										// CHOMP EDIT
	desc = "There's a dangerous toxin in the air and you're breathing it in. Find some fresh air. \
Your emergency supply kit should have an air tank and gas mask in it!"						// CHOMP EDIT
	*/
	name = "Удушье (токсичный воздух)"
	desc = "В воздухе вокруг вас есть что-то токсичное. Срочно подышите свежим воздухом. \
В вашем рюкзаке есть коробка с баллоном и дыхательной маской."
	// End of Bastion of Endeavor Translation
	icon_state = "too_much_tox"

/obj/screen/alert/not_enough_fuel
	/* Bastion of Endeavor Translation
	name = "Choking (No Volatile fuel)"
	desc = "You're not getting enough volatile fuel. Find some good air before you pass out!"
	*/
	name = "Удушье (мало летучего топлива)"
	desc = "Вам не хватает летучего топлива, чтобы дышать. Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_tox"

/obj/screen/alert/not_enough_n2o
	/* Bastion of Endeavor Translation
	name = "Choking (No Sleeping Gas)"
	desc = "You're not getting enough sleeping gas. Find some good air before you pass out!"
	*/
	name = "Удушье (мало N2O)"
	desc = "Вам не хватает усыпляющего газа. Сделайте глоток нормального воздуха, пока не упали в обморок!"
	// End of Bastion of Endeavor Translation
	icon_state = "not_enough_tox"
//End gas alerts


/obj/screen/alert/fat
	/* Bastion of Endeavor Translation
	name = "Full"
	desc = "You've eaten more than you can handle, maybe you should slow down?"
	*/
	name = "Переедание"
	desc = "Вы объелись. Может быть, не стоит переедать?"
	// End of Bastion of Endeavor Translation
	icon_state = "fat"

/obj/screen/alert/fat/vampire
	/* Bastion of Endeavor Translation
	desc = "You've had more than enough blood, for now."
	*/
	desc = "Вы выпили более чем достаточно крови. Надолго ли?"
	// End of Bastion of Endeavor Translation
	icon_state = "v_fat"

/obj/screen/alert/fat/synth
	/* Bastion of Endeavor Translation
	desc = "Your battery is full! Don't overvolt it."
	*/
	name = "Излишний заряд"
	desc = "Ваш аккумулятор полностью заряжен. Не перегрузите его."
	// End of Bastion of Endeavor Translation
	icon_state = "c_fat"

/obj/screen/alert/hungry
	/* Bastion of Endeavor Translation
	name = "Hungry"
	desc = "Some food would be good right about now."
	*/
	name = "Аппетит"
	desc = "Вы бы не отказались перекусить."
	// End of Bastion of Endeavor Translation
	icon_state = "hungry"

/obj/screen/alert/hungry/vampire
	/* Bastion of Endeavor Translation
	desc = "You could go for a bite right now..."
	*/
	desc = "Вам бы укусить кого-нибудь..."
	// End of Bastion of Endeavor Translation
	icon_state = "v_hungry"

/obj/screen/alert/hungry/synth
	/* Bastion of Endeavor Translation
	desc = "Battery's running a bit low, could use a topoff."
	*/
	name = "Низкий заряд"
	desc = "Аккумулятор начинает садиться, не помешало бы подзарядить."
	// End of Bastion of Endeavor Translation
	icon_state = "c_hungry"

/obj/screen/alert/starving
	/* Bastion of Endeavor Translation
	name = "Very Hungry"
	desc = "You're starving. You barely have enough energy to move around."
	*/
	name = "Голодание"
	desc = "Вы голодаете. У вас почти не осталось энергии на передвижение."
	// End of Bastion of Endeavor Translation
	icon_state = "starving"

/obj/screen/alert/starving/vampire
	/* Bastion of Endeavor Translation
	desc = "You *need* blood; go rip out someone's throat already!"
	*/
	desc = "Вам *нужна* кровь, идите и вырвите кому-нибудь глотку!"
	// End of Bastion of Endeavor Translation
	icon_state = "v_starving"

/obj/screen/alert/starving/synth
	/* Bastion of Endeavor Translation
	desc = "Your battery is about to die! Charge it ASAP!"
	*/
	desc = "Аккумулятор вот-вот сядет! Скорее подзарядитесь!"
	// End of Bastion of Endeavor Translation
	icon_state = "c_starving"

/obj/screen/alert/warm
	/* Bastion of Endeavor Translation
	name = "Too Warm"
	desc = "You're uncomfortably warm. Take off some clothes or tweak the thermostat a few degrees cooler."
	*/
	name = "Жарковато"
	desc = "Вам жарко. Снимите с себя что-нибудь или подкрутите слегка термостат."
	// End of Bastion of Endeavor Translation
	icon_state = "mildhot"

/obj/screen/alert/hot
	/* Bastion of Endeavor Translation
	name = "Too Hot"
	desc = "You're flaming hot! Get somewhere cooler and take off any insulating clothing like a fire suit."
	*/
	name = "Жара"
	desc = "Вам слишком жарко! Найдите место попрохладнее и снимите с себя теплоизолирующую одежду."
	// End of Bastion of Endeavor Translation
	icon_state = "hot"

/obj/screen/alert/hot/robot
	/* Bastion of Endeavor Translation
	desc = "The air around you is too hot for a humanoid. Be careful to avoid exposing them to this enviroment."
	*/
	desc = "Воздух вокруг вас слишком горяч для гуманоидных рас. Старайтесь не допускать их контакта с этой средой."
	// End of Bastion of Endeavor Translation

/obj/screen/alert/chilly
	/* Bastion of Endeavor Translation
	name = "Too Chilly"
	desc = "You're uncomfortably cold. Rug up or tweak the thermostat a few degrees higher."
	*/
	name = "Прохладно"
	desc = "Вам холодно. Приоденьтесь или подкрутите слегка термостат."
	// End of Bastion of Endeavor Translation
	icon_state = "mildcold"

/obj/screen/alert/cold
	/* Bastion of Endeavor Translation
	name = "Too Cold"
	desc = "You're freezing cold! Get somewhere warmer and take off any insulating clothing like a space suit."
	*/
	name = "Мороз"
	desc = "Вам слишком холодно! Найдите место потеплее и снимите с себя теплоизолирующую одежду."
	// End of Bastion of Endeavor Translation
	icon_state = "cold"

/obj/screen/alert/cold/robot
	/* Bastion of Endeavor Translation
	desc = "The air around you is too cold for a humanoid. Be careful to avoid exposing them to this enviroment."
	*/
	desc = "Воздух вокруг вас слишком холоден для гуманоидных рас. Старайтесь не допускать их контакта с этой средой."
	// End of Bastion of Endeavor Translation

/obj/screen/alert/lowpressure
	/* Bastion of Endeavor Translation
	name = "Low Pressure"
	desc = "The air around you is hazardously thin. A space suit would protect you."
	*/
	name = "Низкое давление"
	desc = "Вас окружает чрезмерно разреженный воздух. Вас может защитить скафандр."
	// End of Bastion of Endeavor Translation
	icon_state = "lowpressure"

/obj/screen/alert/highpressure
	/* Bastion of Endeavor Translation
	name = "High Pressure"
	desc = "The air around you is hazardously thick. A fire suit would protect you."
	*/
	name = "Высокое давление"
	desc = "Вас окружает чрезмерно плотный воздух. Вас может защитить противопожарный костюм."
	// End of Bastion of Endeavor Translation
	icon_state = "highpressure"

/obj/screen/alert/blind
	/* Bastion of Endeavor Translation
	name = "Blind"
	desc = "You can't see! This may be caused by a genetic defect, eye trauma, being unconscious, \
or something covering your eyes."
	*/
	name = "Слепота"
	desc = "Вы ничего не видите! Это может быть вызвано повреждением глаз, генетическим дефектом, потерей сознания, \
или же просто прикрытием глаз."
	// End of Bastion of Endeavor Translation
	icon_state = "blind"

/obj/screen/alert/stunned
	/* Bastion of Endeavor Translation
	name = "Stunned"
	desc = "You're temporarily stunned! You'll have trouble moving or performing actions, but it should clear up on it's own."
	*/
	name = "Оглушение"
	desc = "Вы временно оглушены! Вам тяжело двигаться или выполнять действия, но это должно скоро пройти."
	// End of Bastion of Endeavor Translation
	icon_state = "stun"

/obj/screen/alert/paralyzed
	/* Bastion of Endeavor Translation
	name = "Paralyzed"
	desc = "You're paralyzed! This could be due to drugs or serious injury. You'll be unable to move or perform actions."
	*/
	name = "Паралич"
	desc = "Вы парализованы! Это может быть вызвано препаратами или серьёзной травмой. Вы не можете двигаться или выполнять действия."
	// End of Bastion of Endeavor Translation
	icon_state = "paralysis"

/obj/screen/alert/weakened
	/* Bastion of Endeavor Translation
	name = "Weakened"
	desc = "You're weakened! This could be a temporary issue due to injury or the result of drugs or drinking."
	*/
	name = "Ослабление"
	desc = "Вы ослаблены! Это временное состояние может быть вызвано травмой, алкоголем или препаратами."
	// End of Bastion of Endeavor Translation
	icon_state = "weaken"

/obj/screen/alert/confused
	/* Bastion of Endeavor Translation
	name = "Confused"
	desc = "You're confused, and may stumble into things! This may be from concussive effects, drugs, or dizzyness. Walking will help reduce incidents."
	*/
	name = "Запутанность"
	desc = "Осторожно, вы можете случайно во что-то врезаться! Это может быть вызвано травмой, препаратами или плохим физическим состоянием. Медленная ходьба поможет снизить риск."
	// End of Bastion of Endeavor Translation
	icon_state = "confused"

/obj/screen/alert/high
	/* Bastion of Endeavor Translation
	name = "High"
	desc = "Whoa, you're tripping balls!"
	*/
	name = "Под кайфом"
	desc = "Ух ты ж ё, да вы под кайфом!"
	icon_state = "high"

/obj/screen/alert/embeddedobject
	/* Bastion of Endeavor Translation
	name = "Embedded Object"
	desc = "Something got lodged into your flesh and is causing major bleeding. It might fall out with time, but surgery is the safest way. \
If you're feeling frisky, right click on yourself and select \"Remove embedded object\" to pull the object out."
	*/
	name = "Инородный объект"
	desc = "Что-то вонзилось в вашу плоть и вызвало сильное кровотечение. Оно может выпасть само, но лучше довериться хирургии. \
Если вы готовы пойти на риск, вы можете самостоятельно извлечь объект, нажав на себя правой кнопкой мыши и выбрав соответствующий глагол."
	// End of Bastion of Endeavor Translation
	icon_state = "embeddedobject"

/obj/screen/alert/embeddedobject/Click()
	if(isliving(usr))
		var/mob/living/carbon/human/M = usr
		return M.help_shake_act(M)

/obj/screen/alert/asleep
	/* Bastion of Endeavor Translation
	name = "Asleep"
	desc = "You've fallen asleep. Wait a bit and you should wake up. Unless you don't, considering how helpless you are."
	*/
	name = "Сон"
	desc = "Вы уснули. Подождите немного, и вы скоро проснётесь. Или нет."
	// End of Bastion of Endeavor Translation
	icon_state = "asleep"

/obj/screen/alert/weightless
	/* Bastion of Endeavor Translation
	name = "Weightless"
	desc = "Gravity has ceased affecting you, and you're floating around aimlessly. You'll need something large and heavy, like a \
wall or lattice, to push yourself off if you want to move. A jetpack would enable free range of motion. A pair of \
magboots would let you walk around normally on the floor. Barring those, you can throw things, use a fire extinguisher, \
or shoot a gun to move around via Newton's 3rd Law of Motion."
	*/
	name = "Невесомость"
	desc = "Сила притяжения прекратила оказывать на вас своё действие, и вы бесцельно летаете в пространстве. Для того, чтобы перемещаться, необходимо что-то тяжелое, \
вроде стены или решетки, от которых можно было бы оттолкнуться. С помощью реактивного ранца можно перемещаться свободно, а \
магнитные ботинки позволяют ходить по полу. Также из вариантов у вас бросить что-нибудь в сторону, выстрелить из оружия или использовать огнетушитель, \
чтобы оттолкнуться согласно третьему закону Ньютона."
	// End of Bastion of Endeavor Translation
	icon_state = "weightless"

/obj/screen/alert/fire
	/* Bastion of Endeavor Translation
	name = "On Fire"
	desc = "You're on fire. Stop, drop and roll to put the fire out or move to a vacuum area."
	*/
	name = "В огне"
	desc = "Вы горите. Бросьтесь вниз и катайтесь по полу, чтобы потушиться, или переместитесь в вакуум."
	// End of Bastion of Endeavor Translation
	icon_state = "fire"

/obj/screen/alert/fire/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()


//ALIENS

/obj/screen/alert/alien_tox
	/* Bastion of Endeavor Translation
	name = "Phoron"
	desc = "There's flammable phoron in the air. If it lights up, you'll be toast."
	*/
	name = "Форон"
	desc = "В воздухе легковоспламеняющийся форон. Если он загорится, вам не жить."
	// End of Bastion of Endeavor Translation
	icon_state = "alien_tox"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_fire
// This alert is temporarily gonna be thrown for all hot air but one day it will be used for literally being on fire
	/* Bastion of Endeavor Translation
	name = "Too Hot"
	desc = "It's too hot! Flee to space or at least away from the flames. Standing on weeds will heal you."
	*/
	name = "Слишком жарко"
	desc = "Горячо! Вам необходимо отдалиться от огня. Вы восстановите здоровье, если встанете на сорняки."
	// End of Bastion of Endeavor Translation
	icon_state = "alien_fire"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_vulnerable
	/* Bastion of Endeavor Translation
	name = "Severed Matriarchy"
	desc = "Your queen has been killed, you will suffer movement penalties and loss of hivemind. A new queen cannot be made until you recover."
	*/
	name = "Свергнутый матриархат"
	desc = "Ваша королева была убита, поэтому ваше передвижение затруднено, а коллективный разум – утрачен. Пока вы не восстановитесь, новой королевы не будет."
	// End of Bastion of Endeavor Translation
	icon_state = "alien_noqueen"
	alerttooltipstyle = "alien"

//BLOBS

/obj/screen/alert/nofactory
	/* Bastion of Endeavor Translation
	name = "No Factory"
	desc = "You have no factory, and are slowly dying!"
	*/
	name = "Нет источника"
	desc = "У вас нет источника, в связи с чем вы медленно умираете!"
	// End of Bastion of Endeavor Translation
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

//SILICONS

/obj/screen/alert/nocell
	/* Bastion of Endeavor Translation
	name = "Missing Power Cell"
	desc = "Unit has no power cell. No modules available until a power cell is reinstalled. Robotics may provide assistance."
	*/
	name = "Нет батарейки"
	desc = "Юнит не обладает батарейкой. Модули недоступны. С этим может помочь робототехник."
	// End of Bastion of Endeavor Translation
	icon_state = "nocell"

/obj/screen/alert/emptycell
	/* Bastion of Endeavor Translation
	name = "Out of Power"
	desc = "Unit's power cell has no charge remaining. No modules available until power cell is recharged. \
Recharging stations are available in robotics, the dormitory bathrooms, and the AI satellite."
	*/
	name = "Нет заряда"
	desc = "Батарейка юнита полностью разряжена. Модули недоступны. Зарядные станции можно найти в робототехнике, уборных и на спутнике ИИ."
	// End of Bastion of Endeavor Translation
	icon_state = "emptycell"

/obj/screen/alert/lowcell
	/* Bastion of Endeavor Translation
	name = "Low Charge"
	desc = "Unit's power cell is running low. Recharging stations are available in robotics, the dormitory bathrooms, and the AI satellite."
	*/
	name = "Низкий заряд"
	desc = "Батарейка юнита почти разряжена. Зарядные станции доступны в робототехнике, уборных при дормиториях и на спутнике ИИ."
	// End of Bastion of Endeavor Translation
	icon_state = "lowcell"

//Need to cover all use cases - emag, illegal upgrade module, malf AI hack, traitor cyborg
/obj/screen/alert/hacked
	/* Bastion of Endeavor Translation
	name = "Hacked"
	desc = "Hazardous non-standard equipment detected. Please ensure any usage of this equipment is in line with unit's laws, if any."
	*/
	name = "Взлом"
	desc = "Обнаружено опасное оснащение. Убедитесь, что использование этого оснащения соблюдает законы юнита, если это применимо."
	// End of Bastion of Endeavor Translation
	icon_state = "hacked"
	no_underlay = TRUE

/obj/screen/alert/locked
	/* Bastion of Endeavor Translation
	name = "Locked Down"
	desc = "Unit has been remotely locked down. Usage of a Robotics Control Console like the one in the " + JOB_RESEARCH_DIRECTOR + "'s \
office by your AI master or any qualified human may resolve this matter. Robotics may provide further assistance if necessary."
	*/
	name = "Отключение"
	desc = "Юнит был удалённо отключён. Эту проблему можно устранить при помощи робототехнической панели управления в кабинете директора по исследованиям \
и квалифицированного работника или ИИ. При необходимости оказать помощь может робототехник."
	// End of Bastion of Endeavor Translation
	icon_state = "locked"
	no_underlay = TRUE

/obj/screen/alert/newlaw
	/* Bastion of Endeavor Translation
	name = "Law Update"
	desc = "Laws have potentially been uploaded to or removed from this unit. Please be aware of any changes \
so as to remain in compliance with the most up-to-date laws."
	*/
	name = "Обновление законов"
	desc = "Обнаружено изменение перечня законов данного юнита. Убедитесь, что вы соблюдаете законы обновленной версии перечня."
	// End of Bastion of Endeavor Translation
	icon_state = "newlaw"
	timeout = 300
	no_underlay = TRUE

//MECHS

/obj/screen/alert/low_mech_integrity
	/* Bastion of Endeavor Translation
	name = "Mech Damaged"
	desc = "Mech integrity is low."
	*/
	name = "Мех повреждён"
	desc = "Низкая целостность меха."
	// End of Bastion of Endeavor Translation
	icon_state = "low_mech_integrity"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/obj/screen/alert/notify_cloning
	/* Bastion of Endeavor Translation
	name = "Revival"
	desc = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!"
	*/
	name = "Реанимация"
	desc = "Кто-то пытается реанимировать вас. Войдите в своё тело, если хотите вернуться к жизни!"
	// End of Bastion of Endeavor Translation
	icon_state = "template"
	timeout = 300

/obj/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client) return
	var/mob/observer/dead/G = usr
	G.reenter_corpse()

// /obj/screen/alert/notify_jump
// 	name = "Body created"
// 	desc = "A body was created. You can enter it."
// 	icon_state = "template"
// 	timeout = 300
// 	var/atom/jump_target = null
// 	var/attack_not_jump = null

// /obj/screen/alert/notify_jump/Click()
// 	if(!usr || !usr.client) return
// 	if(!jump_target) return
// 	var/mob/dead/observer/G = usr
// 	if(!istype(G)) return
// 	if(attack_not_jump)
// 		jump_target.attack_ghost(G)
// 	else
// 		var/turf/T = get_turf(jump_target)
// 		if(T && isturf(T))
// 			G.loc = T

//OBJECT-BASED

/obj/screen/alert/restrained/buckled
	/* Bastion of Endeavor Translation
	name = "Buckled"
	desc = "You've been buckled to something. Click the alert to unbuckle unless you're handcuffed."
	*/
	name = "Положение сидя/лежа"
	desc = "Вы находитесь в сидячем или лежачем положении. Нажмите на это уведомление, чтобы встать, если ваши руки не связаны."
	// End of Bastion of Endeavor Translation

/obj/screen/alert/restrained/handcuffed
	/* Bastion of Endeavor Translation
	name = "Handcuffed"
	desc = "You're handcuffed and can't act. If anyone drags you, you won't be able to move. Click the alert to free yourself."
	*/
	name = "Связанные руки"
	desc = "Ваши руки связаны, и ваши действия ограничены. Если вас кто-то тащит, вы не сможете шевелиться. Нажмите на это уведомление, чтобы высвободиться."
	// End of Bastion of Endeavor Translation

/obj/screen/alert/restrained/legcuffed
	/* Bastion of Endeavor Translation
	name = "Legcuffed"
	desc = "You're legcuffed, which slows you down considerably. Click the alert to free yourself."
	*/
	name = "Связанные ноги"
	desc = "Ваши ноги связаны, и ваше передвижение замедлено. Нажмите на это уведомление, чтобы высвободиться."
	// End of Bastion of Endeavor Translation

/obj/screen/alert/restrained/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()
// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= alerts.len, i++)
			mymob.client.screen -= alerts[alerts[i]]
		return 1
	for(var/i = 1, i <= alerts.len, i++)
		var/obj/screen/alert/alert = alerts[alerts[i]]

		if(alert.icon_state in cached_icon_states(ui_style))
			alert.icon = ui_style

		else if(!alert.no_underlay)
			var/image/I = image(icon = ui_style, icon_state = "template")
			I.color = ui_color
			I.alpha = ui_alpha
			alert.underlays = list(I)

		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		mymob?.client?.screen |= alert
	return 1

/mob
	var/list/alerts = list() // contains /obj/screen/alert only // On /mob so clientless mobs will throw alerts properly

/obj/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return
	var/paramslist = params2list(params)
	if(paramslist["shift"]) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr,"<span class='boldnotice'>[name]</span> - <span class='info'>[desc]</span>")
		return
	if(master)
		return usr.client.Click(master, location, control, params)
	..() // VOREStation Edit: Pass through to click_vr

/obj/screen/alert/Destroy()
	..()
	severity = 0
	master = null
	screen_loc = ""
	return QDEL_HINT_QUEUE
