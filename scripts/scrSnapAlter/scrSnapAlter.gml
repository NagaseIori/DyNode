
function snap_alter_from_xml(_struct) {
	if(variable_struct_exists(_struct, "children")) {
		var l = array_length(_struct.children);
		for(var i=0; i<l; i++) {
			_struct.children[i] = snap_alter_from_xml(_struct.children[i]);
			if(variable_struct_exists(_struct, _struct.children[i].type)) {
				var _cont = variable_struct_get(_struct, _struct.children[i].type)
				if(!is_array(_cont)) {
					_cont = [_cont];
					variable_struct_set(_struct, _struct.children[i].type, _cont);
				}
				array_push(_cont, _struct.children[i])
			}
			else {
				variable_struct_set(_struct, _struct.children[i].type, _struct.children[i]);
			}
		}
		variable_struct_remove(_struct, "children");
	}
	return _struct;
}

function snap_alter_to_xml(_struct) {
    var _names = variable_struct_get_names(_struct);
    _struct.children = [];
    for(var i=0, l=array_length(_names); i<l; i++) if(!snap_alter_is_keyword(_names[i])) {
        var _str = variable_struct_get(_struct, _names[i]);
        if (!is_array(_str)) _str = [_str];
        for (var j=0, lj=array_length(_str); j<lj; j++) {
            _str[j] = snap_alter_to_xml(_str[j]);
            _str[j].type = _names[i];
            array_push(_struct.children, _str[j]);
        }
        variable_struct_remove(_struct, _names[i]);
    }
    return _struct;
}

function snap_alter_is_keyword(word) {
    var _keywords = ["text", "type", "children", "attributes"];
    var l = array_length(_keywords);
    for(var i=0; i<l; i++)
        if(word == _keywords[i]) return true;
    return false;
}