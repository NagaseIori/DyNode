
function generate_lazer_sprite(_height) {
	var _spr = -1;
	var _surf = surface_create(1, _height);
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	shader_set(shd_lazer);
		surface_set_target(_surf);
			draw_surface(_surf, 0, 0);
		surface_reset_target();
	shader_reset();
	
	_spr = sprite_create_from_surface(_surf, 0, 0, 1, _height, 0, 0, 0, _height);
	
	surface_free(_surf);
	
	return _spr;
}
function draw_sprite_stretched_exxt(sprite, subimg, x, y, w, h, rot, col, alpha) {
	var _xscl = w / sprite_get_width(sprite);
	var _yscl = h / sprite_get_height(sprite);
	// better_scaling_draw_sprite(
	// 	sprite, subimg, x, y, _xscl, _yscl, rot, col, alpha, 1);
	draw_sprite_ext(sprite, subimg, x, y, _xscl, _yscl, rot, col, alpha);
}

#region TIME & BAR & BPM
	function ctime_to_bar(time) {
	    return time * objMain.chartBarPerMin / 60000;
	}
	
	function bar_to_ctime(offset) {
	    return offset * 60000 / objMain.chartBarPerMin;
	}
	
	function mtime_to_time(mtime) {
		return mtime + objMain.chartTimeOffset;
	}
	function time_to_mtime(time) {
		return time - objMain.chartTimeOffset;
	}
	
	function bpm_to_mspb(bpm) {
		return 60 * 1000 / bpm;
	}
	function mspb_to_bpm(mspb) {
		return 60 * 1000 / mspb;
	}
#endregion

#region POSITION TRANSFORM
	function note_pos_to_x(_pos, _side) {
	    if(_side == 0) {
	        return global.resolutionW/2 + (_pos-2.5)*300;
	    }
	    else {
	        return global.resolutionH/2 + (2.5-_pos)*150;
	    }
	}
	function x_to_note_pos(_x, _side) {
		if(_side == 0) {
			return (_x - global.resolutionW / 2) / 300 + 2.5;
		}
	}
	function y_to_note_time(_y, _side) {
		if(_side == 0) {
			return (global.resolutionH - objMain.targetLineBelow - _y) / objMain.playbackSpeed + objMain.nowTime;
		}
	}
	function resor_to_x(ratio) {
	    return global.resolutionW * ratio;
	}
	function resor_to_y(ratio) {
	    return global.resolutionH * ratio;
	}
#endregion

function array_top(array) {
    return array[array_length(array)-1];
}

function lerp_lim(from, to, amount, limit) {
    var _delta = lerp(from, to, amount)-from;
    
    _delta = min(abs(_delta), limit) * sign(_delta);
    
    return from+_delta;
}

function lerp_lim_a(from, to, amount, limit) {
    return lerp_lim(from, to, 
        amount * global.fpsAdjust, limit * global.fpsAdjust);
}

function lerp_a(from, to, amount) {
    return lerp(from, to, amount * global.fpsAdjust);
}

function create_scoreboard(_x, _y, _dep, _dig, _align, _lim) {
    var _inst = instance_create_depth(_x, _y, _dep, objScoreBoard);
    _inst.align = _align;
    _inst.preZero = _dig;
    _inst.scoreLimit = _lim;
    return _inst;
}

function random_id(_length) {
	var chrset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var _ret = "", _l = string_length(chrset);
	repeat(_length) {
		_ret += string_char_at(chrset, irandom_range(1, _l));
	}
	return _ret;
}

// Compress sprite using better scaling
function compress_sprite(_spr, _scale, _center = false){
	var _w = sprite_get_width(_spr);
	var _h = sprite_get_height(_spr);
	_w = ceil(_w*_scale);
	_h = ceil(_h*_scale);
	
	var _surf = surface_create(_w, _h);
	draw_clear_alpha(c_black, 0);
	surface_set_target(_surf);
    	better_scaling_draw_sprite(_spr, 0, 0, 0, _scale, _scale, 0, c_white, 1, 1);
    	
    	var _xorig = _center ? _w / 2 : 0;
    	var _yorig = _center ? _h / 2 : 0;
    	var _rspr = sprite_create_from_surface(_surf, 0, 0, _w, _h, 0, 0,
    	    _xorig, _yorig);
	surface_reset_target();
	surface_free(_surf);
	
	return _rspr; 
}

// Array Fast Unstable Sort
function array_sort_f(array, compare) {
    var length = array_length(array);
    if(length == 0) return;
    
    var i, j;
    var lb, ub;
    var lb_stack = [], ub_stack = [];
    
    var stack_pos = 1;
    var pivot_pos;
    var pivot;
    var temp;
    
    lb_stack[1] = 0;
    ub_stack[1] = length - 1;
    
    do {
        lb = lb_stack[stack_pos];
        ub = ub_stack[stack_pos];
        stack_pos--;
        
        do {
            pivot_pos = (lb + ub) >> 1;
            i = lb;
            j = ub;
            pivot = array[pivot_pos];
            
            do {
                while (compare(array[i], pivot)) i++;
                while (compare(pivot, array[j])) j--;
                
                if (i <= j) {
                    temp = array[i];
                    array[@ i] = array[j];
                    array[@ j] = temp;
                    i++;
                    j--;
                }
            } until (i > j);
            
            if (i < pivot_pos) {
                if (i < ub) {
                    stack_pos++;
                    lb_stack[stack_pos] = i;
                    ub_stack[stack_pos] = ub;
                }
                
                ub = j;
            } else {
                if (j > lb) {
                    stack_pos++;
                    lb_stack[stack_pos] = lb;
                    ub_stack[stack_pos] = j;
                }
                
                lb = i;
            }
        } until (lb >= ub);
    } until (stack_pos == 0);
}

function surface_checkate(_surf, _w, _h) {
	if(!surface_exists(_surf))
		return surface_create(_w, _h);
	return _surf;
}

function surface_free_f(_surf) {
    if(surface_exists(_surf))
        surface_free(_surf);
}