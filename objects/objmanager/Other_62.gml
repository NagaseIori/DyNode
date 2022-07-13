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
			else if(_result.tag_name == global.version) {
				announcement_play("DyNode 已经是最新版本。")
			}
			else {
				announcement_play("DyNode 新版本已发布：" + _result.tag_name + "\n" +
					format_markdown(_result.body), 10000);
			}
		}
	}
	else if (async_load[? "status"] < 0) {
		announcement_error("更新检查错误。请检查与 Github 页面的网络连通性。")
		show_debug_message("Get update failed.");
	}
}