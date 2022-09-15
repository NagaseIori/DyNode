
var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Top Progress Bar

    draw_set_color_alpha(c_white, topBarIndicatorA);
    draw_rectangle(0, 0, _nw, topBarMouseH, false);
    if(musicProgress > 0) {
        var _topBarW = round(_nw * musicProgress);
        draw_sprite_stretched_exxt(
        global.sprLazer, 0,
        0, topBarH, _topBarW+1, -26, 0, themeColor, 1.0);
        draw_set_color(c_white); draw_set_alpha(1.0);
        draw_rectangle(0, 0, _topBarW, topBarH, false);
    }
    draw_set_alpha(1.0);

// Draw Note Particles

    part_system_drawit(partSysNote);

// Draw Mixer & Shadow's Position

    for(var i=0; i<2; i++) {
        if(chartSideType[i] == "MIXER") {
                draw_sprite(sprMixer, 0,
                    i*_nw + (i? -1:1) * targetLineBeside, mixerX[i]);
            }
    }
