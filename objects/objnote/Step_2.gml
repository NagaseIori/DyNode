/// @description Update colored squares

// If visible then update the colored squares
if(drawVisible && editor_get_editmode() <= 4){
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
        else if(objEditor.editorHighlightLine) {
        	var _sameside = 
        		objEditor.editorHighlightSide == side ||
        		(objEditor.editorHighlightSide > 0 && side > 0)
            var _position = objEditor.editorHighlightPosition == position
            				&& _sameside;
            var _width = objEditor.editorHighlightWidth == width 
            			 && _sameside;
            var _time = round(objEditor.editorHighlightTime) == round(time);
            if(_position || _width || _time) {
            	animTargetNodeA = 1.0;
            	animTargetInfoA = ctrl_ishold()? 1:0;
            }
            else animTargetNodeA = 0;
            if(_position && _width)
            	_col = 0xa1A1fe;
            else if(_time && _width)
            	_col = 0x50af4c;
            else if(_time)
            	_col = 0x2257ff;
            else if(_position)
            	_col = 0xc2577e;
            else if(_width)
            	_col = 0xFF9E00;
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

        if(objEditor.editorSelectedSingleInbound == id || isDragging)
            animTargetNodeBorderA = 1;
        else
            animTargetNodeBorderA = 0;
    }
    else {
        animTargetNodeBorderA = 0;
    }
	if(state == stateAttach || state == stateAttachSub || state == stateDrop || state == stateDropSub) {
		animTargetNodeA = 0.0;
		animTargetInfoA = 1;
	}
	if((state == stateLast && noteType == 2) || state == stateOut) {
		animTargetNodeA = 0;
		animTargetInfoA = 0;
	}
	
	if(animTargetNodeA > 0)
	    nodeColor = _col;
}