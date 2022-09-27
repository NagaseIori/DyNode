
var _col = theme_get().color;
scriElement
    .gradient(_col, gradAlpha)
    .msdf_shadow(_col, gradAlpha*0.3, 0, gradAlpha*shadowDistance)
    .draw(x, y);

if(input != "") {
    if(!has_cjk(input))
        scribble(cjk_prefix()+input)
            .starting_format("fDynamix16", c_white)
            .align(fa_left, fa_top)
            .gradient(_col, gradAlpha)
            .fit_to_box(maxWidth, scriHeight)
            .msdf_shadow(_col, gradAlpha*0.3, 0, gradAlpha*shadowDistance)
            .draw(x, y+scriHeight);
    else {
        draw_set_font(global._notoFont);
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        draw_text(x, y+scriHeight, input);
    }
}
else {
    var _ny = y + scriHeight*2;
    CleanLine(x, _ny, x + maxWidth + lineShootDistance * gradAlpha, _ny)
        .Blend2(merge_color(c_white, _col, gradAlpha), 1, c_white, 1)
        .Thickness(8)
        .Cap("round", "round")
        .Draw();
}