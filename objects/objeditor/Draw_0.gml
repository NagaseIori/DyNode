
// Draw Beatlines
if(surface_exists(beatlineSurf))
    draw_surface_ext(beatlineSurf, 0, 0, 1, 1, 0, c_white, 1.0);

// Draw Highlight Lines

if(editorHighlightLine) {
    draw_set_color_alpha(0x75e7dc, 1);
    var _ny = note_time_to_y(editorHighlightTime, 0),
        _nx = note_time_to_y(editorHighlightTime, 1);
    // Down
    draw_line_width(
        0,
        _ny,
        global.resolutionW,
        _ny, 3);
    // LR
    draw_set_color(0xacb64d)
    draw_line_width(
        _nx, 0, _nx,
        global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2, 3);
    _nx = global.resolutionW - _nx;
    draw_line_width(
        _nx, 0, _nx,
        global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2, 3);
    
    // Vertical
    draw_set_color(c_white);
    _nx = note_pos_to_x(editorHighlightPosition, 0);
    if(editorHighlightSide == 0)
        draw_line_width(
        _nx, 0, _nx,
        global.resolutionH - objMain.targetLineBelow - objMain.targetLineBelowH / 2, 3);
}

// Draw Selction Area
if(editorSelectArea) {
    var _pos = editorSelectAreaPosition;
    CleanRectangle(min(_pos[0], _pos[2]), min(_pos[1], _pos[3]), max(_pos[0], _pos[2]), max(_pos[1], _pos[3]))
        .Blend(c_white, 0.2)
        .Border(5, c_white, 0.8)
        .Rounding(4)
        .Draw();
}