/// @description Update Editor

#region Input Checks

    var _attach_reset_request = false;
    
    if(keyboard_check_pressed(vk_f10))
        timing_point_load_from_osz();
    if(keyboard_check_pressed(ord("Z")))
        editorGridYEnabled = !editorGridYEnabled;
    if(keyboard_check_pressed(ord("X")))
        editorGridXEnabled = !editorGridXEnabled;
    editorGridWidthEnabled = !ctrl_ishold();
    
    // Editor Side Switch
    editorSide += keyboard_check_pressed(vk_up);
    if(keyboard_check_pressed(vk_up))
        _attach_reset_request = true;
    if(editorSide == 3) editorSide = 0;
    
    // Editor Mode Switch
    for(var i=1; i<=5; i++)
        if(keyboard_check_pressed(ord(string(i)))) {
            if(editorMode != i)
                _attach_reset_request = true;
            editorMode = i;
        }

    if(_attach_reset_request) {
        if(instance_exists(editorNoteAttaching))
            instance_destroy(editorNoteAttaching);
    }

    switch editorMode {
        case 1:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(0, editorSide, editorDefaultWidth);
            break;
        case 2:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(1, editorSide, editorDefaultWidth);
            break;
        case 3:
            if(!instance_exists(editorNoteAttaching))
                editorNoteAttaching = note_build_attach(2, editorSide, editorDefaultWidth);
            break;
            
        case 4:
        default:
            break;
    }

#endregion

#region Beatlines

    if(keyboard_check_pressed(ord("T"))) {
        var _tp = timingPoints[array_length(timingPoints) - 1];
        timing_point_add(objMain.animTargetTime, _tp.beatLength, _tp.meter);
    }
    
    var _modchg = keyboard_check_pressed(ord("V")) - keyboard_check_pressed(ord("C"));
    beatlineNowMode += _modchg;
    beatlineNowMode = clamp(beatlineNowMode, 0, array_length(beatlineModes)-1);
    
    animBeatlineTargetAlpha[0] += 0.7 * keyboard_check_pressed(vk_down);
    animBeatlineTargetAlpha[1] += 0.7 * keyboard_check_pressed(vk_left);
    animBeatlineTargetAlpha[2] += 0.7 * keyboard_check_pressed(vk_right);
    for(var i=0; i<3; i++) {
        if(animBeatlineTargetAlpha[i] > 1.4)
            animBeatlineTargetAlpha[i] = 0;
        beatlineAlpha[i] = lerp_a(beatlineAlpha[i], min(animBeatlineTargetAlpha[i], 1), animSpeed);
    }
        
    
    for(var i=0; i<=16; i++)
        beatlineEnabled[i] = 0;
    var l = array_length(beatlineModes[beatlineNowMode]);
    for(var i=0; i<l; i++)
        beatlineEnabled[beatlineModes[beatlineNowMode][i]] = 1;
    
    
    var _nw = global.resolutionW, _nh = global.resolutionH;
    var nowTime = objMain.nowTime;
    var targetLineBelow = objMain.targetLineBelow + objMain.targetLineBelowH / 2;
    var targetLineBeside = objMain.targetLineBeside;
    var playbackSpeed = objMain.playbackSpeed;
    
    beatlineSurf = surface_checkate(beatlineSurf, _nw, _nh);
    surface_set_target(beatlineSurf);
    draw_clear_alpha(c_black, 0);
    
    // Beat Lines Analyze & Draw
    
    var _nowat = 0, _pointscount = array_length(timingPoints);
    
    while(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= nowTime)
        _nowat ++;
    
    var _nowtp = timingPoints[_nowat];
    var _nowbeats = floor((nowTime - _nowtp.time) / _nowtp.beatLength);
    var _nowtime = _nowtp.time;
    var _nexttime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time)
    
    var _nowhard = false, _noww, _nowl, _nowh;
    var _ny, _nyl, _nyr;
    
    // if(abs(_nowbeats * _nowtp.beatLength + _nowtime - nowTime) <= 10 && objMain.nowPlaying)
    //     with(objMain) _faint_hit();
    
    while((_nowtime - nowTime) * playbackSpeed <= _nh) {
        for(var i = _nowbeats; i * _nowtp.beatLength + _nowtime < _nexttime && (i * _nowtp.beatLength + _nowtime - nowTime) * playbackSpeed <= _nh; i++) {
            for(var j = 16; j >= 1; j--) if(beatlineEnabled[j]) {
                for(var k = (j == 1? 0:1/j); k < 1 && (i + k) * _nowtp.beatLength + _nowtime < _nexttime; k += (j == 1 || j == 3? 1:2)/j) {
                    _ny = note_time_to_y(_nowtime + (i + k) * _nowtp.beatLength, 0);
                    _nyl = note_time_to_y(_nowtime + (i + k) * _nowtp.beatLength, 1);
                    _nyr = note_time_to_y(_nowtime + (i + k) * _nowtp.beatLength, 2);
                    _nowhard = (k == 0 && i % _nowtp.meter == 0);
                    _noww = _nowhard ? beatlineHardWidth : beatlineWidth;
                    _nowl = _nowhard ? beatlineHardLength : beatlineLength;
                    _nowh = _nowhard ? beatlineHardHeight : beatlineHeight;
                    _nowl += beatlineLengthOffset[j];
                    if(_ny < 0 && _nyl > _nw / 2)
                        break;
                    
                    draw_set_color(beatlineColors[j]);
                    if(_ny <= _nh - targetLineBelow && _ny >= 0) {
                        draw_set_alpha(beatlineAlpha[0]);
                        draw_line_width(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny, _noww);
                        if(i == 0 && k == 0) {
                            draw_set_halign(fa_center);
                            draw_set_valign(fa_top);
                            draw_set_color(c_white);
                            draw_text(_nw/2, _ny, string(mspb_to_bpm(_nowtp.beatLength)));
                        }
                    }
                    if(_nyl > targetLineBeside && _nyl <= _nw / 2) {
                        draw_set_alpha(beatlineAlpha[1]);
                        draw_line_width(_nyl, _nh - targetLineBelow - _nowh, _nyl, _nh - targetLineBelow, _noww);
                        draw_set_alpha(beatlineAlpha[2]);
                        draw_line_width(_nyr, _nh - targetLineBelow - _nowh, _nyr, _nh - targetLineBelow, _noww);
                    }
                }
            }
        }
        _nowat ++;
        if(_nowat == _pointscount) break;
        _nowtime = _nexttime;
        _nowtp = timingPoints[_nowat];
        _nexttime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time);
        _nowbeats = 0;
    }
    
    surface_reset_target();
    draw_set_alpha(1.0);

#endregion