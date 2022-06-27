/// @description Draw editor & debug things

if(drawVisible && editor_get_editmode() == 4) {
    var _col = c_blue;
    
    if(!objEditor.editorSelectSingleOccupied && objEditor.editorSelectSingleTargetInbound == id) {
        // _col = c_white;
        animTargetNodeA = 1.0;
    }
        
    else if(state == stateSelected) {
        _col = c_white;
        animTargetNodeA = 1.0;
    }
    
    else animTargetNodeA = 0;
    
    draw_set_color_alpha(_col, nodeAlpha);
    draw_rectangle(x - mouseDetectRange / 2, y - mouseDetectRange / 2,
        x + mouseDetectRange / 2, y + mouseDetectRange / 2, false);
}
else animTargetNodeA = 0;

if(debug_mode && pos_inbound(x, y, 0, 0, room_width, room_height)) {
    // draw_set_color(c_red);
    draw_set_color_alpha(c_white, 1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    
    draw_text(x, y, stateString + " " + string(time)+" "+string(position));
}