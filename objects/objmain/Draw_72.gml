/// @description Draw the Background & Beat Lines

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Background Image

    if(bgImageSpr != -1) {
        draw_sprite(bgImageSpr, 0, _nw/2, _nh/2);
        
        // Dim background
        draw_set_color(c_black);
        draw_set_alpha(bgDim);
        draw_rectangle(0, 0, _nw, _nh, false);
        draw_set_alpha(1.0);
    }
    else {
        draw_clear(c_black);
    }

// Draw Faint Color

    draw_sprite_stretched_exxt(
        global.sprLazer, 0,
        0, _nh - targetLineBelow, _nw, global.resolutionH/2,
        0, themeColor, 0.5);
