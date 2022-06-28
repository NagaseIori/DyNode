/// @description Draw scoreboard

var _len = string_length(nowString);
var _x = x, _w = (sprWidth - shorten) * scale * scaleMul * global.scaleXAdjust;

if(align == fa_middle)
    _x -= _w * _len / 2;
else if(align == fa_right)
    _x -= _w * _len;

for(var _i = 1; _i <= _len; _i ++) {
    draw_sprite_ext(sprNumber, int64(string_char_at(nowString, _i)), _x, y, 
         scale * scaleMul * global.scaleXAdjust,  
         scale * scaleMul * global.scaleYAdjust, 0, c_white, alpha);
    _x += _w;
}