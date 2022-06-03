
if(keyboard_check_pressed(ord("T"))) {
    var _tp = timingPoints[array_length(timingPoints) - 1];
    timing_point_add(objMain.nowTime, _tp.beatLength, _tp.meter);
}