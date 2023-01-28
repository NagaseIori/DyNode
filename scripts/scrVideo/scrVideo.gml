
function safe_video_init() {
    with(objMain) {
        bgVideoSurf = surface_create(global.resolutionW, global.resolutionH);
        
        timesourceUpdateVideo =
    		time_source_create(time_source_game, 1/VIDEO_UPDATE_FREQUENCY, 
    		time_source_units_seconds,
    		function() {
    			if(bgVideoAlpha > EPS && nowPlaying && bgVideoDisplay)
    				safe_video_update();
    		}, [], -1);
    	time_source_start(timesourceUpdateVideo);
    }
}

function safe_video_update() {
    with(objMain) {
        bgVideoSurf = surface_checkate(bgVideoSurf, global.resolutionW, global.resolutionH);
        
        if(bgVideoAlpha < EPS || !bgVideoLoaded)
            return false;
        if(video_get_status() <= 1)
            return false;
        
        if(nowPlaying && editor_get_editmode() == 5 && bgVideoPaused)
            safe_video_seek_to(nowTime);
        
        surface_set_target(bgVideoSurf);
            draw_clear_alpha(c_black, 0);
            var _status = video_draw();
        	if(_status[0] == -1) {
        		announcement_error("video_playback_error");
        		safe_video_free();
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
    	surface_reset_target();
    }
    return true;
}

function safe_video_draw(x, y, alp) {
    with(objMain) {
        if(!surface_exists(bgVideoSurf))
            safe_video_update();
        draw_surface_ext(bgVideoSurf, 0, 0, 1, 1, 0, c_white, alp);
    }
}

function safe_video_free() {
    with(objMain) {
        bgVideoPaused = false;
        bgVideoLoaded = false;
        bgVideoReloading = false;
        bgVideoDisplay = false;
        
        surface_free_f(bgVideoSurf);
        
        if(video_get_status() != 0) {
            bgVideoDestroying = true;
            video_close();
        }
        
        show_debug_message("VIDEO FREE!!");
    }
    
}

function safe_video_seek_to(time) {
    if(editor_get_editmode() != 5 || !objMain.nowPlaying)
        return;
    video_seek_to(time);
    safe_video_resume();
    show_debug_message("VIDEO SEEKING TO: "+ string(time));
}

// If the video is loaded (or being reloading)
function safe_video_check_loaded() {
    return objMain.bgVideoLoaded || objMain.bgVideoReloading;
}

function safe_video_pause() {
    if(objMain.bgVideoPaused) return;
    objMain.bgVideoPaused = true;
    video_pause();
    show_debug_message("VIDEO PAUSED.");
}

function safe_video_resume() {
    if(!objMain.bgVideoPaused) return;
    objMain.bgVideoPaused = false;
    video_resume();
    show_debug_message("VIDEO RESUMED.");
}