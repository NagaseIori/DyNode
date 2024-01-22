function editor_set_editmode(mode) {
	with(objEditor) {
		if(mode > 0) {
			singlePaste = false;
			operation_merge_last_request_revoke();
		}
		else {
			editorModeBeforeCopy = editorMode;
		}
		editorMode = mode;
	}
}

function editor_get_editmode() {
    return objEditor.editorMode;
}

function editor_get_default_width() {
	var _res = 0;
	with(objEditor) {
		switch(editorDefaultWidthMode) {
			case 0:
				_res = editorDefaultWidth[0];
				break;
			case 1:
				_res = editorDefaultWidth[1];
				if(editor_get_editside() > 0)
					_res *= 2;
				break;
			case 2:
				_res = editorDefaultWidth[2][min(editor_get_editside(), 1)];
				break;
			case 3:
				_res = editorDefaultWidth[3][editor_get_editside()];
				break;
		}
	}
	return _res;
}

function editor_set_default_width_qbox() {
	var _val = get_string_i18n("box_set_change_default_width", string(editor_get_default_width()));
	try {
		_val = real(_val);
	} catch (e) {
		if(_val != "")
			announcement_error("error_default_width_must_be_real")
	}
	if(is_real(_val)) {
		editor_set_default_width(_val);
		announcement_set("anno_default_width", string(_val));
		return true;
	}
	return false;
}

function editor_set_default_width(width) {
	with(objEditor) {
		switch(editorDefaultWidthMode) {
			case 0:
				editorDefaultWidth[0] = width;
				break;
			case 1:
				if(editor_get_editside() > 0)
					width /= 2;
				editorDefaultWidth[1] = width;
				break;
			case 2:
				editorDefaultWidth[2][min(editor_get_editside(), 1)] = width;
				break;
			case 3:
				editorDefaultWidth[3][editor_get_editside()] = width;
				break;
		}
	}
}

function editor_set_editside(side, same_then_silence = false) {
	var _sidename = ["editside_down", "editside_left", "editside_right"];
	
	if(!(same_then_silence && objEditor.editorSide == side))
		announcement_play(i18n_get("anno_editside_switch") + ": " +i18n_get(_sidename[side]));
	objEditor.editorSide = side;
	
	if(editor_get_editmode() == 5)
		editor_set_editmode(4);
}

function editor_get_editside() {
    return objEditor.editorSide;
}

function editor_select_is_going() {
	return objEditor.editorSelectOccupied;
}
function editor_select_is_multiple() {
	return objEditor.editorSelectMultiple;
}
function editor_select_is_dragging() {
	return objEditor.editorSelectDragOccupied;
}
function editor_select_is_area() {
	return objEditor.editorSelectArea;
}
function editor_editside_allowed(side) {
	return side == editor_get_editside();
}
function editor_select_get_area_position() {
	var _pos;
	with(objEditor) {
		_pos = noteprop_to_xy(editorSelectAreaPosition.pos, editorSelectAreaPosition.time, editorSide);
		_pos = [_pos.x, _pos.y];
		_pos[2] = mouse_x;
		_pos[3] = mouse_y;
	}
	return _pos;
}
function editor_select_inbound(x, y, side, type, onlytime = -1) {
	var _pos = editor_select_get_area_position();
	return side == editor_get_editside() && type != 3 && pos_inbound(x, y, _pos[0], _pos[1], _pos[2], _pos[3], onlytime)
}

function editor_select_count() {
	return objEditor.editorSelectCount;
}

function editor_select_reset() {
	objEditor.editorSelectResetRequest = true;
}

