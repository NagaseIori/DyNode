
var _col = theme_get().color;
scriElement
    .gradient(_col, gradAlpha)
    .msdf_shadow(merge_color(c_black, _col, lerp(0, 0.5, gradAlpha)), 0.3, 0, shadowDistance, 3)
    .draw(x, y);