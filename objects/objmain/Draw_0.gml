/// @description Draw the Playview

var _nw = global.resolutionW, _nh = global.resolutionH;

// Draw Bottom

    // Draw Bg
    
    if(bgImageSpr != -1) {
        // show_debug_message("Draw below bg");
        if(!surface_exists(bottomBgSurf)) {
            bottomBgSurf = surface_create(_nw, targetLineBelow);
            
            // gpu_set_blendmode(bm_normal);
            surface_set_target(bottomBgSurf);
                draw_sprite(bgImageSpr, 0, _nw / 2, targetLineBelow - _nh / 2);
            surface_reset_target();
            
            if(!surface_exists(bottomBgSurfPing))
                bottomBgSurfPing = surface_create(_nw, targetLineBelow);
            
            surface_set_target(bottomBgSurfPing);
                shader_set(shaderBlur);
                    shader_set_uniform_f_array(u_size, [_nw, targetLineBelow,
                        bottomBgBlurAmount, bottomBgBlurSigma]);
                    shader_set_uniform_f_array(u_blur_vector, [1, 0]);
                    draw_surface(bottomBgSurf, 0, 0);
                shader_reset();
            surface_reset_target();
            
            gpu_set_blendmode_ext(bm_one, bm_zero);
            surface_set_target(bottomBgSurf);
                shader_set(shaderBlur);
                    shader_set_uniform_f_array(u_size, [_nw, targetLineBelow,
                        bottomBgBlurAmount, bottomBgBlurSigma]);
                    shader_set_uniform_f_array(u_blur_vector, [0, 1]);
                    draw_surface(bottomBgSurfPing, 0, 0);
                shader_reset();
            surface_reset_target();
            gpu_set_blendmode(bm_normal);
        }
        
        draw_surface(bottomBgSurf, 0, _nh - targetLineBelow);
        
        draw_set_color(c_black);
        draw_set_alpha(bottomDim);
        draw_rectangle(0, _nh - targetLineBelow, _nw, _nh, false);
        draw_set_alpha(1.0);
    }
    
    // Draw Mods
    
    var _nxx = resor_to_x((1920 - 80 - 30) / 1920), _nww = 180;
    for(var i = 0; i < 8; i++) {
        draw_sprite_ext(
            i==0?sprBottomSignBlue:sprBottomSignBlack,
            0,
            _nxx - i * _nww / 2,
            (i & 1) == 0? _nh : _nh - targetLineBelow,
            1,
            1,
            (i & 1) == 0? 180 : 0,
            c_white,
            1
            );
    }
    
    // Draw Title

    titleElement
    .draw(resor_to_x(0.021), global.resolutionH - targetLineBelow + 34);
    
    // Draw Difficulty
    better_scaling_draw_sprite(global.difficultySprite[chartDifficulty], 0, 
        resor_to_x(0.019), global.resolutionH - targetLineBelow + 77, 0.2, 0.2, 0, c_white,
        1, 0);

// Draw targetline

    var _sprlazer = global.sprLazer;
    // gpu_set_blendmode(bm_add);
    // Light Below
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        0, _nh - targetLineBelow,
        _nw, targetLineBelowH/2 + 25,
        0, themeColor, 1.0);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        0, _nh - targetLineBelow + 1,
        _nw, -(targetLineBelowH/2 + 25),
        0, themeColor, 1.0);
    // Light Left
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        targetLineBeside, _nh - targetLineBelow,
        _nh - targetLineBelow, targetLineBesideW/2 + 25,
        90, themeColor, 1.0);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        targetLineBeside + 1, _nh - targetLineBelow,
        _nh - targetLineBelow, -(targetLineBesideW/2 + 25),
        90, themeColor, 1.0);
    // Light Right
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        _nw - targetLineBeside, _nh - targetLineBelow,
        _nh - targetLineBelow, targetLineBesideW/2 + 25,
        90, themeColor, 1.0);
    draw_sprite_stretched_exxt(
        _sprlazer, 0,
        _nw - targetLineBeside + 1, _nh - targetLineBelow,
        _nh - targetLineBelow, -(targetLineBesideW/2 + 25),
        90, themeColor, 1.0);
    // gpu_set_blendmode(bm_normal);
    
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
    
// Draw Top Progress Bar

    
    
    draw_set_color(c_white); draw_set_alpha(topBarIndicatorA);
    draw_rectangle(0, 0, _nw, topBarMouseH, false);
    if(musicProgress > 0) {
        var _topBarW = round(_nw * musicProgress);
        draw_sprite_stretched_exxt(
        _sprlazer, 0,
        0, topBarH, _topBarW+1, -26, 0, themeColor, 1.0);
        draw_set_color(c_white); draw_set_alpha(1.0);
        draw_rectangle(0, 0, _topBarW, topBarH, false);
    }
    draw_set_alpha(1.0);

// Draw Note Particles

    part_system_drawit(partSysNote);

// Draw Mixer

    for(var i=0; i<2; i++) {
        if(chartSideType[i] == "MIXER") {
                draw_sprite(sprMixer, 0,
                    i*_nw + (i? -1:1) * targetLineBeside, mixerX[i]);
            }
    }

// Debug
    
    // scribble("Music to Chart Delay: " + string(sfmod_channel_get_position(channel, sampleRate) - nowTime) +
    // "\nNow Time: " + string(nowTime)+"\nFPS: "+string(fps) + " / "+string(fps_real))
    // .starting_format("fDynamix20", c_white)
    // .align(fa_center, fa_top)
    // .draw(global.resolutionW/2, 30);
    
    var _debug_str = "";
    _debug_str += "FPS: " + string(fps) + "\nRFPS: "+string(fps_real)+"\n";
    _debug_str += "DSPD: " + string(animTargetPlaybackSpeed)+"\n";
    _debug_str += "MSPD: " + string(musicSpeed)+"\n";
    draw_set_font(fDynamix20);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(global.resolutionW/2, 30, _debug_str);