function editor_snap_to_grid_y(_y, _side) {
	var _ret = {
	    	y: _y,
	    	bar: undefined
    	};
    if(!objEditor.editorGridYEnabled || !array_length(objEditor.timingPoints)) return _ret;
    
    var _nw = global.resolutionW, _nh = global.resolutionH;
    
    var _time = y_to_note_time(_y, _side);
    var _nowat = 0;
    
    with(objEditor) {
        var targetLineBelow = objMain.targetLineBelow;
        var targetLineBeside = objMain.targetLineBeside;
        var playbackSpeed = objMain.playbackSpeed;
        var _l = array_length(timingPoints);
        var _totalBar = 1;
        while(_nowat + 1 != _l && timingPoints[_nowat+1].time <= _time) {
        	_totalBar += ceil((timingPoints[_nowat+1].time - timingPoints[_nowat].time)
        		/(timingPoints[_nowat].beatLength*timingPoints[_nowat].meter));
        	_nowat ++;
        }
        var _nowtp = timingPoints[_nowat];
        var _nowbeats = floor((_time - _nowtp.time) / _nowtp.beatLength);
        var _nexttime = (_nowat + 1 == _l ? objMain.musicLength:timingPoints[_nowat+1].time)
        var _nowdivb = objEditor.get_div(); // divs per beat
        var _nowdiv = 1 / _nowdivb * _nowtp.beatLength;
        var _nowdivbm = _nowdivb * _nowtp.meter; // divs per bar
        
        var _ntime = (_time - _nowbeats * _nowtp.beatLength - _nowtp.time) / _nowdiv;
        var _rd = round(_ntime); // now divs in one beat
        var _rt = _rd * _nowdiv;
        var _rbd = round(_ntime)==ceil(_ntime) ? floor(_ntime) : ceil(_ntime);
        var _rbt = _rbd * _nowdiv;
        _rt += _nowbeats * _nowtp.beatLength + _nowtp.time;
        _rbt += _nowbeats * _nowtp.beatLength + _nowtp.time;
        var _ry = note_time_to_y(_rt, min(_side, 1));
        var _rby = note_time_to_y(_rbt, min(_side, 1));
        
        var _eps = 1;	// Prevent some precision problems
        var _f_genret = method({
        	_nowbeats: _nowbeats,
        	_nowdivb: _nowdivb,
        	_nowdivbm: _nowdivbm,
        	_totalBar: _totalBar
        }, function (_ny, _d) {
        	return {
        		y: _ny,
            	bar: floor((_d + _nowbeats * _nowdivb)/_nowdivbm) + _totalBar,
            	diva: ((_d + _nowbeats * _nowdivb) % _nowdivbm + _nowdivbm) % _nowdivbm,
            	divb: _nowdivbm,
            	divc: _nowdivb * 4
        	};
        });
        
        if(_side == 0) {
            if(_ry >= 0 && _ry <= _nh - targetLineBelow && _rt + _eps <= _nexttime)
                _ret = _f_genret(_ry, _rd);
            else if(_rby >= 0 && _rby <= _nh - targetLineBelow && _rbt + _eps <= _nexttime)
                _ret = _f_genret(_rby, _rbd);
        }
        else {
            if(_ry >= targetLineBeside && _ry <= _nw/2 && _rt + _eps <= _nexttime)
                _ret = _f_genret(_side == 1?_ry:_nw - _ry, _rd);
            else if(_rby >= targetLineBeside && _rby <= _nw/2 && _rbt + _eps <= _nexttime)
                _ret = _f_genret(_side == 1?_rby:_nw - _rby, _rbd);
        }
    }
    
    return _ret;
}

function editor_snap_to_grid_x(_x, _side) {
	if(!objEditor.editorGridXEnabled) return _x;
	
	var _pos = x_to_note_pos(_x, _side);
	_pos = round(_pos * 10) / 10;
	return note_pos_to_x(_pos, _side);
}

function editor_snap_width(_width) {
	if(objEditor.editorGridWidthEnabled)
		_width = round(_width * 20) / 20; // per 0.05
	return _width;
}

// Comparison function to deal with multiple single selection targets
function editor_select_compare(ida, idb) {
	if(!instance_exists(ida)) return idb;
	else if(!instance_exists(idb)) return ida;
	else if(ida.priority < idb.priority) return ida;
	else if(ida.priority > idb.priority) return idb;
	else if(ida.time < idb.time) return ida;
	else if(ida.time > idb.time) return idb;
	else return min(ida, idb);
}

