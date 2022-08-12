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

#region DRAW
function draw_sprite_stretched_exxt(sprite, subimg, x, y, w, h, rot, col, alpha) {
	var _xscl = w / sprite_get_width(sprite);
	var _yscl = h / sprite_get_height(sprite);
	// better_scaling_draw_sprite(
	// 	sprite, subimg, x, y, _xscl, _yscl, rot, col, alpha, 1);
	draw_sprite_ext(sprite, subimg, x, y, _xscl, _yscl, rot, col, alpha);
}

function draw_set_color_alpha(color, alpha) {
	draw_set_color(color);
	draw_set_alpha(alpha);
}

function draw_scribble_box(_ele, x, y, alpha) {
	var _bbox = _ele.get_bbox(x, y);
	
	CleanRectangle(_bbox.left-5, _bbox.top-5, _bbox.right+5, _bbox.bottom+5)
		.Blend(theme_get().color, alpha)
		.Rounding(5)
		.Draw();
}
#endregion

#region TIME & BAR & BPM
function time_to_bar(time, barpm = objMain.chartBarPerMin) {
    return time * barpm / 60000;
}

function bar_to_time(offset, barpm = objMain.chartBarPerMin) {
    return offset * 60000 / barpm;
}

function mtime_to_time(mtime, offset = objMain.chartTimeOffset) {
	return mtime + offset;
}
function time_to_mtime(time, offset = objMain.chartTimeOffset) {
	return time - offset;
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
        return global.resolutionW/2 + (_pos-2.5)*300*global.scaleXAdjust;
    }
    else {
        return global.resolutionH/2 + (2.5-_pos)*150*global.scaleYAdjust;
    }
}
function x_to_note_pos(_x, _side) {
	if(_side == 0) {
		return (_x - global.resolutionW / 2) / (300*global.scaleXAdjust) + 2.5;
	}
	else {
		return 2.5 - (_x - global.resolutionH / 2) / (150*global.scaleYAdjust);
	}
}
function y_to_note_time(_y, _side) {
	if(_side == 0) {
		return (global.resolutionH - objMain.targetLineBelow - _y) / objMain.playbackSpeed + objMain.nowTime;
	}
	else {
		_y = _side == 1? _y: global.resolutionW - _y;
		return (_y - objMain.targetLineBeside) / objMain.playbackSpeed + objMain.nowTime;
	}
}
function note_time_to_y(_time, _side) {
	if(_side == 0) {
		return global.resolutionH - objMain.targetLineBelow - (_time - objMain.nowTime) * objMain.playbackSpeed;
	}
	else {
		return global.resolutionW / 2 + (_side == 1?-1:1) *  (global.resolutionW / 2 - 
			(objMain.playbackSpeed * (_time - objMain.nowTime)) - objMain.targetLineBeside);
	}
}
function noteprop_to_xy(_pos, _time, _side) {
	if(_side == 0)
		return [note_pos_to_x(_pos, _side), note_time_to_y(_time, _side)];
	else
		return [note_time_to_y(_time, _side), note_pos_to_x(_pos, _side)];
}
function resor_to_x(ratio) {
    return global.resolutionW * ratio;
}
function resor_to_y(ratio) {
    return global.resolutionH * ratio;
}
#endregion

#region LOAD & SAVE CHART
function difficulty_num_to_char(_number) {
	return string_char_at(global.difficultyString, _number + 1);
}
function difficulty_char_to_num(_char) {
	return string_last_pos(_char, global.difficultyString) - 1;
}

function note_type_num_to_string(_number) {
	return global.noteTypeName[_number];
}

#endregion

function has_cjk(str) {
	var i=1, l=string_length(str);
	for(; i<=l; i++) {
		if(ord(string_char_at(str, i)) >= 255)
			return true;
	}
	return false;
}

