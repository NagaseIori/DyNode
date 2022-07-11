/// @description Check for latest update

if (async_load[? "id"] == _update_get) {
	if (async_load[? "status"] == 0) {
		show_debug_message("Get update succeed.");
		show_debug_message(async_load[? "result"]);
	}
	else if (async_load[? "status"] < 0) {
		show_debug_message("Get update failed.");
	}
}