function note_build_attach(_type, _side, _width, _pos=0, _time=0, _lasttime = -1) {
    var _obj = [objNote, objChain, objHold];
    _obj = _obj[_type];
    
    var _inst = instance_create_depth(mouse_x, mouse_y, 
                depth, _obj);
    
	/// @self Id.Instance.objNote
    with(_inst) {
        state = stateAttach;
        width = _width;
        side = _side;
        fixedLastTime = _lasttime;
        origPosition = _pos;
        origTime = _time;
        attaching = true;
        _prop_init();
        
        if(_lasttime != -1 && _type == 2) {
        	sinst = instance_create(x, y, objHoldSub);
        	sinst.dummy = true;
        	_prop_hold_update();
        }
    }
    
    return _inst;
}

/// @returns {Id.Instance.objNote} Note instance.
function editor_get_note_attaching_center() {
	return objEditor.editorNoteAttaching[objEditor.editorNoteAttachingCenter];
}

#region UNDO & REDO FUNCTION

function operation_synctime_set(time) {
	with(objEditor) {
		operationSyncTime[0] = min(operationSyncTime[0], time);
		operationSyncTime[1] = max(operationSyncTime[1], time);
		show_debug_message_safe("OPERATION SYNC TIME SET:"+string(operationSyncTime));
	}
}
function operation_synctime_sync() {
	if(objEditor.operationSyncTime[0] == INF) return;
	var _time = objEditor.operationSyncTime;
	
	objMain.time_range_made_inbound(_time[0], _time[1], 300);
	objEditor.operationSyncTime = [INF, -INF];
}

function operation_step_add(_type, _from, _to) {
	with(objEditor) {
		array_push(operationStackStep, new sOperation(_type, _from, _to));
	}
}

function operation_step_flush(_array) {
	with(objEditor) {
		array_resize(operationStack, operationPointer + 1);
		array_push(operationStack, _array);
		operationPointer ++;
		operationCount = operationPointer + 1;
		// show_debug_message_safe($"New operation: {_array}");

		if(operationMergeLastRequest > 0) {
			operationMergeLastRequestCount ++;
			if(operationMergeLastRequest == operationMergeLastRequestCount) {
				operation_merge_last(operationMergeLastRequest);
				operationMergeLastRequest = 0;
				operationMergeLastRequestCount = 0;
			}
		}
	}
}

function operation_do(_type, _from, _to = -1) {
	if(_to != -1)
		operation_synctime_set(_to.time);
	else if(is_struct(_from))
		operation_synctime_set(_from.time);
	switch(_type) {
		case OPERATION_TYPE.ADD:
			return build_note_withprop(_from, false, true);
			break;
		case OPERATION_TYPE.MOVE:
			note_activate(_from.inst);
			_from.inst.set_prop(_to);
			_from.inst.note_outscreen_check();
			_from.inst.select();
			break;
		case OPERATION_TYPE.REMOVE:
			note_activate(_from.inst);
			instance_destroy(_from.inst);
			break;
		case OPERATION_TYPE.TPADD:
			timing_point_add(_from.time, _from.beatLength, _from.meter);
			break;
		case OPERATION_TYPE.TPREMOVE:
			timing_point_delete_at(_from.time);
			break;
		case OPERATION_TYPE.TPCHANGE:
			var _tp = timing_point_get_at(_from.time);
			_tp.time = _to.time;
			_tp.beatLength = _to.beatLength;
			_tp.meter = _to.meter;
			break;
		case OPERATION_TYPE.OFFSET:
			map_add_offset(_from);
			break;
	}
}

function operation_refresh_inst(_origi, _nowi) {
	with(objEditor) {
		for(var i=0, l=array_length(operationStack); i<l; i++) {
			var _ops = operationStack[i];
			for(var ii=0, ll=array_length(_ops); ii<ll; ii++) if(variable_struct_exists(_ops[ii].fromProp, "inst")) {
				if(_ops[ii].fromProp.inst == _origi)
					_ops[ii].fromProp.inst = _nowi;
				if(_ops[ii].toProp != -1 && _ops[ii].toProp.inst == _origi)
					_ops[ii].toProp.inst = _nowi;
				if(_ops[ii].fromProp.sinst == _origi)
					_ops[ii].fromProp.sinst = _nowi;
				if(_ops[ii].toProp != -1 && _ops[ii].toProp.sinst == _origi)
					_ops[ii].toProp.sinst = _nowi;
			}
		}
	}
	
}

