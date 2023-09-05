/// @description Draw the indicator

var _scl = scale * scaleMul;

var _nx = x + PERFECTINDC_SPRITE_ALPHABETS_WIDTH / 2;
var _ny = y + PERFECTINDC_SPRITE_ALPHABETS_HEIGHT / 2;

draw_sprite_ext(sprPerfect, 0, _nx, _ny, _scl * global.scaleXAdjust, _scl * global.scaleYAdjust, 0, c_white, alpha * alphaMul);
draw_sprite_ext(sprPerfectBloom, 0, _nx, _ny, _scl * global.scaleXAdjust, _scl * global.scaleYAdjust, 0, c_white, 1 * bloomAlpha * alpha * alphaMul);

if(debug_mode && PERFECTINDC_DEBUG) {
    draw_set_color(c_red);
    draw_set_alpha(1);
    draw_circle(x, y, 5, false);
    draw_circle(_nx, _ny, 5, false);
}