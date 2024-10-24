/// Takes a screen loc string in the format
/// "+-left-offset:+-pixel,+-bottom-offset:+-pixel"
/// Where the :pixel is optional, and returns
/// A list in the format (x_offset, y_offset)
/// We require context to get info out of screen locs that contain relative info, so NORTH, SOUTH, etc
/proc/screen_loc_to_offset(screen_loc, view)
	if(!screen_loc)
		return list(64, 64)
	var/list/view_size = view_to_pixels(view)
	var/x = 0
	var/y = 0
	// Time to parse for directional relative offsets
	if(findtext(screen_loc, "EAST")) // If you're starting from the east, we start from the east too
		x += view_size[1]
	if(findtext(screen_loc, "WEST")) // HHHHHHHHHHHHHHHHHHHHHH WEST is technically a 1 tile offset from the start. Shoot me please
		x += ICON_SIZE_X
	if(findtext(screen_loc, "NORTH"))
		y += view_size[2]
	if(findtext(screen_loc, "SOUTH"))
		y += ICON_SIZE_Y

	var/list/x_and_y = splittext(screen_loc, ",")

	var/list/x_pack = splittext(x_and_y[1], ":")
	var/list/y_pack = splittext(x_and_y[2], ":")

	var/x_coord = x_pack[1]
	var/y_coord = y_pack[1]

	if (findtext(x_coord, "CENTER"))
		x += view_size[1] / 2

	if (findtext(y_coord, "CENTER"))
		y += view_size[2] / 2

	x_coord = text2num(cut_relative_direction(x_coord))
	y_coord = text2num(cut_relative_direction(y_coord))

	x += x_coord * ICON_SIZE_X
	y += y_coord * ICON_SIZE_Y

	if(length(x_pack) > 1)
		x += text2num(x_pack[2])
	if(length(y_pack) > 1)
		y += text2num(y_pack[2])
	return list(x, y)

/// Takes a list in the form (x_offset, y_offset)
/// And converts it to a screen loc string
/// Accepts an optional view string/size to force the screen_loc around, so it can't go out of scope
/proc/offset_to_screen_loc(x_offset, y_offset, view = null)
	if(view)
		var/list/view_bounds = view_to_pixels(view)
		x_offset = clamp(x_offset, ICON_SIZE_X, view_bounds[1])
		y_offset = clamp(y_offset, ICON_SIZE_Y, view_bounds[2])

	// Round with no argument is floor, so we get the non pixel offset here
	var/x = round(x_offset / ICON_SIZE_X)
	var/pixel_x = x_offset % ICON_SIZE_X
	var/y = round(y_offset / ICON_SIZE_Y)
	var/pixel_y = y_offset % ICON_SIZE_Y

	var/list/generated_loc = list()
	generated_loc += "[x]"
	if(pixel_x)
		generated_loc += ":[pixel_x]"
	generated_loc += ",[y]"
	if(pixel_y)
		generated_loc += ":[pixel_y]"
	return jointext(generated_loc, "")

/**
 * Returns a valid location to place a screen object without overflowing the viewport
 *
 * * target: The target location as a purely number based screen_loc string "+-left-offset:+-pixel,+-bottom-offset:+-pixel"
 * * target_offset: The amount we want to offset the target location by. We explictly don't care about direction here, we will try all 4
 * * view: The view variable of the client we're doing this for. We use this to get the size of the screen
 *
 * Returns a screen loc representing the valid location
**/
/proc/get_valid_screen_location(target_loc, target_offset, view)
	var/list/offsets = screen_loc_to_offset(target_loc)
	var/base_x = offsets[1]
	var/base_y = offsets[2]

	var/list/view_size = view_to_pixels(view)

	// Bias to the right, down, left, and then finally up
	if(base_x + target_offset < view_size[1])
		return offset_to_screen_loc(base_x + target_offset, base_y, view)
	if(base_y - target_offset > ICON_SIZE_Y)
		return offset_to_screen_loc(base_x, base_y - target_offset, view)
	if(base_x - target_offset > ICON_SIZE_X)
		return offset_to_screen_loc(base_x - target_offset, base_y, view)
	if(base_y + target_offset < view_size[2])
		return offset_to_screen_loc(base_x, base_y + target_offset, view)
	/* Bastion of Endeavor Translation
	stack_trace("You passed in a scren location {[target_loc]} and offset {[target_offset]} that can't be fit in the viewport Width {[view_size[1]]}, Height {[view_size[2]]}. what did you do lad")
	*/
	stack_trace("Передана локация экрана {[target_loc]} и оффсет {[target_offset]}, их нельзя вместить в окно шириной {[view_size[1]]} и высотой {[view_size[2]]}.")
	// End of Bastion of Endeavor Translation
	return null // The fuck did you do lad

/// Takes a screen_loc string and cut out any directions like NORTH or SOUTH
/proc/cut_relative_direction(fragment)
	var/static/regex/regex = regex(@"([A-Z])\w+", "g")
	return regex.Replace(fragment, "")

/// Returns a screen_loc format for a tiling screen objects from start and end positions. Start should be bottom left corner, and end top right corner.
/proc/spanning_screen_loc(start_px, start_py, end_px, end_py)
	var/starting_tile_x = round(start_px / ICON_SIZE_X)
	start_px -= starting_tile_x * ICON_SIZE_X
	var/starting_tile_y = round(start_py/ ICON_SIZE_Y)
	start_py -= starting_tile_y * ICON_SIZE_Y
	var/ending_tile_x = round(end_px / ICON_SIZE_X)
	end_px -= ending_tile_x * ICON_SIZE_X
	var/ending_tile_y = round(end_py / ICON_SIZE_Y)
	end_py -= ending_tile_y * ICON_SIZE_Y
	return "[starting_tile_x]:[start_px],[starting_tile_y]:[start_py] to [ending_tile_x]:[end_px],[ending_tile_y]:[end_py]"
