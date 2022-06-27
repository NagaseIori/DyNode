/// @description Draw editor & debug things

if(drawVisible && editor_get_editmode() == 4) {
    var _col = c_blue;
    
    if(!objEditor.editorSelectSingleOccupied && objEditor.editorSelectSingleTargetInbound == id)
        _col = c_white;
    if(state == stateSelected)
        _col = c_white;
    
    draw_set_color_alpha(_col, 1);
    draw_rectangle(x - mouseDetectRange / 2, y - mouseDetectRange / 2,
        x + mouseDetectRange / 2, y + mouseDetectRange / 2, false);
}

if(debug_mode && pos_inbound(x, y, 0, 0, room_width, room_height)) {
    // draw_set_color(c_red);
    draw_set_color_alpha(c_white, 1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    
    draw_text(x, y, stateString + " " + string(time)+" "+string(position));
}