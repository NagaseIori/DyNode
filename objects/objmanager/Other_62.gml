/// @description Check for latest update

if (async_load[? "id"] == _update_get) {
	if (async_load[? "status"] == 0) {
		show_debug_message("Get update succeed.");
		var _result = json_parse(async_load[? "result"]);
		
		if(is_struct(_result)) {
			if(variable_struct_exists(_result, "message") && _result.message == "Not Found") {
				show_debug_message("No updates found.")
				announcement_warning("未收取到 DyNode 的任何正式版本。");
			}
			else if(_result.tag_name != global.version) {
				_update_url = _result.html_url;
				announcement_play("[scale, 1.2]收取到新版本 DyNode：[#aed581]" + _result.tag_name + "[/c][/scale]\n[region,update][cycle,130,150]前往更新页面[/cycle][/region]\n\n" +
					"[c_ltgrey][scale, 0.8]"+format_markdown(_result.body)+"\n", 5000);
			}
		}
	}
	else if (async_load[? "status"] < 0) {
		announcement_error("更新检查错误。请检查与 Github 页面的网络连通性。")
		show_debug_message("Get update failed.");
	}
}