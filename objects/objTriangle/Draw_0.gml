
// draw_set_color(c_white);
// draw_rectangle()
draw_set_alpha(1);
draw_set_color(c_white);
// draw_sprite_ext(sprBg, 0, 0, 0, 1.2, 1.2, 0, c_white, 1);
var _surf = trianglify_draw(triStruct, colors);

draw_surface_ext(_surf, 0, 0, 1, 1, 0, c_white, 1);
surface_free(_surf);

