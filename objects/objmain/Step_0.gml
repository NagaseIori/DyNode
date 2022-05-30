
_position_update();

// Keyboard Time Adjust

    var _spdchange = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"));
    playbackSpeed += 100.0 * _spdchange;
    
    var _timchange = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _timscr = mouse_wheel_up() - mouse_wheel_down();
    
    if(_timchange != 0 || _timscr != 0) {
        if(nowPlaying) {
            nowTime += (_timchange * adtimeSpeed + _timscr * scrolltimeSpeed)
                * global.fpsAdjust;
            sfmod_channel_set_position(nowTime, channel, sampleRate);
        }
        else {
            animTargetOffset += (_timchange * adtimeSpeed 
                + _timscr * scrolltimeSpeed) * global.fpsAdjust / 1000 / 60
                * chartBarPerMin;
        }
    }

// Time Correction

    if(nowPlaying)
        nowTime += delta_time / 1000;
        
    if(music != undefined) {
        var _cor_tim = sfmod_channel_get_position(channel, sampleRate);
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
        
        if(nowTime >= 0 && abs(_cor_tim - nowTime) > MAXIMUM_DELAY_OF_SOUND) {
            nowTime = _cor_tim;
        }
        if(_cor_tim >= musicLength && nowPlaying) {
            FMODGMS_Chan_PauseChannel(channel);
            nowPlaying = false;
        }
        
        nowTime = min(nowTime, musicLength);
    }

// Update and Sync Time & Offset

    if(nowPlaying) {
        nowOffset = nowTime / 60000 * chartBarPerMin + chartOffset;
        animTargetOffset = nowOffset;
    }
    else {
        nowOffset = lerp(nowOffset, animTargetOffset, animSpeed * global.fpsAdjust);
        nowTime = (nowOffset - chartOffset) / chartBarPerMin * 60 * 1000;
    }

// Keyboard Pause & Resume

    if(keyboard_check_pressed(vk_space)) {
        nowPlaying = !nowPlaying;
        if(nowPlaying) {
            FMODGMS_Chan_ResumeChannel(channel);
            sfmod_channel_set_position(nowTime, channel, sampleRate);
        }
        else {
            FMODGMS_Chan_PauseChannel(channel);
        }
    }
