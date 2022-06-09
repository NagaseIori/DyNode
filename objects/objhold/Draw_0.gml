
// Get Position
    
    var _nx, _ny;
    
    if(side == 0) {
        _nx = x;
        _ny = min(y, global.resolutionH - objMain.targetLineBelow);
    }
    else {
        _nx = side == 2? min(x, global.resolutionW - objMain.targetLineBeside) :
                        max(x, objMain.targetLineBeside);
        _ny = y;
    }

// Draw Bg
    
    var _spr = side == 0? sprHold: sprHoldR;
    var _h = sprite_get_height(sprHold), _th = pHeight - dFromBottom - uFromTop,
    _w = sprite_get_width(sprHold), _rw = pWidth - lFromLeft - rFromRight;
    var _scl = _rw / _w;
    if(side == 0) {
        for(var _i = _th; _i >= 0; _i -= _h) {
            draw_sprite_part_ext(_spr, 0, 0, 0, 
                _w, min(_h, _i), _nx - _rw/2, _ny - _i,
                _scl, 1, c_white, lastAlpha * image_alpha);
        }
    }
    else {
        // var _spr = side == 1? sprHoldL:sprHoldR;
        for(var _i = _th; _i >= 0; _i -= _h) {
            draw_sprite_part_ext(_spr, 0, 0, 0, 
                min(_h, _i), _w,
                _nx + _i * (side == 1 ? 1 : -1), _ny - _rw / 2,
                side == 2 ? 1 : -1, _scl, c_white, lastAlpha * image_alpha);
        }
    }

// Draw Edge

if(side == 0) {
    draw_sprite_ext(sprHoldEdge, image_number,
        _nx - pWidth/2,
        _ny + dFromBottom, 
        image_xscale, edgeScaleY, image_angle, image_blend, image_alpha);
}
else {
    draw_sprite_ext(sprHoldEdge, image_number,
        _nx + dFromBottom * (side == 1? -1: 1),
        _ny + pWidth/2 * (side == 1? -1: 1), 
        image_xscale, edgeScaleY, image_angle, image_blend, image_alpha);
}

_editor_draw();
_debug_draw();