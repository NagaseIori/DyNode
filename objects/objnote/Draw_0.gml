
if(!drawVisible) return;
if(side == 0) {
    draw_sprite_ext(sprNote2, image_number, x - pWidth / 2, y, 
        image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}
else {
    draw_sprite_ext(sprNote2, image_number, x, y + pWidth / 2 * (side == 1?-1:1), 
        image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}
// draw_set_color(c_red);
// draw_circle(x, y, 5, false)