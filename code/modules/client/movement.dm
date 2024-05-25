
/client/New()
	..()
	dir = NORTH

/client/verb/spinleft()
	/* Bastion of Endeavor Translation: We dont want this ancient relic here as it breaks a lot of sprites
	set name = "Spin View CCW"
<<<<<<< HEAD
	set category = "OOC"
	*/
	set name = "Повернуть камеру ↻"
	set hidden = TRUE
	// End of Bastion of Endeavor Translation
=======
	set category = "OOC.Game" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	dir = turn(dir, 90)

/client/verb/spinright()
	/* Bastion of Endeavor Translation
	set name = "Spin View CW"
<<<<<<< HEAD
	set category = "OOC"
	*/
	set name = "Повернуть камеру ↺"
	set hidden = TRUE
	// End of Bastion of Endeavor Translation
=======
	set category = "OOC.Game" //CHOMPEdit
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
	dir = turn(dir, -90)
