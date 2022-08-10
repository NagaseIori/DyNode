
var _col = theme_get().color;
scriElement
    .gradient(_col, gradAlpha)
    .msdf_shadow(_col, gradAlpha*0.3, 0, gradAlpha*shadowDistance)
    .draw(x, y);