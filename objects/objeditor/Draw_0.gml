
var _nw = global.resolutionW, _nh = global.resolutionH;
var nowTime = objMain.nowTime;
var targetLineBelow = objMain.targetLineBelow;
var playbackSpeed = objMain.playbackSpeed;

beatlineSurf = surface_checkate(beatlineSurf, _nw, _nh);
surface_set_target(beatlineSurf);
draw_clear_alpha(c_black, 0);

// Draw Beat Lines

var _nowat = 0, _pointscount = array_length(timingPoints);

while(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= nowTime)
    _nowat ++;

var _nowtp = timingPoints[_nowat];
var _nowbeats = floor((nowTime - _nowtp.time) / _nowtp.beatLength);
var _nowtime = _nowtp.time;
var _nexttime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time)

var _nowhard = false, _noww, _nowl;
var _ny;

while((_nowtime - nowTime) * playbackSpeed <= _nh) {
    for(var i = _nowbeats; i * _nowtp.beatLength + _nowtime < _nexttime; i++) {
        for(var j = 16; j >= 1; j--) if(beatlineEnabled[j]) {
            for(var k = (j == 1? 0:1/j); k < 1 && (i + k) * _nowtp.beatLength + _nowtime < _nexttime; k += (j == 1 || j == 3? 1:2)/j) {
                _ny = _nh - targetLineBelow -
                    (_nowtime + (i + k) * _nowtp.beatLength - nowTime) * playbackSpeed;
                _nowhard = (k == 0 && i % _nowtp.meter == 0);
                _noww = _nowhard ? beatlineHardWidth : beatlineWidth;
                _nowl = _nowhard ? beatlineHardLength : beatlineLength;
                _nowl += beatlineLengthOffset[j];
                if(_ny < 0)
                    break;
                if(_ny <= _nh - targetLineBelow) {
                    draw_set_color(beatlineColors[j]);
                    draw_set_alpha(beatlineAlpha[0]);
                    draw_line_width(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny, _noww);
                }
                    
            }
        }
    }
    _nowat ++;
    if(_nowat == _pointscount) break;
    _nowtime = _nexttime;
    _nexttime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time);
    _nowbeats = 0;
}

surface_reset_target();
draw_set_alpha(1.0);

draw_surface_ext(beatlineSurf, 0, 0, 1, 1, 0, c_white, 1.0);