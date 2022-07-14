/// @description Draw announcements

if(announcementTime < announcementLastTime)
	announcementAlpha = 1;
else
	announcementAlpha -= animAnnoSpeed;

announcementAlpha = clamp(announcementAlpha, 0, 1);

if(announcementAlpha > 0) {
	var _nx = global.resolutionW, _ny = global.resolutionH;
	
	var _ele = scribble(cjk_prefix() + announcementString)
	.wrap(0.7 * global.resolutionW, -1, true)
	.align(fa_right, fa_bottom)
	.blend(c_white, announcementAlpha)
	.transform(0.8, 0.8)
	// .msdf_border(c_black, 2)
	.msdf_shadow(c_black, announcementAlpha * 0.5, 0, 3);
	// _ele.region_set_active("update", c_white, 1);
	
	var _bbox = _ele.get_bbox(_nx, _ny);
	if(mouse_inbound(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom))
		announcementAlpha = 1;
	
	CleanRectangle(_bbox.left-5, _bbox.top-5, _bbox.right+5, _bbox.bottom+5)
		.Blend(theme_get().color, 0.3 * announcementAlpha)
		.Rounding(5)
		.Draw();
	
	_ele
	.draw(_nx, _ny);
	
	if(_ele.region_detect(_nx, _ny, mouse_x, mouse_y) == "update" && mouse_isclick_l()) {
		url_open(_update_url);
	}
}