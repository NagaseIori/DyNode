
function editor_set_width_default(_width) {
    objEditor.editorDefaultWidth = _width;
}

function editor_get_editmode() {
    return objEditor.editorMode;
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