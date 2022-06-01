
// Mixer Update

    for(var i=0; i<2; i++) {
        mixerX[i] = lerp_lim(mixerX[i], mixerNextX[i], 
            mixerSpeed * global.fpsAdjust, mixerMaxSpeed * global.fpsAdjust);
    }