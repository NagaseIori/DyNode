/// @description Check for latest update

if (async_load[? "id"] == _update_get) {
	if (async_load[? "status"] == 0) {
		var _result = json_parse(async_load[? "result"]);
		
		if(is_struct(_result)) {
			if(variable_struct_exists(_result, "message") && _result.message == "Not Found") {
				announcement_warning("autoupdate_warn");
			}
			else if(version_cmp(_result.tag_name, VERSION)>0) {
				_update_url = _result.html_url;
				announcement_play("[scale, 1.5]"+i18n_get("autoupdate_found_1")+"[#aed581]" + _result.tag_name + 
					"[/c][scale,1]\n[region,update][cycle,130,150]" + i18n_get("autoupdate_found_2") + "[/cycle][/region]\n\n" +
					"[c_ltgrey][scale, 1]"+format_markdown(_result.body)+"\n", 5000);
			}
		}
	}
	else if (async_load[? "status"] < 0) {
		announcement_error("autoupdate_err")
	}
}