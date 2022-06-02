/// @description Draw the indicator

var _scl = scale * scaleMul;

draw_sprite_ext(sprPerfect, 0, x, y, _scl, _scl, 0, c_white, alpha);
draw_sprite_ext(sprPerfectBloom, 0, x, y, _scl, _scl, 0, c_white, 1 * bloomAlpha * alpha);
