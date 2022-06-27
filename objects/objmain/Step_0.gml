
var _music_resync_request = false;
_position_update();

// Functions Control
    
    if(keyboard_check_pressed(vk_f3))
        music_load();
    if(keyboard_check_pressed(vk_f4))
        image_load();
    if(keyboard_check_pressed(vk_f5))
    	map_export_xml();
    if(keyboard_check_pressed(ord("P")))
        hideScoreboard = !hideScoreboard;
    if(keyboard_check_pressed(ord("M")))
    	hitSoundOn = !hitSoundOn;

// Chart Properties Update

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
    
    var _muspdchange = keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S"));
    if(_muspdchange != 0) {
        musicSpeed += 0.1 * _muspdchange;
        musicSpeed = max(musicSpeed, 0.1);
        FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
    }

// Keyboard Time & Speed Adjust

    var _spdchange = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
    animTargetPlaybackSpeed += 0.1 * _spdchange;
    
    playbackSpeed = lerp_a(playbackSpeed, animTargetPlaybackSpeed, animSpeed);
    
    var _timchange = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _timscr = mouse_wheel_up() - mouse_wheel_down();
    
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
            	objInput.mouseHoldTimeL = 0; // Clear the Hold Buffer
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

    if(keyboard_check_pressed(ord("L")))
        animTargetTime = chartNotesArray[chartNotesArrayAt].time;
    if(keyboard_check_pressed(ord("K")) && chartNotesArrayAt>0)
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

// Keyboard Pause & Resume

    if(keyboard_check_pressed(vk_space)) {
        nowPlaying = !nowPlaying;
        if(nowPlaying) {
        	if(nowTime >= musicLength) nowTime = 0;
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowTime, channel, sampleRate);
            nowTime = sfmod_channel_get_position(channel, sampleRate);
        }
        else {
            FMODGMS_Chan_PauseChannel(channel);
        }
    }

// Bg Animation

    bgFaintAlpha = lerp_a(bgFaintAlpha, animTargetBgFaintAlpha, animSpeedFaint);