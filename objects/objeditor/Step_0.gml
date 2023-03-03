/// @description Update Editor

#region Beatlines
    
    animBeatlineTargetAlphaM = editorMode != 5 && array_length(timingPoints);
    beatlineAlphaMul = lerp_a(beatlineAlphaMul, animBeatlineTargetAlphaM, animSpeed);
    if(array_length(timingPoints)) {
        var _modchg = keycheck_down(ord("V")) - keycheck_down(ord("C"));
        var _groupchg = keycheck_down(ord("G"));
        beatlineNowGroup += _groupchg;
        beatlineNowGroup %= 2;
        beatlineNowMode += _modchg;
        beatlineNowMode = clamp(beatlineNowMode, 0, array_length(beatlineModes[beatlineNowGroup])-1);
        
        if(_modchg != 0 || _groupchg != 0) {
            announcement_play(i18n_get("beatline_divs", string(beatlineDivs[beatlineNowGroup][beatlineNowMode]),
            	chr(beatlineNowGroup+ord("A"))), 3000, "beatlineDiv");
            
        }
        
        animBeatlineTargetAlpha[0] += 0.7 * keycheck_down(vk_down);
        animBeatlineTargetAlpha[1] += 0.7 * keycheck_down(vk_left);
        animBeatlineTargetAlpha[2] += 0.7 * keycheck_down(vk_right);
        for(var i=0; i<3; i++) {
            if(animBeatlineTargetAlpha[i] > 1.4)
                animBeatlineTargetAlpha[i] = 0;
            beatlineAlpha[i] = lerp_a(beatlineAlpha[i], min(animBeatlineTargetAlpha[i], 1), animSpeed);
        }
            
        
        for(var i=0; i<=28; i++)
            beatlineEnabled[i] = 0;
        var l = array_length(beatlineModes[beatlineNowGroup][beatlineNowMode]);
        for(var i=0; i<l; i++)
            beatlineEnabled[beatlineModes[beatlineNowGroup][beatlineNowMode][i]] = 1;
        
        
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
        var _totalBeats = 0;
        
        while(_nowat + 1 != _pointscount && timingPoints[_nowat+1].time <= nowTime) {
        	_totalBeats += ceil((timingPoints[_nowat+1].time - timingPoints[_nowat].time)
        		/(timingPoints[_nowat].beatLength*timingPoints[_nowat].meter))
        	_nowat ++;
        }
            
        
        var _nowTp = timingPoints[_nowat];
        var _nowBeats = floor((nowTime - _nowTp.time) / _nowTp.beatLength);
        var _nowTpTime = _nowTp.time;
        var _nextTpTime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time)
        
        var _nowhard = false, _noww, _nowl, _nowh;
        var _ny, _nyl, _nyr;
        
        
            // Background Glow
            with(objMain) {
                animCurvFaintEval = animcurve_channel_evaluate(
                    animCurvFaintChan, frac((nowTime - _nowTp.time) / _nowTp.beatLength / _nowTp.meter));
                
                animCurvFaintEval = lerp(0.5, 1.0, animCurvFaintEval);
            }
        
        while(((_nowTpTime - nowTime) * playbackSpeed <= _nh || _nowat == 0) && beatlineAlphaMul > 0.01) {
            for(var i = _nowBeats; i * _nowTp.beatLength + _nowTpTime < _nextTpTime && (i * _nowTp.beatLength + _nowTpTime - nowTime) * playbackSpeed <= _nh; i++) {
                for(var j = 28; j >= 1; j--) if(beatlineEnabled[j]) {
                    for(var k = (j == 1? 0:1/j); k < 1 && (i + k) * _nowTp.beatLength + _nowTpTime < _nextTpTime; k += ((j&1)? 1:2)/j) {
                        _ny =  note_time_to_y(_nowTpTime + (i + k) * _nowTp.beatLength, 0);
                        _nyl = note_time_to_y(_nowTpTime + (i + k) * _nowTp.beatLength, 1);
                        _nyr = note_time_to_y(_nowTpTime + (i + k) * _nowTp.beatLength, 2);
                        _nowhard = (k == 0 && i % _nowTp.meter == 0);
                        _noww = _nowhard ? beatlineHardWidth : beatlineWidth;
                        _nowl = _nowhard ? beatlineHardLength : beatlineLength;
                        _nowh = _nowhard ? beatlineHardHeight : beatlineHeight;
                        _noww = _noww * 3;
                        _nowl += beatlineLengthOffset[j];
                        if(_ny < 0 && _nyl > _nw / 2)
                            break;
                        
                        draw_set_color(beatlineColors[j]);
                        // LR
                        if(_nyl > targetLineBeside && _nyl <= _nw / 2) {
                            if(beatlineAlpha[1]>0.01) {
                                CleanLine(_nyl, _nh - targetLineBelow - _nowh, _nyl, _nh - targetLineBelow)
                                    .Blend(beatlineColors[j], beatlineAlpha[1])
                                    .Thickness(_noww)
                                    .Cap("round", "round")
                                    .Draw();
                                    
                                // draw_set_alpha(beatlineAlpha[1]);
                                // draw_line_width(_nyl, _nh - targetLineBelow - _nowh, _nyl, _nh - targetLineBelow, _noww);
                                
                            }
                                
                            if(beatlineAlpha[2]>0.01) {
                                CleanLine(_nyr, _nh - targetLineBelow - _nowh, _nyr, _nh - targetLineBelow)
                                    .Blend(beatlineColors[j], beatlineAlpha[2])
                                    .Thickness(_noww)
                                    .Cap("round", "round")
                                    .Draw();
                                
                                // draw_set_alpha(beatlineAlpha[2]);
                                // draw_line_width(_nyr, _nh - targetLineBelow - _nowh, _nyr, _nh - targetLineBelow, _noww);
                            }
                                
                        }
                        // Down
                        if(_ny <= _nh - targetLineBelow && _ny >= 0 && beatlineAlpha[0]>0.01) {
                            CleanLine(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny)
                                    .Blend(beatlineColors[j], beatlineAlpha[0])
                                    .Thickness(_noww)
                                    .Cap("round", "round")
                                    .Draw();
                            
                            // draw_set_alpha(beatlineAlpha[0]);
                            // draw_line_width(_nw / 2 - _nowl / 2, _ny, _nw / 2 + _nowl / 2, _ny, _noww);
                            
                            if(i == 0 && k == 0) {
                                scribble("BPM "+string_format(mspb_to_bpm(_nowTp.beatLength), 1, 2)+" "+string(_nowTp.meter)+"/4")
                                    .starting_format("mDynamix", c_white)
                                    .msdf_border(c_dkgrey, 2)
                                    .align(fa_center, fa_top)
                                    .scale(0.9, 0.9)
                                    .blend(c_white, beatlineAlpha[0])
                                    .draw(_nw/2, _ny+3);
                            }
                            
                            if(_nowhard) {
                            	scribble(string_format(_totalBeats + round(i/_nowTp.meter) + 1, 1, 0))
                            		.align(fa_left, fa_center)
                            		.starting_format("mDynamix", c_white)
                            		.msdf_border(c_dkgrey, 2)
                            		.scale(0.9, 0.9)
                            		.blend(c_white, beatlineAlpha[0])
                            		.draw(_nw/2 + _nowl/2 + 20, _ny);
                            }
                        }
                    }
                }
            }
            _totalBeats += ceil((_nextTpTime - _nowTpTime) / (_nowTp.beatLength * _nowTp.meter));
            _nowat ++;
            if(_nowat == _pointscount) break;
            _nowTpTime = _nextTpTime;
            _nowTp = timingPoints[_nowat];
            _nextTpTime = (_nowat + 1 == _pointscount ? objMain.musicLength:timingPoints[_nowat+1].time);
            _nowBeats = 0;
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
    editorWidthAdjustTime = min(editorWidthAdjustTime, 10000);

#endregion