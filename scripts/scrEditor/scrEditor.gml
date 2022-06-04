

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