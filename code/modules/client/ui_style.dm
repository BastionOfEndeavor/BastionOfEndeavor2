

/var/all_ui_styles = list(
	/* Bastion of Endeavor Translation
	"Midnight"     = 'icons/mob/screen/midnight.dmi',
	"Orange"       = 'icons/mob/screen/orange.dmi',
	"old"          = 'icons/mob/screen/old.dmi',
	"White"        = 'icons/mob/screen/white.dmi',
	"old-noborder" = 'icons/mob/screen/old-noborder.dmi',
	"minimalist"   = 'icons/mob/screen/minimalist.dmi',
	"Hologram"     = 'icons/mob/screen/holo.dmi'
	*/
	"Полночь"    		= 'russian/_modular/icons/mob/screen/midnight_ru.dmi',
	"Оранжевый"     	= 'russian/_modular/icons/mob/screen/orange_ru.dmi',
	"Ретро"         	= 'russian/_modular/icons/mob/screen/old_ru.dmi',
	"Белый"        		= 'russian/_modular/icons/mob/screen/white_ru.dmi',
	"Ретро (без рамок)" = 'russian/_modular/icons/mob/screen/old-noborder_ru.dmi',
	"Минимализм"   		= 'russian/_modular/icons/mob/screen/minimalist_ru.dmi',
	"Голограмма"     	= 'russian/_modular/icons/mob/screen/holo_ru.dmi'
	// End of Bastion of Endeavor Translation
	)

/var/all_ui_styles_robot = list(
	/* Bastion of Endeavor Translation: The tooltips below are handled differently so they remain unlocalized
	"Midnight"     = 'icons/mob/screen1_robot.dmi',
	"Orange"       = 'icons/mob/screen1_robot.dmi',
	"old"          = 'icons/mob/screen1_robot.dmi',
	"White"        = 'icons/mob/screen1_robot.dmi',
	"old-noborder" = 'icons/mob/screen1_robot.dmi',
	"minimalist"   = 'icons/mob/screen1_robot_minimalist.dmi',
	"Hologram"     = 'icons/mob/screen1_robot_minimalist.dmi'
	*/
	"Полночь"    		= 'russian/_modular/icons/mob/screen1_robot_ru.dmi',
	"Оранжевый"       	= 'russian/_modular/icons/mob/screen1_robot_ru.dmi',
	"Ретро"         	= 'russian/_modular/icons/mob/screen1_robot_ru.dmi',
	"Белый"        		= 'russian/_modular/icons/mob/screen1_robot_ru.dmi',
	"Ретро (без рамок)" = 'russian/_modular/icons/mob/screen1_robot_ru.dmi',
	"Минимализм"   		= 'russian/_modular/icons/mob/screen1_robot_minimalist_ru.dmi',
	"Голограмма"    	= 'russian/_modular/icons/mob/screen1_robot_minimalist_ru.dmi'
	// End of Bastion of Endeavor Translation
	)

var/global/list/all_tooltip_styles = list(
	"Midnight",		//Default for everyone is the first one,
	"Plasmafire",
	"Retro",
	"Slimecore",
	"Operative",
	"Clockwork"
	)

/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	/* Bastion of Endeavor Translation
	return all_ui_styles["White"]
	*/
	return all_ui_styles["Белая"]
	// End of Bastion of Endeavor Translation


/client/verb/change_ui()
	/* Bastion of Endeavor Translation
	set name = "Change UI"
	set category = "Preferences.Game" //CHOMPEdit
	set desc = "Configure your user interface"
	*/
	set name = "Интерфейс"
	set category = "Предпочтения"
	set desc = "Изменить оформление интерфейса"
	// End of Bastion of Endeavor Translation

	if(!ishuman(usr))
		if(!isrobot(usr))
			/* Bastion of Endeavor Translation
			to_chat(usr, "<span class='warning'>You must be a human or a robot to use this verb.</span>")
			*/
			to_chat(usr, "<span class='warning'>Чтобы изменить оформление своего интерфейса, необходимо быть человеком или роботом.</span>")
			// End of Bastion of Endeavor Translation
			return

	/* Bastion of Endeavor Translation
	var/UI_style_new = tgui_input_list(usr, "Select a style. White is recommended for customization", "UI Style Choice", all_ui_styles)
	*/
	var/UI_style_new = tgui_input_list(usr, "Выберите стиль интерфейса. Для персонализации рекомендуется выбрать Белый.", "Выбор стиля интерфейса", all_ui_styles)
	// End of Bastion of Endeavor Translation
	if(!UI_style_new) return

	/* Bastion of Endeavor Translation
	var/UI_style_alpha_new = tgui_input_number(usr, "Select a new alpha (transparency) parameter for your UI, between 50 and 255", null, null, 255, 50)
	*/
	var/UI_style_alpha_new = tgui_input_number(usr, "Укажите значение альфа (непрозрачность) интерфейса от 50 до 255:", null, null, 255, 50)
	// End of Bastion of Endeavor Translation
	if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50)) return

	/* Bastion of Endeavor Translation
	var/UI_style_color_new = input(usr, "Choose your UI color. Dark colors are not recommended!") as color|null
	*/
	var/UI_style_color_new = input(usr, "Выберите цвет интерфейса. Белый оставляет стиль по умолчанию. Тёмные цвета не рекомендуются!") as color|null
	// End of Bastion of Endeavor Translation
	if(!UI_style_color_new) return

	//update UI
	var/list/icons = usr.hud_used.adding + usr.hud_used.other + usr.hud_used.hotkeybuttons
	icons.Add(usr.zone_sel)
	icons.Add(usr.gun_setting_icon)
	icons.Add(usr.item_use_icon)
	icons.Add(usr.gun_move_icon)
	icons.Add(usr.radio_use_icon)

	var/icon/ic = all_ui_styles[UI_style_new]
	if(isrobot(usr))
		ic = all_ui_styles_robot[UI_style_new]

	for(var/obj/screen/I in icons)
		/* Bastion of Endeavor Translation
		if(I.name in list(I_HELP, I_HURT, I_DISARM, I_GRAB)) continue
		*/
		if(I.name in list("Помочь", "Навредить", "Обезвредить", "Схватить")) continue
		// End of Bastion of Endeavor Translation
		I.icon = ic
		I.color = UI_style_color_new
		I.alpha = UI_style_alpha_new


	/* Bastion of Endeavor Translation
	if(tgui_alert(usr, "Like it? Save changes?","Save?",list("Yes", "No")) == "Yes")
	*/
	if(tgui_alert(usr, "Сохранить изменения?","Сохранить?",list("Да", "Нет")) == "Да")
	// End of Bastion of Endeavor Translation
		prefs.UI_style = UI_style_new
		prefs.UI_style_alpha = UI_style_alpha_new
		prefs.UI_style_color = UI_style_color_new
		SScharacter_setup.queue_preferences_save(prefs)
		/* Bastion of Endeavor Translation
		to_chat(usr, "UI was saved")
		*/
		to_chat(usr, "Настройки интерфейса применены.")
		// End of Bastion of Endeavor Translation
