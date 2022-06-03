


var _nw = global.resolutionW, _nh = global.resolutionH;
var nowTime = objMain.nowTime;
var targetLineBelow = objMain.targetLineBelow;
var playbackSpeed = objMain.playbackSpeed;

beatlineSurf = surface_checkate(beatlineSurf, _nw, _nh);
surface_set_target(beatlineSurf);
draw_clear_alpha(c_black, 0);

// Draw Beat Lines

var _nowat = 0, _pointscount = array_length(timingPoints);
var _ny = _nh - targetLineBelow;

while(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= nowTime)
    _nowat ++;

var _nowtp = timingPoints[_nowat];
var _nowbeats = (nowTime - _nowtp.time) / _nowtp.beatLength;
var _nowtime = ceil(_nowbeats) * _nowtp.beatLength + _nowtp.time;
if(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= _nowtime) {
    _nowat ++;
    _nowtp = timingPoints[_nowat];
    _nowtime = _nowtp.time;
}
_ny = _nh - targetLineBelow - playbackSpeed * (_nowtime - nowTime);

var _nowhard = false, _noww, _nowl;
while(_ny >= 0) {
    _nowbeats = round((_nowtime - _nowtp.time) / _nowtp.beatLength);
    _nowhard = (_nowbeats % _nowtp.meter == 0);
    _noww = _nowhard?beatlineHardWidth:beatlineWidth;
    _nowl = _nowhard?beatlineHardLength:beatlineLength;
    
    draw_line_width_color(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny, 
        _noww, c_white, c_white);
    // scribble(string(_nowtime)).starting_format("fDynamix20", themeColor)
    // .align(fa_center, fa_top)
    // .draw(_nw / 2, _ny);
    
    _nowtime += _nowtp.beatLength;
    if(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= _nowtime) {
        _nowat ++;
        _nowtp = timingPoints[_nowat];
        _nowtime = _nowtp.time;
    }
    _ny = _nh - targetLineBelow - playbackSpeed * (_nowtime - nowTime);
}

surface_reset_target();

draw_surface_ext(beatlineSurf, 0, 0, 1, 1, 0, c_white, 0.7);