function operation_undo() {
	with(objEditor) {
		if(operationPointer == -1) return;
		var _ops = operationStack[operationPointer];
		
		note_select_reset();
		for(var i=0, l=array_length(_ops); i<l; i++) {
			switch(_ops[i].opType) {
				case OPERATION_TYPE.MOVE:
					operation_do(OPERATION_TYPE.MOVE, _ops[i].toProp, _ops[i].fromProp);
					break;
				case OPERATION_TYPE.ADD:
					operation_do(OPERATION_TYPE.REMOVE, _ops[i].fromProp);
					break;
				case OPERATION_TYPE.REMOVE:
					var _inst = operation_do(OPERATION_TYPE.ADD, _ops[i].fromProp);
					operation_refresh_inst(_ops[i].fromProp.inst, _inst);
					operation_refresh_inst(_ops[i].fromProp.sinst, _inst.sinst);
					break;
				case OPERATION_TYPE.TPADD:
					operation_do(OPERATION_TYPE.TPREMOVE, _ops[i].fromProp);
					break;
				case OPERATION_TYPE.TPREMOVE:
					operation_do(OPERATION_TYPE.TPADD, _ops[i].fromProp);
					break;
				case OPERATION_TYPE.TPCHANGE:
					operation_do(OPERATION_TYPE.TPCHANGE, _ops[i].toProp, _ops[i].fromProp);
					break;
				case OPERATION_TYPE.OFFSET:
					operation_do(OPERATION_TYPE.OFFSET, -_ops[i].fromProp);
					break;
				default:
					show_error("Unknown operation type.", true);
			}
		}
		
		operationPointer--;
		
		announcement_play(i18n_get("undo", string(array_length(_ops))));
		note_sort_request();
		// show_debug_message_safe("POINTER: "+ string(operationPointer));
	}
	
}

function operation_redo() {
	with(objEditor) {
		if(operationPointer + 1 == operationCount) return;
		operationPointer ++;
		var _ops = operationStack[operationPointer];
		note_select_reset();
		for(var i=0, l=array_length(_ops); i<l; i++) {
			switch(_ops[i].opType) {
				case OPERATION_TYPE.MOVE:
				case OPERATION_TYPE.TPCHANGE:
					operation_do(_ops[i].opType, _ops[i].fromProp, _ops[i].toProp);
					break;
				case OPERATION_TYPE.ADD:
					var _inst = operation_do(OPERATION_TYPE.ADD, _ops[i].fromProp);
					operation_refresh_inst(_ops[i].fromProp.inst, _inst);
					operation_refresh_inst(_ops[i].fromProp.sinst, _inst.sinst);
					break;
				case OPERATION_TYPE.REMOVE:
				case OPERATION_TYPE.TPADD:
				case OPERATION_TYPE.TPREMOVE:
				case OPERATION_TYPE.OFFSET:
					operation_do(_ops[i].opType, _ops[i].fromProp);
					break;
				default:
					show_error("Unknown operation type.", true);
			}
		}
		
		announcement_play(i18n_get("redo", string(array_length(_ops))));
		note_sort_request();
	}
}

/// @description Merge last operations to one operation.
/// @param {Real} count The number of last operations to merge.
function operation_merge_last(count) {
	// show_debug_message($"Merge last {count} operations.");
	if(count <= 1) {
		show_debug_message("[Warning] At least merge 2 operations.");
		return;
	}
	with(objEditor) {
		var _new_ops = [];
		for(var i=0; i<count; i++) {
			_new_ops = array_concat(_new_ops, operationStack[operationPointer - i]);
		}
		operationPointer -= count - 1;
		operationCount = operationPointer + 1;
		operationStack[operationPointer] = _new_ops;
	}
}

/// @description Send requests to merge the last new operations from now on.
/// @param {Real} count The number of last operations to merge.
function operation_merge_last_request(count) {
	if(count <= 1) {
		show_debug_message("[Warning] At least merge 2 operations.");
		return;
	}
	with(objEditor) {
		operationMergeLastRequestCount = 0;
		operationMergeLastRequest = count;
	}
}

