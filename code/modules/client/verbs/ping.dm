/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*world.tick_usage/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
	/* Bastion of Endeavor Translation
	to_chat(src, "<span class='notice'>Round trip ping took [round(pingfromtime(time),1)]ms</span>")
	*/
	to_chat(src, "<span class='notice'>Пинг составляет [round(pingfromtime(time),1)] мс.</span>")
	// End of Bastion of Endeavor Translation

/client/verb/ping()
	/* Bastion of Endeavor Translation
	set name = "Ping"
<<<<<<< HEAD
	*/
	set name = "Пинг"
	// End of Bastion of Endeavor Translation
	set category = "OOC"
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*world.tick_usage/100]") 
=======
	set category = "OOC.Debug" //CHOMPEdit
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*world.tick_usage/100]")
>>>>>>> e28fa96705 (Tg panel patch 2 (#8085))
