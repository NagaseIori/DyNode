/// @description Draw the Playview

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Bottom
    
    if(!surface_exists(bottomInfoSurf)) {
    	bottomInfoSurf = surface_create(global.resolutionW, targetLineBelow);
    	surface_set_target(bottomInfoSurf);
    	
    		draw_clear_alpha(c_black, 0);
    		var _nx = resor_to_x(0.017);
	    	// Draw Title
			if(has_cjk(chartTitle)) {
				draw_set_halign(fa_left); draw_set_valign(fa_middle);
				
				draw_set_font(global._notoFont);
				// Shadow
				draw_set_color_alpha(c_black, 0.4);
				draw_text(_nx, 44 * global.scaleYAdjust, chartTitle);
				draw_set_color_alpha(c_white, 1);
				draw_text(_nx, 37 * global.scaleYAdjust, chartTitle);
				draw_set_alpha(1.0);
			}
			else {
				scribble(chartTitle).starting_format("fOrbitron48s", c_white)
		        .align(fa_left, fa_middle)
			    .transform(global.scaleXAdjust * 0.7, global.scaleYAdjust * 0.7)
			    .draw(_nx, 42 * global.scaleYAdjust);
			}
		    
		    // Draw Difficulty
		    better_scaling_draw_sprite(global.difficultySprite[chartDifficulty], 0, 
		        _nx, 77 * global.scaleYAdjust,
		        0.67 * global.scaleXAdjust, 0.67 * global.scaleYAdjust, 0, c_white,
		        1, 0);
	    
	    surface_reset_target();
    }
    
    draw_surface_ext(bottomInfoSurf, 0, global.resolutionH - targetLineBelow,
    	1.0, 1.0, 0, c_white, titleAlpha);
    	

// Draw targetline

    var _sprlazer = global.sprLazer;
    // Light Below
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        0, _nh - targetLineBelow,
        _nw, targetLineBelowH/2 + 25,
        0, themeColor, lazerAlpha[0]);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        0, _nh - targetLineBelow + 1,
        _nw, -(targetLineBelowH/2 + 25),
        0, themeColor, lazerAlpha[0]);
    // Light Left
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        targetLineBeside, _nh - targetLineBelow,
        _nh - targetLineBelow, targetLineBesideW/2 + 25,
        90, themeColor, lazerAlpha[1]);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        targetLineBeside + 1, _nh - targetLineBelow,
        _nh - targetLineBelow, -(targetLineBesideW/2 + 25),
        90, themeColor, lazerAlpha[1]);
    // Light Right
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        _nw - targetLineBeside, _nh - targetLineBelow,
        _nh - targetLineBelow, targetLineBesideW/2 + 25,
        90, themeColor, lazerAlpha[2]);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        _nw - targetLineBeside + 1, _nh - targetLineBelow,
        _nh - targetLineBelow, -(targetLineBesideW/2 + 25),
        90, themeColor, lazerAlpha[2]);
    
    
    
    // Line Left
    draw_set_color_alpha(merge_color(themeColor, c_white, lineMix[1]), 1.0);
    draw_rectangle(targetLineBeside - targetLineBesideW/2, 0, 
                    targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);
    // Line Right
    draw_set_color_alpha(merge_color(themeColor, c_white, lineMix[2]), 1.0);
    draw_rectangle(_nw - targetLineBeside - targetLineBesideW/2, 0, 
                    _nw - targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);
	// Line Below
	draw_set_color_alpha(merge_color(themeColor, c_white, lineMix[0]), 1.0);
    draw_rectangle(0, _nh - targetLineBelow - targetLineBelowH/2, 
                    _nw, _nh - targetLineBelow + targetLineBelowH/2, false);
    
