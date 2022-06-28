/// @description Draw the indicator

var _scl = scale * scaleMul;

draw_sprite_ext(sprPerfect, 0, x, y, _scl * global.scaleXAdjust, _scl * global.scaleYAdjust, 0, c_white, alpha * alphaMul);
draw_sprite_ext(sprPerfectBloom, 0, x, y, _scl * global.scaleXAdjust, _scl * global.scaleYAdjust, 0, c_white, 1 * bloomAlpha * alpha * alphaMul);
