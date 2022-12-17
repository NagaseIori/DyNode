/// @description Draw the text.

scribble(text)
    .starting_format(font, c_white)
    .align(fa_left, fa_top)
    .msdf_shadow(c_black, 0.3, 0, 3)
    .blend(image_blend, image_alpha)
    .draw(x, y);