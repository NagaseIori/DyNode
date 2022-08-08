/// @description Update Editor

#region Beatlines
    
    if(array_length(timingPoints)) {
        animBeatlineTargetAlphaM = editorMode != 5;
        beatlineAlphaMul = lerp_a(beatlineAlphaMul, animBeatlineTargetAlphaM, animSpeed);
    
        var _modchg = keycheck_down(ord("V")) - keycheck_down(ord("C"));
        beatlineNowMode += _modchg;
        beatlineNowMode = clamp(beatlineNowMode, 0, array_length(beatlineModes)-1);
        
        if(_modchg != 0) {
            announcement_play("节拍细分： 1/"+string(beatlineDivs[beatlineNowMode]));
        }
        
        animBeatlineTargetAlpha[0] += 0.7 * keycheck_down(vk_down);
        animBeatlineTargetAlpha[1] += 0.7 * keycheck_down(vk_left);
        animBeatlineTargetAlpha[2] += 0.7 * keycheck_down(vk_right);
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
        
        
        // Background Glow
            with(objMain) {
                animCurvFaintEval = animcurve_channel_evaluate(
                    animCurvFaintChan, frac((nowTime - _nowtp.time) / _nowtp.beatLength / _nowtp.meter));
                
                animCurvFaintEval = lerp(0.5, 1.0, animCurvFaintEval);
            }
        
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
                        // LR
                        if(_nyl > targetLineBeside && _nyl <= _nw / 2) {
                            draw_set_alpha(beatlineAlpha[1]);
                            draw_line_width(_nyl, _nh - targetLineBelow - _nowh, _nyl, _nh - targetLineBelow, _noww);
                            draw_set_alpha(beatlineAlpha[2]);
                            draw_line_width(_nyr, _nh - targetLineBelow - _nowh, _nyr, _nh - targetLineBelow, _noww);
                        }
                        // Down
                        if(_ny <= _nh - targetLineBelow && _ny >= 0) {
                            draw_set_alpha(beatlineAlpha[0]);
                            draw_line_width(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny, _noww);
                            if(i == 0 && k == 0) {
                                scribble("BPM "+string(mspb_to_bpm(_nowtp.beatLength))+" "+string(_nowtp.meter)+"/4")
                                    .starting_format("fDynamix20", c_white)
                                    .align(fa_center, fa_top)
                                    .blend(c_white, beatlineAlpha[0])
                                    .draw(_nw/2, _ny);
                            }
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
    }

#endregion

#region Note Edit

    // Wheel width adjust
    var _delta_width = wheelcheck_up_ctrl() - wheelcheck_down_ctrl();
    if(_delta_width != 0) {
        with(objNote) if(state == stateSelected) {
            if(objEditor.editorWidthAdjustTime > objEditor.editorWidthAdjustTimeThreshold)
                origProp = get_prop();
            width += _delta_width * 0.05;
        }
        editorWidthAdjustTime = 0;
    }
    
    if(editorWidthAdjustTime < editorWidthAdjustTimeThreshold) {
        editorWidthAdjustTime += delta_time / 1000;
        if(editorWidthAdjustTime >= editorWidthAdjustTimeThreshold) {
            with(objNote) if(state == stateSelected) {
                operation_step_add(OPERATION_TYPE.MOVE, origProp, get_prop());
            }
        }
    }
    editorWidthAdjustTime = min(editorWidthAdjustTime, 1000);

#endregion