/// @description Revoke the merge operations request.
function operation_merge_last_request_revoke() {
	objEditor.operationMergeLastRequest = 0;
	objEditor.operationMergeLastRequestCount = 0;
}

#endregion

#region TIMING POINT FUNCTION

// Sort the "timingPoints" array
function timing_point_sort() {
    var _f = function(_a, _b) {
        return sign(_a.time - _b.time);
    }
    array_sort(objEditor.timingPoints, _f);
}

// Add a timing point to "timingPoints" array
function timing_point_add(_t, _l, _b, record = false) {
    with(objEditor) {
        array_push(timingPoints, new sTimingPoint(_t, _l, _b));
        timing_point_sort();
    }
    if(record)
    	operation_step_add(OPERATION_TYPE.TPADD, new sTimingPoint(_t, _l, _b), -1);
}

function timing_point_create(record = false) {
	var _time = undefined;
	if(editor_select_count() == 1) {
		var _ntime = 0;
		with(objNote)
			if(state == stateSelected)
				_ntime = time;
		var _ptp = timing_point_get_at(_ntime);
		if(_ptp != undefined) {
			timing_point_change(_ptp, record);
			return;
		}
		var _que = show_question_i18n(i18n_get("tpc_extra_question", string_format(_ntime, 1, 3)));
		if(_que) _time = _ntime;
	}
	if(is_undefined(_time))
		_time = string_digits(get_string_i18n("tpc_q1", ""));
	if(_time == "") return;
	var _bpm = string_real(get_string_i18n("tpc_q2", ""));
	if(_bpm == "") return;
	var _meter = string_digits(get_string_i18n("tpc_q3", ""));
	if(_meter == "") return;
	
	_time = real(_time);
	_bpm = real(_bpm);
	_meter = real(_meter);
	
	_bpm = bpm_to_mspb(_bpm);
	timing_point_add(_time, _bpm, _meter, record);
	
    announcement_play(
    	i18n_get("add_timing_point", format_time_ms(_time), string(mspb_to_bpm(_bpm)), string(_meter)), 
    	5000);
}

function timing_point_change(tp, record = false) {
	var _current_setting = $"{tp.time} , {mspb_to_bpm(tp.beatLength)} , {tp.meter}";
	var _setting = get_string(i18n_get("timing_point_change", tp.time), _current_setting);
	if(_setting == _current_setting || _setting == "")
		return;
	try {
		var _arr = string_split(_setting, ",", true);
		var _oarr = string_split(_current_setting, ",", true);
		var _noffset = real(_arr[0]);
		var _nbpm = real(_arr[1]);
		var _nmeter = int64(_arr[2]);

		var _tpBefore = SnapDeepCopy(tp);
		var _tpAfter = SnapDeepCopy(tp);
		var _fixable = false;
		if(_oarr[0] != _arr[0]) {
			_tpAfter.time = _noffset;
			_fixable = true;
		}
		if(_oarr[1] != _arr[1]) {
			_tpAfter.beatLength = bpm_to_mspb(_nbpm);
			_fixable = true;
		}
		if(_oarr[2] != _arr[2])
			_tpAfter.meter = _nmeter;

		if(_fixable)
			timing_fix(tp, _tpAfter);

		tp.meter = _tpAfter.meter;
		tp.beatLength = _tpAfter.beatLength;
		tp.time = _tpAfter.time;

		if(record)
			operation_step_add(OPERATION_TYPE.TPCHANGE, _tpBefore, _tpAfter);
		
		timing_point_sort();
		announcement_play(i18n_get("timing_point_change_success", tp.time, _nbpm, _nmeter), 5000);
	} catch (e) {
		announcement_error(i18n_get("timing_point_change_err") + "\n[scale,0.5]" + string(e));
		return;
	}
}

