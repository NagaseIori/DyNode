
// Draw Bg Hold
var _h = sprite_get_height(sprHold), _th = pHeight - dFromBottom - uFromTop,
    _w = sprite_get_width(sprHold), _rw = pWidth - lFromLeft - rFromRight;
var _scl = _rw / _w;
for(var _i = 0; _i < _th; _i += _h) {
    draw_sprite_part_ext(sprHold, 0, 0, _h-min(_h, _th-_i), 
        _w, min(_h, _th-_i), x - _rw/2, y - _i - min(_h, _th-_i),
        _scl, 1, c_white, lastAlpha);
}

// Draw Edge
draw_sprite_ext(sprite_index, image_number, x - pWidth/2, y + dFromBottom, 
    image_xscale, image_yscale, image_angle, image_blend, image_alpha);


_debug_draw();