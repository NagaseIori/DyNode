
function editor_set_width_default(_width) {
    objEditor.editorDefaultWidth = _width;
}

function editor_set_editmode(mode) {
	objEditor.editorMode = mode;
}

function editor_get_editmode() {
    return objEditor.editorMode;
}

function editor_set_editside(side) {
	var _sidename = ["正面", "左侧", "右侧"];
	
	objEditor.editorSide = side;
	
	announcement_play("编辑侧切换至："+_sidename[side]);
	
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
function editor_select_get_area_position() {
	return objEditor.editorSelectAreaPosition;
}
function editor_select_inbound(x, y, side, type) {
	var _pos = editor_select_get_area_position();
	return side == editor_get_editside() && type != 3 && pos_inbound(x, y, _pos[0], _pos[1], _pos[2], _pos[3])
}

function editor_select_count() {
	return objEditor.editorSelectCount;
}

function editor_select_reset() {
	objEditor.editorSelectResetRequest = true;
}

function editor_snap_to_grid_y(_y, _side) {
    if(!objEditor.editorGridYEnabled || !array_length(objEditor.timingPoints)) return _y;
    
    var _nw = global.resolutionW, _nh = global.resolutionH;
    var _ret = _y;
    var _time = y_to_note_time(_y, _side);
    var _nowat = 0;
    with(objEditor) {
        var targetLineBelow = objMain.targetLineBelow;
        var targetLineBeside = objMain.targetLineBeside;
        var playbackSpeed = objMain.playbackSpeed;
        var _l = array_length(timingPoints);
        while(_nowat + 1 < _l && timingPoints[_nowat+1].time <= _time)
            _nowat++;
        var _nowtp = timingPoints[_nowat];
        var _nowbeats = floor((_time - _nowtp.time) / _nowtp.beatLength);
        var _nexttime = (_nowat + 1 == _l ? objMain.musicLength:timingPoints[_nowat+1].time)
        var _nowdiv = 1 / beatlineDivs[beatlineNowGroup][beatlineNowMode] * _nowtp.beatLength;
        
        var _ntime = (_time - _nowbeats * _nowtp.beatLength - _nowtp.time) / _nowdiv;
        var _rt = round(_ntime) * _nowdiv;
        var _rbt = round(_ntime)==ceil(_ntime) ? floor(_ntime) * _nowdiv : ceil(_ntime) * _nowdiv;
        _rt += _nowbeats * _nowtp.beatLength + _nowtp.time;
        _rbt += _nowbeats * _nowtp.beatLength + _nowtp.time;;
        var _ry = note_time_to_y(_rt, min(_side, 1));
        var _rby = note_time_to_y(_rbt, min(_side, 1));
        
        if(_side == 0) {
            if(_ry >= 0 && _ry <= _nh - targetLineBelow && _rt <= _nexttime)
                _ret = _ry;
            else if(_rby >= 0 && _rby <= _nh - targetLineBelow && _rbt <= _nexttime)
                _ret = _rby;
        }
        else {
            if(_ry >= targetLineBeside && _ry <= _nw/2 && _rt <= _nexttime)
                _ret = _side == 1?_ry:_nw - _ry;
            else if(_rby >= targetLineBeside && _rby <= _nw/2 && _rbt <= _nexttime)
                _ret = _side == 1?_rby:_nw - _rby;
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
	else if(ida.depth < idb.depth) return ida;
	else if(ida.depth > idb.depth) return idb;
	else if(ida.time < idb.time) return ida;
	else if(ida.time > idb.time) return idb;
	else return min(ida, idb);
}

function note_build_attach(_type, _side, _width, _pos=0, _time=0, _lasttime = -1) {
    var _obj = [objNote, objChain, objHold];
    _obj = _obj[_type];
    
    var _inst = instance_create_depth(mouse_x, mouse_y, 
                depth, _obj);
    
    with(_inst) {
        state = stateAttach;
        width = _width;
        side = _side;
        fixedLastTime = _lasttime;
        origPosition = _pos;
        origTime = _time;
        _prop_init();
        
        if(_lasttime != -1 && _type == 2) {
        	sinst = instance_create(x, y, objHoldSub);
        	sinst.dummy = true;
        	_prop_hold_update();
        }
    }
    
    return _inst;
}

function editor_get_note_attaching_center() {
	return objEditor.editorNoteAttaching[objEditor.editorNoteAttachingCenter];
}

#region UNDO & REDO FUNCTION

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
		// show_debug_message("New operation: "+string(array_length(_array)));
	}
}

function operation_do(_type, _from, _to = -1) {
	switch(_type) {
		case OPERATION_TYPE.ADD:
			return build_note_withprop(_from);
			break;
		case OPERATION_TYPE.MOVE:
			instance_activate_object(_from.inst);
			_from.inst.set_prop(_to);
			break;
		case OPERATION_TYPE.REMOVE:
			instance_activate_object(_from.inst);
			instance_destroy(_from.inst);
			break;
	}
}

function operation_refresh_inst(_origi, _nowi) {
	with(objEditor) {
		for(var i=0, l=array_length(operationStack); i<l; i++) {
			var _ops = operationStack[i];
			for(var ii=0, ll=array_length(_ops); ii<ll; ii++) {
				if(_ops[ii].fromProp.inst == _origi)
					_ops[ii].fromProp.inst = _nowi;
				if(_ops[ii].toProp != -1 && _ops[ii].toProp.inst == _origi)
					_ops[ii].toProp.inst = _nowi;
			}
		}
	}
	
}

function operation_undo() {
	if(operationPointer == -1) return;
	var _ops = operationStack[operationPointer];
	
	
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
				break;
			default:
				show_error("Unknown operation type.", true);
		}
	}
	
	operationPointer--;
	
	announcement_play("撤销操作 共 "+ string(array_length(_ops)) + " 处");
	note_sort_request();
	// show_debug_message("POINTER: "+ string(operationPointer));
}

