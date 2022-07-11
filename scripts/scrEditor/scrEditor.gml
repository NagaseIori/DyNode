
function editor_set_width_default(_width) {
    objEditor.editorDefaultWidth = _width;
}

function editor_set_editmode(mode) {
	objEditor.editorMode = mode;
}

function editor_get_editmode() {
    return objEditor.editorMode;
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

function editor_snap_to_grid_y(_y, _side) {
    if(!objEditor.editorGridYEnabled) return _y;
    
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
        var _nowdiv = 1 / beatlineDivs[beatlineNowMode] * _nowtp.beatLength;
        
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

function note_build_attach(_type, _side, _width) {
    var _obj = [objNote, objChain, objHold];
    _obj = _obj[_type];
    
    var _inst = instance_create_depth(mouse_x, mouse_y, 
                depth, _obj);
    
    with(_inst) {
        state = stateAttach;
        width = _width;
        side = _side;
        _prop_init();
    }
    
    return _inst;
}

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
	                				build_note(random_id(6), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false, false);
	                				break;
	                			case 3: // Mania Mode
	                				var _x = real(_grid[# 0, i]);
	                				if(_ntype & 128) { // If is a Mania Hold
	                					var _subtim = real(string_copy(_grid[# 5, i], 1, string_pos(":", _grid[# 5, i])-1)) + _delay_time;
	                					build_hold(random_id(6), _ntime, _x / 512 * 5, 1.0, random_id(6), _subtim, 0);
	                				} 
	                				else
	                					build_note(random_id(6), 0, _ntime, _x / 512 * 5, 1.0, -1, 0, false, false);
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
    note_all_sort();
    ds_grid_destroy(_grid);
}
#endregion