function string_real(str) {
	var _dot = false, _ch, _ret = "";
	for(var i=1, l=string_length(str); i<=l; i++) {
		_ch = string_char_at(str, i);
		_ch = ord(_ch);
		if(_ch >= ord("0") || _ch <=ord("9"))
			_ret += chr(_ch);
		else if(!_dot && _ch == ord(".")) {
			_dot = true;
			_ret += chr(_ch);
		}
	}
	return _ret;
}

function cjk_prefix() {
	return "[sprMsdfNotoSans][scale,1.5]";
}


#region FORMAT FUNCTIONS
function format_markdown(_str) {
	_str = string_replace_all(_str, "**", "");
	_str = string_replace_all(_str, "* ", "· ")
	return _str;
}

function format_time_ms(_time) {
	return string_format(_time, 1, 1) + "ms";
}

function format_time_string(_time) {
	var _min = floor(_time / 1000 / 60);
	var _sec = floor((_time - _min * 60000)/1000);
	var _ms = floor(_time - _min * 60000 - _sec * 1000);
	var _str = string_format(_min, 2, 0) + ":" + string_format(_sec, 2, 0) + ":" + string_format(_ms, 3, 0);
	_str = string_replace_all(_str, " ", "0");
	return _str;
}

#endregion

function in_between(x, l, r) {
	return abs(r-x) + abs(x-l) == abs(r-l);
}
function pos_inbound(xo, yo, x1, y1, x2, y2) {
	return in_between(xo, x1, x2) && in_between(yo, y1, y2);
}

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

// Get a blured application surface
function get_blur_appsurf() {
	var _w = surface_get_width(application_surface);
	var _h = surface_get_height(application_surface);
	var u_size = shader_get_uniform(shd_gaussian_blur_2pass, "size");
    var u_blur_vector = shader_get_uniform(shd_gaussian_blur_2pass, "blur_vector");
	
	var _ret = surface_create(_w, _h);
	var _pong = surface_create(_w, _h);
	
	surface_set_target(_pong);
		shader_set(shd_gaussian_blur_2pass);
			shader_set_uniform_f_array(u_size, [_w, _h, 20, 10]);
			shader_set_uniform_f_array(u_blur_vector, [0, 1]);
			draw_surface(application_surface, 0, 0);
		shader_reset();
	surface_reset_target();
	
	surface_set_target(_ret);
		shader_set(shd_gaussian_blur_2pass);
			shader_set_uniform_f_array(u_size, [_w, _h, 20, 10]);
			shader_set_uniform_f_array(u_blur_vector, [1, 0]);
			draw_surface(_pong, 0, 0);
		shader_reset();
	surface_reset_target();
	
	surface_free(_pong);
	return _ret;
}

