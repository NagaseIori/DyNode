/// @description Draw the Playview

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Bottom
    
    // Draw Title

	if(has_cjk(chartTitle)) {
		scribble("[sprMsdfNotoSans]"+chartTitle).starting_format("fOrbitron48", c_white)
        .align(fa_left, fa_middle)
	    .transform(global.scaleXAdjust * 1.2, global.scaleYAdjust * 1.2)
	    .draw(resor_to_x(0.021), global.resolutionH - targetLineBelow + 47 * global.scaleYAdjust);
	}
	else {
		scribble(chartTitle).starting_format("fOrbitron48", c_white)
        .align(fa_left, fa_middle)
	    .transform(global.scaleXAdjust * 0.7, global.scaleYAdjust * 0.7)
	    .draw(resor_to_x(0.021), global.resolutionH - targetLineBelow + 42 * global.scaleYAdjust);
	}
    
    
    // Draw Difficulty
    better_scaling_draw_sprite(global.difficultySprite[chartDifficulty], 0, 
        resor_to_x(0.019), global.resolutionH - targetLineBelow + 77 * global.scaleYAdjust,
        0.2 * global.scaleXAdjust, 0.2 * global.scaleYAdjust, 0, c_white,
        1, 0);

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
    
    
    draw_set_color_alpha(c_white, 1.0);
    // Line Left
    draw_rectangle(targetLineBeside - targetLineBesideW/2, 0, 
                    targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);
    // Line Right
    draw_rectangle(_nw - targetLineBeside - targetLineBesideW/2, 0, 
                    _nw - targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);
	// Line Below
    draw_rectangle(0, _nh - targetLineBelow - targetLineBelowH/2, 
                    _nw, _nh - targetLineBelow + targetLineBelowH/2, false);
    
