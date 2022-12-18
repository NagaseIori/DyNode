
// Draw Beatlines
if(surface_exists(beatlineSurf))
    draw_surface_ext(beatlineSurf, 0, 0, 1, 1, 0, c_white, beatlineAlphaMul);

// Draw Highlight Lines

if(editorHighlightLine) {
    draw_set_color_alpha(0x75e7dc, 1);
    var _ny = note_time_to_y(editorHighlightTime, 0),
        _nx = note_time_to_y(editorHighlightTime, 1);
    // Down
    CleanPolyline([30, _ny, global.resolutionW/2, _ny, global.resolutionW - 30, _ny])
        .BlendExt([highlightLineColorDownA, 1, highlightLineColorDownB, 0.8, highlightLineColorDownA, 1])
        .Thickness(5)
        .Cap("round", "round")
        .Draw();
    
    // LR
    CleanLine(_nx, 30, _nx, global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2)
        .Thickness(10)
        .Blend2(highlightLineColorSideA, 1,
            highlightLineColorSideB, 1)
        .Cap("round", "none")
        .Draw();
    _nx = global.resolutionW - _nx;
    CleanLine(_nx, 30, _nx, global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2)
        .Thickness(10)
        .Blend2(highlightLineColorSideA, 1,
            highlightLineColorSideB, 1)
        .Cap("round", "none")
        .Draw();
    
    // Vertical
    draw_set_color_alpha(c_white, 1);
    _nx = note_pos_to_x(editorHighlightPosition, 0);
    if(editorHighlightSide == 0)
        draw_line_width(
        _nx, 0, _nx,
        global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2, 3);
}

// Draw Selction Area
if(editorSelectArea) {
    var _pos = editor_select_get_area_position();
    _pos[0] = clamp(_pos[0], -10, global.resolutionW+10);
    _pos[2] = clamp(_pos[2], -10, global.resolutionW+10);
    _pos[1] = clamp(_pos[1], -10, global.resolutionH+10);
    _pos[3] = clamp(_pos[3], -10, global.resolutionH+10);
    CleanRectangle(min(_pos[0], _pos[2]), min(_pos[1], _pos[3]), max(_pos[0], _pos[2]), max(_pos[1], _pos[3]))
        .Blend(c_white, 0.2)
        .Border(5, c_white, 0.8)
        .Rounding(4)
        .Draw();
}