// Draw some shapes on blurred application surface and return
function get_blur_shapesurf(func) {
	if(!is_method(func))
		show_error("func must be a method.", true);
	
	var _surf = get_blur_appsurf();
	var _w = surface_get_width(application_surface);
	var _h = surface_get_height(application_surface);
	var _temp = surface_create(_w, _h)
	surface_set_target(_temp);
		draw_clear_alpha(c_black, 0);
		func();
	surface_reset_target();
	
	surface_set_target(_surf);
		gpu_set_blendmode_ext(bm_zero, bm_src_alpha);
		draw_surface(_temp, 0, 0);
		gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	surface_free(_temp);
	
	return _surf;
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

function io_clear_diag() {
	keyboard_clear(keyboard_lastkey);
	mouse_clear(mouse_lastbutton);
	io_clear();
}

function csv_to_grid(){
	/// @desc csv_to_grid
	/// @param file
	/// @param [force_strings]
	/// @param [cell_delimiter]
	/// @param [string_delimiter]
	/// @param [mac_newline]
	//  
	//  CAUTION: Please ensure your files are in UTF-8 encoding.
	//  
	//  You may pass <undefined> to use the default value for optional arguments.
	//  arg0   string   Filename for the source UTF-8 CSV file
	//  arg1   bool     Whether to force all cells to be a string. Defaults to false
	//  arg2   string   The delimiter used to separate cells. Defaults to a comma
	//  arg3   string   The delimiter used to define strings in the CSV file. Defaults to a double-quote
	//  arg4   bool     Newline compatibility mode for Mac (0A). Defaults to Windows standard newline (0D,0A)
	//  
	//  (c) Juju Adams 26th May 2017
	//  @jujuadams

	//Handle arguments
	if ( argument_count < 1 ) or ( argument_count > 5 ) {
		show_error( "Incorrect number of arguments (" + string( argument_count ) + ")", false );
		return undefined;
	}

	var _filename = argument[0];
	var _force_strings    = false;
	var _cell_delimiter   = chr(44); //comma
	var _string_delimiter = chr(34); //double-quote
	var _newline_alt      = false;

	if ( argument_count >= 2 ) and ( !is_undefined( argument[1] ) ) _force_strings    = argument[1];
	if ( argument_count >= 3 ) and ( !is_undefined( argument[2] ) ) _cell_delimiter   = argument[2];
	if ( argument_count >= 4 ) and ( !is_undefined( argument[3] ) ) _string_delimiter = argument[3];
	if ( argument_count >= 5 ) and ( !is_undefined( argument[4] ) ) _newline_alt      = argument[4];

	//Check for silliness...
	if ( string_length( _cell_delimiter ) != 1 ) or ( string_length( _string_delimiter ) != 1 ) {
		show_error( "Delimiters must be one character", false );
		return undefined;
	}

	//More variables...
	var _cell_delimiter_ord  = ord( _cell_delimiter  );
	var _string_delimiter_ord = ord( _string_delimiter );

	var _sheet_width  = 0;
	var _sheet_height = 1;
	var _max_width    = 0;

	var _prev_val   = 0;
	var _val        = 0;
	var _str        = "";
	var _in_string  = false;
	var _is_decimal = !_force_strings;
	var _grid       = ds_grid_create( 1, 1 ); _grid[# 0, 0 ] = "";

	//Load CSV file as a buffer
	var _buffer = buffer_load( _filename );
	var _size = buffer_get_size( _buffer );
	buffer_seek( _buffer, buffer_seek_start, 0 );

	//Handle byte order marks from some UTF-8 encoders (EF BB BF at the start of the file)
	var _bom_a = buffer_read( _buffer, buffer_u8 );
	var _bom_b = buffer_read( _buffer, buffer_u8 );
	var _bom_c = buffer_read( _buffer, buffer_u8 );
	if !( ( _bom_a == 239 ) and ( _bom_b == 187 ) and ( _bom_c == 191 ) ) {
		show_debug_message( "CAUTION: csv_to_grid: " + _filename + ": CSV file might not be UTF-8 encoded (no BOM)" );
		buffer_seek( _buffer, buffer_seek_start, 0 );
	} else {
		_size -= 3;
	}

	//Iterate over the buffer
	for( var _i = 0; _i < _size; _i++ ) {

		_prev_val = _val;
		var _val = buffer_read( _buffer, buffer_u8 );

		//Handle UTF-8 encoding
		if ( ( _val & 224 ) == 192 ) { //two-byte

			_val  = (                              _val & 31 ) <<  6;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 );
			_i++;

		} else if ( ( _val & 240 ) == 224 ) { //three-byte

			_val  = (                              _val & 15 ) << 12;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) <<  6;
			_val +=   buffer_read( _buffer, buffer_u8 ) & 63;
			_i += 2;

		} else if ( ( _val & 248 ) == 240 ) { //four-byte

			_val  = (                              _val &  7 ) << 18;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) << 12;
			_val += ( buffer_read( _buffer, buffer_u8 ) & 63 ) <<  6;
			_val +=   buffer_read( _buffer, buffer_u8 ) & 63;
			_i += 3;

		}

		//If we've found a string delimiter
		if ( _val == _string_delimiter_ord ) {

			//This definitely isn't a decimal number!
			_is_decimal = false;

			//If we're in a string...
			if ( _in_string ) {

				//If the next character is a string delimiter itself, skip this character
				if ( buffer_peek( _buffer, buffer_tell( _buffer ), buffer_u8 ) == _string_delimiter_ord ) continue;

				//If the previous character is a string delimiter itself, add the string delimiter to the working string
				if ( _prev_val == _string_delimiter_ord ) {
				    _str += _string_delimiter;
				    continue;
				}

			}

			//Toggle "we're in a string" behaviour
			_in_string = !_in_string;
			continue;

		}
    
		if ( _newline_alt ) {
			var _newline = ( _val == 10 );
		} else {
			var _newline = ( _prev_val == 13 ) and ( _val == 10 );
        
			//If we've found a newline and we're in a string, skip over the chr(10) character
			if ( _in_string ) and ( _newline ) continue;
		}

		//If we've found a new cell
		if ( ( _val == _cell_delimiter_ord ) or ( _newline ) ) and ( !_in_string ) {

			_sheet_width++;

			//If this cell is now longer than the maximum width of the grid, expand the grid
			if ( _sheet_width > _max_width ) {

				_max_width = _sheet_width;
				ds_grid_resize( _grid, _max_width, _sheet_height );

				//Clear cells vertically above to overwrite the default 0-value
				if ( _sheet_height >= 2 ) ds_grid_set_region( _grid, _max_width-1, 0, _max_width-1, _sheet_height-2, "" );

			}

			//Write the working string to a grid cell
			if ( _is_decimal )
	                {
	                    if (_str == "") _str = 0; else _str = real( _str );
	                }
                
			_grid[# _sheet_width-1, _sheet_height-1 ] = _str;

			_str = "";
			_in_string = false;
			_is_decimal = !_force_strings;

			//A newline outside of a string triggers a new line... unsurprisingly
			if ( _newline ) {

				//Clear cells horizontally to overwrite the default 0-value
				if ( _sheet_width < _max_width ) ds_grid_set_region( _grid, _sheet_width, _sheet_height-1, _max_width-1, _sheet_height-1, "" );

				_sheet_width = 0;
				_sheet_height++;
				ds_grid_resize( _grid, _max_width, _sheet_height );
			}

			continue;

		}

		//Check if we've read a "\n" dual-character
		if ( _prev_val == 92 ) and ( _val == 110 ) {
			_str = string_delete( _str, string_length( _str ), 1 ) + "\n";
			continue;
		}
    
		//No newlines should appear outside of a string delimited cell
		if ( ( _val == 10 ) or ( _val == 13 ) ) and ( !_in_string ) continue;
    
		//Check if this character is outside valid decimal character range
		if ( _val != 45 ) and ( _val != 46 ) and ( ( _val < 48 ) or ( _val > 57 ) ) _is_decimal = false;

		//Finally add this character to the working string!
		_str += chr( _val );

	}

	//Catch hanging work string on end-of-file
	if ( _str != "" ) {
	
		_sheet_width++;
	
		if ( _sheet_width > _max_width ) {
			_max_width = _sheet_width;
			ds_grid_resize( _grid, _max_width, _sheet_height );
			if ( _sheet_height >= 2 ) ds_grid_set_region( _grid, _max_width-1, 0, _max_width-1, _sheet_height-2, "" );
		}
	
		if ( _is_decimal ) _str = real( _str );
		_grid[# _sheet_width-1, _sheet_height-1 ] = _str;
	
	}

	//If the last character was a newline then we'll have an erroneous extra row at the bottom
	if ( _newline ) ds_grid_resize( _grid, _max_width, _sheet_height-1 );

	buffer_delete( _buffer );
	return _grid;
}