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

function _outscreen_check(_x, _y, _side) {
	return _side == 0? !in_between(_x, 0, global.resolutionW) : !in_between(_y, 0, global.resolutionH);
}

function note_sort_all() {
	notes_array_update();
    var _f = function(_a, _b) {
        return sign(_a.time == _b.time ? int64(_a.inst) - int64(_b.inst) : _a.time - _b.time);
    }
    array_sort(objMain.chartNotesArray, _f);
    
    // Update arrayPos & Flush deleted notes
    with(objMain) {
    	chartNotesCount = array_length(chartNotesArray);
    	
    	for(var i=0; i<chartNotesCount; i++)
    		if(instance_exists(chartNotesArray[i].inst))
    			chartNotesArray[i].inst.arrayPos = i;
    	
    	while(array_length(chartNotesArray) > 0 && array_last(chartNotesArray).time == INF) {
    		array_pop(chartNotesArray);
    	}
    }
}

function note_sort_request() {
	objEditor.editorNoteSortRequest = true;
}

function build_note(_id, _type, _time, _position, _width, _subid, _side, _fromxml = false, _record = false, _selecting = false) {
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
    	if(_selecting) state = stateSelected;
    }
    with(objMain) {
        array_push(chartNotesArray, _inst.get_prop(_fromxml));
        if(ds_map_exists(chartNotesMap[_inst.side], _id)) {
            show_error_async("Duplicate Note ID " + _id + " in side " 
                + string(_side), false);
            return true;
        }
        chartNotesMap[_inst.side][? _id] = _inst;
        
        note_sort_request();
    }
    
    if(_record)
    	operation_step_add(OPERATION_TYPE.ADD, _inst.get_prop(_fromxml), -1);
    
    return _inst;
}

function build_hold(_id, _time, _position, _width, _subid, _subtime, _side, _record = false, _selecting = false) {
	var _sinst = build_note(_subid, 3, _subtime, _position, _width, -1, _side, false, false, _selecting);
	var _inst = build_note(_id, 2, _time, _position, _width, _subid, _side, false, false, _selecting);
	_sinst.beginTime = _time;
	if(_record)
		operation_step_add(OPERATION_TYPE.ADD, _inst.get_prop(), -1);
	return _inst;
}


function build_note_withprop(prop, record = false, selecting = false) {
	if(prop.noteType < 2) {
		return build_note(random_id(9), prop.noteType, prop.time, prop.position, 
			prop.width, "-1", prop.side, false, record, selecting);
	}
	else {
		return build_hold(random_id(9), prop.time, prop.position, prop.width,
			random_id(9), prop.time + prop.lastTime, prop.side, record, selecting);
	}
}

function note_delete(_inst, _record = false) {
	if(_inst.arrayPos == -1)
		return;
    with(objMain) {
        var i = _inst.arrayPos;
        if(chartNotesArray[i].inst == _inst) {
        	chartNotesArray[i] = chartNotesArray[i].inst.get_prop();
        	if(_record)
        		operation_step_add(OPERATION_TYPE.REMOVE, SnapDeepCopy(chartNotesArray[i]), -1);
        	
        	ds_map_delete(chartNotesMap[chartNotesArray[i].side], _inst.nid);
            chartNotesArray[i].time = INF;
        }
        else
        	show_error("NOTE DELETE ERROR.", true);
    }
    note_sort_request();
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
		statCount = [0, 0, 0];
		chartNotesCount = array_length(chartNotesArray);
		var i=0, l=chartNotesCount;
		for(; i<l; i++) {
			if(instance_exists(chartNotesArray[i].inst)) {
				chartNotesArray[i].time = chartNotesArray[i].inst.time;
				chartNotesArray[i].side = chartNotesArray[i].inst.side;
				chartNotesArray[i].width = chartNotesArray[i].inst.width;
				chartNotesArray[i].lastTime = chartNotesArray[i].inst.lastTime;
				chartNotesArray[i].position = chartNotesArray[i].inst.position;
				chartNotesArray[i].noteType = chartNotesArray[i].inst.noteType;
				chartNotesArray[i].beginTime = chartNotesArray[i].inst.beginTime;
			}
			if(chartNotesArray[i].noteType < 3)
				statCount[chartNotesArray[i].noteType] ++;
		}
	}
	note_sort_request();
}

function notes_reallocate_id() {
	with(objMain) {
		instance_activate_object(objNote);
		var i=0, l=chartNotesCount;
		ds_map_clear(chartNotesMap[0]);
		ds_map_clear(chartNotesMap[1]);
		ds_map_clear(chartNotesMap[2]);
		for(; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			_inst.nid = string(i);
			chartNotesMap[_inst.side][? _inst.nid] = _inst;
		}
		for(i=0; i<l; i++) {
			var _inst = chartNotesArray[i].inst;
			if(_inst.noteType == 2)
				_inst.sid = _inst.sinst.nid;
			else
				_inst.sid = "-1";
		}
		note_activation_reset();
	}
}

function note_check_and_activate(_posistion_in_array) {
	var _struct = objMain.chartNotesArray[_posistion_in_array];
	if(instance_exists(_struct.inst)) {
		_struct.inst.arrayPos = _posistion_in_array;
		return 0;
	}
	var _str = _struct, _flag;
	_flag = _outbound_check_t(_str.time, _str.side);
	if((!_flag || (_str.noteType == 3 && _str.beginTime < nowTime)) && _str.time + _str.lastTime > nowTime) {
		// instance_activate_object(_str.inst);
		note_activate(_str.inst);
		_str.inst.arrayPos = _posistion_in_array;
		return 1;
	}
	else if(_flag && _outbound_check_t(_str.time, !(_str.side))) {
		return -1;
	}
	return 0;
}

function note_deactivate_request(inst) {
	objMain.deactivationQueue[? inst] = true;
}

function note_activate(inst) {
	instance_activate_object(inst);
	if(ds_map_exists(objMain.deactivationQueue, inst))
		ds_map_delete(objMain.deactivationQueue, inst);
}

function note_deactivate_flush() {
	// return;
	with(objMain) {
		var q=deactivationQueue;
		var k=ds_map_find_first(q), s=ds_map_size(q);
		if(s)
			show_debug_message_safe("DEACTIVATED "+string(s)+" NOTES.");
		for(; s>0; s--) {
			if(instance_exists(k.sinst))
				instance_deactivate_object(k.sinst);
			instance_deactivate_object(k);
			k=ds_map_find_next(q, k);
		}
		
		ds_map_clear(q);
	}
}

function note_select_reset(isself = false) {
	with(isself?id:objNote)
		if(state == stateSelected) {
			state = stateNormal;
			state();
		}
}

function note_activation_reset() {
	instance_deactivate_object(objNote);
	with(objMain) {
		ds_map_clear(deactivationQueue);
		for(var i=0; i<chartNotesCount; i++)
			note_check_and_activate(i);
	}
}