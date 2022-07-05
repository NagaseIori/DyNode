
var _music_resync_request = false;
_position_update();

// Functions Control
    
    if(keycheck_down(vk_f3))
        music_load();
    if(keycheck_down(vk_f4))
        image_load();
    if(keycheck_down(vk_f5))
    	map_export_xml();
    if(keycheck_down(vk_f11))
    	showDebugInfo = !showDebugInfo;
    if(keycheck_down(ord("P")))
        hideScoreboard = !hideScoreboard;
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
    

// Music Speed Adjust
    
    var _muspdchange = keycheck_down(ord("W")) - keycheck_down(ord("S"));
    if(_muspdchange != 0) {
        musicSpeed += 0.1 * _muspdchange;
        musicSpeed = max(musicSpeed, 0.1);
        FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
    }

// Keyboard Time & Speed Adjust

    var _spdchange = keycheck_down(ord("E")) - keycheck_down(ord("Q"));
    _spdchange += editor_select_is_going() ? 0: wheelcheck_up_ctrl() - wheelcheck_down_ctrl();
    animTargetPlaybackSpeed += 0.1 * _spdchange;
    
    playbackSpeed = lerp_a(playbackSpeed, animTargetPlaybackSpeed, animSpeed);
    
    var _timchange = keycheck(ord("D")) - keycheck(ord("A"));
    var _timscr = wheelcheck_up() - wheelcheck_down();
    
    if(_timchange != 0 || _timscr != 0) {
        if(nowPlaying) {
            nowTime += (_timchange * adtimeSpeed + _timscr * scrolltimeSpeed)
                * global.fpsAdjust;
            _music_resync_request = true;
        }
        else {
            animTargetTime += (_timchange * adtimeSpeed + _timscr * scrolltimeSpeed)
                * global.fpsAdjust;
        }
    }

// Time Operation

    if(nowPlaying && !(_timchange != 0 || _timscr != 0)) {
    	nowTime += delta_time * musicSpeed / 1000;
    }
    
        
    if(music != undefined) {
        var _cor_tim = sfmod_channel_get_position(channel, sampleRate);
        
        // Play music at chart's beginning
        if(nowTime < 0) {
            FMODGMS_Chan_PauseChannel(channel);
            sfmod_channel_set_position(0, channel, sampleRate);
            channelPaused = true;
        }
        else if(nowPlaying && channelPaused) {
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowTime, channel, sampleRate);
            channelPaused = false;
        }
        
        // Top Bar Adjust Part
        
            if((mouse_y <= topBarMouseH && mouse_y > 0) || topBarMousePressed)
                animTargetTopBarIndicatorA = 0.3;
            else
                animTargetTopBarIndicatorA = 0;
            
            topBarIndicatorA = lerp(topBarIndicatorA, 
                animTargetTopBarIndicatorA, animSpeed * global.fpsAdjust);
                
        
            if(mouse_check_button_pressed(mb_left) && mouse_y <= topBarMouseH && mouse_y > 0) {
                topBarMousePressed = true;
                topBarMouseLastX = -5;
            }
                
            
            if(topBarMousePressed) {
            	mouse_clear_hold(); // Clear the Hold Buffer
                if(mouse_check_button_released(mb_left))
                    topBarMousePressed = false;
                else {
                    if(nowPlaying) {
                        if(abs(topBarMouseLastX - mouse_x) >= 2) {
                            musicProgress = mouse_x / global.resolutionW;
                            nowTime = musicProgress * musicLength;
                            _music_resync_request = true;
                        }
                        topBarMouseLastX = mouse_x;
                    }
                    else {
                        musicProgress = mouse_x / global.resolutionW;
                        animTargetTime =
                            mtime_to_time(musicProgress * musicLength);
                    }
                }
            }
        
        // Reduce Chart to Music's Latency
        // (Bad Performance)
        // if(nowPlaying && nowTime >= 0 && abs(_cor_tim - nowTime) > MAXIMUM_DELAY_OF_SOUND) {
        //     nowTime = _cor_tim;
        // }
        
        
        // If music ends then pause
        if(_cor_tim > musicLength && nowPlaying) {
            // FMODGMS_Chan_PauseChannel(channel);
            
            // Channel gets invalid, recreate another one.
            FMODGMS_Chan_RemoveChannel(channel);
            channel = FMODGMS_Chan_CreateChannel();
            FMODGMS_Snd_PlaySound(music, channel);
            FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
            FMODGMS_Chan_PauseChannel(channel);
            
            nowPlaying = false;
        }
        
        musicProgress = clamp(nowTime, 0, musicLength) / musicLength;
        
        animTargetTime = clamp(animTargetTime, mtime_to_time(0),
                            mtime_to_time(musicLength));
    }
    
    else {
        musicProgress = 0;
    }
    
// Time Jump

    if(keycheck_down(ord("L")))
        animTargetTime = chartNotesArray[chartNotesArrayAt].time;
    if(keycheck_down(ord("K")) && chartNotesArrayAt>0)
        animTargetTime = chartNotesArray[chartNotesArrayAt-1].time;

// Update and Sync Time & musicTime

    if(nowPlaying) {
        if(music != undefined)
            nowTime = clamp(nowTime, mtime_to_time(0), mtime_to_time(musicLength));
        animTargetTime = nowTime;
    }
    else {
        nowTime = lerp_lim_a(nowTime, animTargetTime, animSpeed, 10000);
        
        if(abs(nowTime - animTargetTime) < 1)
            nowTime = animTargetTime; // Speeeed up
    }
    
    if(_music_resync_request) {
        sfmod_channel_set_position(nowTime, channel, sampleRate);
        nowTime = sfmod_channel_get_position(channel, sampleRate);
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