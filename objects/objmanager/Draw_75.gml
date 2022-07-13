/// @description Draw announcements

if(announcementTime < announcementLastTime)
	announcementAlpha = 1;
else
	announcementAlpha -= animAnnoSpeed;

announcementAlpha = clamp(announcementAlpha, 0, 1);

if(announcementAlpha > 0) {
	
	var _ele = scribble(cjk_prefix() + announcementString)
	.wrap(0.7 * global.resolutionW, -1, true)
	.align(fa_right, fa_bottom)
	.blend(c_white, announcementAlpha)
	.transform(0.8, 0.8)
	// .msdf_border(c_black, 2)
	.msdf_shadow(c_black, announcementAlpha * 0.5, 0, 3);
	
	var _bbox = _ele.get_bbox(global.resolutionW, global.resolutionH);
	CleanRectangle(_bbox.left-5, _bbox.top-5, _bbox.right+5, _bbox.bottom+5)
		.Blend(theme_get().color, 0.3 * announcementAlpha)
		.Rounding(5)
		.Draw();
	
	_ele
	.draw(global.resolutionW, global.resolutionH);
}