function timing_fix(tpBefore, tpAfter) {
	with(objEditor) {
		var l = array_length(timingPoints);
		var at = -1;
		for(var i=0; i<l; i++)
			if(timingPoints[i] == tpBefore) {
				at = i;
				break;
			}
		// Get affected time range.
		var _timeL = tpBefore.time, _timeR = at+1 == l? 1000000000: timingPoints[at+1].time - 1;
		var _timeM = at - 1 < 0 ? -1000000000: timingPoints[at-1].time;
		var _noteArr = objMain.chartNotesArray;
		var nl = array_length(_noteArr);
		// Get affected notes.
		var _affectedNotes = [];
		for(var i=0; i<nl; i++)
			if(in_between(_noteArr[i].time, _timeL, _timeR))
				array_push(_affectedNotes, _noteArr[i]);
		if(array_length(_affectedNotes) == 0)
			return;
		var _que = show_question(i18n_get("timing_fix_question", _timeL, at+1 == l?objMain.musicLength:_timeR, array_length(_affectedNotes)));
		if(!_que) return;
		var _bar = [];
		nl = array_length(_affectedNotes);
		// Caculate the notes' bars before.
		for(var i=0; i<nl; i++)
			array_push(_bar, time_to_bar_dyn(_affectedNotes[i].time, _timeR));
		tpBefore.beatLength = tpAfter.beatLength;
		var _cross_timing_warning = false;
		// Convert bar to the new time.
		for(var i=0; i<nl; i++) {
			var _prop = _affectedNotes[i].inst.get_prop();
			_prop.time = bar_to_time_dyn(_bar[i]);
			// Add the offset's delta.
			_prop.time += tpAfter.time - tpBefore.time;
			_prop.lastTime = -1;	// Detatch the sub and the hold.
			if(_prop.time > _timeR)
				_cross_timing_warning = true;
			_affectedNotes[i].inst.set_prop(_prop, true);
		}
		if(tpAfter.time < _timeM)
			_cross_timing_warning = true;	// Timing's offset conflicts with another timing.
		note_sort_request();
		if(_cross_timing_warning)
			announcement_warning("timing_fix_cross_warning");
	}
}

function timing_point_get_at(_time) {
	with(objEditor) {
		for(var i=0, l=array_length(timingPoints); i<l; i++)
			if(abs(timingPoints[i].time-_time) <= 1)
				return timingPoints[i];
		return undefined;
	}
}

function timing_point_delete_at(_time, record = false) {
	with(objEditor) {
		for(var i=0, l=array_length(timingPoints); i<l; i++)
			if(abs(timingPoints[i].time-_time) <= 1) {
				var _tp = timingPoints[i];
				announcement_play(
					i18n_get("remove_timing_point", format_time_ms(_tp.time),
    					string(mspb_to_bpm(_tp.beatLength)), string(_tp.meter)),
					5000);
    			
    			
    			if(record)
    				operation_step_add(OPERATION_TYPE.TPREMOVE, _tp, -1);
				array_delete(timingPoints, i, 1);
				l--;
				i--;
			}
	}
}

// Duplicate the last timing point at certain point
function timing_point_duplicate(_time) {
	with(objEditor) {
		if(array_length(timingPoints) == 0) {
			announcement_error("error_no_timing_point");
			return;
		}
		var _tp = timingPoints[array_length(timingPoints) - 1];
    	timing_point_add(_time, _tp.beatLength, _tp.meter, true);
    	
    	announcement_play(
    		i18n_get("copy_timing_point", format_time_ms(_time), 
    			string(mspb_to_bpm(_tp.beatLength)), string(_tp.meter)), 
			5000);
    	
	}
}

// Reset the "timingPoints" array
function timing_point_reset() {
    with(objEditor) {
        var _l = array_length(timingPoints);
        for(var i=0; i<_l; i++) {
            delete timingPoints[i];
        }
        timingPoints = [];
    }
}

// For Compatibility
function timing_point_sync_with_chart_prop(_force_sync = true, _force_reset = true) {
	if(array_length(objEditor.timingPoints) == 0)
		return false;
	with(objMain) {
		var _q = _force_reset? true:show_question_i18n("bar_calibration_question");
		
		if(_force_sync || _q) {
			chartBeatPerMin = mspb_to_bpm(objEditor.timingPoints[0].beatLength);
			chartBarPerMin = chartBeatPerMin / 4;
		}
		
		if(_q) {
			chartTimeOffset = -objEditor.timingPoints[0].time;
			chartBarOffset = time_to_bar(chartTimeOffset);
			chartBarUsed = true;
			
			// Deprecated
			// announcement_play(i18n_get("bar_calibration_complete", chartBarPerMin, chartBarOffset));
			
			return true;
		}
		else if(_force_sync) {
			chartTimeOffset = 0;
			chartBarOffset = 0;
		}
		
		return false;
	}
}

