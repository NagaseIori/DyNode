/// @description Draw editor & debug things

if(drawVisible && editor_get_editmode() <= 4) {
    var _col = c_blue;
    
    if(editor_select_is_area()) {
        var _pos = editor_select_get_area_position();
        
        if(side == editor_get_editside() && noteType != 3 && pos_inbound(x, y, _pos[0], _pos[1], _pos[2], _pos[3])) {
            _col = 0x28caff;
            animTargetNodeA = 1;
        }
        else {
            animTargetNodeA = 0;
        }
    }
    else {
        if((!objEditor.editorSelectOccupied || ctrl_ishold()) && objEditor.editorSelectSingleTargetInbound == id) {
            animTargetNodeA = 1.0;
        }
        else if(objEditor.editorHighlightLine && objEditor.editorHighlightPosition == position &&
            objEditor.editorHighlightSide == side) {
            animTargetNodeA = 1.0;
            _col = 0xc2577e;
        }
        else animTargetNodeA = 0;
    }
    if(state == stateSelected) {
        _col = c_white;
        animTargetNodeA = 1.0;
    }
	if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
		animTargetNodeA = 0.0;
	}
	
	if(animTargetNodeA > 0)
	    nodeColor = _col;
    
    CleanRectangleXYWH(x, y, nodeRadius, nodeRadius)
        .Rounding(5)
        .Blend(nodeColor, nodeAlpha)
        .Draw();
}
else animTargetNodeA = 0;

if(debug_mode && objMain.showDebugInfo && pos_inbound(x, y, 0, 0, global.resolutionW, global.resolutionH)) {
    draw_set_color_alpha(c_white, 1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    
    draw_text(x, y, stateString + " " + string(time)+" "+string(position)+"\n"+string(width));
}