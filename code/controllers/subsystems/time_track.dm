SUBSYSTEM_DEF(time_track)
	/* Bastion of Endeavor Translation
	name = "Time Tracking"
	*/
	name = "Отслеживание времени"
	// End of Bastion of Endeavor Translation
	wait = 600
	flags = SS_NO_INIT|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/time_dilation_current = 0

	var/time_dilation_avg_fast = 0
	var/time_dilation_avg = 0
	var/time_dilation_avg_slow = 0

	var/first_run = TRUE

	var/last_tick_realtime = 0
	var/last_tick_byond_time = 0
	var/last_tick_tickcount = 0

/datum/controller/subsystem/time_track/fire()

	var/current_realtime = REALTIMEOFDAY
	var/current_byondtime = world.time
	var/current_tickcount = world.time/world.tick_lag

	if (!first_run)
		var/tick_drift = max(0, (((current_realtime - last_tick_realtime) - (current_byondtime - last_tick_byond_time)) / world.tick_lag))

		time_dilation_current = tick_drift / (current_tickcount - last_tick_tickcount) * 100

		time_dilation_avg_fast = MC_AVERAGE_FAST(time_dilation_avg_fast, time_dilation_current)
		time_dilation_avg = MC_AVERAGE(time_dilation_avg, time_dilation_avg_fast)
		time_dilation_avg_slow = MC_AVERAGE_SLOW(time_dilation_avg_slow, time_dilation_avg)

		/* Bastion of Endeavor Translation
		log_game("TIDI: [time_dilation_current];[time_dilation_avg_fast];[time_dilation_avg];[time_dilation_avg_slow]")
		*/
		log_game("ЗАМЕДЛЕНИЕ: [time_dilation_current];[time_dilation_avg_fast];[time_dilation_avg];[time_dilation_avg_slow]")
		// End of Bastion of Endeavor Translation
	else
		first_run = FALSE
		/* Bastion of Endeavor Translation
		log_debug("TiDi Starting Log")
		*/
		log_debug("Начало лога замедления времени.")
		// End of Bastion of Endeavor Translation
	last_tick_realtime = current_realtime
	last_tick_byond_time = current_byondtime
	last_tick_tickcount = current_tickcount
