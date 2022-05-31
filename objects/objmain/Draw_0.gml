/// @description Draw the Playview

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Bottom

    // Draw Bg
    draw_set_color(c_black);
    draw_set_alpha(1.0);
    draw_rectangle(0, _nh - targetLineBelow, _nw, _nh, false);
    
    // Draw Title

    scribble(chartTitle).starting_format("fDynamix48", c_white)
    .align(fa_left, fa_middle)
    .transform(0.7, 0.7)
    .draw(global.resolutionW*0.021, global.resolutionH - targetLineBelow + 34);

// Draw targetline

    draw_set_color(c_white);
    draw_set_alpha(1.0);
    // Line Below
    draw_rectangle(0, _nh - targetLineBelow - targetLineBelowH/2, 
                    _nw, _nh - targetLineBelow + targetLineBelowH/2, false);
    // Line Left
    draw_rectangle(targetLineBeside - targetLineBesideW/2, 0, 
                    targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);
    // Line Right
    draw_rectangle(_nw - targetLineBeside - targetLineBesideW/2, 0, 
                    _nw - targetLineBeside + targetLineBesideW/2,
                    _nh - targetLineBelow, false);

// Draw Note Particles

    part_system_drawit(partSysNote);

// Debug
    
    scribble("Music to Chart Delay: " + string(sfmod_channel_get_position(channel, sampleRate) - nowTime) +
    "\nNow Time: " + string(nowTime)+"\nFPS: "+string(fps))
    .starting_format("fDynamix20", c_white)
    .align(fa_center, fa_top)
    .draw(global.resolutionW/2, 30);