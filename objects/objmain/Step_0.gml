
_position_update();

// Functions Control
    
    if(keyboard_check_pressed(vk_f3))
        music_load();
    if(keyboard_check_pressed(vk_f4))
        image_load();
    if(keyboard_check_pressed(ord("P")))
        hideScoreboard = !hideScoreboard;

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
        // FMODGMS_Chan_Set_Frequency(channel, sampleRate * musicSpeed);
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
        if(nowMusicTime < 0) {
            FMODGMS_Chan_PauseChannel(channel);
            sfmod_channel_set_position(0, channel, sampleRate);
            channelPaused = true;
        }
        else if(nowPlaying && channelPaused) {
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowMusicTime, channel, sampleRate);
            channelPaused = false;
        }
        
        // Top Bar Adjust Part
        
            if((mouse_y <= topBarMouseH && mouse_y > 0) || topBarMousePressed)
                animTargetTopBarIndicatorA = 0.3;
            else
                animTargetTopBarIndicatorA = 0;
            
            topBarIndicatorA = lerp(topBarIndicatorA, 
                animTargetTopBarIndicatorA, animSpeed * global.fpsAdjust);
                
        
            if(mouse_check_button_pressed(mb_left) && mouse_y <= topBarMouseH) {
                topBarMousePressed = true;
                topBarMouseLastX = -5;
            }
                
            
            if(topBarMousePressed) {
                if(mouse_check_button_released(mb_left))
                    topBarMousePressed = false;
                else {
                    if(nowPlaying) {
                        if(abs(topBarMouseLastX - mouse_x) >= 2) {
                            musicProgress = mouse_x / global.resolutionW;
                            nowMusicTime = musicProgress * musicLength;
                            nowTime = mtime_to_time(musicProgress * musicLength);
                            sfmod_channel_set_position(nowMusicTime, channel, sampleRate);
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
        
        // Actually no need for every frame time adjust
        // if(nowMusicTime >= 0 && abs(_cor_tim - nowMusicTime) > MAXIMUM_DELAY_OF_SOUND) {
        //     nowMusicTime = _cor_tim;
        // }
        
        
        // If music ends then pause
        if(_cor_tim >= musicLength && nowPlaying) {
            FMODGMS_Chan_PauseChannel(channel);
            nowPlaying = false;
        }
        
        // If there are modifications then sync music with time
        if(nowPlaying && (_timchange!=0 || _timscr!=0)) {
            sfmod_channel_set_position(nowMusicTime, channel, sampleRate);
        }
        
        // nowMusicTime = min(nowMusicTime, musicLength);
        
        musicProgress = clamp(nowMusicTime, 0, musicLength) / musicLength;
        
        animTargetTime = clamp(animTargetTime, mtime_to_time(0),
                            mtime_to_time(musicLength));
    }
    
    else {
        musicProgress = 0;
    }

// Update and Sync Time & musicTime

    if(nowPlaying) {
        animTargetTime = nowTime;
    }
    else {
        nowTime = lerp_lim_a(nowTime, animTargetTime, animSpeed, 10000);
        
        if(abs(nowTime - animTargetTime) < 1)
            nowTime = animTargetTime; // Speeeed up
    }
    nowMusicTime = time_to_mtime(nowTime);

// Keyboard Pause & Resume

    if(keyboard_check_pressed(vk_space)) {
        nowPlaying = !nowPlaying;
        if(nowPlaying) {
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowMusicTime, channel, sampleRate);
        }
        else {
            FMODGMS_Chan_PauseChannel(channel);
        }
    }