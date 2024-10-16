/// @description Mixer Update & Update activated notes array

// Mixer Update

    for(var i=0; i<2; i++) {
        
        // Mixer Restriction
        var _nextX = mixer_get_next_x(i+1);
        if(!is_undefined(_nextX))
        	mixerNextX[i] = _nextX;
        mixerNextX[i] = clamp(mixerNextX[i], resor_to_y(198/1080), resor_to_y(858/1080));
        
        mixerX[i] = lerp_lim_a(mixerX[i], mixerNextX[i], mixerSpeed, mixerMaxSpeed);
        
        mixerShadow[i].y = mixerX[i];
        mixerShadow[i].x = i*global.resolutionW + (i? -1:1) * targetLineBeside;
    }

// Get activated notes

	array_resize(chartNotesArrayActivated, 0);
	with(objNote) {
		if(noteType <= 2 && !attaching)
			array_push(objMain.chartNotesArrayActivated, self);
    }
    // Sort by array position
    array_sort(chartNotesArrayActivated, function(_a, _b) { return _a.arrayPos - _b.arrayPos; });