/// @description Mixer Update & Update activated notes array

// Mixer Update

    for(var i=0; i<2; i++) {
        
        // Mixer Restriction
        mixerNextX[i] = clamp(mixerNextX[i], resor_to_y(198/1080), resor_to_y(858/1080));
        
        mixerX[i] = lerp_lim_a(mixerX[i], mixerNextX[i], mixerSpeed, mixerMaxSpeed);
        
        mixerShadow[i].y = mixerX[i];
        mixerShadow[i].x = i*global.resolutionW + (i? -1:1) * targetLineBeside;
    }

// Get activated notes

	array_resize(chartNotesArrayActivated, 0);
	with(objNote) {
		if(noteType <= 2)
			array_push(objMain.chartNotesArrayActivated, self);
    }
    // Sort by array position
    array_sort(chartNotesArrayActivated, function(_a, _b) { return _a.arrayPos - _b.arrayPos; });