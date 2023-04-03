
function sNote(prop) constructor {
	if(!is_struct(prop))
		show_error("prop in sNote must be a struct.", true);
	
	width = 2.0;
    position = 2.5;
    side = 0;
    time = 0;
    lastTime = 0;
    noteType = 0;
    arrayPos = -1;
    
    inst = undefined;
    sinst = undefined;
    snote = undefined;
    finst = undefined;
    fnote = undefined;
    selfPointer = self;
	
	static set_prop = function (prop) {
		width = prop.width;
		position = prop.position;
		side = prop.side;
		noteType = prop.noteType;
		time = prop.time;
		lastTime = prop.lastTime;
	}
	
	set_prop(prop);
	
	static get_prop = function (with_inst = true) {
		var _ret = {
			width: width,
			position: position,
			side: side,
			noteType: noteType,
			time: time,
			lastTime: lastTime
		};
		if(with_inst) {
			variable_struct_set(_ret, "inst", inst);
			variable_struct_set(_ret, "sinst", sinst);
		}
		return _ret;
	}
	
	static create_self = function () {
		if(instance_exists(inst))
			show_error("Create self failed. There has been a instance related to the note.", true);
		static obj_types = [objNote, objChain, objHold, objHoldSub];
		var obj_type = obj_types[noteType];
		inst = instance_create_depth(0, 0, 0, obj_type, {fstruct: selfPointer});
		return inst;
	}
	
	static get_begin_time = function () {
		if(noteType == 3) return time - lastTime;
		return 0x3f3f3f3f;
	}
	
	static activate = function () {
		note_activate(inst);
		inst.sync_prop_get();
	}
	
	static deactivate = function () {
		note_deactivate_request(inst);
	}
	
	static destroy = function (_record = true) {
		if(arrayPos == -1) {
			return;
		}
		var i = arrayPos;
    	if(_record)
    		operation_step_add(OPERATION_TYPE.REMOVE, get_prop(), -1);
		if(array_length(objMain.chartNotesArray))
    		ds_map_delete(objMain.chartNotesMap[objMain.chartNotesArray[i].side], inst.nid);
        time = INF;
	}
}

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
    var _f = function(_a, _b) {
        return sign(_a.time == _b.time ? int64(_a.inst) - int64(_b.inst) : _a.time - _b.time);
    }
    array_sort(objMain.chartNotesArray, _f);
    
    // Update arrayPos & Flush deleted notes
    with(objMain) {
    	chartNotesCount = array_length(chartNotesArray);
    	
    	for(var i=0; i<chartNotesCount; i++)
			chartNotesArray[i].arrayPos = i;
    	
    	while(array_length(chartNotesArray) > 0 && array_last(chartNotesArray).time == INF) {
    		array_pop(chartNotesArray);
    		// show_debug_message("Remove one note from array.");
    	}
    }
}

function note_sort_request() {
	objEditor.editorNoteSortRequest = true;
}

function build_note(prop, _fromxml = false, _record = false, _selecting = false) {
    var _note = new sNote(prop);
	var _inst = _note.create_self();
	
	if(_note.noteType == 2) {
		var _sprop = SnapDeepCopy(prop);
		_sprop.time = _note.time+_note.lastTime;
		_sprop.noteType = 3;
		var _snote = build_note(_sprop, _fromxml)
		_note.sinst = _snote.inst;
		_note.snote = _snote;
		_snote.finst = _note.inst;
		_snote.fnote = _note;
	}
    
    if(_fromxml)
        _note.position += _note.width/2;
    
    with(_inst) {
    	_prop_init();
    	if(noteType == 2) _prop_hold_update();
    	if(_selecting) state = stateSelected;
    }
    with(objMain) {
        array_push(chartNotesArray, _note);
        note_sort_request();
    }
    
    if(_record)
    	operation_step_add(OPERATION_TYPE.ADD, _note.get_prop(), -1);
    
    return _note;
}

function build_note_withprop(prop, record = false, selecting = false) {
	return build_note(prop, false, record, selecting);
}

function note_delete(_note, _record = false) {
	if(is_undefined(_note)) return;
	_note.destroy(_record);
}

function note_delete_all() {
	with(objMain) {
		chartNotesArray = [];
		chartNotesArrayAt = 0;
		ds_map_clear(chartNotesMap[0]);
		ds_map_clear(chartNotesMap[1]);
		ds_map_clear(chartNotesMap[2]);
		
		instance_activate_all();
		with(objNote) arrayPos = -1;
		instance_destroy(objNote);
	}
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
	var _str = objMain.chartNotesArray[_posistion_in_array];
	_str.arrayPos = _posistion_in_array;
	var _flag;
	_flag = _outbound_check_t(_str.time, _str.side);
	if((!_flag || (_str.noteType == 3 && _str.get_begin_time() < nowTime)) && _str.time + _str.lastTime > nowTime) {
		_str.activate();
		_str.arrayPos = _posistion_in_array;
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