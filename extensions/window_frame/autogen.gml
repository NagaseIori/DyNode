#define window_command_check
/// window_command_check(button:int)->number
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_command_check_raw(buffer_get_address(_buf), 4);

#define window_command_run
/// window_command_run(command:int, lParam:int = 0)->int
var _buf = window_frame_prepare_buffer(9);
buffer_write(_buf, buffer_s32, argument[0]);
if (argument_count >= 2) {
	buffer_write(_buf, buffer_bool, true);
	buffer_write(_buf, buffer_s32, argument[1]);
} else buffer_write(_buf, buffer_bool, false);
return window_command_run_raw(buffer_get_address(_buf), 9);

#define window_command_hook
/// window_command_hook(button:int)->bool
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_command_hook_raw(buffer_get_address(_buf), 4);

#define window_command_unhook
/// window_command_unhook(button:int)->bool
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_command_unhook_raw(buffer_get_address(_buf), 4);

#define window_command_get_hooked
/// window_command_get_hooked(button:int)->bool
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_command_get_hooked_raw(buffer_get_address(_buf), 4);

#define window_command_set_hooked
/// window_command_set_hooked(button:int, hook:bool)->bool
var _buf = window_frame_prepare_buffer(5);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_bool, argument1);
return window_command_set_hooked_raw(buffer_get_address(_buf), 5);

#define window_command_get_active
/// window_command_get_active(command:int)->bool
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_command_get_active_raw(buffer_get_address(_buf), 4);

#define window_command_set_active
/// window_command_set_active(command:int, val:bool)->bool
var _buf = window_frame_prepare_buffer(5);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_bool, argument1);
return window_command_set_active_raw(buffer_get_address(_buf), 5);

#define window_frame_init
/// window_frame_init(x:int, y:int, w:int, h:int, title:string)->bool
var _buf = window_frame_prepare_buffer(25);
buffer_write(_buf, buffer_u64, int64(window_handle()));
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
return window_frame_init_raw(buffer_get_address(_buf), 25, argument4);

#define window_frame_set_background
/// window_frame_set_background(color:int)->number 
var _buf = window_frame_prepare_buffer(4);
buffer_write(_buf, buffer_s32, argument0);
return window_frame_set_background_raw(buffer_get_address(_buf), 4);

#define window_frame_set_region
/// window_frame_set_region(x:int, y:int, width:int, height:int)->bool
var _buf = window_frame_prepare_buffer(16);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
return window_frame_set_region_raw(buffer_get_address(_buf), 16);

#define window_frame_get_rect
/// window_frame_get_rect()->
var _buf = window_frame_prepare_buffer(8);
if (window_frame_get_rect_raw(buffer_get_address(_buf), 8)) {
	var _tup_0 = array_create(4);
	_tup_0[0] = buffer_read(_buf, buffer_s32);
	_tup_0[1] = buffer_read(_buf, buffer_s32);
	_tup_0[2] = buffer_read(_buf, buffer_s32);
	_tup_0[3] = buffer_read(_buf, buffer_s32);
	return _tup_0;
} else return undefined;

#define window_frame_set_rect
/// window_frame_set_rect(x:int, y:int, width:int, height:int)->bool
var _buf = window_frame_prepare_buffer(16);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
buffer_write(_buf, buffer_s32, argument2);
buffer_write(_buf, buffer_s32, argument3);
return window_frame_set_rect_raw(buffer_get_address(_buf), 16);

#define window_frame_set_min_size
/// window_frame_set_min_size(minWidth:int, minHeight:int)->bool
var _buf = window_frame_prepare_buffer(8);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
return window_frame_set_min_size_raw(buffer_get_address(_buf), 8);

#define window_frame_set_max_size
/// window_frame_set_max_size(maxWidth:int, maxHeight:int)->bool
var _buf = window_frame_prepare_buffer(8);
buffer_write(_buf, buffer_s32, argument0);
buffer_write(_buf, buffer_s32, argument1);
return window_frame_set_max_size_raw(buffer_get_address(_buf), 8);

