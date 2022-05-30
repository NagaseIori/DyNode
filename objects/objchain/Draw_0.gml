
draw_sprite_ext(sprChainL, 0, x, y, image_xscale, image_yscale,
                image_angle, image_blend, image_alpha);
draw_sprite_ext(sprChainR, 0, x, y, image_xscale, image_yscale,
                image_angle, image_blend, image_alpha);

if(debug_mode) {
    scribble(stateString).starting_format("fDynamix20", c_white)
    .align(fa_left, fa_middle)
    .draw(round(x + pWidth/2), y);
}

// draw_set_color(c_red);
// draw_circle(x, y, 5, false)