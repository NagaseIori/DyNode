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
    
    with(_inst) _prop_init();
    with(objMain) {
        array_push(chartNotesArray, _inst);
        if(ds_map_exists(chartNotesMap[_inst.side], _id)) {
            show_error_async("Duplicate Note ID " + _id + " in side " 
                + string(_side), false);
            return true;
        }
        chartNotesMap[_inst.side][? _id] = _inst;
        
        if(!_fromxml && _sort)
            note_all_sort();
    }
}

function build_hold(_id, _time, _position, _width, _subid, _subtime, _side) {
	build_note(_subid, 3, _subtime, _position, _width, -1, _side, false);
	build_note(_id, 2, _time, _position, _width, _subid, _side, false);
}

function note_delete(_id) {
    with(objMain) {
        var l=array_length(chartNotesArray);
        var found = false;
        for(var i=0; i<l; i++)
            if(chartNotesArray[i].nid == _id) {
                var _insta = chartNotesArray[i];
                array_delete(chartNotesArray, i, 1);
                found = true;
                break;
            }
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
		
		instance_destroy(objNote);
	}
}