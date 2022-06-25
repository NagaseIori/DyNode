
function editor_set_width_default(_width) {
    objEditor.editorDefaultWidth = _width;
}

function editor_get_editmode() {
    return objEditor.editorMode;
}

function editor_get_editside() {
    return objEditor.editorSide;
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
    
    var _import_hitobj = show_question("是否导入 .osu 中的物件？（仅用于测试）");
    
    timing_point_reset();
    var _grid = csv_to_grid(_file, true);
    var _type = "";
    var _w = ds_grid_width(_grid);
    var _h = ds_grid_height(_grid);
    
    for(var i=0; i<_h; i++) {
        if(string_last_pos("[", _grid[# 0, i]) != 0) {
        	_type = _grid[# 0, i];
        }
            
        else if(_grid[# 0, i] != ""){
            switch _type {
                case "[TimingPoints]":
                    var _time = real(_grid[# 0, i]);
                    var _mspb = real(_grid[# 1, i]);
                    var _meter = real(_grid[# 2, i]);
                    if(_mspb > 0)
                        timing_point_add(_time, _mspb, _meter);
                    break;
                case "[HitObjects]":
                	if(_import_hitobj) {
                		var _ntime = real(_grid[# 2, i]);
                		var _ntype = real(_grid[# 3, i]);
                		if(_time > 0) {
                			build_note(random_id(6), 0, _ntime, random_range(1, 4), 1.0, -1, 0, false, false);
                			// switch _ntype {
                			// 	case 0:	// Hit Circle
                			// 	case 1:
                			// 		build_note(random_id(6), 0, _ntime, random_range(1, 4), 1.0, -1, 0, false);
                			// 		break;
                			// 	// case 1: // Slider
                			// 	// 	build_hold(random_id(6), 0, _ntime, random_range(1, 4), 1.0, _ntime, 0);
                			// 	// 	break;
                			// 	default:
                			// 		break;
                			// }
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