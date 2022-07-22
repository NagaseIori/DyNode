function _outbound_check(_x, _y, _side) {
    if(_side == 0 && _y < -100)
        return true;
    else if(_side == 1 && _x >= global.resolutionW / 2)
        return true;
    else if(_side == 2 && _x <= global.resolutionW / 2)
        return true;
    else
        return false;
}

function _outroom_check(_x, _y) {
	return !pos_inbound(_x, _y, 0, 0, global.resolutionW, global.resolutionH);
}

function _outbound_check_t(_time, _side) {
    var _pos = note_time_to_y(_time, _side);
    if(_side == 0 && _pos < -100)
        return true;
    else if(_side == 1 && _pos >= global.resolutionW / 2)
        return true;
    else if(_side == 2 && _pos <= global.resolutionW / 2)
        return true;
    else
        return false;
}

function note_all_sort() {
    var _f = function(_a, _b) {
        return _a.time < _b.time;
    }
    array_sort_f(objMain.chartNotesArray, _f);
}

function build_note(_id, _type, _time, _position, _width, _subid, _side, _fromxml = true, _sort = true) {
    var _obj = undefined;
    switch(_type) {
        case "NORMAL":
        case 0:
            _obj = objNote;
            break;
        case "CHAIN":
        case 1:
            _obj = objChain;
            break;
        case "HOLD":
        case 2:
            _obj = objHold;
            break;
        case "SUB":
        case 3:
            _obj = objHoldSub;
            break;
        default:
            return;
    }
    var _inst = instance_create_depth(0, 0, 0, _obj);
    _inst.width = real(_width);
    _inst.side = real(_side);
    // _inst.offset = real(_time);
    if(_fromxml)
        _inst.bar = real(_time);
    else
        _inst.time = _time;
    _inst.position = real(_position);
    _inst.nid = _id;
    _inst.sid = _subid;
    
    if(_fromxml)
        _inst.position += _inst.width/2;
    
    with(_inst) {
    	_prop_init();
    	if(noteType == 2) _prop_hold_update();
    }
    with(objMain) {
        array_push(chartNotesArray, {
        	time : _fromxml?_inst.bar:_inst.time,
        	side : _inst.side,
        	width : _inst.width,
        	position : _inst.position,
        	lastTime : _inst.lastTime,
        	noteType : _inst.noteType,
        	inst : _inst,
        	beginTime : _inst.beginTime
        });
        if(ds_map_exists(chartNotesMap[_inst.side], _id)) {
            show_error_async("Duplicate Note ID " + _id + " in side " 
                + string(_side), false);
            return true;
        }
        chartNotesMap[_inst.side][? _id] = _inst;
        
        if(!_fromxml && _sort)
            note_all_sort();
    }
    
    return _inst;
}

function build_hold(_id, _time, _position, _width, _subid, _subtime, _side, _sort = true) {
	var _sinst = build_note(_subid, 3, _subtime, _position, _width, -1, _side, false, _sort);
	build_note(_id, 2, _time, _position, _width, _subid, _side, false, _sort);
	_sinst.beginTime = _time;
	if(_sort)
		notes_array_update();
}

function note_delete(_id) {
    with(objMain) {
        var l=array_length(chartNotesArray);
        var found = false;
        for(var i=0; i<l; i++)
            if(chartNotesArray[i].inst.nid == _id) {
                var _insta = chartNotesArray[i].inst;
                array_delete(chartNotesArray, i, 1);
                found = true;
                break;
            }
		chartNotesCount = array_length(chartNotesArray);
    }
    if(found) note_all_sort();
}

function note_delete_all() {
	with(objMain) {
		chartNotesArray = [];
		chartNotesArrayAt = 0;
		ds_map_clear(chartNotesMap[0]);
		ds_map_clear(chartNotesMap[1]);
		ds_map_clear(chartNotesMap[2]);
		
		instance_activate_all();
		instance_destroy(objNote);
	}
}

function notes_array_update() {
	with(objMain) {
		chartNotesCount = array_length(chartNotesArray);
		var i=0, l=chartNotesCount;
		for(; i<l; i++) if(instance_exists(chartNotesArray[i].inst)) {
			chartNotesArray[i].time = chartNotesArray[i].inst.time;
			chartNotesArray[i].side = chartNotesArray[i].inst.side;
			chartNotesArray[i].width = chartNotesArray[i].inst.width;
			chartNotesArray[i].lastTime = chartNotesArray[i].inst.lastTime;
			chartNotesArray[i].position = chartNotesArray[i].inst.position;
			chartNotesArray[i].noteType = chartNotesArray[i].inst.noteType;
			chartNotesArray[i].beginTime = chartNotesArray[i].inst.beginTime;
		}
	}
	note_all_sort();
}

function notes_reallocate_id() {
	with(objMain) {
		var i=0, l=chartNotesCount;
		var _cnt = [0, 0, 0];
		for(; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			_inst.nid = string(_cnt[_inst.side]++);
		}
		for(i=0; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			if(_inst.noteType == 2)
				_inst.sid = _inst.sinst.nid;
		}
	}
}

function note_check_and_activate(_struct) {
	var _str = _struct, _flag;
	_flag = _outbound_check_t(_str.time, _str.side);
	if((!_flag || (_str.noteType == 3 && _str.beginTime < nowTime)) && _str.time + _str.lastTime > nowTime) {
		instance_activate_object(_str.inst);
		return 1;
	}
	else if(_flag && _outbound_check_t(_str.time, !(_str.side))) {
		return -1;
	}
	return 0;
}