#endregion

/// surprise
function chart_randomize() {
	instance_activate_all();
	with(objNote) {
		if(noteType != 3) {
			origProp = get_prop();
			position = random(5);
			side = irandom_range(0, 2);
			width = random_range(0.5, 5);
			operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
		}
		
	}
	notes_array_update();
	note_activation_reset();
}

/// For advanced property modifications.
function advanced_expr() {
	with(objEditor) {
		var _global = editorSelectCount == 0;
		var _scope_str = _global?"你正在对谱面的所有音符进行高级操作。":"你正在对选定的音符进行高级操作。";
		var _expr = get_string(_scope_str+"请填写表达式：", editorLastExpr);
		if(_expr == "") return;
		var _using_bar = string_last_pos(_expr, "bar");
		var _success = 1;
		
		if(_global)
			instance_activate_all();
		
		with(objNote) {
			if(noteType != 3)
			if(_global || state==stateSelected) {
				var _prop = get_prop();
				var _nprop = get_prop();
				
				expr_init(); // Reset symbol table
				expr_set_var("time", _prop.time);
				expr_set_var("pos", _prop.position);
				expr_set_var("wid", _prop.width);
				expr_set_var("len", _prop.lastTime);
				expr_set_var("htime", _prop.time);
				expr_set_var("etime", _prop.time + _prop.lastTime);
				
				_success = _success && expr_exec(_expr);
				
				if(!_success) {
					announcement_error("advanced_expr_error");
					break;
				}
				
				_nprop.time = expr_get_var("time");
				_nprop.position = expr_get_var("pos");
				_nprop.width = expr_get_var("wid");
				if(noteType == 2) {
					if(expr_get_var("htime") != _prop.time) {
						_nprop.lastTime = _prop.lastTime - (expr_get_var("htime") - _prop.time);
						_nprop.time = expr_get_var("htime");
					}
					if(expr_get_var("len") != _prop.lastTime)
						_nprop.lastTime = expr_get_var("len");
					else
						_nprop.lastTime = expr_get_var("etime") - _nprop.time;
				}
				
				set_prop(_nprop, true);
				
				delete _prop;
				delete _nprop;
			}
		}
		
		if(_success)
			announcement_play("表达式执行成功。");
			
		editorLastExpr = _expr;
		
		note_sort_all();
		if(_global)
			note_activation_reset();
	}
}

// Advanced divisor setter
function editor_set_div() {
	var _div = get_string_i18n("box_set_div", string(objEditor.get_div()));
	if(_div == "") return 0;
	try {
		_div = int64(_div);
		if(_div<1) {
			throw "Bad range.";
		}
		else {
			objEditor.set_div(_div);
		}
	} catch (e) {
		announcement_error("Please input a valid number.");
		return -1;
	}
	return 1;
}

// error correction
function note_error_correction(_limit, _array = objMain.chartNotesArray, _sync_to_instance = true) {
	if(_limit <= 0) {
		announcement_error($"不合法的修正参数{_limit}。请使用大于零的误差。");
		return;
	}
	
	instance_activate_object(objNote);
	var notes_to_fix = [];
	for(var i=0, l=array_length(_array); i < l; i++) {
		if(i==0) {
			array_push(notes_to_fix, _array[i]);
		}
		else {
			assert(_array[i].time >= _array[i-1].time);

			if(_array[i].time - notes_to_fix[0].time <= _limit)
				array_push(notes_to_fix, _array[i]);
			else {
				if(array_length(notes_to_fix) > 1) {
					for(var _i=1, _l=array_length(notes_to_fix); _i < _l; _i++) {
						notes_to_fix[_i].time = notes_to_fix[0].time;
						if(_sync_to_instance)
							notes_to_fix[_i].inst.set_prop(notes_to_fix[_i]);
					}
				}
				notes_to_fix = [_array[i]];
			}
		}
	}
	note_activation_reset();
}