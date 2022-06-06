
function editor_set_width_default(_width) {
    objEditor.editorDefaultWidth = _width;
}

function editor_get_editmode() {
    return objEditor.editorMode;
}

function editor_snap_to_grid_y(_y, _side) {
    if(!objEditor.editorGridYEnabled) return _y;
    
    var _nw = global.resolutionW, _nh = global.resolutionH;
    var _ret = _y;
    if(_side == 0) {
        var _time = y_to_note_time(_y, _side);
        var _nowat = 0;
        with(objEditor) {
            var targetLineBelow = objMain.targetLineBelow;
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
            var _ry = note_time_to_y(_rt, _side);
            var _rby = note_time_to_y(_rbt, _side);
            
            if(_ry >= 0 && _ry <= _nh - targetLineBelow && _rt <= _nexttime)
                _ret = _ry;
            else if(_rby >= 0 && _rby <= _nh - targetLineBelow && _rbt <= _nexttime)
                _ret = _rby;
        }
    }
    
    return _ret;
}

function timing_point_sort() {
    var _f = function(_a, _b) {
        return _a.time < _b.time;
    }
    array_sort_f(objEditor.timingPoints, _f);
}

function timing_point_add(_t, _l, _b) {
    with(objEditor) {
        // show_debug_message("ADD A TIMING POINT. FROM " + string(array_length(timingPoints)))
        array_push(timingPoints, new sTimingPoint(_t, _l, _b));
        timing_point_sort();
        // show_debug_message("TO " + string(array_length(timingPoints)))
    }
}

function timing_point_reset() {
    with(objEditor) {
        var _l = array_length(timingPoints);
        for(var i=0; i<_l; i++) {
            delete timingPoints[i];
        }
        timingPoints = [];
    }
}

function note_build_attach(_width) {
    var _inst = instance_create_depth(mouse_x, mouse_y, 
                depth, objNote);
    with(_inst) {
        state = stateAttach;
        width = _width;
        _prop_init();
    }
    
    return _inst;
}