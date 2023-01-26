/// @description Draw the Background & Beat Lines

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Background

    if(bgImageSpr != -1) {
        draw_sprite(bgImageSpr, 0, _nw/2, _nh/2);
    }
    else {
        draw_clear(c_white);
    }
    
    if(bgVideoLoaded && !bgVideoReloading && nowPlaying && video_get_status() == video_status_playing) {
    	var _status = video_draw();
    	if(_status[0] == -1) {
    		announcement_error("视频播放出现错误。");
    		video_close();
    		bgVideoLoaded = false;
    	}
    	else {
    		var _w = surface_get_width(_status[1]), _h = surface_get_height(_status[1]);
    		var _wscl = global.resolutionW / _w;
		    var _hscl = global.resolutionH / _h;
		    var _scl = max(_wscl, _hscl); // Centre & keep ratios
		    var _nx = global.resolutionW/2 - _scl * _w / 2;
		    var _ny = global.resolutionH/2 - _scl * _h / 2;
		    draw_surface_ext(_status[1], _nx, _ny, _scl, _scl, 0, c_white, 1);
    	}
    }

	// Draw bottom blured bg
    
    var _surf = kawase_get_surface(kawaseArr);
    surface_set_target(_surf);
    	draw_surface(application_surface, 0, targetLineBelow - _nh);
    surface_reset_target();
    kawase_blur(kawaseArr);
    draw_surface(_surf, 0, _nh - targetLineBelow);
    
    // Dim background
	    draw_set_color(c_black);
	    draw_set_alpha(bgDim);
	    draw_rectangle(0, 0, _nw, _nh, false);
	    draw_set_alpha(1.0);
        
        draw_set_color(c_black);
        draw_set_alpha(bottomDim);
        draw_rectangle(0, _nh - targetLineBelow, _nw, _nh, false);
        draw_set_alpha(1.0);

	// Draw Bottom Right
    
    var _nxx = resor_to_x((1920 - 80 - 30) / 1920), _nww = 180 * global.scaleXAdjust;
    for(var i = 0; i < 8; i++) {
        draw_sprite_ext(
            i==0?sprBottomSignBlue:sprBottomSignBlack,
            0,
            _nxx - i * _nww / 2,
            (i & 1) == 0? _nh : _nh - targetLineBelow,
            global.scaleXAdjust,
            global.scaleYAdjust,
            (i & 1) == 0? 180 : 0,
            c_white,
            1
            );
    }

// Draw Faint Color

    draw_sprite_stretched_exxt(
        global.sprLazer, 0,
        0, _nh - targetLineBelow, _nw, global.resolutionH*0.75,
        0, themeColor, bgFaintAlpha * animCurvFaintEval);