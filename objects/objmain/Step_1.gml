/// @description Reset Tags & Time Update & Activate notes

// Mixer
    
    mixerNextNote = [-1, -1]
    
#region TIME UPDATE

var _music_resync_request = false;

// Music Speed Adjust
    
    var _muspdchange = keycheck_down(ord("W")) - keycheck_down(ord("S"));
    if(_muspdchange != 0) {
        musicSpeed += 0.1 * _muspdchange;
        musicSpeed = max(musicSpeed, 0.1);
        FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
        
        announcement_play("音乐倍速：x" + string_format(musicSpeed, 1, 1));
    }

// Keyboard Time & Speed Adjust

    var _spdchange = keycheck_down(ord("E")) - keycheck_down(ord("Q"));
    _spdchange += editor_select_is_going()? 0: wheelcheck_up_ctrl() - ((animTargetPlaybackSpeed > 0.2) * wheelcheck_down_ctrl());
    animTargetPlaybackSpeed += 0.1 * _spdchange;
    
    if(_spdchange != 0) {
    	announcement_play("下落速度：x" + string_format(animTargetPlaybackSpeed, 1, 2));
    	
    	if(animTargetPlaybackSpeed == 0.2 && _spdchange < 0)
    		announcement_warning("你现在的下落速度为：x0.2。过低的下落速度可能导致严重的性能问题。");
    }
    
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
        
    		topBarMouseInbound = mouse_y <= topBarMouseH && mouse_y > 0;
            if(topBarMouseInbound || topBarMousePressed || _timchange != 0 || _timscr != 0) {
            	animTargetTopBarIndicatorA = 0.3;
            	topBarTimeLastTime = 2000;
            }
            else
                animTargetTopBarIndicatorA = 0;
            
            topBarIndicatorA = lerp(topBarIndicatorA, 
                animTargetTopBarIndicatorA, animSpeed * global.fpsAdjust);
            
            topBarTimeLastTime -= delta_time / 1000;
            if(editor_get_editmode() < 5) topBarTimeLastTime = 1;
        	
            animTargetTopBarTimeGradA = topBarMouseInbound || topBarMousePressed;
        	animTargetTopBarTimeA = topBarTimeLastTime > 0;
        	topBarTimeA = lerp_a(topBarTimeA, animTargetTopBarTimeA, 0.2);
        	topBarTimeGradA = lerp_a(topBarTimeGradA, animTargetTopBarTimeGradA, 0.2);
                
        
            if(mouse_check_button_pressed(mb_left) && mouse_y <= topBarMouseH && mouse_y > 0) {
                topBarMousePressed = true;
                topBarMouseLastX = -5;
            }
                
            
            if(topBarMousePressed) {
            	mouse_clear_hold(); // Clear the Hold Buffer
                if(mouse_check_button_released(mb_left)) {
                	topBarMousePressed = false;
                	mouse_clear(mb_left);
                }
                    
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
                        animTargetTime = musicProgress * musicLength;
                    }
                }
            }
        
        // Reduce Chart to Music's Latency
        // (Bad Performance)
        // if(nowPlaying && nowTime >= 0 && abs(_cor_tim - nowTime) > MAXIMUM_DELAY_OF_SOUND) {
        //     nowTime = _cor_tim;
        // }
        
        // If music ends then stop
        if(FMODGMS_Chan_Is_Playing(channel)<=0 && nowPlaying) {
        	
            // Channel gets invalid, create another one.
            FMODGMS_Chan_RemoveChannel(channel);
            channel = FMODGMS_Chan_CreateChannel();
            FMODGMS_Snd_PlaySound(music, channel);
            FMODGMS_Chan_Set_Pitch(channel, musicSpeed);
            FMODGMS_Chan_PauseChannel(channel);
            nowTime = musicLength;
            animTargetTime = musicLength;
            
            nowPlaying = false;
        }
        
        musicProgress = clamp(nowTime, 0, musicLength) / musicLength;
        
        animTargetTime = clamp(animTargetTime, 0, musicLength);
    }
    
    else {
        musicProgress = 0;
    }
    
// Time Jump

    if(keycheck_down(ord("L")) && chartNotesArrayAt<chartNotesCount)
        animTargetTime = chartNotesArray[chartNotesArrayAt].time;
    if(keycheck_down(ord("K")) && chartNotesArrayAt>0)
        animTargetTime = chartNotesArray[chartNotesArrayAt-1].time;

// Update and Sync Time & musicTime

    if(nowPlaying) {
        if(music != undefined)
            nowTime = clamp(nowTime, 0, musicLength);
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

#endregion

#region NOTES ACTIVATE

	var i=max(chartNotesArrayAt-3, 0), l=chartNotesCount;
	
	for(; i<l; i++)
		if(note_check_and_activate(chartNotesArray[i]) < 0)
			break;

#endregion