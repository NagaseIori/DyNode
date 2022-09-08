
if(!drawVisible) return;
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
    
    // Optimization
    if(side == 0 && _th > global.resolutionH)
    	_th -= floor((_th - global.resolutionH) / _h) * _h;
    else if(side == 1 && _th > global.resolutionW)
    	_th -= floor((_th - global.resolutionW) / _h) * _h;
    
    // Draw Green Blend
    
    draw_set_color_alpha(c_green, lastAlpha);
    if(side == 0)
    	draw_rectangle(_nx - _rw/2, _ny - _th, _nx + _rw/2, _ny, false);
    else
    	draw_rectangle(_nx , _ny - _rw/2, _nx + _th * (side == 1 ? 1 : -1), _ny + _rw / 2, false);
    draw_set_alpha(1);

    // Draw Sprites
    
    if(side == 0) {
        for(var _i = _th; _i >= 0; _i -= _h) {
            draw_sprite_part_ext(_spr, 0, 0, 0, 
                _w, min(_h, _i), _nx - _rw/2, _ny - _i,
                _scl, 1, c_white, holdAlpha * image_alpha);
        }
    }
    else {
        // var _spr = side == 1? sprHoldL:sprHoldR;
        for(var _i = _th; _i >= 0; _i -= _h) {
            draw_sprite_part_ext(_spr, 0, 0, 0, 
                min(_h, _i), _w,
                _nx + _i * (side == 1 ? 1 : -1), _ny - _rw / 2,
                side == 2 ? 1 : -1, _scl, c_white, holdAlpha * image_alpha);
        }
    }

// Draw Edge

if(side == 0) {
    better_scaling_draw_sprite(sprHoldEdge, image_number,
    	_nx - pWidth/2,
    	_ny + dFromBottom,
    	image_xscale, edgeScaleY, image_angle, image_blend, image_alpha, 1);
}
else {
    better_scaling_draw_sprite(sprHoldEdge, image_number,
        _nx + dFromBottom * (side == 1? -1: 1),
        _ny + pWidth/2 * (side == 1? -1: 1), 
        image_xscale, edgeScaleY, image_angle, image_blend, image_alpha, 1);
}
