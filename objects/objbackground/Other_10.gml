/// @description Load Image
var _nspr = sprite_add(global.bg_img_file, 1, 0, 0, 0, 0);
if(_nspr<0) {
	chat_msg("[ERROR] 背景图片文件读取失败！");
	global.bg_type = 0;
	return;
}
var _cspr = compress_sprite(_nspr, max(surf_w/sprite_get_width(_nspr), surf_h/sprite_get_height(_nspr)));
sprite_delete(_nspr);

if(sprite_exists(image_spr))
	sprite_delete(image_spr);
image_spr = _cspr;
last_radius = 0;
show_debug_message("Background has changed.");