#define window_frame_preinit
window_frame_preinit_raw();
//#macro window_frame_is_ready   global.__window_frame_ready
//#macro window_command_close    $F060
//#macro window_command_maximize $F030
//#macro window_command_minimize $F020
//#macro window_command_restore  $F120
//#macro window_command_resize   $F000
//#macro window_command_move     $F010
global.__window_frame_buffer = undefined;
global.__window_frame_init_timer = 2;
global.__window_frame_ready = false;
global.__window_frame_bound = false;
global.__window_frame_visible = false;
global.__window_frame_pre_fs_x = window_get_x();
global.__window_frame_pre_fs_y = window_get_y();
global.__window_frame_pre_fs_w = window_get_width();
global.__window_frame_pre_fs_h = window_get_height();
global.__window_frame_queue_topmost = undefined;
global.__window_frame_post_fullscreen_t = false;
global.__window_frame_check_visible_t = false;
global.__window_frame_force_focus_t = false;
global.__window_frame_topmost = false;

#define window_frame_prepare_buffer
/// (size:int)~
var _size = argument0;
var _buf = global.__window_frame_buffer;
if (_buf == undefined) {
	_buf = buffer_create(_size, buffer_grow, 1);
	global.__window_frame_buffer = _buf;
} else if (buffer_get_size(_buf) < _size) {
	buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;

#define window_frame_init_auto
/// ()
return window_frame_init(
	window_get_x(),
	window_get_y(),
	window_get_width(),
	window_get_height(),
	window_get_caption()
);

#define window_frame_update
/// (): Should be called once per frame.
if (global.__window_frame_init_timer > 0) {
	global.__window_frame_init_timer -= 1;
	if (global.__window_frame_init_timer <= 0) {
		if (window_frame_init_auto()) {
			global.__window_frame_ready = true;
			global.__window_frame_bound = true;
			global.__window_frame_visible = true;
			show_debug_message("window_frame_init succeeded!");
		} else show_debug_message("window_frame_init failed!");
	}
}

if 0 trace(
	"fs:", window_get_fullscreen(),
	"visible:", global.__window_frame_visible,
	"bound:", global.__window_frame_bound
);
if (global.__window_frame_ready) {
	if (window_get_fullscreen()) {
		if (global.__window_frame_bound) {
			//trace("unbind");
			global.__window_frame_bound = false;
			window_frame_set_visible_raw1(false);
		}
	} else {
		if (global.__window_frame_force_focus_t > 0) {
			if (--global.__window_frame_force_focus_t <= 0) {
				window_frame_force_focus();
			}
		}
		if (global.__window_frame_check_visible_t > 0) {
			if (--global.__window_frame_check_visible_t <= 0) {
				if (global.__window_frame_visible) {
					window_frame_set_visible(true);
				}
			}
		}
		if (global.__window_frame_post_fullscreen_t > 0) {
			if (--global.__window_frame_post_fullscreen_t <= 0) {
				window_set_rectangle(
					global.__window_frame_pre_fs_x,
					global.__window_frame_pre_fs_y,
					global.__window_frame_pre_fs_w,
					global.__window_frame_pre_fs_h
				);
				// this is cursed as heck, unless you add a lot of delay,
				// the frame enters some kind of error-state where it cannot
				// be focused and does not dispatch WM_SYSCOMMAND for its buttons
				global.__window_frame_force_focus_t = 5;
				global.__window_frame_check_visible_t = 10;
			}
		}
		var _tm = global.__window_frame_queue_topmost;
		if (_tm != undefined) {
			global.__window_frame_queue_topmost = undefined;
			window_set_topmost_raw(_tm);
		}
	}
}

#define window_frame_get_visible
/// ()->bool
return global.__window_frame_visible;

#define window_frame_set_visible
/// (visible:bool)
var _visible = argument0;
global.__window_frame_visible = _visible;
// we confidently cannot embed fullscreen windows
// therefore framing is delayed until exiting fs
if (!window_get_fullscreen()) {
	global.__window_frame_bound = _visible;
	window_frame_set_visible_raw1(_visible);
	//trace("bind:", _visible);
}

#define window_frame_set_visible_raw1
var _visible = argument0;
if (global.__window_frame_topmost) window_set_topmost_raw(false);
window_frame_set_visible_raw(_visible);
if (global.__window_frame_topmost) window_set_topmost_raw(true);

#define window_frame_set_fullscreen
/// (full): 
if (argument0) {
	if (window_get_fullscreen()) exit;
	if (global.__window_frame_topmost) window_set_topmost_raw(false);
	if (global.__window_frame_bound) {
		//trace("unbind");
		global.__window_frame_bound = false;
		window_frame_set_visible_raw(false);
	}
	global.__window_frame_pre_fs_x = window_frame_get_x();
	global.__window_frame_pre_fs_y = window_frame_get_y();
	global.__window_frame_pre_fs_w = window_frame_get_width();
	global.__window_frame_pre_fs_h = window_frame_get_height();
	window_set_fullscreen(true);
} else {
	if (!window_get_fullscreen()) exit;
	window_set_fullscreen(false);
	global.__window_frame_post_fullscreen_t = 2;
}

#define window_frame_get_fullscreen
/// ():
return window_get_fullscreen();

#define window_get_topmost
/// ()->bool
return global.__window_frame_topmost;

#define window_set_topmost
/// (stayontop)
global.__window_frame_topmost = bool(argument0);
if (!window_get_fullscreen()) {
	//trace("topmost.gml", argument0, window_get_fullscreen());
	return window_set_topmost_raw(argument0);
} else return true;