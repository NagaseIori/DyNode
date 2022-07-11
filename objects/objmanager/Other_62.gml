/// @description Check for latest update

if (async_load[? "id"] == _update_get) {
	if (async_load[? "status"] == 0) {
		show_debug_message("Get update succeed.");
		var _result = json_parse(async_load[? "result"]);
		
		if(is_struct(_result)) {
			if(variable_struct_exists(_result, "message") && _result.message == "Not Found") {
				show_debug_message("No updates found.")
			}
			else {
				show_debug_message("Version: " + _result.tag_name);
				show_debug_message("Html_Url: " + _result.html_url);
			}
		}
	}
	else if (async_load[? "status"] < 0) {
		show_debug_message("Get update failed.");
	}
}