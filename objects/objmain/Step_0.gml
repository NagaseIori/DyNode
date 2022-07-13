
_position_update();

// Functions Control
    
    if(keycheck_down(vk_f3))
        music_load();
    if(keycheck_down(vk_f4))
        image_load();
    if(keycheck_down(vk_f5))
    	map_export_xml();
    if(keycheck_down(vk_f11))
    	switch_debug_info();
    if(keycheck_down(ord("P")))
        hideScoreboard = !hideScoreboard;
    if(keycheck_down(ord("O")))
    	particlesEnabled = !particlesEnabled;
    if(keycheck_down_ctrl(ord("M")))
    	hitSoundOn = !hitSoundOn;
    if(keycheck_down_ctrl(ord("T")))
    	map_set_title();
    
    if(keycheck_down(vk_enter)) {		// Replay Mode
    	editor_set_editmode(5);
    	nowTime = 0;
    	animTargetTime = 0;
    	reset_scoreboard();
    }

// Chart Properties Update

	// Adjust Difficulty
	var _diff_delta = keycheck_down_ctrl(ord("P")) - keycheck_down_ctrl(ord("O"));
	chartDifficulty += _diff_delta;
	chartDifficulty = clamp(chartDifficulty, 0, global.difficultyCount - 1);

    chartNotesCount = array_length(chartNotesArray)

    while(chartNotesArrayAt < chartNotesCount &&
        chartNotesArray[chartNotesArrayAt].time <= nowTime)
        chartNotesArrayAt ++;
    
    while(chartNotesArrayAt > 0 &&
        chartNotesArray[chartNotesArrayAt-1].time > nowTime)
        chartNotesArrayAt --;
    
// Scoreboard Update

    if(nowCombo != chartNotesArrayAt) {
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

// Muisc Pause & Resume

    if(keycheck_down(vk_space) || keycheck_down(vk_enter)) {
    	if(!nowPlaying) {
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

// Bg Animation

	animTargetBgFaintAlpha = editor_get_editmode() == 5? 0.5: 0;
    bgFaintAlpha = lerp_a(bgFaintAlpha, animTargetBgFaintAlpha, animSpeedFaint);
   
// Targetline Animation

	if(editor_get_editmode() == 5) {
		animTargetLazerAlpha = [1.0, 1.0, 1.0];
	}
	else {
		animTargetLazerAlpha = [0.0, 0.0, 0.0];
		animTargetLazerAlpha[editor_get_editside()] = 1.0;
	}
	
	for(var i=0; i<3; i++)
		lazerAlpha[i] = lerp_a(lazerAlpha[i], animTargetLazerAlpha[i], animSpeed);