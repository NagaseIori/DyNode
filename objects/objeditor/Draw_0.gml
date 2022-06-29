
if(surface_exists(beatlineSurf))
    draw_surface_ext(beatlineSurf, 0, 0, 1, 1, 0, c_white, 1.0);

if(editorSelectArea) {
    var _pos = editorSelectAreaPosition;
    CleanRectangle(min(_pos[0], _pos[2]), min(_pos[1], _pos[3]), max(_pos[0], _pos[2]), max(_pos[1], _pos[3]))
        .Blend(c_white, 0.2)
        .Border(5, c_white, 0.8)
        .Rounding(4)
        .Draw();
}