function operation_redo() {
	if(operationPointer + 1 == operationCount) return;
	operationPointer ++;
	var _ops = operationStack[operationPointer];
	
	for(var i=0, l=array_length(_ops); i<l; i++) {
		switch(_ops[i].opType) {
			case OPERATION_TYPE.MOVE:
				operation_do(OPERATION_TYPE.MOVE, _ops[i].fromProp, _ops[i].toProp);
				break;
			case OPERATION_TYPE.ADD:
				var _inst = operation_do(OPERATION_TYPE.ADD, _ops[i].fromProp);
				operation_refresh_inst(_ops[i].fromProp.inst, _inst);
				break;
			case OPERATION_TYPE.REMOVE:
				operation_do(OPERATION_TYPE.REMOVE, _ops[i].fromProp);
				break;
			default:
				show_error("Unknown operation type.", true);
		}
	}
	
	announcement_play("还原操作 共 "+ string(array_length(_ops)) + " 处");
	note_sort_request();
}

#endregion

#region TIMING POINT FUNCTION
// Sort the "timingPoints" array
function timing_point_sort() {
    var _f = function(_a, _b) {
        return _a.time < _b.time;
    }
    array_sort_f(objEditor.timingPoints, _f);
}

// Add a timing point to "timingPoints" array
function timing_point_add(_t, _l, _b) {
    with(objEditor) {
        array_push(timingPoints, new sTimingPoint(_t, _l, _b));
        timing_point_sort();
    }
}

function timing_point_create() {
	var _time = string_digits(get_string("请输入该 Timing Point 的 offset（毫秒）：", ""));
	if(_time == "") return;
	var _bpm = string_real(get_string("请输入 BPM ：", ""));
	if(_bpm == "") return;
	var _meter = string_digits(get_string("请输入节拍（x/4）：", ""));
	if(_meter == "") return;
	
	_time = real(_time);
	_bpm = real(_bpm);
	_meter = real(_meter);
	
	_bpm = bpm_to_mspb(_bpm);
	timing_point_add(_time, _bpm, _meter);
	
	announcement_play("添加 Timing Point 至时间 "+format_time_ms(_time)+" 处\nBPM："+string(mspb_to_bpm(_bpm)) +
    		"\n节拍："+string(_meter)+"/4", 5000);
	
}

