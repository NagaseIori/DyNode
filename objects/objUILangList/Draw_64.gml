
var _col = theme_get().color;
scriElement
    .gradient(_col, gradAlpha)
    .msdf_shadow(merge_color(c_black, _col, lerp(0, 0.5, gradAlpha)), 0.3, 0, shadowDistance, 3)
	.align(fa_right, fa_top)
    .draw(x-10, y);

scribble(cjk_prefix()+input)
    .starting_format("fDynamix16", c_white)
    .align(fa_left, fa_top)
    .gradient(_col, gradAlpha)
    .fit_to_box(maxWidth, scriHeight)
    .msdf_shadow(merge_color(c_black, _col, lerp(0, 0.5, gradAlpha)), 0.3, 0, shadowDistance, 3)
    .draw(x+10, y);