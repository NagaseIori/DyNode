
// _position_update();

#region Functions Control

	if(mouse_ishold_r() && !instance_exists(objUISideSwitcher))
		instance_create(mouse_get_last_pos(1)[0], mouse_get_last_pos(1)[1], objUISideSwitcher);
    
    if(keycheck_down(vk_f3))
        music_load();
    if(keycheck_down(vk_f4))
        background_load();
    if(keycheck_down_ctrl(vk_f4))
    	background_reset();
    if(keycheck_down(vk_f5))
    	map_export_xml();
    if(keycheck_down(vk_f6))
    	map_set_global_bar();
    if(keycheck_down(vk_f11))
    	switch_debug_info();
    if(keycheck_down_ctrl(ord("B"))) {
    	if(!chartBarUsed) {
    		announcement_warning("anno_show_bar_warn");
    	}
    	else {
    		showBar = !showBar;
    		announcement_adjust("anno_show_bar", showBar);
    	}
    }
    if(keycheck_down(ord("P"))) {
    	hideScoreboard = !hideScoreboard;
    	announcement_adjust("anno_hide_scoreboard", hideScoreboard);
    }
    if(keycheck_down(ord("O"))) {
    	particlesEnabled = !particlesEnabled;
    	announcement_adjust("anno_particles_effect", particlesEnabled);
    }
    if(keycheck_down_ctrl(ord("H"))) {
    	hitSoundOn = !hitSoundOn;
    	announcement_adjust("anno_hitsound", hitSoundOn);
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
	    	announcement_play("anno_switch_sidetype"+chartSideType[_side]);
    	}
    	else {
    		announcement_warning("anno_switch_sidetype_warn");
    	}
    }
    if(keycheck_down(ord("F"))) {
    	fadeOtherNotes = !fadeOtherNotes;
    	announcement_adjust("anno_fade_other_notes", fadeOtherNotes);
    }
    
    if(keycheck_down(vk_enter)) {		// Replay Mode
    	editor_set_editmode(5);
    	nowTime = 0;
    	animTargetTime = 0;
    	reset_scoreboard();
    }
    
    if(keycheck_down(ord("U")))
    	map_add_offset("", true);
    
    if(keycheck_down(ord("N"))) {
    	global.simplify = !global.simplify;
    	announcement_adjust("anno_simplify", global.simplify);
    }
    
    if(mouse_check_button_pressed(mb_middle)) {
    	showStats ++;
    	showStats %= 3;
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
            
            if(bgVideoLoaded) {
            	safe_video_pause();
            }
        }
    }

#endregion

#region Bg Animation

	animTargetBgFaintAlpha = editor_get_editmode() == 5? 0.5: 0;
    bgFaintAlpha = lerp_a(bgFaintAlpha, animTargetBgFaintAlpha, animSpeedFaint);
    
    if(editor_get_editmode()==5 && safe_video_check_loaded())
    	bgVideoAlpha = lerp_a(bgVideoAlpha, 1, animSpeed);
    else
    	bgVideoAlpha = lerp_a(bgVideoAlpha, 0, animSpeed);
    
#endregion

#region Targetline Animation

	array_fill(animTargetLineMix, 1, 0, 3);
	if(editor_get_editmode() == 5) {
		array_fill(animTargetLazerAlpha, 1, 0, 3);
	}
	else {
		array_fill(animTargetLazerAlpha, 0, 0, 3);
		animTargetLazerAlpha[editor_get_editside()] = 1.0;
		animTargetLineMix[editor_get_editside()] = 0.5;
	}
	
	for(var i=0; i<3; i++) {
		lazerAlpha[i] = lerp_a(lazerAlpha[i], animTargetLazerAlpha[i], animSpeed);
		lineMix[i] = lerp_a(lineMix[i], animTargetLineMix[i], animSpeed);
	}

#endregion

#region Other Animation
	
	animTargetTitleAlpha = editor_get_editmode() == 5? titleAlphaL: 1.0;
	titleAlpha = lerp_a(titleAlpha, animTargetTitleAlpha, animSpeed);
	
#endregion