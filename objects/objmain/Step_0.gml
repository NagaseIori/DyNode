
_position_update();

#region Functions Control

	if(mouse_ishold_r() && !instance_exists(objUISideSwitcher))
		instance_create(mouse_get_last_pos(1)[0], mouse_get_last_pos(1)[1], objUISideSwitcher);
    
    if(keycheck_down(vk_f3))
        music_load();
    if(keycheck_down(vk_f4))
        image_load();
    if(keycheck_down(vk_f5))
    	map_export_xml();
    if(keycheck_down(vk_f6))
    	map_set_global_bar();
    if(keycheck_down(vk_f11))
    	switch_debug_info();
    if(keycheck_down_ctrl(ord("B"))) {
    	if(!chartBarUsed) {
    		announcement_warning("你还未设置全局 Bar Per Minute 与 Offset 。无法切换 Bar/Time 显示。\n使用 F6 即可进行设置。");
    	}
    	else {
    		showBar = !showBar;
    		announcement_adjust("以 Bar 代替 Time 显示", showBar);
    	}
    }
    if(keycheck_down(ord("P"))) {
    	hideScoreboard = !hideScoreboard;
    	announcement_adjust("编辑模式下隐藏分数显示", hideScoreboard);
    }
    if(keycheck_down(ord("O"))) {
    	particlesEnabled = !particlesEnabled;
    	announcement_adjust("粒子效果", particlesEnabled);
    }
    if(keycheck_down_ctrl(ord("M"))) {
    	hitSoundOn = !hitSoundOn;
    	announcement_adjust("打击音", hitSoundOn);
    }
    	
    if(keycheck_down_ctrl(ord("T")))
    	map_set_title();
    if(keycheck_down_ctrl(ord("F"))) {
    	if(editor_get_editside() > 0) {
    		var _side = editor_get_editside() - 1;
    		var _type = chartSideType[_side];
    		
    		switch (_type) {
    			case "MIXER":
    				_type = "MULTI";
    				break;
    			case "MULTI":
    				_type = "PAD";
    				break;
    			default:
    			case "PAD":
    				_type = "MIXER";
    				break;
    		}
    		
	    	chartSideType[_side] = _type;
	    	announcement_play("切换侧面类型至："+chartSideType[_side]);
    	}
    	else {
    		announcement_warning("你只有正在编辑侧面才可以切换侧面类型。");
    	}
    }
    if(keycheck_down(ord("F"))) {
    	fadeOtherNotes = !fadeOtherNotes;
    	announcement_adjust("透明化非编辑侧音符", fadeOtherNotes);
    }
    
    if(keycheck_down(vk_enter)) {		// Replay Mode
    	editor_set_editmode(5);
    	nowTime = 0;
    	animTargetTime = 0;
    	reset_scoreboard();
    }
    
    if(mouse_check_button_pressed(mb_middle)) {
    	showStats = !showStats;
    }

#endregion

#region Chart Properties Update

	// Adjust Difficulty
	var _diff_delta = keycheck_down_ctrl(ord("P")) - keycheck_down_ctrl(ord("O"));
	chartDifficulty += _diff_delta;
	chartDifficulty = clamp(chartDifficulty, 0, global.difficultyCount - 1);

    chartNotesCount = array_length(chartNotesArray)

	chartNotesArrayAt = clamp(chartNotesArrayAt, 0, chartNotesCount);
	
    while(chartNotesArrayAt < chartNotesCount &&
        chartNotesArray[chartNotesArrayAt].time <= nowTime) {
            chartNotesArrayAt ++;
            if(chartNotesArrayAt < chartNotesCount)
                note_check_and_activate(chartNotesArray[chartNotesArrayAt]);
        }

    while(chartNotesArrayAt > 0 &&
        chartNotesArray[chartNotesArrayAt-1].time > nowTime){
            chartNotesArrayAt --;
            note_check_and_activate(chartNotesArray[chartNotesArrayAt]);
        }

#endregion
  
#region Scoreboard Update

    if(nowCombo != chartNotesArrayAt && chartNotesCount > 0) {
        var _hit = nowCombo < chartNotesArrayAt;
        if(_hit) {
            with(objPerfectIndc)
                _hitit();
        }
        var _val;
        nowCombo = chartNotesArrayAt;
        _val = 1000000*nowCombo/chartNotesCount;
        with(scbLeft) {
            _update_score(_val, _hit);
        }
        _val = nowCombo;
        with(scbRight) {
            _update_score(_val, _hit, true);
        }
    }
    if(chartNotesCount == 0) {
    	with(scbLeft) _update_score(0, 0);
    	with(scbRight) _update_score(0, 0, true);
    }

#endregion

#region Muisc Pause & Resume

    if(keycheck_down(vk_space) || keycheck_down(vk_enter)) {
    	FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
    	if(!nowPlaying || keycheck_down(vk_enter)) {
        	if(nowTime >= musicLength) nowTime = 0;
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowTime-resumeDelay, channel, sampleRate);
            time_source_start(timesourceResumeDelay);
            // nowTime = sfmod_channel_get_position(channel, sampleRate);
        }
        else {
            FMODGMS_Chan_PauseChannel(channel);
            nowPlaying = false;
        }
    }

#endregion

#region Bg Animation

	animTargetBgFaintAlpha = editor_get_editmode() == 5? 0.5: 0;
    bgFaintAlpha = lerp_a(bgFaintAlpha, animTargetBgFaintAlpha, animSpeedFaint);
    
#endregion

#region Targetline Animation

	animTargetLineMix = [1.0, 1.0, 1.0];
	if(editor_get_editmode() == 5) {
		animTargetLazerAlpha = [1.0, 1.0, 1.0];
	}
	else {
		animTargetLazerAlpha = [0.0, 0.0, 0.0];
		animTargetLazerAlpha[editor_get_editside()] = 1.0;
		animTargetLineMix[editor_get_editside()] = 0.5;
	}
	
	for(var i=0; i<3; i++) {
		lazerAlpha[i] = lerp_a(lazerAlpha[i], animTargetLazerAlpha[i], animSpeed);
		lineMix[i] = lerp_a(lineMix[i], animTargetLineMix[i], animSpeed);
	}
		

#endregion
