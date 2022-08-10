x = resor_to_x(0.05)

eventFunc = function() {
	var _mus = objUIInputManager.get_input("music");
	var _title = objUIInputManager.get_input("title");
	var _ltype = objUIInputManager.get_input("leftType");
	var _rtype = objUIInputManager.get_input("rightType");
	var _bg = objUIInputManager.get_input("background");
	var _chart = objUIInputManager.get_input("chart");
	var _difficulty = objUIInputManager.get_input("difficulty");
	if(_mus == "") {
		announcement_error("必须选择一个音乐文件来创建项目。");
		return;
	}
	
	objManager.initVars = {
			mus: _mus,
			title: _title,
			ltype: _ltype,
			rtype: _rtype,
			bg: _bg,
			chart: _chart,
			diff: _difficulty
		};
	room_goto(rMain);
}