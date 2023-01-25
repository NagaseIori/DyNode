
var _col = theme_get().color;
scriElement
    .gradient(_col, gradAlpha)
    .msdf_shadow(_col, gradAlpha*0.3, 0, gradAlpha*shadowDistance)
	.align(fa_right, fa_top)
    .draw(x-10, y);

scribble(cjk_prefix()+input)
    .starting_format("fDynamix16", c_white)
    .align(fa_left, fa_top)
    .gradient(_col, gradAlpha)
    .fit_to_box(maxWidth, scriHeight)
    .msdf_shadow(_col, gradAlpha*0.3, 0, gradAlpha*shadowDistance)
    .draw(x+10, y);