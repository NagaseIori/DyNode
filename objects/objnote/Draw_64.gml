/// @description Draw editor & debug things

if(_outroom_check(x, y)) return;

if((drawVisible || nodeAlpha > EPS || infoAlpha > EPS) && editor_get_editmode() <= 4) {
    var _col = c_blue;
    
    animTargetInfoA = 0;
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
            animTargetInfoA = 0;
            _col = 0xc2577e;
        }
        else animTargetNodeA = 0;
    }
    if(state == stateSelected) {
        _col = c_white;
        animTargetNodeA = 1.0;
        animTargetInfoA = 1;
    }
	if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
		animTargetNodeA = 0.0;
		animTargetInfoA = 1;
	}
	if((state == stateLast && noteType == 2) || state == stateOut) {
		animTargetNodeA = 0;
		animTargetInfoA = 0;
	}
	
	var _inv = noteType == 3 ? -1:1;
	
	if(animTargetNodeA > 0)
	    nodeColor = _col;
    
    // Draw Node
    if(nodeAlpha>EPS) {
    	CleanRectangleXYWH(x, y, nodeRadius, nodeRadius)
	        .Rounding(5)
	        .Blend(nodeColor, nodeAlpha)
	        .Draw();
    }
    
    // Draw Information
    if(infoAlpha > EPS) {
    	var _dx = 20, _dy = (noteType == 2? dFromBottom:20) * _inv;
	    scribble(string_format(position, 1, 2))
	    	.starting_format("fDynamix16", c_aqua)
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_right, fa_middle)
	    	.draw(x - _dx, y + _dy);
	    
	    scribble(string_format(width, 1, 2))
	    	.starting_format("fDynamix16", c_white)
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_left, fa_middle)
	    	.draw(x + _dx, y + _dy);
    }
    
}
else animTargetNodeA = 0;

if(debug_mode && objMain.showDebugInfo && pos_inbound(x, y, 0, 0, global.resolutionW, global.resolutionH)) {
    draw_set_color_alpha(c_white, 1.0);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
    
    draw_text(x, y, stateString + " " + string(time)+" "+string(position)+"\n"+string(width)+"\n"+string(depth));
}