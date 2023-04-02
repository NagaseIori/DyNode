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
    }

#endregion