
creditsSurf = surface_checkate(creditsSurf, width, height);

surface_set_target(creditsSurf);
    draw_clear_alpha(c_black, 0);
    var _ele = scribble(i18n_get(text))
        .starting_format(font, c_white)
        .align(fa_left, fa_top)
        .msdf_shadow(c_black, 0.6, 0, 3, 3)
        .blend(image_blend, image_alpha)
    	.transform(scl, scl);
    _ele.draw(nowX, round(nowY));
    if(nowY + _ele.get_height() < - 50)
        nowY = height+50;
surface_reset_target();

draw_surface(creditsSurf, round(x), round(y));