
var _col = theme_get().color;
var _cont = ["L", "D", "R"];



for(var i=0; i<3; i++) {
    scribble(_cont[i])
        .starting_format("fDynamix20", c_white)
        .gradient(_col, gradAlpha[i])
        .msdf_shadow(_col, gradAlpha[i]*0.3, 0, gradAlpha[i]*shadowDistance)
        .align(fa_middle, fa_center)
        .draw(x + (i-1) * sideButtonWidth, y);
}