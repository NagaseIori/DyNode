/// @description Draw editor & debug things

if(_outroom_check(x, y)) return;

if((drawVisible || nodeAlpha > EPS || infoAlpha > EPS) && editor_get_editmode() <= 4) {
    var _col = c_blue;
    
    animTargetInfoA = 0;
    if(editor_select_is_area()) {
        if(editor_select_inbound(x, y, side, noteType)) {
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
            animTargetInfoA = ctrl_ishold()? 1:0;
        }
        else if(objEditor.editorHighlightLine && objEditor.editorHighlightPosition == position &&
            objEditor.editorHighlightSide == side) {
            animTargetNodeA = 1.0;
            animTargetInfoA = ctrl_ishold()? 1:0;
            _col = 0xc2577e;
        }
        else animTargetNodeA = 0;
    }
    if(state == stateSelected) {
    	if(editor_select_is_area() && editor_select_inbound(x, y, side, noteType))
    		_col = scribble_rgb_to_bgr(0xff1744);
    	else 
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
    	var _dx = 20, _dy = (noteType == 2? dFromBottom:20) * _inv,
    		_dyu = (noteType == 2? dFromBottom:25) * _inv;
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
	    
	    var _time = objMain.showBar ? "Bar " + string_format(time_to_bar(mtime_to_time(time)), 1, 6) : string_format(time, 1, 0);
	    scribble(_time)
	    	.starting_format("fDynamix16", scribble_rgb_to_bgr(0xb2fab4))
	    	.transform(global.scaleXAdjust, global.scaleYAdjust)
	    	.blend(c_white, infoAlpha)
	    	.align(fa_right, fa_middle)
	    	.draw(x - _dx, y - _dyu);
    }
    
}
else animTargetNodeA = 0;

if(debug_mode && objMain.showDebugInfo && !_outroom_check(x, y)) {
	draw_set_font(fDynamix16)
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
    draw_text(x, y+5, stateString + " " + string(depth) + " " + string(arrayPos))
}