
// Mixer Update

    for(var i=0; i<2; i++) {
        
        // Mixer Restriction
        mixerNextX[i] = clamp(mixerNextX[i], resor_to_y(198/1080), resor_to_y(858/1080));
        
        mixerX[i] = lerp_lim_a(mixerX[i], mixerNextX[i], mixerSpeed, mixerMaxSpeed);
    }