function timing_point_delete_at(_time) {
	with(objEditor) {
		for(var i=0, l=array_length(timingPoints); i<l; i++)
			if(int64(timingPoints[i].time) == _time) {
				var _tp = timingPoints[i];
				announcement_play("删除位于时间 "+ format_time_ms(_tp.time) + " 的 Timing Point\n"+
					"BPM："+string(mspb_to_bpm(_tp.beatLength)) +
    				"\n节拍："+string(_tp.meter)+"/4", 5000);
				array_delete(timingPoints, i, 1);
				return;
			}
	}
}

// Duplicate the last timing point at certain point
function timing_point_duplicate(_time) {
	with(objEditor) {
		if(array_length(timingPoints) == 0) {
			announcement_error("你没有设置任何 Timing Point 。需按 Y 键放置至少一个 Timing Point 。");
			return;
		}
		var _tp = timingPoints[array_length(timingPoints) - 1];
    	timing_point_add(_time, _tp.beatLength, _tp.meter);
    	
    	announcement_play("复制末尾 Timing Point 至时间 "+format_time_ms(_time)+" 处\nBPM："+string(mspb_to_bpm(_tp.beatLength)) +
    		"\n节拍："+string(_tp.meter)+"/4", 5000);
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
function timing_point_sync_with_chart_prop() {
	with(objMain) {
		chartBeatPerMin = mspb_to_bpm(objEditor.timingPoints[0].beatLength);
		chartBarPerMin = chartBeatPerMin / objEditor.timingPoints[0].meter;
	}
}

function timing_point_load_from_osz() {
    var _file = "";
    _file = get_open_filename_ext("OSU Files (*.osu)|*.osu", "", 
        program_directory, "Load osu! Chart File 加载 osu! 谱面文件");
        
    if(_file == "") return;
    
    var _import_hitobj = show_question("是否导入 .osu 中的物件？（要进行转谱吗？）");
    var _delay_import = show_question("是否为所有 Timing Points / 物件 添加 64ms 的延迟？");
    var _clear_notes = show_question("是否清除所有原谱面物件？此操作不可撤销！");
    if(_clear_notes) note_delete_all();
    var _delay_time = 64 * _delay_import;
    
    timing_point_reset();
    var _grid = csv_to_grid(_file, true);
    
    show_debug_message("CSV Load Finished.");
    
    var _type = "";
    var _w = ds_grid_width(_grid);
    var _h = ds_grid_height(_grid);
    var _mode = 0;				// Osu Game Mode
    
    for(var i=0; i<_h; i++) {
        if(string_last_pos("[", _grid[# 0, i]) != 0) {
        	_type = _grid[# 0, i];
        }
            
        else if(_grid[# 0, i] != ""){
            switch _type {
            	case "[General]":
            		if(string_last_pos("Mode", _grid[# 0, i]) != 0)
            			_mode = real(string_digits(_grid[# 0, i]));
            		break;
                case "[TimingPoints]":
                    var _time = real(_grid[# 0, i]) + _delay_time;
                    var _mspb = real(_grid[# 1, i]);
                    var _meter = real(_grid[# 2, i]);
                    if(_mspb > 0)
                        timing_point_add(_time, _mspb, _meter);
                    break;
                case "[HitObjects]":
                	if(_import_hitobj) {
                		var _ntime = real(_grid[# 2, i]) + _delay_time;
                		var _ntype = real(_grid[# 3, i]);
                		if(_ntime > 0) {
	                		switch _mode {
	                			case 0:
	                			case 1:
	                			case 2:
	                				var _x = real(_grid[# 0, i]);
	                				var _y = real(_grid[# 1, i]);
	                				build_note(random_id(9), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false);
	                				break;
	                			case 3: // Mania Mode
	                				var _x = real(_grid[# 0, i]);
	                				if(_ntype & 128) { // If is a Mania Hold
	                					var _subtim = real(string_copy(_grid[# 5, i], 1, string_pos(":", _grid[# 5, i])-1)) + _delay_time;
	                					build_hold(random_id(9), _ntime, _x / 512 * 5, 1.0, random_id(9), _subtim, 0);
	                				} 
	                				else
	                					build_note(random_id(9), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false);
	                				break;
	                		}
                		}
                	}
                	break;
				default:
					break;
            }
        }
    }
    
    timing_point_sort();
    note_sort_all();
    ds_grid_destroy(_grid);
    
    announcement_play("导入谱面信息完毕。", 1000);
}
#endregion
